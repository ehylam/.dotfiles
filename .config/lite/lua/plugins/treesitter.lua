return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "windwp/nvim-ts-autotag" },
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"html",
				"markdown",
				"markdown_inline",
				"css",
				"typescript",
				"tsx",
				"javascript",
				"json",
				"graphql",
				"prisma",
				"rust",
				"go",
				"toml",
				"c",
				"svelte",
			},
			auto_install = true,
			-- ensure_installed = "all", -- one of "all" or a list of languages
			ignore_install = { "" }, -- List of parsers to ignore installing
			sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

			highlight = {
				enable = true, -- false will disable the whole extension
				disable = {}, -- list of language that will be disabled
			},
			autopairs = {
				enable = true,
			},
			indent = { enable = true },

			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},

			-- auto tag
			autotag = {
				enable = true,
			},
		},
	},
}
