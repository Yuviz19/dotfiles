-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 28
config.window_decorations = "NONE"
config.enable_tab_bar = false
config.enable_wayland = false

-- or, changing the font size and color scheme.
config.font_size = 13
config.color_scheme = "Tokyo Night Moon"

-- Finally, return the configuration to wezterm:
return config
