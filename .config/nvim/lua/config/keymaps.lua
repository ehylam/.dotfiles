-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

-- Dashboard
-- Add keymap to open alpha dashboard
keymap("n", "<leader>;", function()
	-- close all open buffers before open dashboard
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		---@diagnostic disable-next-line: redundant-parameter
		local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
		if buftype ~= "terminal" then
			vim.api.nvim_buf_delete(bufnr, { force = true })
		end
	end

	if Util.has("alpha-nvim") then
		require("alpha").start(true)
	end
end, opts)

-- Close buffers
if Util.has("mini.bufremove") then
	keymap("n", "<S-q>", function()
		require("mini.bufremove").delete(0, false)
		local bufs = vim.fn.getbufinfo({ buflisted = true })
		-- open alpha if no buffers are left
		if not bufs[2] and Util.has("alpha-nvim") then
			require("alpha").start(true)
		end
	end, opts)
else
	keymap("n", "<S-q>", "<cmd>bd<CR>", opts)
end

keymap("n", "<leader>\\", "<cmd>:Lazy<CR>", { desc = "Lazy Plugins" })

-- Better paste
-- remap "p" in visual mode to delete the highlighted text without overwriting your yanked/copied text, and then paste the content from the unnamed register.
keymap("v", "p", '"_dP', opts)

-- Copy whole file content to clipboard with C-c
keymap("n", "<C-c>", ":%y+<CR>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move live up or down
-- moving
keymap("n", "<A-Down>", ":m .+1<CR>", opts)
keymap("n", "<A-Up>", ":m .-2<CR>", opts)
keymap("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
keymap("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
keymap("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
keymap("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +0<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -0<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -0<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +0<cr>", { desc = "Increase window width" })
keymap("n", "<leader>j", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>l", "<C-W>v", { desc = "Split window right" })

-- Show Lsp info
keymap("n", "<leader>cl", "<cmd>LspInfo<CR>", opts)

-- Floating terminal
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Show references on telescope
if Util.has("telescope.nvim") then
	keymap("n", "gr", "<cmd>Telescope lsp_references<CR>")
end

-- Trouble
-- Add keymap only show FIXME
if Util.has("todo-comments.nvim") then
	-- show fixme on telescope
	keymap("n", "<leader>xf", "<cmd>TodoTelescope keywords=FIX,FIXME<CR>", {
		desc = "Show FIXME",
	})
end

-- Gitsigns
-- Add toggle gitsigns blame line
if Util.has("gitsigns.nvim") then
	keymap("n", "<leader>ub", "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>", {
		desc = "Toggle current line blame",
	})
end

-- Harpoon
if Util.has("harpoon") then
	keymap("n", "<leader>hh", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", {
		desc = "Toggle Harpoon menu",
	})

	keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", {
		desc = "Add file to Harpoon",
	})
end

-- Fix Spell checking
keymap("n", "z0", "1z=", {
	desc = "Fix world under cursor",
})
