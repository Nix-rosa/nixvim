local M = {}

M.has_plugin = function(name)
    local ok, _ = pcall(require, name)
    return ok
end

M.get_os = function()
    return vim.uv.os_uname().sysname
end

M.is_nixos = function()
    local file = io.open("/etc/NIXOS", "r")
    if file then
        file:close()
        return true
    end
    return false
end

M.get_project_root = function()
    local git_dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
    if git_dir and git_dir ~= "" then
        return git_dir
    end
    return vim.fn.getcwd()
end

M.notify = function(msg, level, opts)
    vim.notify(msg, level or vim.log.levels.INFO, opts or {})
end

M.map = function(mode, lhs, rhs, opts)
    local options = { noremap = true, silent = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.keymap.set(mode, lhs, rhs, options)
end

M.has_arduino_cli = function()
    local handle = io.popen("which arduino-cli 2>/dev/null")
    if handle then
        local result = handle:read("*a")
        handle:close()
        return result ~= ""
    end
    return false
end

return M
