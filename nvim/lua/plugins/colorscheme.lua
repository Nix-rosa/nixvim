return {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        local pywal_ok, pywal = pcall(require, "ui.pywal")
        if pywal_ok then
            pywal.load()
        end

        require("bamboo").setup({
            theme = "dark",
            colors = {
                polyglot = true,
            },
        })
        require("bamboo").load()

        if pywal_ok and pywal.colors then
            local hl = vim.api.nvim_set_hl
            local c = pywal.colors

            hl(0, "Normal", { fg = c.fg, bg = "NONE" })
            hl(0, "NormalFloat", { fg = c.fg, bg = "NONE" })
            hl(0, "FloatBorder", { fg = c.blue, bg = "NONE" })
            hl(0, "FloatTitle", { fg = c.magenta, bg = "NONE", bold = true })
            hl(0, "SignColumn", { bg = "NONE" })
            hl(0, "EndOfBuffer", { fg = c.bg, bg = "NONE" })
            hl(0, "LineNr", { fg = c.bright_black, bg = "NONE" })
            hl(0, "CursorLineNr", { fg = c.yellow, bg = "NONE", bold = true })
            hl(0, "Pmenu", { fg = c.fg, bg = "NONE" })
            hl(0, "PmenuSel", { fg = c.bg, bg = c.blue })
            hl(0, "PmenuSbar", { bg = "NONE" })
            hl(0, "PmenuThumb", { bg = c.blue })

            hl(0, "DashboardLogo",      { fg = c.magenta, bold = true })
            hl(0, "DashboardSubtitle",  { fg = c.cyan, italic = true })
            hl(0, "DashboardDate",      { fg = c.bright_black })
            hl(0, "DashboardSection",   { fg = c.blue, bold = true })
            hl(0, "DashboardIcon",      { fg = c.magenta, bold = true })
            hl(0, "DashboardKey",       { fg = c.cyan, bold = true })
            hl(0, "DashboardLabel",     { fg = c.fg })
            hl(0, "DashboardSystem",    { fg = c.bright_black })
            hl(0, "DashboardFooter",    { fg = c.bright_black, italic = true })
            hl(0, "DashboardShortcut",  { fg = c.yellow })

            hl(0, "NixVimAccent",       { fg = c.magenta, bold = true })
            hl(0, "StatusLineAccent", { fg = c.bg, bg = c.magenta })
        else
            local hl = vim.api.nvim_set_hl
            hl(0, "NixVimAccent", { fg = "#f5c2e7", bold = true })
            hl(0, "StatusLineAccent", { bg = "#f5c2e7", fg = "#1e1e2e" })
        end

        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "*",
            callback = function()
                if pywal_ok then pywal.load() end
                local hl = vim.api.nvim_set_hl
                if pywal_ok and pywal.colors then
                    local c = pywal.colors
                    hl(0, "Normal", { fg = c.fg, bg = "NONE" })
                    hl(0, "NormalFloat", { fg = c.fg, bg = "NONE" })
                    hl(0, "FloatBorder", { fg = c.blue, bg = "NONE" })
                    hl(0, "NixVimAccent", { fg = c.magenta, bold = true })
                    hl(0, "StatusLineAccent", { fg = c.bg, bg = c.magenta })
                else
                    hl(0, "NixVimAccent", { fg = "#f5c2e7", bold = true })
                    hl(0, "StatusLineAccent", { bg = "#f5c2e7", fg = "#1e1e2e" })
                end
            end,
        })
    end,
}
