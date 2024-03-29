return {
	-- project management
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function(_, opts)
			require("project_nvim").setup(opts)
			require("telescope").load_extension("projects")
		end,
		keys = {
			{ "<leader>p", "<Cmd>Telescope projects<CR>", desc = "Projects" },
		},
	},
}
