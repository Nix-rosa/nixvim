local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup("plugins", {
    install = {
        colorscheme = { "rosa" },
    },
    ui = {
        border = "rounded",
        title = "  NixVim  ",
        title_pos = "center",
    },
    checker = {
        enabled = true,
        notify = false,
    },
    change_detection = {
        notify = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "2html_plugin", "tohtml", "getscript", "getscriptPlugin",
                "gzip", "logipat", "netrw", "netrwPlugin", "netrwSettings",
                "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
                "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin",
                "tutor", "rplugin", "syntax", "synmenu", "optwin", "compiler",
                "bugreport", "ftplugin",
            },
        },
    },
})
