local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()
local launch_menu = {}
local is_windows = wezterm.target_triple == "x86_64-pc-windows-msvc"

-- appearance / theme
config.color_scheme = "Catppuccin Mocha"
local scheme = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
print(scheme.background)
-- background
config.background = {
	-- base layer
	{
		source = { Color = scheme.background },
		width = "100%",
		height = "100%",
		opacity = 0.95,
	},
	-- image layer
	{
		source = { File = wezterm.config_dir .. "/background.png" },
		vertical_align = "Bottom",
		horizontal_align = "Right",
		width = "Cover",
		height = "Cover",
		hsb = {
			brightness = 0.1,
		},
		opacity = 0.5,
	},
}

-- config.font = wezterm.font("Hack Nerd Font")
config.font = wezterm.font("Monaspace Neon")
-- style the titlebar with theme
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_fancy_tab_bar = true
config.show_tab_index_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = true
config.use_resize_increments = true
config.window_frame = {
	font = wezterm.font({ family = "Hack Nerd Font", weight = "Bold" }),
	font_size = 12.0,

	active_titlebar_bg = scheme.tab_bar.background,
	inactive_titlebar_bg = scheme.tab_bar.background,
}
config.colors = {
	tab_bar = {
		inactive_tab_edge = scheme.tab_bar.inactive_tab_edge,
	},
}
config.window_padding = {
	left = 0,
	right = 0,
	top = 4,
	bottom = 0,
}

config.initial_cols = 120
config.initial_rows = 30
config.window_close_confirmation = "NeverPrompt"

config.max_fps = 144

config.ui_key_cap_rendering = "WindowsLong"

-- tab bar formatting
local function tab_title(tab_info)
	local title = tab_info.tab_title

	-- if title is explicitly set
	if title and #title > 0 then
		return title
	end

	-- return title
	return tab_info.active_pane.title
end

local function tab_title_remap(tab_info)
	local title = tab_title(tab_info)

	local remaps = {
		["pwsh.exe"] = "PowerShell",
		["neovim.exe"] = "neovim",
	}

	if remaps[title] then
		return remaps[title]
	end

	return title
end

-- extra utilities

---check if string 'str' starts with 'start'
---@param str string
---@param start string
---@return boolean
local function starts_with(str, start)
	return string.sub(str, 1, string.len(start)) == start
end

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
	local title = tab_title_remap(tab)

	local style = scheme.tab_bar.inactive_tab

	if hover then
		style = scheme.tab_bar.inactive_tab_hover
	end

	if tab.is_active then
		style = scheme.tab_bar.active_tab
	end

	local icon

	if string.find(title, "vim") then
		icon = wezterm.nerdfonts.custom_vim
	end

	if string.find(title, "node") or string.find(title, "bun") then
		icon = wezterm.nerdfonts.dev_nodejs_small
	end

	local title_with_icon = icon and icon .. " " .. title or title

	return {
		{ Background = { Color = style.bg_color } },
		{ Foreground = { Color = style.fg_color } },
		{ Text = " " .. title_with_icon .. " " },
	}
end)

-- style command palette with theme
config.command_palette_bg_color = scheme.tab_bar.background

