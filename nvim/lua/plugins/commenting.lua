return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup{
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }
  end,
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      init = function()
        -- nvim-treesitter main removed the module system this plugin would register into.
        vim.g.skip_ts_context_commentstring_module = true
      end,
      opts = { enable_autocmd = false },
    },
  },
}
