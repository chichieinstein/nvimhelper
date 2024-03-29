return {
   "nvim-treesitter/nvim-treesitter",
   build = ":TSUpdate",
   config = function()
	local configs = require("nvim-treesitter.configs")

	configs.setup({
	   ensure_installed = {"c", "cpp","rust", "vim", "vimdoc", "lua", "markdown", "python"},
	   sync_install = false,
	   highlight = { enable = true},
	   indent = { enable = true},
        })
   end
}
