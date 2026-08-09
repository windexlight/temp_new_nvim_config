local map = vim.keymap.set

-- RPC stuff for QMK
vim.fn.serverstart([[\\.\pipe\nvim-win-]] .. vim.fn.getpid())

-- Notify via RPC when mode changes
local function notify_mode_change()
  local current_mode = vim.api.nvim_get_mode().mode
  vim.rpcnotify(0, "mode_change", current_mode)
end
vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  callback = notify_mode_change,
})
-- This is to work around an issue with ModeChanged not always firing when closing a window such as fzf-lua. Keep an eye out for other issues.
vim.api.nvim_create_autocmd("TermLeave", {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      notify_mode_change()
    end)
  end,
})

-- Notify via RPC when using r, f, F, t, T and waiting for next char (treat it like insert mode)
local ns = vim.api.nvim_create_namespace("rpc_char_tracker")
local waiting_for_char = false
local f_wrapper_armed = false
vim.on_key(function(key)
  if f_wrapper_armed then
    vim.rpcnotify(0, "mode_change", "i")
    waiting_for_char = true
    f_wrapper_armed = false
  elseif waiting_for_char then
    vim.rpcnotify(0, "mode_change", "n")
    waiting_for_char = false
  end
end, ns)

local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next) -- TODO -- These don't seem to actually work if there is an f or t in history
map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

local function f_wrapper(call_me)
  f_wrapper_armed = true
  return call_me()
end

local function r_wrapper()
  f_wrapper_armed = true
  return "r"
end

-- Make builtin f, F, t, T also repeatable with ; and ,
map({ "n", "x", "o" }, "f", function() return f_wrapper(ts_repeat_move.builtin_f_expr) end, { expr = true })
map({ "n", "x", "o" }, "F", function() return f_wrapper(ts_repeat_move.builtin_F_expr) end, { expr = true })
map({ "n", "x", "o" }, "t", function() return f_wrapper(ts_repeat_move.builtin_t_expr) end, { expr = true })
map({ "n", "x", "o" }, "T", function() return f_wrapper(ts_repeat_move.builtin_T_expr) end, { expr = true })
map({ "n", "x", "o" }, "r", r_wrapper, { expr = true })

