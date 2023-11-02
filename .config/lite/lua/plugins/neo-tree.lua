return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
			bind_to_cwd = false,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
      filtered_items = {
				visible = true,
				show_hidden_count = true,
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_by_name = {
					'.git',
					'.DS_Store',
					'thumbs.db',
				},
				never_show = {},
      },
    }
  }
}