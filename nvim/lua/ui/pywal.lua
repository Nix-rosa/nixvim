local M = {}
local wal_path = os.getenv("HOME") .. "/.cache/wal/colors"

function M.load()
    local f = io.open(wal_path, "r")
    if not f then return nil end
    local colors = {}
    for line in f:lines() do
        local c = line:match("^#(%x+)$") or line:match("^#?(%x+)$")
        if c then table.insert(colors, "#" .. c) end
    end
    f:close()
    if #colors < 16 then return nil end

    M.colors = {
        bg       = colors[1],
        fg       = colors[7],
        red      = colors[2],
        green    = colors[3],
        yellow   = colors[4],
        blue     = colors[5],
        magenta  = colors[6],
        cyan     = colors[8],
        white    = colors[7],
        bright_black  = colors[9],
        bright_red    = colors[10],
        bright_green  = colors[11],
        bright_yellow = colors[12],
        bright_blue   = colors[13],
        bright_magenta= colors[14],
        bright_cyan   = colors[15],
        bright_white  = colors[16],
    }

    local hl = vim.api.nvim_set_hl
    local transparent = { bg = "NONE", ctermbg = "NONE" }

    hl(0, "Normal", { fg = M.colors.fg, bg = "NONE" })
    hl(0, "NormalFloat", { fg = M.colors.fg, bg = "NONE" })
    hl(0, "NormalNC", { fg = M.colors.fg, bg = "NONE" })
    hl(0, "NormalSB", { fg = M.colors.fg, bg = "NONE" })
    hl(0, "SignColumn", { bg = "NONE" })
    hl(0, "EndOfBuffer", { fg = M.colors.bg, bg = "NONE" })
    hl(0, "FoldColumn", { bg = "NONE" })
    hl(0, "LineNr", { fg = M.colors.bright_black, bg = "NONE" })
    hl(0, "CursorLineNr", { fg = M.colors.yellow, bg = "NONE", bold = true })

    hl(0, "Pmenu",      { fg = M.colors.fg, bg = "NONE" })
    hl(0, "PmenuSel",   { fg = M.colors.bg, bg = M.colors.blue })
    hl(0, "PmenuSbar",  { bg = "NONE" })
    hl(0, "PmenuThumb", { bg = M.colors.blue })
    hl(0, "FloatBorder", { fg = M.colors.blue, bg = "NONE" })
    hl(0, "FloatTitle",  { fg = M.colors.magenta, bg = "NONE", bold = true })

    hl(0, "DashboardLogo",      { fg = M.colors.magenta, bold = true })
    hl(0, "DashboardSubtitle",  { fg = M.colors.cyan, italic = true })
    hl(0, "DashboardDate",      { fg = M.colors.bright_black })
    hl(0, "DashboardSection",   { fg = M.colors.blue, bold = true })
    hl(0, "DashboardIcon",      { fg = M.colors.magenta, bold = true })
    hl(0, "DashboardKey",       { fg = M.colors.cyan, bold = true })
    hl(0, "DashboardLabel",     { fg = M.colors.fg })
    hl(0, "DashboardSystem",    { fg = M.colors.bright_black })
    hl(0, "DashboardFooter",    { fg = M.colors.bright_black, italic = true })
    hl(0, "DashboardShortcut",  { fg = M.colors.yellow })

    hl(0, "NixVimAccent",       { fg = M.colors.magenta, bold = true })
    hl(0, "StatusLineAccent", { fg = M.colors.bg, bg = M.colors.magenta })

    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            M.load()
        end,
    })

    return M.colors
end

return M
