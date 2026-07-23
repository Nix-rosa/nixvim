return {
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPost",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "│" },
                    change = { text = "│" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns
                    local map = function(mode, l, r, desc)
                        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
                    end
                    map("n", "]h", gs.next_hunk, "Next hunk")
                    map("n", "[h", gs.prev_hunk, "Previous hunk")
                    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                    map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
                    map("n", "<leader>hd", gs.diffthis, "Diff this")
                end,
            })
        end,
    },
    {
        "tpope/vim-fugitive",
        cmd = { "Git" },
        keys = {
            { "<leader>gs", "<cmd>Git<CR>", desc = "Git status" },
            { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
            { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
            { "<leader>gl", "<cmd>Git log<CR>", desc = "Git log" },
            { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
        },
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
            { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "Diffview history" },
        },
    },
}
