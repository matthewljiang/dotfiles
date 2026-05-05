-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Yank absolute path
vim.keymap.set("n", "<leader>fy", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
  vim.notify("Yanked absolute path")
end, { desc = "Yank absolute path" })

-- Yank relative path
vim.keymap.set("n", "<leader>fY", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
  vim.notify("Yanked relative path")
end, { desc = "Yank relative path" })
