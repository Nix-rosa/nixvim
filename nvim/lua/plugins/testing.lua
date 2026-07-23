return {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "rouge8/neotest-rust",
    },
    keys = {
        { "<leader>tt", function() require("neotest").run.run() end, desc = "Test nearest" },
        { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file" },
        { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug test" },
        { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test summary" },
        { "<leader>to", function() require("neotest").output_panel.toggle() end, desc = "Test output" },
        { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop tests" },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-rust")({ args = { "--no-capture" } }),
            },
        })
    end,
}
