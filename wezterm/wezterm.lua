-- Pull in the wezterm API
local wezterm = require("wezterm")

local act = wezterm.action

local function tab_title(tab_info)
	-- if the tab title is explicitly set, take that
	if tab_info.tab_title and #tab_info.tab_title > 0 then
		return tab_info.tab_title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	local title = tab_info.active_pane.title
	-- do not display nvim path in tab
	title = title:gsub("%(.*%)", "")
	-- remove trailing spaces
	return title:gsub("%s+", " ")
end

wezterm.on("update-right-status", function(window, pane)
	local date = wezterm.strftime("%a %-d %b %H:%M ")
	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.fa_clock_o .. " " .. date },
	}))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- The filled in variant of the < symbol
	local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
	local SOLID_LEFT_MOST = utf8.char(0x2588)
	-- The filled in variant of the > symbol
	local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

	local edge_background = "#121212"
	local background = "#4E4E4E"
	local foreground = "#1C1B19"
	local dim_foreground = "#3A3A3A"

	if tab.is_active then
		background = "#66aaed"
		foreground = "#1C1B19"
	elseif hover then
		background = "#274e75"
		foreground = "#1C1B19"
	end

	local edge_foreground = background

	local title = tab_title(tab)
	local left_arrow = SOLID_LEFT_ARROW

	local zoom_str = ""

	if tab.tab_index == 0 then
		left_arrow = SOLID_LEFT_MOST
	end

	if tab.active_pane.is_zoomed then
		zoom_str = "[Z]"
	end

	return {
		{ Attribute = { Intensity = "Bold" } },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = left_arrow },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },

		{ Text = tab.tab_index + 1 .. "|" .. tab.active_pane.pane_index + 1 .. ": " .. title .. " " .. zoom_str },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
		{ Attribute = { Intensity = "Normal" } },
	}
end)

local config = {}
-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.window_background_opacity = 0.7

-- Apply background effects for macos
config.macos_window_background_blur = 30

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_max_width = 60
config.tab_bar_at_bottom = true

config.font = wezterm.font("JetBrainsMono Nerd Font")
-- config.font = wezterm.font("Iosevka Term")
-- config.font = wezterm.font("VictorMono Nerd Font")

--<!-- -- != := === == != >= >- >=> |-> -> <$> </> #[ |||> |= ~@

config.font_size = 12
config.freetype_load_flags = "NO_HINTING"

config.colors = {
	visual_bell = "grey",
	tab_bar = {
		background = "#121212",
		new_tab = { bg_color = "#121212", fg_color = "#FCE8C3", intensity = "Bold" },
		new_tab_hover = { bg_color = "#121212", fg_color = "#FBB829", intensity = "Bold" },
		active_tab = { bg_color = "#121212", fg_color = "#FCE8C3" },
	},
}

config.window_decorations = "RESIZE"

config.front_end = "WebGpu"

config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0cell",
}

config.audible_bell = "Disabled"

config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 50,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 50,
}

config.keys = {
	-- Rebind CTRL-SHIFT <-/-> to match TMUX keybindings
	{
		key = "LeftArrow",
		mods = "SHIFT|CTRL",
		action = act.SendKey({
			key = "LeftArrow",
			mods = "SHIFT|CTRL",
		}),
	},
	{
		key = "RightArrow",
		mods = "SHIFT|CTRL",
		action = act.SendKey({
			key = "RightArrow",
			mods = "SHIFT|CTRL",
		}),
	},
}

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 50000 }
local tmux_keymap = {
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{
		key = "a",
		mods = "LEADER|CTRL",
		action = act.SendKey({ key = "a", mods = "CTRL" }),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "|",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = "TogglePaneZoomState",
	},
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "h",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "H",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Left", 5 }),
	},
	{
		key = "J",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Down", 5 }),
	},
	{
		key = "K",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Up", 5 }),
	},
	{
		key = "L",
		mods = "LEADER",
		action = act.AdjustPaneSize({ "Right", 5 }),
	},
	{
		key = "&",
		mods = "LEADER",
		action = act.CloseCurrentTab({ confirm = true }),
	},
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = ";",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Next"),
	},
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },
	{ key = "PageUp", action = act.ScrollByPage(-0.5) },
	{ key = "PageDown", action = act.ScrollByPage(0.5) },
}
for i = 1, #tmux_keymap do
	table.insert(config.keys, tmux_keymap[i])
end

-- and finally, return the configuration to wezterm
return config
