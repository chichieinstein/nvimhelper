-- Set Leader
vim.g.mapleader = " "
-- Add lazy.nvim package for managing plugins
-- Check to see if lazy.nvim exists already
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
	  "git",
	  "clone",
	  "--filter=blob:none",
	  "https://github.com/folke/lazy.nvim.git",
	  "--branch=stable",
	  lazypath,
  })
  end

  vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
local opt = vim.o

-- Display diagnostics in a non-focusable floating window
local function show_line_diagnostics()
    if vim.api.nvim_get_mode().mode ~= 'i' then
  	vim.diagnostic.open_float(nil, {
    	    scope = "line",
    	    focusable = false,
    	    width = 60,
    	    height = 20,
 })
 end
end

-- Show line diagnostics on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = show_line_diagnostics
})

-- Check if a client is attached 
-- If so, toggle inlay hints, if the attached server allows it
local function toggle_hints()
   local client = vim.lsp.get_clients({bufnr=0})[1]
   if client then
	if client.server_capabilities.inlayHintProvider then
	   local enabled = vim.lsp.inlay_hint.is_enabled()
	   vim.lsp.inlay_hint.enable(0, not enabled)
   	end
   end
end

-- If client exists, toggle inlay hints to visible if possible
vim.api.nvim_create_autocmd({"InsertEnter"},{
	callback = toggle_hints
})

-- Remove inlay hints when leaving Insert mode if possible:
vim.api.nvim_create_autocmd({"InsertLeave"},{
	callback = toggle_hints
})
	
-- Set line numbers 
opt.number = true

-- Set relative line numbers
opt.relativenumber = true

-- Enable mouse support
opt.mouse = 'a'

--Turn off inline diagnostics
vim.diagnostic.config({
   update_on_insert = false,
   virtual_text = false,
})


-- CursorHold event happens after `updatetime` milliseconds.
opt.updatetime = 300

-- Enable colorscheme
vim.cmd('colorscheme tokyonight')

require('lualine').setup {
	options = { theme = 'tokyonight' },
}
-- Keybindings
--
-- Map function
function Map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true}
	if opts then 
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
    end

-- Telescope/nvimtree integration
local builtin = require("telescope.builtin")
local treelib = require("nvim-tree.lib")

-- Find files in current directory (ff - find files)
Map("n", "<leader>ff", builtin.find_files, {})

-- Perform live grep on NvimTree buffer if it exists(tt - traverse tree)
Map("n", "<leader>tt", function()
	local node = treelib.get_node_at_cursor()
	if node then 
		builtin.live_grep({ search_dirs = {node.absolute_path} })
	else 
		print("Not in nvim-tree, or no node selected")
	end 
end, {})

-- Perform find files on NvimTree buffer if it exists(sd - search directory)
Map("n", "<leader>sd", function()
	local node = treelib.get_node_at_cursor()
	if node then 
		builtin.find_files({ search_dirs = {node.absolute_path} })
	else 
		print("Not in nvim-tree, or no node selected")
	end 
end, {})

-- Open and Close NvimTree 
Map("n", "<leader>op", ":NvimTreeOpen<CR>", {})
Map("n", "<leader>x", ":NvimTreeClose<CR>", {})

-- Create a vertically split window in Normal mode
Map("n", "<A-w>", "<C-w>v")
-- Traverse windows
Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-l>", "<C-w>l")




