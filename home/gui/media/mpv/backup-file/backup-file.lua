local utils = require("mp.utils")
local msg = require("mp.msg")

local options = {
  BackupFilesPath = "",
}

require("mp.options").read_options(options, "backup")

if options.BackupFilesPath == "" then
  options.BackupFilesPath = utils.join_path(utils.getcwd(), "_bak")
end

if not options.BackupFilesPath then
  msg.error("Could not determine the backup directory")
  return
end

local bak_list = {}

local function run(args)
  local res = mp.command_native({
    name = "subprocess",
    args = args,
    playback_only = false,
  })

  if not res then
    return false, "subprocess failed"
  end

  if res.status ~= 0 then
    return false, res.error_string or res.stderr or ("exit status " .. tostring(res.status))
  end

  return true
end

local function ensure_backup_dir()
  if utils.file_info(options.BackupFilesPath) then
    return true
  end

  local ok, err = run({ "mkdir", "-p", options.BackupFilesPath })
  if not ok then
    msg.error("Could not create backup directory: " .. tostring(err))
    return false
  end

  return true
end

local function is_absolute(path)
  return path:match("^/") ~= nil or path:match("^%a:[/\\]") ~= nil or path:match("^\\\\") ~= nil
end

local function get_full_path(path)
  if not path or path == "" then
    return nil
  end

  if is_absolute(path) then
    return path
  end

  local work_dir = mp.get_property("working-directory") or utils.getcwd()
  if not work_dir then
    return nil
  end

  return utils.join_path(work_dir, path)
end

local function mark_bak()
  local path = get_full_path(mp.get_property("path"))
  if not path then
    msg.warn("No local file path is available to back up")
    return
  end

  for i, marked_path in ipairs(bak_list) do
    if marked_path == path then
      table.remove(bak_list, i)
      mp.osd_message("Backup mark removed")
      msg.info("Removed backup mark: " .. path)
      return
    end
  end

  table.insert(bak_list, path)
  mp.osd_message("Marked for backup")
  msg.info("Marked for backup: " .. path)
end

local function split_filename(path)
  local _, filename = utils.split_path(path)
  local stem, ext = filename:match("^(.*)(%.[^%.]+)$")

  -- Don't treat a dotfile without another extension as having an extension.
  if stem and stem ~= "" then
    return stem, ext
  end

  return filename, ""
end

local function bak_file()
  if #bak_list == 0 then
    return
  end

  if not ensure_backup_dir() then
    return
  end

  for _, source_path in ipairs(bak_list) do
    local stem, ext = split_filename(source_path)
    local copied = false

    for index = 1, 100 do
      local filename
      if index == 1 then
        filename = stem .. ext
      else
        filename = string.format("%s_%d%s", stem, index, ext)
      end

      local dest_path = utils.join_path(options.BackupFilesPath, filename)
      if not utils.file_info(dest_path) then
        local ok, err = run({ "cp", "--", source_path, dest_path })
        if ok then
          msg.info("Backed up: " .. source_path .. " -> " .. dest_path)
          copied = true
        else
          msg.error("Backup failed for " .. source_path .. ": " .. tostring(err))
        end
        break
      end
    end

    if not copied then
      msg.error("Could not back up file (all candidate names exist, or copy failed): " .. source_path)
    end
  end
end

mp.add_key_binding("\\", "mark_backup", mark_bak)
mp.register_event("shutdown", bak_file)
