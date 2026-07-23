vim.bo.tabstop = 2
vim.bo.shiftwidth = 2
vim.bo.expandtab = true
vim.bo.commentstring = "// %s"
vim.bo.makeprg = "arduino-cli compile --fqbn arduino:avr:uno"

vim.opt_local.errorformat = [[
    %f:%l:%c: error: %m,
    %f:%l:%c: warning: %m,
    %f:%l: %m
]]

vim.treesitter.language.register("cpp", "arduino")
