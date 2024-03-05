vim.keymap.set("n", "<leader>F", ":w<CR>:!autopep8 --in-place --aggressive --aggressive %<CR>:e<CR>", { noremap = true, silent = true })
