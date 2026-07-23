local M = {}

M.config = {
    cli = "arduino-cli",
    default_fqbn = "arduino:avr:uno",
    default_baud = 9600,
    sketch_dir = vim.fn.expand("~/Arduino"),
    cli_config = vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
}

function M.has_cli()
    local handle = io.popen("which arduino-cli 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
    end
    return false
end

function M.run(cmd, callback)
    if not M.has_cli() then
        vim.notify("arduino-cli no encontrado. Instala con: nix-env -iA nixpkgs.arduino-cli", vim.log.levels.ERROR)
        return
    end
    local full_cmd = M.config.cli .. " " .. cmd
    vim.notify("$ " .. full_cmd, vim.log.levels.INFO)
    vim.fn.jobstart(full_cmd, {
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then print(line) end
                end
            end
        end,
        on_stderr = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then vim.notify(line, vim.log.levels.WARN) end
                end
            end
        end,
        on_exit = function(_, code)
            if callback then callback(code) end
        end,
    })
end

function M.parse_json(cmd)
    local handle = io.popen(M.config.cli .. " " .. cmd .. " --format json 2>/dev/null")
    if not handle then return nil end
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
        local ok, data = pcall(vim.fn.json_decode, result)
        if ok then return data end
    end
    return nil
end

function M.compile(fqbn)
    fqbn = fqbn or M.config.default_fqbn
    local dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
    M.run(string.format("compile --fqbn %s %s", fqbn, dir), function(code)
        if code == 0 then
            vim.notify("Compilacion exitosa!", vim.log.levels.INFO)
        else
            vim.notify("Error en compilacion (exit code: " .. code .. ")", vim.log.levels.ERROR)
        end
    end)
end

function M.upload(fqbn, port)
    fqbn = fqbn or M.config.default_fqbn
    local dir = vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h")
    local cmd = string.format("upload --fqbn %s %s", fqbn, dir)
    if port and port ~= "" then
        cmd = cmd .. " --port " .. port
    end
    M.run(cmd, function(code)
        if code == 0 then
            vim.notify("Upload exitoso!", vim.log.levels.INFO)
        else
            vim.notify("Error en upload (exit code: " .. code .. ")", vim.log.levels.ERROR)
        end
    end)
end

function M.serial_monitor(port, baud)
    port = port or ""
    baud = baud or M.config.default_baud
    local cmd = string.format("monitor --config log_format:human --config baudrate=%d", baud)
    if port ~= "" then cmd = cmd .. " --port " .. port end

    local Term = require("toggleterm.terminal")
    local term = Term.Terminal:new({
        cmd = M.config.cli .. " " .. cmd,
        direction = "float",
        close_on_exit = false,
        on_close = function() vim.notify("Serial monitor cerrado", vim.log.levels.INFO) end,
    })
    term:toggle()
end

function M.boards_select()
    if not M.has_cli() then return end
    vim.ui.select(M.get_installed_boards(), {
        prompt = "Seleccionar board:",
        format_item = function(item)
            return string.format("%s (%s)", item.name, item.fqbn)
        end,
    }, function(choice)
        if choice then
            M.config.default_fqbn = choice.fqbn
            vim.notify("Board: " .. choice.name .. " (" .. choice.fqbn .. ")", vim.log.levels.INFO)
        end
    end)
end

function M.ports_select()
    if not M.has_cli() then return end
    local ports = M.parse_json("board list")
    if not ports then
        vim.notify("No se encontraron puertos seriales", vim.log.levels.WARN)
        return
    end
    local items = {}
    for _, p in ipairs(ports) do
        if p.port and p.port.address then
            table.insert(items, {
                address = p.port.address,
                label = p.port.label or p.port.address,
                fqbn = p.matching_boards and p.matching_boards[1] and p.matching_boards[1].fqbn or "",
            })
        end
    end
    if #items == 0 then
        vim.notify("No se encontraron puertos seriales", vim.log.levels.WARN)
        return
    end
    vim.ui.select(items, {
        prompt = "Seleccionar puerto:",
        format_item = function(item) return string.format("%s - %s", item.label, item.address) end,
    }, function(choice)
        if choice then
            M.config.default_port = choice.address
            vim.notify("Puerto: " .. choice.address, vim.log.levels.INFO)
        end
    end)
end

function M.get_installed_boards()
    return M.parse_json("board listall") or {}
end

function M.get_installed_libraries()
    return M.parse_json("lib list") or {}
end

function M.search_libraries(query)
    if not query or query == "" then return {} end
    return M.parse_json(string.format('lib search "%s"', query)) or {}
end

function M.install_library(name)
    M.run(string.format('lib install "%s"', name), function(code)
        if code == 0 then
            vim.notify("Libreria instalada: " .. name, vim.log.levels.INFO)
        else
            vim.notify("Error instalando: " .. name, vim.log.levels.ERROR)
        end
    end)
end

function M.uninstall_library(name)
    M.run(string.format('lib uninstall "%s"', name), function(code)
        if code == 0 then
            vim.notify("Libreria removida: " .. name, vim.log.levels.INFO)
        else
            vim.notify("Error removiendo: " .. name, vim.log.levels.ERROR)
        end
    end)
end

function M.library_store()
    local Telescope = require("telescope.builtin")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    vim.ui.input({ prompt = "Buscar libreria Arduino: " }, function(query)
        if not query or query == "" then return end
        local results = M.search_libraries(query)
        if not results or #results == 0 then
            vim.notify("No se encontraron librerias para: " .. query, vim.log.levels.WARN)
            return
        end

        local items = {}
        for name, data in pairs(results) do
            local latest = data.latest
            table.insert(items, {
                name = name,
                version = latest and latest.version or "?",
                author = latest and latest.maintainer or "?",
                sentence = latest and latest.sentence or "",
                website = latest and latest.website or "",
                category = latest and latest.category or "",
            })
        end

        table.sort(items, function(a, b) return a.name < b.name end)

        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        pickers.new({}, {
            prompt_title = "Tienda de Librerias Arduino",
            finder = finders.new_table({
                results = items,
                entry_maker = function(entry)
                    return {
                        value = entry,
                        display = string.format("%s v%s - %s [%s]", entry.name, entry.version, entry.sentence, entry.category),
                        ordinal = entry.name,
                    }
                end,
            }),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(bufnr, _)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(bufnr)
                    if selection then
                        local lib = selection.value
                        vim.ui.select({ "Instalar", "Cancelar" }, {
                            prompt = string.format("Libreria: %s v%s\n%s\nAutor: %s\nSitio: %s",
                                lib.name, lib.version, lib.sentence, lib.author, lib.website),
                        }, function(choice)
                            if choice == "Instalar" then
                                M.install_library(lib.name)
                            end
                        end)
                    end
                end)
                return true
            end,
        }):find()
    end)
