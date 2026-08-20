
-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Enable UI2
require('vim._core.ui2').enable()

-- PLUGINS

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
-- vim.cmd('packadd! nohlsearch')

-- Install third-party plugins via "vim.pack.add()".
vim.pack.add({
  -- Quickstart configs for LSP
  'https://github.com/neovim/nvim-lspconfig',
  -- Fuzzy picker
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/kyazdani42/nvim-web-devicons',
  -- Autocompletion
  'https://github.com/nvim-mini/mini.completion',
  -- Enhanced quickfix/loclist
  'https://github.com/stevearc/quicker.nvim',
  -- Git integration
  'https://github.com/lewis6991/gitsigns.nvim',
  -- File navigation
  'https://github.com/nvim-mini/mini.files',
  -- Color scheme
  'https://github.com/sainnhe/gruvbox-material',
  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  -- Grug-Far
  'https://github.com/MagicDuck/grug-far.nvim',
  -- Diff view
  'https://github.com/sindrets/diffview.nvim',
  -- Neogit
  'https://github.com/neogitorg/neogit',
})

require('fzf-lua').setup {
  fzf_colors = true,
  defaults = { file_icons = false, git_icons = false },
  -- files = { file_icons = false, git_icons = false },
  -- oldfiles = { file_icons = false, git_icons = false },
  winopts = {
    split = "botright new",
    preview = {
      layout = "flex",
      vertical = "down:50%",
      horizontal = "right:50%",
    },
  },
  grep = {
    rg_glob_fn = function(query, opts)
      local search, flags = query:match("^(.-)%s+%-%-%s+(.*)$")
      if not search then
        return query, nil
      end
      return search, flags
    end,
  },
}
require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {}
require('mini.files').setup {
  mappings = {
    reset = '_',
  }
}
require('grug-far').setup {}
require('neogit').setup {
  disable_line_numbers = false,
  disable_relative_line_numbers = false,
}

require("diffview").setup({
  keymaps = {
    view = {
      { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
    },
    file_panel = {
      { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
    },
    file_history_panel = {
      { "n", "q", "<cmd>DiffviewClose<CR>", { desc = "Close Diffview" } },
    },
  },
})

require('config.options')
require('config.diagnostics')
require('config.treesitter')
require('config.lsp')
require('config.qmk')
require('config.keymaps')
require('config.autocmds')
require('config.usercmds')

vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_background = 'medium'
vim.cmd.colorscheme('gruvbox-material')

-- Neovide config
if vim.g.neovide then
  vim.o.guifont = "IosevkaTerm Nerd Font:h10.5"
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  -- vim.g.neovide_scroll_animation_far_lines = 0
  -- vim.g.neovide_scroll_animation_length = 0.00
end

