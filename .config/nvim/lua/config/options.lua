-- Loaded before lazy.nvim startup. LazyVim defaults:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Don't format on save (toggle per buffer with <leader>uf)
vim.g.autoformat = false

-- WSL: copy to the Windows clipboard via OSC 52 (works through tmux and ssh).
-- Windows Terminal doesn't support OSC 52 reads, so paste from the unnamed
-- register inside nvim and use Ctrl+Shift+V for text copied in Windows.
if vim.fn.has("wsl") == 1 then
  local osc52 = require("vim.ui.clipboard.osc52")
  local function paste()
    return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
  end
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
