-- ============================================================
-- NixVim - Neovim IDE for NixOS
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.utils")
require("core.lazy")
require("arduino").setup()

pcall(require, "ui.pywal")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0 then
            pcall(require, "ui.pywal")
            require("ui.dashboard")()
        end
    end,
})
