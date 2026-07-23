return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        { "<leader>t", "<cmd>ToggleTerm<CR>", desc = "Terminal" },
        { "<leader>T", "<cmd>ToggleTerm direction=vertical size=80<CR>", desc = "Terminal vertical" },
        { [[<C-\>]], "<cmd>ToggleTerm<CR>", desc = "ToggleTerm" },
    },
    config = function()
        require("toggleterm").setup({
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<C-\>]],
            direction = "float",
            float_opts = {
                border = "rounded",
            },
        })

        function _G.set_terminal_keymaps()
            local opts = { noremap = true }
            vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", [[<C-\><C-n>]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
            vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
        end

        vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function() set_terminal_keymaps() end,
        })
    end,
}
