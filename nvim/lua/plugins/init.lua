local merge_tb = vim.tbl_deep_extend

local lsps = require "plugins.lsp"
local formatters = require "plugins.formatters"
local colorscheme = {"folke/tokyonight.nvim"}


local config = merge_tb("force", lsps, formatters, colorscheme)

return config
