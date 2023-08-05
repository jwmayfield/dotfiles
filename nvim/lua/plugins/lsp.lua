return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v2.x",
    config = function()
      local lsp = require("lsp-zero").preset("recommended")

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()
      end)

      lsp.ensure_installed({
        "html",
        "lua_ls",
        "standardrb",
      })

      require("lspconfig").html.setup({
        filetypes = { "html", "eruby" },
        init_options = {
          provideFormatter = false,
        },
      })
      require("lspconfig").lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()
    end,
    dependencies = {
      -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },

      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "L3MON4D3/LuaSnip" },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics

      null_ls.setup({
        debug = true,
        sources = {
          diagnostics.erb_lint,
          formatting.prettier,
          formatting.htmlbeautifier, -- eruby only
          formatting.rustywind.with({
            extra_filetypes = { "eruby" },
          }),
        },
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
