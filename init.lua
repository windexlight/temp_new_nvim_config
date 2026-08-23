
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
  -- Mini.ai
  'https://github.com/nvim-mini/mini.ai',
  -- Grug-Far
  'https://github.com/MagicDuck/grug-far.nvim',
  -- Diff view
  'https://github.com/dlyongemallo/diffview-plus.nvim',
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
require('mini.files').setup {
  mappings = {
    reset = '_',
  }
}

local spec_treesitter = require('mini.ai').gen_spec.treesitter
require('mini.ai').setup {
  n_lines = 500,
  custom_textobjects = {
    a = spec_treesitter { a = '@parameter.outer', i = '@parameter.inner' },
    c = spec_treesitter { a = '@class.outer', i = '@class.inner' },
    f = spec_treesitter { a = '@function.outer', i = '@function.inner' },
    F = spec_treesitter { a = '@call.outer', i = '@call.inner' },
    o = spec_treesitter {
      a = { '@block.outer', '@conditional.outer', '@loop.outer' },
      i = { '@block.inner', '@conditional.inner', '@loop.inner' },
    },
  },
  -- Defaults:
  -- mappings = {
  --   -- Main textobject prefixes
  --   around = 'a',
  --   inside = 'i',
  --
  --   -- Next/last textobjects
  --   -- NOTE: This (deliberately) overrides Neovim>=0.12 built-in incremental
  --   -- selection mappings. See `:h MiniAi-default-an-in` for more details.
  --   around_next = 'an',
  --   inside_next = 'in',
  --   around_last = 'al',
  --   inside_last = 'il',
  --
  --   -- Move cursor to corresponding edge of `a` textobject
  --   goto_left = 'g[',
  --   goto_right = 'g]',
  -- },
  -- ┌───┬───────────────┬──────────────────┬────────┬────────┬────────┬────────┐
  -- │Key│     Name      │   Example line   │   a    │   i    │   2a   │   2i   │
  -- ├───┴───────────────┴──────────────────┴────────┴────────┴────────┴────────┤
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ ( │  Balanced ()  │ (( *a (bb) ))    │        │        │        │        │
  -- │ [ │  Balanced []  │ [[ *a [bb] ]]    │ [2;12] │ [4;10] │ [1;13] │ [2;12] │
  -- │ { │  Balanced {}  │ {{ *a {bb} }}    │        │        │        │        │
  -- │ < │  Balanced <>  │ << *a <bb> >>    │        │        │        │        │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ ) │  Balanced ()  │ (( *a (bb) ))    │        │        │        │        │
  -- │ ] │  Balanced []  │ [[ *a [bb] ]]    │        │        │        │        │
  -- │ } │  Balanced {}  │ {{ *a {bb} }}    │ [2;12] │ [3;11] │ [1;13] │ [2;12] │
  -- │ > │  Balanced <>  │ << *a <bb> >>    │        │        │        │        │
  -- │ b │  Alias for    │ [( *a {bb} )]    │        │        │        │        │
  -- │   │  ), ], or }   │                  │        │        │        │        │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ " │  Balanced "   │ "*a" " bb "      │        │        │        │        │
  -- │ ' │  Balanced '   │ '*a' ' bb '      │        │        │        │        │
  -- │ ` │  Balanced `   │ `*a` ` bb `      │ [1;4]  │ [2;3]  │ [6;11] │ [7;10] │
  -- │ q │  Alias for    │ '*a' " bb "      │        │        │        │        │
  -- │   │  ", ', or `   │                  │        │        │        │        │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ ? │  User prompt  │ e*e o e o o      │ [3;5]  │ [4;4]  │ [7;9]  │ [8;8]  │
  -- │   │(typed e and o)│                  │        │        │        │        │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ t │      Tag      │ <x><y>*a</y></x> │ [4;12] │ [7;8]  │ [1;16] │ [4;12] │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ f │ Function call │ f(a, g(*b, c) )  │ [6;13] │ [8;12] │ [1;15] │ [3;14] │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │ a │   Argument    │ f(*a, g(b, c) )  │ [3;5]  │ [3;4]  │ [5;14] │ [7;13] │
  -- ├┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈1234567890123456┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┈┤
  -- │   │    Default    │ aa_*b__cc___     │ [4;7]  │ [4;5]  │ [8;12] │ [8;9]  │
  -- │   │   (typed _)   │                  │        │        │        │        │
  -- └───┴───────────────┴──────────────────┴────────┴────────┴────────┴────────┘
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
local keymaps = require('config.keymaps')
require('config.autocmds')
require('config.usercmds')

require('gitsigns').setup {
  on_attach = keymaps.gitsigns_on_attach
}

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

