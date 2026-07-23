return {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
        local notify = require("notify")
        notify.setup({
            background_colour = "#1e1e2e",
            render = "compact",
            stages = "fade",
            timeout = 3000,
            icons = {
                ERROR = "",
                WARN = "",
                INFO = "",
                DEBUG = "",
                TRACE = "",
            },
        })
        vim.notify = notify
    end,
}
