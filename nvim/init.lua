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
   virtual_lines = { only_current_line = true } 
   })

-- Show all diagnostics in current line in a floating window. 
-- CursorHold event happens after `updatetime` milliseconds.
-- vim.cmd('autocmd CursorHold * lua vim.diagnostic.open_float({scope="line"})')
-- opt.updatetime = 300

-- Enable colorscheme
vim.cmd('colorscheme tokyonight')

