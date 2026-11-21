local mp = require("mp")
local utils = require("mp.utils")

-- Backup destination. A relative value is resolved against the mpv working directory.
local BackupFilesPath = "_bak"

-- Entries marked for backup: { src = absolute source path, rel = path relative to pwd or filename }
local bak_list = {}
-- Set of already marked absolute paths, used to avoid duplicate entries
local marked = {}

-- Convert backslashes to forward slashes, remove "/./" segments,
-- collapse duplicate slashes, and remove a trailing slash (except for the root "/")
local function normalize(path)
  path = path:gsub("\\", "/")
  while path:find("/%./") do
    path = path:gsub("/%./", "/")
  end
  path = path:gsub("/+", "/")
  if #path > 1 and path:sub(-1) == "/" then
    path = path:sub(1, -2)
  end
  return path
end

-- Return true if the path is a network URL such as http:// or https://
local function is_network(path)
  return path:match("^%a[%w+.-]*://") ~= nil
end

-- Return true if a file can be opened for reading at the given path
local function file_exists(path)
  local f = io.open(path, "rb")
  if f then
    f:close()
    return true
  end
  return false
end

-- Return the directory part of a path
local function dirname(path)
  return path:match("(.*)/")
end

-- Create a directory and any missing parents using mkdir -p
local function ensure_dir(dir)
  if not dir or dir == "" then
    return
  end
  utils.subprocess({ args = { "mkdir", "-p", dir }, cancellable = false })
end

-- Copy a file in chunks so large video files are not loaded into memory at once
local function copy_file(src, dest)
  local fin = io.open(src, "rb")
  if not fin then
    return false
  end
  local fout = io.open(dest, "wb")
  if not fout then
    fin:close()
    return false
  end
  local chunk_size = 1024 * 1024
  while true do
    local chunk = fin:read(chunk_size)
    if not chunk then
      break
    end
    fout:write(chunk)
  end
  fin:close()
  fout:close()
  return true
end

-- Toggle the backup mark for the currently playing file
local function mark_backup()
  local path = mp.get_property("path")
  if not path or is_network(path) then
    mp.osd_message("Backup: network URLs and empty paths are not supported")
    return
  end

  local wd = normalize(mp.get_property("working-directory") or "")

  -- Resolve relative file paths against the working directory
  local abs = path
  if abs:sub(1, 1) ~= "/" then
    abs = wd .. "/" .. abs
  end
  abs = normalize(abs)

  -- If the file is already marked, remove the mark instead
  if marked[abs] then
    for i, entry in ipairs(bak_list) do
      if entry.src == abs then
        table.remove(bak_list, i)
        break
      end
    end
    marked[abs] = nil
    mp.osd_message("Backup: mark removed")
    return
  end

  -- Lock in the relative path now, so a later change of working directory does not affect it
  local rel
  if abs:sub(1, #wd + 1) == wd .. "/" then
    -- File is under the working directory: keep the relative path
    rel = abs:sub(#wd + 2)
  else
    -- File is outside the working directory: keep only the filename
    rel = abs:match("([^/]+)$")
  end

  marked[abs] = true
  table.insert(bak_list, { src = abs, rel = rel })
  mp.osd_message("Backup: marked " .. rel)
end

-- Copy all marked files to the backup directory when mpv shuts down
local function bak_file()
  if #bak_list == 0 then
    return
  end

  local wd = normalize(mp.get_property("working-directory") or "")

  -- Resolve the backup root against the working directory unless it is absolute
  local root
  if BackupFilesPath:sub(1, 1) == "/" then
    root = normalize(BackupFilesPath)
  else
    root = normalize(wd .. "/" .. BackupFilesPath)
  end
  ensure_dir(root)

  for _, entry in ipairs(bak_list) do
    local dest = root .. "/" .. entry.rel

    if not file_exists(entry.src) then
      mp.msg.warn("Skipped, source file not found: " .. entry.src)
    elseif file_exists(dest) then
      -- A file with the same name already exists in the backup location
      mp.msg.info("Skipped, backup already exists: " .. dest)
    else
      ensure_dir(dirname(dest))
      if copy_file(entry.src, dest) then
        mp.msg.info("Backed up: " .. dest)
      else
        mp.msg.error("Failed to back up: " .. entry.src)
      end
    end
  end
end

mp.add_key_binding("\\", "mark_backup", mark_backup)
mp.register_event("shutdown", bak_file)
