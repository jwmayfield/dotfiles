return {
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup {
                options = { theme  = 'nord' },
            }
        end,
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },
}
