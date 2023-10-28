local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action
local config = {}

config.color_scheme = "Andromeda"
config.font = wezterm.font_with_fallback({
	"Fira Code",
	"JetBrains Mono",
	"IBM Plex Mono",
})
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
	-- allow `wezterm start -- something` to affect what we spawn
	-- in our initial window
	local args = {}
	if cmd then
		args = cmd.args
	end

	-- Set a workspace for coding on a current project
	-- Top pane is for the editor, bottom pane is for the build tool
	local project_dir = wezterm.home_dir .. "/documents/sites"
	local tab, build_pane, window = mux.spawn_window({
		workspace = "coding",
		cwd = project_dir,
		args = args,
	})

	local editor_pane = build_pane:split({
		direction = "Top",
		size = 0.95,
		cwd = project_dir,
	})

	-- We want to startup in the coding workspace
	mux.set_active_workspace("coding")
end)

-- Show which key table is active in the status area
wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

config.leader = { key = "a", mods = "CTRL" }
config.keys = {
	-- CTRL+SHIFT+Space, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- CTRL+SHIFT+Space, followed by 'g' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "g",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "go_to_pane",
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "add_pane",
			timeout_milliseconds = 1000,
		}),
	},
	{
		key = "W",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "workspace",
			timeout_milliseconds = 1000,
		}),
	},
	{ key = "w", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	-- activate pane selection mode with the default alphabet (labels are "a", "s", "d", "f" and so on)
	{ key = "8", mods = "CTRL", action = act.PaneSelect },
	-- activate pane selection mode with numeric labels
	{
		key = "9",
		mods = "CTRL",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	-- show the pane selection mode, but have it swap the active and selected panes
	{
		key = "0",
		mods = "CTRL",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'go_to_pane' here corresponds to the name="go_to_pane" in
	-- the key assignments above.
	go_to_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
	add_pane = {
		{ key = "h", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "l", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
		{ key = "j", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{ key = "k", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	},

	workspace = {
		{
			key = "y",
			action = act.SwitchToWorkspace({
				name = "default",
			}),
		},
		-- Switch to a monitoring workspace, which will have `top` launched into it
		{
			key = "u",
			action = act.SwitchToWorkspace({
				name = "monitoring",
				spawn = {
					args = { "top" },
				},
			}),
		},
		-- Create a new workspace with a random name and switch to it
		{ key = "i", action = act.SwitchToWorkspace },
		-- Show the launcher in fuzzy selection mode and have it list all workspaces
		-- and allow activating one.
		{
			key = "9",
			action = act.ShowLauncherArgs({
				flags = "FUZZY|WORKSPACES",
			}),
		},
		-- delete workspace
		{ key = "l", action = act.SwitchWorkspaceRelative(1) },
		{ key = "h", action = act.SwitchWorkspaceRelative(-1) },
		{
			key = "n",
			action = act.PromptInputLine({
				description = wezterm.format({
					{ Attribute = { Intensity = "Bold" } },
					{ Foreground = { AnsiColor = "Fuchsia" } },
					{ Text = "Enter name for new workspace" },
				}),
				action = wezterm.action_callback(function(window, pane, line)
					-- line will be `nil` if they hit escape without entering anything
					-- An empty string if they just hit enter
					-- Or the actual line of text they wrote
					if line then
						window:perform_action(
							act.SwitchToWorkspace({
								name = line,
							}),
							pane
						)
					end
				end),
			}),
		},
	},
}

return config
