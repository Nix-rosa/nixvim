local M = {}
local ns = vim.api.nvim_create_namespace("dashboard")

local function c(text, width)
    local w = width or vim.o.columns
    local pad = math.max(0, math.floor((w - vim.fn.strdisplaywidth(text)) / 2))
    return string.rep(" ", pad) .. text
end

local function hl(buf, l, cs, ce, g)
    pcall(vim.api.nvim_buf_add_highlight, buf, ns, g, l, cs, ce)
end

local function get_git()
    local b = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("\n", "")
    if b == "" then return nil, 0 end
    local s = vim.fn.system("git status --porcelain 2>/dev/null")
    local n = 0
    for _ in s:gmatch("\n") do n = n + 1 end
    return b, n
end

local function get_sys()
    local r = {}
    r.uptime = vim.fn.system("uptime -p 2>/dev/null | sed 's/up //'"):gsub("\n", "")
    r.mem = vim.fn.system("free -h 2>/dev/null | awk '/Mem:/{print $3\"/\"$2}'"):gsub("\n", "")
    r.cpu = vim.fn.system("nproc 2>/dev/null"):gsub("\n", "") .. " cores"
    return r
end

local function get_projects()
    local p = {}
    local home = os.getenv("HOME") or "/home/rosa"
    for _, d in ipairs({"Documents","Projects","Developer","Code","repos","Arduino"}) do
        if vim.uv.fs_stat(home.."/"..d) then
            table.insert(p, { name = d, path = home.."/"..d })
        end
    end
    return p
end

