local merge_tb = vim.tbl_deep_extend

local lsps = require "plugins.lsp"
local formatters = require "plugins.formatters"
local telescope = require "plugins.telescope"
local parser = require "plugins.parser"
local directtree = require "plugins.tree"
local colorscheme = {"folke/tokyonight.nvim"}
local config = merge_tb("force", lsps, formatters, telescope, parser, directtree, colorscheme)

return config
