local merge_tb = vim.tbl_deep_extend

local lsps = require "plugins.lsp"

local telescope = require "plugins.telescope"
local parser = require "plugins.parser"
local directtree = require "plugins.tree"
local colorscheme = require "plugins.tokyonight"
local lines = require "plugins.statusline"
local preview = require "plugins.preview"
local tex = require "plugins.tex"
local config = merge_tb("force", lsps,telescope, parser, directtree, lines, preview, colorscheme, tex)

return config
