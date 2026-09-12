return {
  "folke/trouble.nvim",
  config = function()
    local trouble = require("trouble")
    trouble.setup({ focus = true })

    vim.keymap.set("n", "<leader>xx", function() trouble.open("diagnostics") end)
    vim.keymap.set("n", "<leader>xw",
      function() trouble.open("diagnostics") end)
    vim.keymap.set("n", "<leader>xd",
      function() trouble.open({ mode = "diagnostics", filter = { buf = 0 } }) end)
    vim.keymap.set("n", "<leader>xq", function() trouble.open("quickfix") end)
    vim.keymap.set("n", "<leader>xl", function() trouble.open("loclist") end)
    vim.keymap.set("n", "gR", function() trouble.open("lsp_references") end)
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
