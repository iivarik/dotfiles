return {
  -- Ctrl+h/j/k/l moves between nvim splits and tmux panes (pairs with tmux.conf)
  {
    "alexghergh/nvim-tmux-navigation",
    keys = {
      { "<C-h>", "<cmd>NvimTmuxNavigateLeft<cr>" },
      { "<C-j>", "<cmd>NvimTmuxNavigateDown<cr>" },
      { "<C-k>", "<cmd>NvimTmuxNavigateUp<cr>" },
      { "<C-l>", "<cmd>NvimTmuxNavigateRight<cr>" },
      { "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<cr>" },
      { "<C-Space>", "<cmd>NvimTmuxNavigateNext<cr>" },
    },
    opts = { disable_when_zoomed = true },
  },

  -- Show hidden (dot) files in the file picker; .gitignore is still respected
  {
    "folke/snacks.nvim",
    opts = {
      picker = { sources = { files = { hidden = true } } },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "groovy" } },
  },
}
