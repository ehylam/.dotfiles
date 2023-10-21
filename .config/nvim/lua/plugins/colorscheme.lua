local function is_day_time()
	local hour = tonumber(os.date("%H"))
	return hour >= 9 and hour < 19
end
-- Select colorscheme based on the time, and load it with LazyVim
-- day time: tokyonight (moon)
-- night time: random from {nightfox, rose-pine, catppuccin-frappe, everforest, dracula}
local function selectColorSchemeByTime()
	-- skip if running in vscode
	if vim.g.vscode then
		return "tokyonight"
	end

	local colorscheme
	local night_themes = {
		"tokyonight",
		"nightfox",
		"rose-pine",
		"catppuccin-frappe",
		"everforest",
		"dracula",
		"kanagawa",
		"embark",
		"nordic",
	}

	local idx = tonumber(os.date("%S")) % #night_themes + 1
	colorscheme = night_themes[idx]

	vim.notify("Selected colorscheme: " .. colorscheme)
	return colorscheme
end

local is_transparent = is_day_time()

return {
	{
		"EdenEast/nightfox.nvim",
		opts = {
			options = {
				transparent = is_transparent,
				styles = is_transparent and {
					comments = "italic",
					keywords = "bold",
					types = "italic,bold",
				} or {},
			},
		},
		lazy = true,
	},
	{ "embark-theme/vim", name = "embark" },
	{
		"AlexvZyl/nordic.nvim",
		name = "nordic",
		lazy = true,
		priority = 1000,
		config = function()
			require("nordic").load()
		end,
	},
	{
		"rose-pine/neovim",
		name = "rose-pine",
		opts = {
			variant = "moon",
			disable_background = is_transparent,
			disable_float_background = is_transparent,
		},
		lazy = true,
	},
	{
		"catppuccin/nvim",
		lazy = true,
		name = "catppuccin",
		opts = {
			transparent_background = is_transparent,
		},
	},
	{
		"rebelot/kanagawa.nvim",
		opts = {
			theme = "dragon",
		},
	},
	{
		"sainnhe/everforest",
		config = function()
			-- " Available values: 'hard', 'medium'(default), 'soft'
			vim.g.everforest_background = "soft"
			vim.g.everforest_transparent_background = 1
			-- For better performance
			vim.g.everforest_better_performance = 1
			-- Enable italic
			vim.g.everforest_enable_italic = 1
		end,
		lazy = true,
	},
	{
		"Mofiqul/dracula.nvim",
		opts = {
			transparent_bg = is_transparent,
			show_end_of_buffer = true,
			-- set italic comment
			italic_comment = true,
		},
		config = function(_, opts)
			local dracula = require("dracula")
			dracula.setup(opts)
			-- Disable spell check as it's too red
			vim.o.spell = false
		end,
		lazy = true,
	},
	-- default is tokyonight in moon style
	{
		"folke/tokyonight.nvim",
		opts = {
			style = "moon",
			transparent = is_transparent,
			styles = is_transparent and {
				sidebars = "transparent",
				floats = "transparent",
			} or {},
		},
	},

	-- set LazyVim to load colorscheme
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = selectColorSchemeByTime(),
		},
	},
}