end

function M.list_libraries()
    local libs = M.get_installed_libraries()
    if #libs == 0 then
        vim.notify("No hay librerias instaladas", vim.log.levels.INFO)
        return
    end
    local items = {}
    for _, lib in ipairs(libs) do
        table.insert(items, string.format("  %s v%s - %s", lib.name, lib.version or "?", lib.author or ""))
    end
    print("Librerias instaladas:\n" .. table.concat(items, "\n"))
end

function M.list_boards()
    local boards = M.get_installed_boards()
    if #boards == 0 then
        vim.notify("No hay boards instalados", vim.log.levels.INFO)
        return
    end
    local items = {}
    for _, b in ipairs(boards) do
        table.insert(items, string.format("  %s (%s)", b.name, b.fqbn))
    end
    print("Boards instalados:\n" .. table.concat(items, "\n"))
end

function M.open_docs()
    local ft = vim.bo.filetype
    local urls = {
        arduino = "https://www.arduino.cc/reference/en/",
        cpp = "https://cplusplus.com/reference/",
        c = "https://en.cppreference.com/w/c",
        python = "https://docs.python.org/3/",
        lua = "https://www.lua.org/pil/",
        rust = "https://doc.rust-lang.org/book/",
        go = "https://go.dev/doc/",
        javascript = "https://developer.mozilla.org/en-US/docs/Web/JavaScript",
        typescript = "https://www.typescriptlang.org/docs/",
        nix = "https://nixos.org/manual/nix/stable/",
    }
    local url = urls[ft]
    if url then
        vim.fn.jobstart({ "xdg-open", url })
    else
        vim.notify("No hay documentacion configurada para: " .. ft, vim.log.levels.WARN)
    end
end

function M.setup()
    if not M.has_cli() then
        vim.notify("arduino-cli no encontrado. Algunas funciones no estaran disponibles.", vim.log.levels.WARN)
    end

    vim.api.nvim_create_user_command("ArduinoCompile", function() M.compile() end, { desc = "Compilar sketch Arduino" })
    vim.api.nvim_create_user_command("ArduinoUpload", function() M.upload() end, { desc = "Subir sketch a board" })
    vim.api.nvim_create_user_command("ArduinoSerial", function() M.serial_monitor() end, { desc = "Abrir monitor serial" })
    vim.api.nvim_create_user_command("ArduinoBoard", function() M.boards_select() end, { desc = "Seleccionar board" })
    vim.api.nvim_create_user_command("ArduinoPort", function() M.ports_select() end, { desc = "Seleccionar puerto serial" })
    vim.api.nvim_create_user_command("ArduinoLibs", function() M.list_libraries() end, { desc = "Listar librerias instaladas" })
    vim.api.nvim_create_user_command("ArduinoBoards", function() M.list_boards() end, { desc = "Listar boards instalados" })
    vim.api.nvim_create_user_command("ArduinoStore", function() M.library_store() end, { desc = "Tienda de librerias Arduino" })
    vim.api.nvim_create_user_command("ArduinoDocs", function() M.open_docs() end, { desc = "Abrir documentacion" })
    vim.api.nvim_create_user_command("ArduinoSearch", function(opts)
        M.library_store()
    end, { desc = "Buscar librerias Arduino", nargs = "?" })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "arduino",
        callback = function(ev)
            local buf = ev.buf
            local bmap = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Arduino: " .. desc })
            end
            bmap("n", "<leader>ac", function() M.compile() end, "Compilar")
            bmap("n", "<leader>au", function() M.upload() end, "Subir")
            bmap("n", "<leader>as", function() M.serial_monitor() end, "Monitor serial")
            bmap("n", "<leader>ab", function() M.boards_select() end, "Seleccionar board")
            bmap("n", "<leader>ap", function() M.ports_select() end, "Seleccionar puerto")
            bmap("n", "<leader>al", function() M.library_store() end, "Tienda de librerias")
            bmap("n", "<leader>aL", function() M.list_libraries() end, "Listar librerias")
            bmap("n", "<leader>ad", function() M.open_docs() end, "Documentacion")

            vim.bo.tabstop = 2
            vim.bo.shiftwidth = 2
            vim.bo.commentstring = "// %s"
            vim.bo.makeprg = "arduino-cli compile --fqbn " .. M.config.default_fqbn .. " $*"
        end,
    })

    _G.NixVimArduino = M
end

return M
