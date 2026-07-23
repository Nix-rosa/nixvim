return {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
        "saghen/blink.lib",
        "rafamadriz/friendly-snippets",
    },
    build = function()
        require("blink.cmp").build():pwait()
    end,
    opts = {
        keymap = {
            preset = "super-tab",
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = { enabled = true },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        signature = { enabled = true },
        snippets = { preset = "default" },
        fuzzy = { implementation = "lua" },
    },
}
