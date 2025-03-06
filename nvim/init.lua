require("a.core")
require("a.lazy")

-- scrolling
neoscroll = require("neoscroll")
local keymap = {
  ["<C-k>"] = function()
    neoscroll.scroll(-0.1, { move_cursor = false, duration = 100, easing = "linear" })
  end,
  ["<C-j>"] = function()
    neoscroll.scroll(0.1, { move_cursor = false, duration = 100, easing = "linear" })
  end,
  ["<C-b>"] = function()
    neoscroll.ctrl_b({ duration = 450 })
  end,
  ["<C-f>"] = function()
    neoscroll.ctrl_f({ duration = 450 })
  end,
  ["zt"] = function()
    neoscroll.zt({ half_win_duration = 250 })
  end,
  ["zz"] = function()
    neoscroll.zz({ half_win_duration = 250 })
  end,
  ["zb"] = function()
    neoscroll.zb({ half_win_duration = 250 })
  end,
}
local modes = { "n" }
for key, func in pairs(keymap) do
  vim.keymap.set(modes, key, func)
end
