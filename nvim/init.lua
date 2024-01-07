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

-- Enable colorscheme
vim.cmd('colorscheme murphy')

