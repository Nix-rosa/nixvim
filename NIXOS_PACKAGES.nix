# Agrega estas lineas a /etc/nixos/configuration.nix
# dentro de environment.systemPackages = with pkgs; [
#
# Despues ejecuta: sudo nixos-rebuild switch
#
# Copia desde aqui:

    # --- NixVim: LSP Servers ---
    clang-tools                        # clangd (C/C++/Arduino)
    nil                                # nil (Nix LSP)
    arduino-language-server            # Arduino LSP

    # --- NixVim: Formatters ---
    stylua                             # Lua formatter
    shfmt                              # Shell/Bash formatter
    nixfmt-rfc-style                   # Nix formatter
    prettier                           # JS/TS/HTML/CSS/JSON/YAML formatter
    rustfmt                            # Rust formatter (via rustup)

    # --- NixVim: Linters ---
    shellcheck                         # Shell/Bash linter
    hadolint                           # Dockerfile linter

    # --- NixVim: Arduino ---
    arduino-cli                        # Arduino CLI

# hasta aqui.
