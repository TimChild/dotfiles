-- Copy to system clipboard
vim.keymap.set("n", "<leader>y", '"+y')

vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "[q", ":cprev<CR>", { noremap = true, silent = true })
-- 2024-11-06 -- want to add this back in, but something wrong with setup that is causing errors on commenting
-- and dont want this confusing things further
--
--
-- -- -- Easier commenting (Note: / is _ in keybinding)
-- -- -- Normal mode
-- vim.keymap.set("n", "<C-_>", "gcc", { remap = true, silent = true, desc = "Toggle comment on current line" })
-- --
-- -- -- Visual mode
-- vim.keymap.set("x", "<C-_>", "gc", { remap = true, silent = true, desc = "Toggle comment on selected lines" })
-- --
-- -- -- Insert mode
-- vim.keymap.set("i", "<C-_>", function()
-- 	-- Exit insert mode and comment the current line (returning cursor to roughly where it was)
-- 	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>mxgcc`xi", true, false, true), "i", false)
-- end, { remap = true, silent = true, desc = "Toggle comment on current line from insert mode" })
