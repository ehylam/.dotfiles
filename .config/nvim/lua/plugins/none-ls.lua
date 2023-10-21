local ok, none_ls = pcall(require, "null-ls")
if not ok then
  return
end

local b = none_ls.builtins


-- Helper function to traverse up directory tree and find if a file exists
local function find_upwards(filename)
  local current_dir = vim.fn.expand("%:p:h")
  local search_count = 0

  local max_search = 10 -- search up to parent directories
  while current_dir ~= "/" and search_count < max_search do
    if vim.loop.fs_stat(current_dir .. "/" .. filename) then
      return current_dir
    end
    -- stop find if we reach a git repo
    if vim.loop.fs_stat(current_dir .. "/.git") then
      return nil
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
    search_count = search_count + 1
  end

  return nil
end

local function prettier_config_dir()
  local prettier_files = {
    -- List of possible Prettier config files
    ".prettierrc",
    ".prettierrc.json",
    ".prettierrc.yml",
    ".prettierrc.yaml",
    ".prettierrc.json5",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.toml",
    "prettier.config.js",
    "prettier.config.cjs",
    "prettier.config.mjs",
    -- "package.json", ignore package.json for monorepo as the prettier config is usually in the root
  }

  for _, file in ipairs(prettier_files) do
    local dir = find_upwards(file)
    if dir then
      return dir
    end
  end

  return nil
end

local function biome_config_exists()
  local current_dir = vim.fn.getcwd()
  local config_file = current_dir .. "/biome.json"
  if vim.fn.filereadable(config_file) == 1 then
    return true
  end

  return false
end

-- formatters
return {
  "nvimtools/none-ls.nvim",
  keys = {
    { "<leader>cn", "<cmd>NullLsInfo<cr>", desc = "NullLs Info" },
  },
  dependencies = { "mason.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local sources = {

      -- spell check
      b.diagnostics.codespell,
      b.diagnostics.misspell,


      -- prettier
      b.formatting.prettier.with({
        condition = function()
          return not biome_config_exists() and prettier_config_dir()
        end,
      }),

      -- biome
      b.formatting.biome.with({
        condition = function()
          return biome_config_exists() and not prettier_config_dir()
        end,
      }),

      -- Lua
      b.formatting.stylua,

      -- proto buf
      b.diagnostics.protolint, -- brew tap yoheimuta/protolint && brew install protolint

      -- Php - comment out as I don't use php much
      -- b.formatting.pint,
    }

    return {
      sources = sources,
      debounce = 200,
      debug = true,
    }
  end,
}