function M.open()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = true

    local W = math.min(vim.o.columns, 80)
    local lines = {}

    local function add(text)
        table.insert(lines, c(text, W))
    end


    add("███╗   ██╗██╗██╗  ██╗     ██╗   ██╗██╗███╗   ███╗")
    add("████╗  ██║██║╚██╗██╔╝     ██║   ██║██║████╗ ████║")
    add("██╔██╗ ██║██║ ╚███╔╝█████╗██║   ██║██║██╔████╔██║")
    add("██║╚██╗██║██║ ██╔██╗╚════╝╚██╗ ██╔╝██║██║╚██╔╝██║")
    add("██║ ╚████║██║██╔╝ ██╗      ╚████╔╝ ██║██║ ╚═╝ ██║")
    add("╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝       ╚═══╝  ╚═╝╚═╝     ╚═╝")
    add("")
    add("~ NixOS Edition ~")
    add("")

    local t = os.date("%H:%M")
    local d = os.date("%A, %d de %B %Y")
    local pc = #vim.tbl_keys(require("lazy").plugins())
    local br, ch = get_git()
    local info = string.format("%s  |  %s  |  %d plugins", t, d, pc)
    if br then
        info = info .. string.format("  |  %s", br)
        if ch > 0 then info = info .. string.format(" (%d)", ch) end
    end
    add(info)
    add("")

    add("─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  Acciones  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─")
    add("")

    local btns = {
        { "f", "", "Buscar Archivo",  "FzfLua files" },
        { "g", "", "Buscar Texto",    "FzfLua live_grep" },
        { "r", "", "Recientes",       "FzfLua oldfiles" },
        { "b", "", "Buffers",         "FzfLua buffers" },
        { "p", "", "Proyectos",       nil },
        { "c", "", "Configuracion",   "e " .. vim.fn.stdpath("config") .. "/init.lua" },
        { "n", "", "Nuevo Archivo",   "enew" },
        { "q", "", "Salir",           "qa!" },
    }

    for _, b in ipairs(btns) do
        local line = string.format("   %s  [ %s ]  %s", b[2], b[1], b[3])
        add(line)
    end
    add("")

    add("─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─  Sistema  ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ──")
    add("")

    local si = get_sys()
    local lc = 0
    for _ in ipairs(vim.lsp.get_clients()) do lc = lc + 1 end
    local arduino = "arduino-cli: "
    local h = io.popen("which arduino-cli 2>/dev/null")
    if h then
        local r = h:read("*a"); h:close()
        arduino = arduino .. (r ~= "" and "OK" or "no instalado")
    else
        arduino = arduino .. "no instalado"
    end

    add(string.format("  LSP: %d activos", lc))
    add(string.format("  %s", arduino))
    add(string.format("  CPU: %s  |  RAM: %s", si.cpu, si.mem))
    add(string.format("  Uptime: %s", si.uptime))
    add("")

    add(string.format("  NixVim v1.0  |  NixOS  |  Neovim 0.12  |  %s", os.date("%H:%M:%S")))

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    -- highlights
    for i = 0, 2 do hl(buf, i, 0, -1, "DashboardLogo") end
    hl(buf, 3, 0, -1, "Normal")
    hl(buf, 4, 0, -1, "DashboardSubtitle")
    hl(buf, 5, 0, -1, "Normal")
    hl(buf, 6, 0, -1, "DashboardDate")
    hl(buf, 7, 0, -1, "Normal")

    local sep1 = 8
    hl(buf, sep1, 0, -1, "DashboardSection")
    hl(buf, sep1 + 1, 0, -1, "Normal")

    local btn_start = 10
    for i, b in ipairs(btns) do
        local ln = btn_start + i - 1
        local full = lines[ln + 1]
        if full then
            local s, e = full:find(b[2] .. "  %[" .. b[1] .. "%]  " .. b[3], 1, true)
            if s then
                hl(buf, ln, s - 1, s, "DashboardIcon")
                hl(buf, ln, s + 2, s + 5, "DashboardKey")
                hl(buf, ln, s + 6, e, "DashboardLabel")
            else
                hl(buf, ln, 0, -1, "DashboardLabel")
            end
        end
    end

    local sep2 = btn_start + #btns
    hl(buf, sep2, 0, -1, "Normal")
    hl(buf, sep2 + 1, 0, -1, "DashboardSection")
    local sys_start = sep2 + 2
    for i = 0, 4 do hl(buf, sys_start + i, 0, -1, "DashboardSystem") end
    local footer = sys_start + 5
    hl(buf, footer, 0, -1, "DashboardFooter")

    -- keymaps
    local actions = {
        f = function() vim.cmd("FzfLua files") end,
        g = function() vim.cmd("FzfLua live_grep") end,
        r = function() vim.cmd("FzfLua oldfiles") end,
        b = function() vim.cmd("FzfLua buffers") end,
        p = function()
            local projects = get_projects()
            if #projects == 0 then vim.notify("No hay proyectos", vim.log.levels.INFO); return end
            vim.ui.select(projects, {
                prompt = "Abrir proyecto:",
                format_item = function(i) return i.name .. " -> " .. i.path end,
            }, function(c) if c then vim.cmd("e " .. c.path) end end)
        end,
        c = function() vim.cmd("e " .. vim.fn.stdpath("config") .. "/init.lua") end,
        n = function() vim.cmd("enew"); vim.bo.buftype = "" end,
        q = function() vim.cmd("qa!") end,
    }
    for key, fn in pairs(actions) do
        vim.keymap.set("n", key, function()
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
            fn()
        end, { buffer = buf, nowait = true })
    end

    -- floating window
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = W,
        height = #lines,
        row = math.floor((vim.o.lines - #lines) / 2) - 1,
        col = math.floor((vim.o.columns - W) / 2),
        style = "minimal",
        border = "rounded",
    })
    vim.api.nvim_set_option_value("cursorline", false, { win = win })
    vim.api.nvim_set_option_value("wrap", false, { win = win })
    vim.api.nvim_set_option_value("winblend", 0, { win = win })

    -- live clock
    local timer = vim.uv.new_timer()
    local footer_line = footer
    if timer then
        timer:start(0, 1000, vim.schedule_wrap(function()
            if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
                timer:stop(); timer:close(); return
            end
            local new_line = c(string.format("  NixVim v1.0  |  NixOS  |  Neovim 0.12  |  %s", os.date("%H:%M:%S")), W)
            pcall(vim.api.nvim_buf_set_lines, buf, footer_line, footer_line + 1, false, { new_line })
            pcall(vim.api.nvim_buf_add_highlight, buf, ns, "DashboardFooter", footer_line, 0, -1)
        end))
    end

    vim.api.nvim_create_autocmd("BufLeave", {
        buffer = buf, once = true,
        callback = function()
            if timer and not timer:is_closing() then timer:stop(); timer:close() end
            if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
        end,
    })
end

setmetatable(M, { __call = function() M.open() end })
return M
