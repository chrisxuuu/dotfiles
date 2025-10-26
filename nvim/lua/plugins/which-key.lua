return {
  'folke/which-key.nvim',
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    
    wk.setup({
      delay = 300,
      preset = "modern",
    })
    
    wk.add({
      -- Buffer management (using tab-like shortcuts)
      { "<leader>t", group = "Buffers" },
      { "<leader>to", "<cmd>enew<CR>", desc = "New buffer" },
      { "<leader>tx", "<cmd>Bdelete!<CR>", desc = "Close buffer" },
      { "<leader>tn", "<cmd>bnext<CR>", desc = "Next buffer" },
      { "<leader>tp", "<cmd>bprevious<CR>", desc = "Previous buffer" },
      
      -- Other mappings
      { "<leader>b", "<cmd>enew<CR>", desc = "New buffer" },
      { "<leader>x", "<cmd>Bdelete!<CR>", desc = "Close buffer" },
      { "<leader>v", desc = "Split vertically" },
      { "<leader>h", desc = "Split horizontally" },
      { "<leader>s", group = "Split/Save" },
      { "<leader>se", desc = "Equal splits" },
      { "<leader>sn", desc = "Save no format" },
      { "<leader>xs", desc = "Close split" },
      { "<leader>l", group = "Line" },
      { "<leader>lw", desc = "Toggle wrap" },
      { "<leader>d", desc = "Open diagnostics" },
      { "<leader>q", desc = "Diagnostics list" },
    })
  end,
}