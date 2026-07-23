local opt = vim.opt

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.hidden = true
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false
opt.showcmd = true
opt.ruler = true
opt.laststatus = 3
opt.termguicolors = true
opt.background = "dark"
opt.splitbelow = true
opt.splitright = true
opt.fillchars = {
    eob = " ",
    vert = "│",
    fold = "─",
    diff = "─",
    msgsep = "─",
}

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.updatetime = 250
opt.timeoutlen = 300
opt.ttimeoutlen = 10

opt.fileencoding = "utf-8"
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.shortmess:append("casI")
opt.digraph = true
opt.virtualedit = "block"
opt.inccommand = "nosplit"
