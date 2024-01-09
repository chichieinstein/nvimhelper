local cargo_home = os.getenv("CARGO_HOME")
return {
	"neovim/nvim-lspconfig",
	dependencies = 
	{
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
		{
			"hrsh7th/nvim-cmp", 
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function() 
				 local cmp = require("cmp")
				 cmp.setup({
                 		 snippet = {
                   			expand = function(args)
                    			  require('luasnip').lsp_expand(args.body)
                   			end,
                 			},
                 		mapping = cmp.mapping.preset.insert({
                			['<C-b>'] = cmp.mapping.scroll_docs(-4),
                			['<C-f>'] = cmp.mapping.scroll_docs(4),
                			['<C-Space>'] = cmp.mapping.complete(),
                			['<C-e>']     = cmp.mapping.abort(),
                			['<CR>'] = cmp.mapping.confirm({ select = true}),
                			}),
                 		sources = cmp.config.sources({
                        	{ name = 'nvim_lsp' },
                        	{ name = 'luasnip' }
                		}, {
                   			{ name = "buffer"},
                		  })
                               })

			       cmp.setup.filetype("gitcommit", {
                                sources = cmp.config.sources({
				   { name = "git" },
				}, {
				 {name = "buffer"},
				})
			      })
			      cmp.setup.cmdline({ '/', '?' }, {
                              sources = {
				{ name = "buffer"}
		            }
			   })

			   cmp.setup.cmdline(":", {
			     mapping = cmp.mapping.preset.cmdline(),
			     sources = cmp.config.sources({
				 { name = 'path' }
			}, {
				{ name = 'cmdline' }
			})
		    })
	        end,
		},			
	},
   	config = function()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		require("lspconfig").clangd.setup{
		  capabilities = capabilities
		}
		require("lspconfig").rust_analyzer.setup{
			cmd = {cargo_home .. "/bin/rust-analyzer"},
			capabilities = capabilities
		}		
   	end,
}

