local wezterm = require 'wezterm'

local config = {}

config.font = wezterm.font 'JetBrains Mono'

config.color_scheme = 'Tokyo Night Moon'


config.unix_domains = {
    {
        name = "orca-wez",
        proxy_command = {"docker", "exec", "-i", "orca-orca-1", "wezterm", "cli", "proxy"}
    },
    {
        name = "orca-nap-wez",
        proxy_command = {"ssh", "orca-nap", "wezterm", "cli", "proxy"}
    }
}

return config
