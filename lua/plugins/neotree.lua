return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    keys = {
        { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "File explorer" },
        { "<leader>o", "<cmd>Neotree focus<CR>", desc = "Focus file explorer" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
                follow_current_file = { enabled = true },
                use_libuv_file_watcher = true,
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
            },
            default_component_configs = {
                indent = {
                    with_expanders = true,
                },
                git_status = {
                    symbols = {
                        added = "+",
                        modified = "~",
                        deleted = "x",
                        renamed = "r",
                        untracked = "?",
                        ignored = "!",
                        unstaged = "U",
                        staged = "S",
                        conflict = "C",
                    },
                },
            },
            window = {
                position = "left",
                width = 30,
                mappings = {
                    ["<space>"] = "none",
                },
            },
        })
    end,
}
