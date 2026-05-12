return {
  {
    "maxmx03/solarized.nvim",
    lazy = false,
    config = function()
      require("solarized")
      vim.o.background = "light"
      vim.cmd.colorscheme("solarized")
    end,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
  },
}
