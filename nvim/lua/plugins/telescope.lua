return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
        { "<leader>tt", "<cmd>Telescope<CR>", desc = "Telescope" },
        { "<leader>tR", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
        { "<leader>tB", "<cmd>Telescope builtins<CR>", desc = "Builtins" },
        { "<leader>tM", "<cmd>Telescope marks<CR>", desc = "Marks" },
        { "<leader>tq", "<cmd>Telescope quickfix<CR>", desc = "Quickfix" },
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                border = true,
                prompt_prefix = "  ",
                selection_caret = " ",
            },
        })
        pcall(telescope.load_extension, "fzf")
    end,
}
