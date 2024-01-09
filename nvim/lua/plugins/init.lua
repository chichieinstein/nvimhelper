local merge_tb = vim.tbl_deep_extend

local lsps = require "plugins.lsp"
local formatters = require "plugins.formatters"
local colorscheme = {"folke/tokyonight.nvim"}
local diagnostics = require "plugins.diagnostics"

local config = merge_tb("force", lsps, formatters, diagnostics, colorscheme)

return config
