local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Tokyo Night"
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", scale = 1.2 },
})

config.window_background_opacity = 0.9
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "home"

-- Dim inactive RotatePanes
config.inactive_pane_hsb = { saturation = 0.5, brightness = 0.5 }

-- keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "|", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{
		key = "v",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local dim = pane:get_dimensions()
			if dim.pixel_width > dim.pixel_height then
				window:perform_action(act.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
			else
				window:perform_action(act.SplitVertical({ domain = "CurrentPaneDomain" }), pane)
			end
		end),
	},
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "phys:Space", mods = "LEADER", action = act.RotatePanes("Clockwise") },
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- Tab keybindings
	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "m", mods = "LEADER", action = act.ActivateKeyTable({ name = "move_tabs", one_shot = false }) },

	{ key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
}
for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
	move_tabs = {
		{ key = "h", action = act.MoveTabRelative(-1) },
		{ key = "l", action = act.MoveTabRelative(-1) },
		{ key = "k", action = act.MoveTabRelative(1) },
		{ key = "j", action = act.MoveTabRelative(1) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},
}
config.debug_key_events = true
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
	-- Worskapce name
	local ws = window:active_workspace()

	if window:active_key_table() then
		ws = window:active_key_table()
	end
	if window:leader_is_active() then
		ws = "LEADER ACTIVE"
	end

	local basename = function(s)
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end
	local process_name = basename(pane:get_foreground_process_name())
	local cwd = basename(pane:get_current_working_dir().path)

	local time = wezterm.strftime("%H:%M")

	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. ws },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.fa_code .. "  " .. process_name },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		{ Text = " | " },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time },
	}))
end)

return config
