local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Yank highlight
augroup("NixVimYankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "NixVimYankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Trim whitespace on save
augroup("NixVimTrimWhitespace", { clear = true })
autocmd("BufWritePre", {
    group = "NixVimTrimWhitespace",
    pattern = { "*" },
    callback = function()
        local save = vim.fn.winsaveview()
        vim.fn.execute("%s/\\s\\+$//e")
        vim.fn.winrestview(save)
    end,
})

-- Auto-create directories
augroup("NixVimAutoMkdir", { clear = true })
autocmd("BufWritePre", {
    group = "NixVimAutoMkdir",
    pattern = { "*.*" },
    callback = function()
        local dir = vim.fn.expand("<afile>:p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Arduino filetype detection
augroup("NixVimArduinoDetect", { clear = true })
autocmd({ "BufRead", "BufNewFile" }, {
    group = "NixVimArduinoDetect",
    pattern = { "*.ino", "*.pde" },
    callback = function()
        vim.bo.filetype = "arduino"
        vim.bo.syntax = "cpp"
        vim.treesitter.language.register("cpp", "arduino")
    end,
})

-- Restore cursor position
augroup("NixVimRestoreCursor", { clear = true })
autocmd("BufReadPost", {
    group = "NixVimRestoreCursor",
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Highlight on cursor hold
augroup("NixVimHighlightOnHold", { clear = true })
autocmd("CursorHold", {
    group = "NixVimHighlightOnHold",
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})
