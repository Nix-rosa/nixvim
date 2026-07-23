return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
        local function arduino_indicator()
            if vim.bo.filetype == "arduino" then
                local ok, arduino = pcall(require, "arduino")
                if ok and arduino.config then
                    return "  " .. (arduino.config.default_fqbn or "arduino")
                end
                return "  arduino"
            end
            return ""
        end

        local function lsp_servers()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if #clients == 0 then return "" end
            local names = {}
            for _, client in ipairs(clients) do
                table.insert(names, client.name)
            end
            return table.concat(names, ", ")
        end

        require("lualine").setup({
            options = {
                theme = {
                    normal = { a = { fg = "#1e1e2e", bg = "#f5c2e7", bold = true } },
                    insert = { a = { fg = "#1e1e2e", bg = "#a6e3a1", bold = true } },
                    visual = { a = { fg = "#1e1e2e", bg = "#cba6f7", bold = true } },
                    replace = { a = { fg = "#1e1e2e", bg = "#f38ba8", bold = true } },
                    command = { a = { fg = "#1e1e2e", bg = "#89b4fa", bold = true } },
                    inactive = { a = { fg = "#6c7086", bg = "#313244" } },
                },
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    {
                        function() return "  NV " end,
                        color = { fg = "#1e1e2e", bg = "#f5c2e7", bold = true },
                    },
                },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 1 },
                },
                lualine_x = {
                    arduino_indicator,
                    lsp_servers,
                    "encoding",
                    "fileformat",
                },
                lualine_y = { "filetype" },
                lualine_z = { "progress", "location" },
            },
            extensions = {
                "neo-tree", "toggleterm", "fugitive", "quickfix", "trouble",
                "lazy", "mason",
            },
        })
    end,
}
