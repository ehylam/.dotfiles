return {
	-- cmdline tools and lsp servers
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				-- "stylua",
				"emmet-language-server",
				-- formatters
				-- "eslint_d",
				-- "prettier",
				-- "biome",
				-- code spell
				-- "codespell",
				-- "misspell",
				-- php
				-- "pint",
				-- "phpactor",
			},
		},
	},
}
