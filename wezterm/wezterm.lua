local wezterm = require("wezterm")
CONFIG = wezterm.config_builder()
CONFIG = {
	automatically_reload_config = true,
	enable_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	font_size = 14,
	max_fps = 30,
	background = {
		{
			source = {
				File = "/Users/chris/Documents/Wallpaper/725002.png",
			},
			hsb = {
				brightness = 0.1,
			},
			horizontal_align = "Center",
		},
	},
	keys = {
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "n",
			mods = "CMD",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "n",
			mods = "CMD|SHIFT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		-- Command+Left Arrow - move backward one word
		{
			key = "LeftArrow",
			mods = "CMD",
			action = wezterm.action.SendKey({
				key = "b",
				mods = "ALT",
			}),
		},
		-- Command+Right Arrow - move forward one word
		{
			key = "RightArrow",
			mods = "CMD",
			action = wezterm.action.SendKey({
				key = "f",
				mods = "ALT",
			}),
		},
		-- Command+Up Arrow - move to beginning of line
		{
			key = "UpArrow",
			mods = "CMD",
			action = wezterm.action.SendKey({
				key = "a",
				mods = "CTRL",
			}),
		},
		-- Command+Down Arrow - move to end of line
		{
			key = "DownArrow",
			mods = "CMD",
			action = wezterm.action.SendKey({
				key = "e",
				mods = "CTRL",
			}),
		},
	},
}
return CONFIG
