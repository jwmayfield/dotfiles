return {
	{ "nvim-treesitter/nvim-treesitter-context", },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function () 
			require("nvim-treesitter.configs").setup{
				auto_install = true,
				context_commentstring = {
					enable = true,
					enable_autocmd = false,
				},
				ensure_installed = { "lua", },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = { enable = true },  
				sync_install = false,
			}
		end,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
	},
}
