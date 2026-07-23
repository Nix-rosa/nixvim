return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    config = function()
        require("mason").setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls", "ts_ls", "pyright", "rust_analyzer",
                "gopls", "clangd", "jdtls", "zls",
            },
            automatic_installation = true,
        })

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        pcall(function()
            capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
        end)

        local on_attach = function(client, bufnr)
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(bufnr, true)
            end
            if client.server_capabilities.documentHighlightProvider then
                local hl_group = vim.api.nvim_create_augroup("NixVimLspHighlight", { clear = false })
                vim.api.nvim_clear_autocmds({ group = hl_group, buffer = bufnr })
                vim.api.nvim_create_autocmd("CursorHold", {
                    group = hl_group, buffer = bufnr,
                    callback = vim.lsp.buf.document_highlight,
                })
                vim.api.nvim_create_autocmd("CursorMoved", {
                    group = hl_group, buffer = bufnr,
                    callback = vim.lsp.buf.clear_references,
                })
            end
        end

        vim.lsp.config("*", {
            capabilities = capabilities,
            on_attach = on_attach,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true),
                        checkThirdParty = false,
                    },
                    telemetry = { enable = false },
                    hint = { enable = true },
                },
            },
        })

        vim.lsp.config("ts_ls", {
            settings = {
                typescript = {
                    inlayHints = {
                        includeInlayParameterNameHints = "all",
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
            },
        })

        vim.lsp.config("pyright", {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "strict",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        vim.lsp.config("rust_analyzer", {
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = { command = "clippy" },
                },
            },
        })

        vim.lsp.config("gopls", {
            settings = {
                gopls = {
                    gofumpt = true,
                    codelenses = {
                        generate = true, gc_details = true, test = true, tidy = true,
                    },
                },
            },
        })

        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
            },
        })

        vim.lsp.enable({
            "lua_ls", "ts_ls", "pyright", "rust_analyzer",
            "gopls", "clangd", "jdtls", "zls",
        })

        vim.diagnostic.config({
            virtual_text = { prefix = "●", spacing = 4 },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end,
}
