/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int borderpx  = 2;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 12;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 15;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 0;        /* 1 means no outer gap when there is only one window */
static const int swallowfloating    = 0;        /* 1 means swallow floating windows by default */
static const int swterminheritfs    = 1;        /* 1 terminal inherits fullscreen on unswallow, 0 otherwise */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int vertpad            = 5;       /* vertical padding of bar */
static const int sidepad            = 15;       /* horizontal padding of bar */
static const char *fonts[] = {
	"DejaVuSansM Nerd Font:size=12",
	"Noto Sans CJK SC:size=12",
	"Symbols Nerd Font Mono:size=12",
	"Noto Emoji Color:size=12"
};
static const char dmenufont[] = "Sauce Code Pro Nerd Font Mono:size=12";
static const char col_gray1[]       = "#282c34";
static const char col_gray2[]       = "#353b45";
static const char col_gray3[]       = "#3e4451";
static const char col_white[]       = "#abb2bf";
static const char col_blue[]       = "#61AFEF";
static const char col_darkblue[]       = "#355f82";
static const char col_red[]       = "#e06c75";
static const char col_yellow[]       = "#e5c07b";

static const unsigned int baralpha    = 0xe0; // 0~255
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_white, col_gray1, col_gray3 },
	[SchemeSel]  = { col_white, col_gray2,  col_darkblue  },
	[SchemeStatus]    = { col_white, col_gray1,  col_gray3  }, // Statusbar right {text,background,not used but cannot be empty}
	[SchemeTagsSel]   = { col_white, col_gray2,  col_gray3  }, // Tagbar left selected {text,background,not used but cannot be empty}
	[SchemeTagsNorm]  = { col_white, col_gray1,  col_gray3  }, // Tagbar left unselected {text,background,not used but cannot be empty}
	[SchemeInfoSel]   = { col_white, col_gray1,  col_gray3  }, // infobar middle  selected {text,background,not used but cannot be empty}
	[SchemeInfoNorm]  = { col_white, col_gray1,  col_gray3  }, // infobar middle  unselected {text,background,not used but cannot be empty}
};
static const unsigned int alphas[][3]      = {
    /*               fg      bg        border*/
    [SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
	[SchemeStatus]    = { OPAQUE, baralpha, borderalpha }, // Statusbar right {text,background,not used but cannot be empty}
	[SchemeTagsSel]   = { OPAQUE, baralpha, borderalpha }, // Tagbar left selected {text,background,not used but cannot be empty}
	[SchemeTagsNorm]  = { OPAQUE, baralpha, borderalpha }, // Tagbar left unselected {text,background,not used but cannot be empty}
	[SchemeInfoSel]   = { OPAQUE, baralpha, borderalpha }, // infobar middle  selected {text,background,not used but cannot be empty}
	[SchemeInfoNorm]  = { OPAQUE, baralpha, borderalpha }, // infobar middle  unselected {text,background,not used but cannot be empty}
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class            instance    title            tags mask  iscentered  isfloating  isterminal  noswallow  monitor */
	{ "Gimp",           NULL,       NULL,            0,         0,          1,          0,           0,        -1 },
	{ "firefox",        NULL,       NULL,            0,         0,          0,          0,          -1,        -1 },
	{ "St",             NULL,       NULL,            0,         0,          0,          1,           0,        -1 },
	{ "st-256color",    NULL,       NULL,            0,         0,          0,          1,           0,        -1 },
	{ "st-float",       NULL,       NULL,            0,         1,          1,          1,           0,        -1 },
	{ NULL,             NULL,       "Event Tester",  0,         0,          0,          0,           1,        -1 }, /* xev */
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */
static const int decorhints  = 1;    /* 1 means respect decoration hints */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "D[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ NULL,       NULL },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

#define STATUSBAR "dwmblocks"

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, NULL };
static const char *termcmd[]  = { "st", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = {
    "st",   "-t",          scratchpadname, "-g", "120x35",      "-e",
    "tmux", "new-session", "-A",           "-s", "scraptchpad", NULL};
static const Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_Escape, togglescratch,  {.v = scratchpadcmd } },
	// { MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	// { MODKEY|Mod4Mask,              XK_u,      incrgaps,       {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_u,      incrgaps,       {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_i,      incrigaps,      {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_i,      incrigaps,      {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_o,      incrogaps,      {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_o,      incrogaps,      {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_6,      incrihgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_6,      incrihgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_7,      incrivgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_7,      incrivgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_8,      incrohgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_8,      incrohgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_9,      incrovgaps,     {.i = +1 } },
	// { MODKEY|Mod4Mask|ShiftMask,    XK_9,      incrovgaps,     {.i = -1 } },
	// { MODKEY|Mod4Mask,              XK_0,      togglegaps,     {0} }, // has bug
	// { MODKEY|Mod4Mask|ShiftMask,    XK_0,      defaultgaps,    {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	// { MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	// { MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_m,      togglefullscreen, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_q,                      3)
	TAGKEYS(                        XK_w,                      4)
	TAGKEYS(                        XK_e,                      5)
	// TAGKEYS(                        XK_7,                      6)
	// TAGKEYS(                        XK_8,                      7)
	// TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_Escape,  quit,          {0} },
	// `kill -l` to get all signals
	{ MODKEY,			                  XK_minus,      spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- ; kill -47 $(pidof dwmblocks)") },
	{ MODKEY|ShiftMask,							XK_minus,      spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 15%-; kill -47 $(pidof dwmblocks)") },
	{ MODKEY,												XK_equal,      spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ ; kill -47 $(pidof dwmblocks)") },
	{ MODKEY|ShiftMask,							XK_equal,      spawn,                  SHCMD("wpctl set-volume @DEFAULT_AUDIO_SINK@ 15%+; kill -47 $(pidof dwmblocks)") },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
	// { ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	// { ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

