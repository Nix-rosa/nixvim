return {
    {
        "lewis6991/gitsigns.nvim",
        enabled = false,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = "BufReadPost",
        opts = {
            indent = { char = "│" },
            scope = { enabled = true },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            win = { border = "rounded" },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.add({
                { "<leader>f", group = "Find" },
                { "<leader>g", group = "Git" },
                { "<leader>a", group = "Arduino" },
                { "<leader>b", group = "Buffer" },
                { "<leader>d", group = "Debug" },
                { "<leader>l", group = "LSP" },
                { "<leader>t", group = "Test/Terminal" },
                { "<leader>x", group = "Diagnostics" },
                { "<leader>s", group = "Split" },
            })
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufReadPost",
        config = function()
            require("colorizer").setup({
                "css", "html", "javascript", "typescript", "lua",
            }, { mode = "background" })
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                check_ts = true,
                ts_config = {
                    lua = { "string" },
                    javascript = { "template_string" },
                },
            })
        end,
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = true,
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = "n", desc = "Comment toggle linewise" },
            { "gb", mode = "n", desc = "Comment toggle blockwise" },
            { "gc", mode = "v", desc = "Comment toggle linewise" },
            { "gb", mode = "v", desc = "Comment toggle blockwise" },
        },
        config = function()
            require("Comment").setup()
        end,
    },
    {
        "folke/todo-comments.nvim",
        event = "BufReadPost",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = true,
    },
    {
        "folke/trouble.nvim",
        cmd = { "Trouble", "TroubleToggle" },
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics" },
            { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
            { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "Quickfix" },
            { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "Location list" },
        },
        config = true,
    },
    {
        "rmagatti/auto-session",
        lazy = false,
        opts = {
            suppressed_dirs = { "~/", "~/Downloads", "/" },
        },
    },
    {
        "karb94/neoscroll.nvim",
        event = "BufReadPost",
        config = function()
            require("neoscroll").setup({ easing_function = "cubic" })
        end,
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = { border = "rounded" },
            select = { border = "rounded" },
        },
    },
}
