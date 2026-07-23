return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
        { "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
        { "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
        { "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
        { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<CR>", desc = "Document symbols" },
        { "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Workspace symbols" },
        { "<leader>fr", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
        { "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Document diagnostics" },
        { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
        { "<leader>/", "<cmd>FzfLua grep_cword<CR>", desc = "Grep word under cursor" },
    },
    config = function()
        require("fzf-lua").setup({
            winopts = {
                border = "rounded",
                preview = {
                    layout = "vertical",
                    vertical = "up:50%",
                },
            },
            files = {
                fd_opts = "--color=always --type f --hidden --follow --exclude .git",
            },
        })
    end,
}
