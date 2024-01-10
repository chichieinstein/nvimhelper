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

local builtin = require("telescope.builtin")
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


-- Create a vertically split window in Normal mode
Map("n", "<A-w>", "<C-w>v")

-- Traverse windows
Map("n", "<C-h>", "<C-w>h")
Map("n", "<C-l>", "<C-w>l")





