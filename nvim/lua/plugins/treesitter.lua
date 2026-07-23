return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        local parsers = {
            "bash", "c", "cpp", "css", "dockerfile", "go", "html",
            "javascript", "json", "lua", "luadoc", "markdown", "markdown_inline",
            "nix", "python", "rust", "toml", "tsx", "typescript", "vim",
            "vimdoc", "yaml", "zig", "java", "kotlin", "dart", "php",
            "ruby", "swift", "scala", "haskell", "elixir", "clojure",
            "cmake", "make", "regex", "sql", "graphql",
        }

        pcall(function()
            require("nvim-treesitter").install(parsers)
        end)

        vim.treesitter.language.register("cpp", "arduino")

        local augroup = vim.api.nvim_create_augroup("NixVimTreesitter", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match)
                if lang and pcall(vim.treesitter.language.inspect, lang) then
                    pcall(vim.treesitter.start, args.buf, lang)
                end
            end,
        })
    end,
}