-- status bar
config.status_update_interval = 1000
wezterm.on("update-status", function(window, pane)
	local stat = pane:get_domain_name()

	if window:active_key_table() then
		stat = window:active_key_table()
	end
	if window:leader_is_active() then
		stat = "< LDR >"
	end
	local basename = function(s)
		if not s then
			return ""
		end
		return string.gsub(s, "(.*[/\\])(.*)", "%2")
	end

	-- FIXME: cwd is "" on pwsh, and "kyle" on wsl (not changing properly)
	local cwd = pane:get_current_working_dir()
	if cwd == nil then
		cwd = "cwd"
	else
		cwd = cwd.file_path
	end

	cwd = basename(cwd)

	local cmd = basename(pane:get_foreground_process_name())

	local time = wezterm.strftime("%H:%M")

	-- set app icon based on domain (os)
	-- nerdfonts reference: https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
	local app_icon = wezterm.nerdfonts.dev_terminal
	if pane:get_domain_name() == "WSL:Ubuntu" then
		app_icon = wezterm.nerdfonts.dev_ubuntu
	elseif pane:get_domain_name() == "WSL:NixOS" then
		app_icon = wezterm.nerdfonts.linux_nixos
	elseif is_windows and pane:get_domain_name() == "local" then
		app_icon = wezterm.nerdfonts.dev_windows
	end

	window:set_left_status(wezterm.format({
		{ Text = " " .. app_icon .. "  " },
	}))

	-- hide program if its wsl
	local show_cmd = true
	if starts_with(pane:get_domain_name(), "WSL") then
		show_cmd = false
	end

	-- FIXME: not working
	if pane:get_user_vars()["cmd"] then
		cmd = pane:get_user_vars()["cmd"]
		show_cmd = true
		wezterm.log_info(cmd)
	end

	window:toast_notification("status", "updated!", nil, 4000)

	window:set_right_status(wezterm.format({
		{ Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
		{ Text = " | " },
		-- { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
		-- { Text = " | " },
		-- { Text = show_cmd and wezterm.nerdfonts.fa_code .. "  " .. cmd or "" },
		-- { Text = show_cmd and " | " or "" },
		{ Text = wezterm.nerdfonts.md_clock .. "  " .. time .. "  " },
		-- { Text = " | " },
	}))
end)

if is_windows then
	-- add pwsh.exe to list of domains
	table.insert(launch_menu, {
		label = "Windows PowerShell",
		args = { "pwsh.exe", "-NoLogo" },
		domain = { DomainName = "local" },
	})

	-- use wsl2 as default launch profile
	-- config.default_domain = "WSL:Ubuntu"
	config.default_domain = "local"
	config.default_prog = { "pwsh.exe", "-NoLogo" }
end

-- custom command palette
wezterm.on("augment-command-palette", function(_window, _pane)
	return {
		{
			brief = "Edit Wezterm Config",
			icon = "md_wrench",

			action = act.SpawnCommandInNewTab({
				domain = "DefaultDomain",
				args = { "nvim", "./.config/wezterm/wezterm.lua" },
			}),
		},
	}
end)

-- keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
	-- send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

	{ key = "c", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "l", mods = "LEADER", action = act.ActivateLastTab },
	{ key = "l", mods = "LEADER|SHIFT", action = act.ShowLauncher },
	{ key = "p", mods = "LEADER", action = act.ActivateCommandPalette },

	{ key = "UpArrow", mods = "SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "SHIFT", action = act.ScrollToPrompt(1) },

	-- tab bindings
	{ key = "n", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "[", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "]", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "t", mods = "LEADER|SHIFT", action = act.ShowTabNavigator },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },

	-- move to new tab
	{
		key = "!",
		mods = "LEADER|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab, window = pane:move_to_new_tab()
			pane:activate()
		end),
	},

	-- === pane bindings ===
	-- navigation
	{ key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection("Right") },
	{ key = "s", mods = "LEADER", action = act.PaneSelect },
	-- splits
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- show a small terminal at the bottom
	{
		key = "t",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			command = {
				domain = "CurrentPaneDomain",
			},
			size = { Percent = 20 },
		}),
	},
	-- zoom
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- key tables
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "manage_panes", one_shot = false }) },
}

config.key_tables = {
	-- would be cool to make this a "pane crafting" mode, where you can resize, split, navigate/pick, etc
	manage_panes = {
		-- resize by 1
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- resize by 5
		{ key = "LeftArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
		{ key = "h", mods = "SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },

		{ key = "RightArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
		{ key = "l", mods = "SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },

		{ key = "UpArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
		{ key = "k", mods = "SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },

		{ key = "DownArrow", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
		{ key = "j", mods = "SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },

		-- rotate panes
		{ key = "r", action = act.RotatePanes("Clockwise") },
		{ key = "r", mods = "SHIFT", action = act.RotatePanes("CounterClockwise") },

		-- switch panes by direction
		{ key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "h", mods = "CTRL", action = act.ActivatePaneDirection("Left") },
		{ key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
		{ key = "l", mods = "CTRL", action = act.ActivatePaneDirection("Right") },
		{ key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "k", mods = "CTRL", action = act.ActivatePaneDirection("Up") },
		{ key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection("Down") },
		{ key = "j", mods = "CTRL", action = act.ActivatePaneDirection("Down") },

		-- create / destroy panes
		{ key = "%", mods = "SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = "|", mods = "SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
		{ key = '"', mods = "SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "_", mods = "SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
		{ key = "x", action = act.CloseCurrentPane({ confirm = true }) },
		{ key = "x", mods = "SHIFT", action = act.CloseCurrentPane({ confirm = false }) },

		-- Cancel the mode by pressing escape, enter, or space
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "Enter", action = "PopKeyTable" },
		{ key = "Space", action = "PopKeyTable" },
	},
}

local copy_mode_kt
if wezterm.gui then
	copy_mode_kt = wezterm.gui.default_key_tables().copy_mode

	table.insert(copy_mode_kt, {
		key = "i",
		action = act.CopyMode("Close"),
	})
	table.insert(copy_mode_kt, {
		key = "a",
		action = act.CopyMode("Close"),
	})
end

config.key_tables.copy_mode = copy_mode_kt

for i = 1, 9 do
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
	table.insert(config.keys, {
		key = tostring(i),
		mods = "LEADER|CTRL",
		action = act.ActivatePaneByIndex(i - 1),
	})
end

config.launch_menu = launch_menu
return config
