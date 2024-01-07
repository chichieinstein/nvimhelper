local cargo_home = os.getenv("HOME") .. "/.cargo"
return {
	"neovim/nvim-lspconfig",
	dependencies = 
   			{
   				"williamboman/mason-lspconfig.nvim",
   				dependencies = 
						{
							"williamboman/mason.nvim",
							config = function()
	   							 require("mason").setup()
							end,
   						},	   
   				config = function()
					 require("mason-lspconfig").setup({
	   				 ensure_installed = {"clangd"}
					 })
   				end,
   			},
   	config = function()
		require("lspconfig").clangd.setup{}
		require("lspconfig").rust_analyzer.setup{
			cmd = {cargo_home .. "/bin/rust-analyzer"},
		}		
   	end,
}

