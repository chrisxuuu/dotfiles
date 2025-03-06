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
	},
}

return CONFIG
