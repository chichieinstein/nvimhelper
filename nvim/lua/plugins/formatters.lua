local rust_formatter =  {
   "rust-lang/rust.vim",
   config = function()
	vim.g.rustfmt_autosave = 1
   end,
}

local clang_formatter = {
   "rhysd/vim-clang-format",
   config = function()
   -- code style is google
   end,

}

return {
  rust_formatter,
  clang_formatter
}
