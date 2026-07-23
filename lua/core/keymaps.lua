local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
map("n", "<C-Up>", ":resize +2<CR>", opts)
map("n", "<C-Down>", ":resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize -2<CR>", opts)
map("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Buffer navigation
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Window splits
map("n", "<leader>sv", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>sh", ":split<CR>", { desc = "Horizontal split" })

-- Save / Quit
map("n", "<leader>w", ":w<CR>", { desc = "Save" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>Q", ":qa!<CR>", { desc = "Force quit" })

-- Clear search highlight
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- Better indenting
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Move lines in visual
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Paste without yanking
map("v", "p", '"_dP', opts)

-- Centered scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)

-- LSP keymaps (set on LspAttach)
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("NixVimLspKeymaps", { clear = true }),
    callback = function(ev)
        local buf = ev.buf
        local bmap = function(mode, lhs, rhs, desc)
            map(mode, lhs, rhs, { buffer = buf, desc = "LSP: " .. desc })
        end

        bmap("n", "gd", vim.lsp.buf.definition, "Go to definition")
        bmap("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        bmap("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        bmap("n", "gr", vim.lsp.buf.references, "References")
        bmap("n", "K", vim.lsp.buf.hover, "Hover documentation")
        bmap("n", "<leader>lk", vim.lsp.buf.signature_help, "Signature help")
        bmap("n", "<leader>la", vim.lsp.buf.code_action, "Code action")
        bmap("n", "<leader>lr", vim.lsp.buf.rename, "Rename symbol")
        bmap("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, "Format file")
        bmap("n", "<leader>ld", vim.diagnostic.open_float, "Float diagnostics")
        bmap("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        bmap("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
    end,
})
