# NixVim - Neovim IDE 

Entorno de desarrollo completo basado en Neovim con soporte multi-lenguaje,
autocompletado inteligente, depurador, terminal, git, Arduino con tienda de
librerias, fondo transparente con integracion pywal, y dashboard personalizado.

---

## Requisitos

- Neovim >= 0.12
- NixOS (compatible con cualquier Linux)
- git
- curl (para lazy.nvim)

## Instalacion

```bash
# Clonar el repositorio
git clone https://github.com/Nix-rosa/nixvim.git ~/.config/nvim

# Ejecuta nvim - lazy.nvim descargara los 43 plugins automaticamente
nvim

# Instala las herramientas del sistema (requiere sudo)
# Copia el contenido de NIXOS_PACKAGES.nix a configuration.nix
sudo nixos-rebuild switch
```

### Paquetes del sistema (`NIXOS_PACKAGES.nix`)

Agregar dentro de `environment.systemPackages = with pkgs; [...]`:

```nix
# LSP Servers
clang-tools                  # clangd (C/C++/Arduino)
nil                          # nil (Nix)
arduino-language-server      # Arduino

# Formatters
stylua                       # Lua
shfmt                        # Shell/Bash
nixfmt-rfc-style             # Nix
prettier                     # JS/TS/HTML/CSS/JSON/YAML
rustfmt                      # Rust (via rustup)

# Linters
shellcheck                   # Shell/Bash
hadolint                     # Dockerfile

# Arduino
arduino-cli                  # Arduino CLI

# Opcional: pywal para colores del wallpaper
pywal                        # Generador de paletas
```

### Arduino CLI (post-instalacion)

```bash
arduino-cli config init
arduino-cli core update-index
arduino-cli core install arduino:avr
```

### Pywal (opcional)

```bash
# Genera colores desde tu wallpaper
wal -i /ruta/a/tu/wallpaper.jpg

# Neovim automaticamente usa esos colores con fondo transparente
nvim
```

---

## Estructura del proyecto

```
nixvim/
└── nvim/
    ├── init.lua                         # Entry point
    ├── ftplugin/
    │   └── arduino.lua                  # Config Arduino filetype
    ├── lua/
    │   ├── arduino/
    │   │   └── init.lua                 # Modulo Arduino completo
    │   ├── core/
    │   │   ├── options.lua              # Opciones de Neovim
    │   │   ├── keymaps.lua              # Atajos globales + LSP
    │   │   ├── autocmds.lua             # Autocomandos
    │   │   ├── utils.lua                # Utilidades
    │   │   └── lazy.lua                 # Bootstrap lazy.nvim
    │   ├── plugins/
    │   │   ├── colorscheme.lua          # bamboo.nvim + pywal
    │   │   ├── lsp.lua                  # Mason + 8 LSP servers
    │   │   ├── completion.lua           # blink.cmp v2
    │   │   ├── treesitter.lua           # Syntax highlighting
    │   │   ├── formatting.lua           # conform.nvim
    │   │   ├── linting.lua              # nvim-lint
    │   │   ├── testing.lua              # neotest
    │   │   ├── git.lua                  # gitsigns + fugitive + diffview
    │   │   ├── debugging.lua            # nvim-dap + dap-ui
    │   │   ├── fzf.lua                  # FzfLua (finder principal)
    │   │   ├── telescope.lua            # Telescope (finder secundario)
    │   │   ├── neotree.lua              # Explorador de archivos
    │   │   ├── terminal.lua             # toggleterm
    │   │   ├── lualine.lua              # Statusline
    │   │   ├── extras.lua               # which-key, indent, autopairs, etc
    │   │   └── notify.lua               # Notificaciones
    │   └── ui/
    │       ├── dashboard.lua            # Dashboard personalizado
    │       └── pywal.lua                # Integracion pywal
    ├── lazy-lock.json                   # Lockfile de plugins
    ├── NIXOS_PACKAGES.nix               # Paquetes para configuration.nix
    └── README.md                        # Este archivo
```

---

## Plugins (43)

### Core
| Plugin | Funcion |
|--------|---------|
| lazy.nvim | Gestor de plugins |
| bamboo.nvim | Colorscheme |
| vim-fugitive | Git |
| gitsigns.nvim | Signs de git en el gutter |
| diffview.nvim | Ventanas de diff git |

### LSP y Completado
| Plugin | Funcion |
|--------|---------|
| mason.nvim | Gestor de LSP servers |
| blink.cmp v2 | Autocompletado moderno y rapido |
| nvim-treesitter | Syntax highlighting |

### Formato y Lint
| Plugin | Funcion |
|--------|---------|
| conform.nvim | Formateo al guardar |
| nvim-lint | Linting en tiempo real |
| nvim-lspconfig | Configuracion LSP (Mason) |

### Busqueda y Navegacion
| Plugin | Funcion |
|--------|---------|
| fzf-lua | Buscador fuzzy principal |
| telescope.nvim | Buscador fuzzy secundario |
| neo-tree.nvim | Explorador de archivos |

### Debug
| Plugin | Funcion |
|--------|---------|
| nvim-dap | Protocolo DAP |
| nvim-dap-ui | UI para debugger |
| nvim-dap-go | Adapter Go |
| nvim-dap-python | Adapter Python |

### Terminal
| Plugin | Funcion |
|--------|---------|
| toggleterm.nvim | Terminales integradas |

### Testing
| Plugin | Funcion |
|--------|---------|
| neotest | Framework de tests |
| neotest-rust | Adapter Rust |

### UI
| Plugin | Funcion |
|--------|---------|
| lualine.nvim | Statusline |
| which-key | Panel de atajos |
| indent-blankline | Guias de indentacion |
| nvim-autopairs | Auto-completado de parentesis |
| nvim-surround | Operador de surrounding |
| Comment.nvim | Comentar lineas |
| todo-comments | Resaltar TODOs |
| trouble.nvim | Lista de diagnostics |
| auto-session | Sesiones automaticas |
| neoscroll | Scroll suave |
| dressing.nvim | UI mejorada para inputs |
| nvim-notify | Notificaciones |
| nvim-colorizer | Colores hex en el buffer |

---

## Dashboard

Pantalla de inicio con:

- Logo ASCII con estilo
- Reloj en tiempo real (actualiza cada segundo)
- Info del sistema: LSP activos, arduino-cli, CPU, RAM, uptime
- Branch de git y archivos modificados
- Lista vertical de acciones con atajos de teclado
- Fondo transparente con colores pywal

Acciones rapidas (presiona la tecla):

| Tecla | Accion |
|-------|--------|
| `f` | Buscar archivo (FzfLua files) |
| `g` | Buscar texto (FzfLua live_grep) |
| `r` | Archivos recientes |
| `b` | Buffers abiertos |
| `p` | Proyectos |
| `c` | Abrir configuracion |
| `n` | Nuevo archivo |
| `q` | Salir |

---

## Atajos de Teclado

### Leader Key

La tecla leader es `ESPACIO`.

### Navegacion

| Key | Accion |
|-----|--------|
| `<C-h>` | Mover a ventana izquierda |
| `<C-j>` | Mover a ventana abajo |
| `<C-k>` | Mover a ventana arriba |
| `<C-l>` | Mover a ventana derecha |
| `<S-h>` | Buffer anterior |
| `<S-l>` | Buffer siguiente |
| `<C-d>` | Scroll centrado abajo |
| `<C-u>` | Scroll centrado arriba |
| `<leader>e` | Explorador de archivos (neo-tree) |

### Archivos y Busqueda

| Key | Accion |
|-----|--------|
| `<leader>ff` | Buscar archivos (FZF) |
| `<leader>fg` | Buscar texto (grep) |
| `<leader>fb` | Buffers abiertos |
| `<leader>fr` | Archivos recientes |
| `<leader>fp` | Buscar en proyecto |
| `<leader>fs` | Buscar simbolo |
| `<leader>w` | Guardar archivo |
| `<leader>q` | Cerrar ventana |

### LSP

| Key | Accion |
|-----|--------|
| `gd` | Ir a definicion |
| `gD` | Ir a declaracion |
| `gi` | Ir a implementacion |
| `gr` | Referencias |
| `K` | Hover documentation |
| `<leader>lr` | Renombrar simbolo |
| `<leader>la` | Code action |
| `<leader>lf` | Formatear archivo |
| `<leader>ld` | Diagnostics flotante |
| `<leader>ls` | Signature help |
| `[d` | Diagnostic anterior |
| `]d` | Diagnostic siguiente |

### Autocompletado (blink.cmp)

| Key | Accion |
|-----|--------|
| `<Tab>` | Siguiente item / expandir snippet |
| `<S-Tab>` | Item anterior |
| `<C-Space>` | Activar completado |
| `<C-e>` | Cerrar menu |
| `<CR>` | Confirmar seleccion |
| `<C-b>` | Scroll documentacion arriba |
| `<C-f>` | Scroll documentacion abajo |

### Arduino

| Key | Accion |
|-----|--------|
| `<leader>ac` | Compilar sketch |
| `<leader>au` | Subir a board |
| `<leader>as` | Monitor serial |
| `<leader>ab` | Seleccionar board |
| `<leader>ap` | Seleccionar puerto |
| `<leader>al` | Tienda de librerias |
| `<leader>aL` | Listar librerias instaladas |
| `<leader>ad` | Documentacion Arduino |

### Debug

| Key | Accion |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Breakpoint condicional |
| `<leader>dc` | Continuar (continue) |
| `<leader>do` | Step over |
| `<leader>di` | Step into |
| `<leader>dO` | Step out |
| `<leader>dx` | Terminar debug |
| `<leader>dp` | Toggle REPL |
| `<leader>dl` | Toggle breakpoints list |
| `<leader>du` | Toggle dap-ui |
| `<leader>dt` | Test nearest (neotest) |

### Git

| Key | Accion |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git log |
| `<leader>gb` | Git blame |
| `<leader>gd` | Diffview open |
| `<leader>gh` | Hunk stage (gitsigns) |
| `<leader>gr` | Hunk reset (gitsigns) |
| `<leader>gp` | Preview hunk (gitsigns) |

### Testing

| Key | Accion |
|-----|--------|
| `<leader>tt` | Test nearest |
| `<leader>tf` | Test file |
| `<leader>ts` | Test summary |
| `<leader>to` | Test output |
| `<leader>td` | Debug test |

### Terminal

| Key | Accion |
|-----|--------|
| `<leader>t` | Terminal flotante |
| `<leader>T` | Terminal vertical |
| `<C-\>` | Toggle terminal |
| `<Esc>` (en terminal) | Salir del modo terminal |

### Comentar

| Key | Accion |
|-----|--------|
| `gcc` | Toggle comment linea |
| `gbc` | Toggle comment bloque |
| `gc` (visual) | Toggle comment seleccion |
| `gb` (visual) | Toggle comment bloque seleccion |

### Otros

| Key | Accion |
|-----|--------|
| `<leader>xx` | Trouble diagnostics |
| `<leader>xq` | Trouble quickfix |
| `<leader>xl` | Trouble loclist |
| `<leader>uD` | Toggle colorizer |
| `<leader>ss` | Save session |
| `<leader>sr` | Restore session |

---

## Comandos Arduino

| Comando | Descripcion |
|---------|-------------|
| `:ArduinoCompile` | Compilar el sketch actual |
| `:ArduinoUpload` | Subir al board seleccionado |
| `:ArduinoSerial` | Abrir monitor serial en terminal flotante |
| `:ArduinoBoard` | Seleccionar board (lista boards conectados) |
| `:ArduinoPort` | Seleccionar puerto serial |
| `:ArduinoStore` | Tienda de librerias (busca e instala) |
| `:ArduinoLibs` | Listar librerias instaladas |
| `:ArduinoBoards` | Listar boards instalados |
| `:ArduinoDocs` | Abrir documentacion Arduino |
| `:ArduinoVerify` | Verificar compilacion sin output |

### Configuracion Arduino

El modulo Arduino busca en:
- `~/Arduino/` o `~/Documents/Arduino/`
- Sketch: `*.ino` o `*.pde`

Board y puerto se guardan en `~/.config/arduino/nvim_state.json`.

### Tienda de Librerias

`:ArduinoStore` abre un selector Telescope con ~40 librerias populares:
- Busca por nombre o keyword
- Instala con `arduino-cli lib install`
- Filtra por categorias: sensores, display, LED, WiFi, etc.

---

## LSP Servers Configurados

| Server | Lenguaje | Paquete del sistema |
|--------|----------|-------------------|
| lua_ls | Lua | (via Mason) |
| ts_ls | JavaScript/TypeScript | (via Mason) |
| pyright | Python | (via Mason) |
| rust_analyzer | Rust | (via Mason) |
| gopls | Go | (via Mason) |
| clangd | C/C++/Arduino | clang-tools |
| jdtls | Java | (via Mason) |
| zls | Zig | (via Mason) |

### Instalacion automatica via Mason

Al abrir un archivo, Mason instala automaticamente el LSP correspondiente.
Los servidores que requieren paquete del sistema (clangd) deben instalarse
por separado.

---

## Formateo (conform.nvim)

Se ejecuta automaticamente al guardar:

| Lenguaje | Formateador | Paquete |
|----------|-------------|---------|
| Lua | stylua | stylua |
| JavaScript/TypeScript | prettier | prettier |
| Rust | rustfmt | rustup |
| Go | gofumpt | (via Go) |
| C/C++ | clang-format | clang-tools |
| Shell/Bash | shfmt | shfmt |
| Nix | nixfmt | nixfmt-rfc-style |
| HTML/CSS/JSON/YAML | prettier | prettier |

---

## Linting (nvim-lint)

Se ejecuta automaticamente al guardar y al escribir:

| Lenguaje | Linter | Paquete |
|----------|--------|---------|
| Shell/Bash | shellcheck | shellcheck |
| Dockerfile | hadolint | hadolint |
| Markdown | markdownlint | (via Mason) |

---

## Depuracion (nvim-dap)

### Adaptadores disponibles

| Adapter | Lenguaje | Como iniciar |
|---------|----------|--------------|
| delve | Go | `<leader>dc` en archivo .go |
| python | Python | `<leader>dc` en archivo .py |

### Funciones del debugger

- **Breakpoints**: punto rojo en el gutter
- **DAP UI**: se abre automaticamente al iniciar debug
- **Virtual text**: muestra el valor de la variable en la linea
- **REPL**: consola interactiva del debugger

---

## Terminal (toggleterm)

### Modos

| Modo | Tecla | Descripcion |
|------|-------|-------------|
| Flotante | `<leader>t` | Terminal flotante centrada |
| Vertical | `<leader>T` | Terminal al lado derecho |
| Toggle | `<C-\>` | Abrir/cerrar terminal rapida |

### Comandos en terminal

| Comando | Descripcion |
|---------|-------------|
| `<C-\><C-n>` | Salir al modo normal |
| `<Esc>` | Cerrar terminal (modo normal) |

---

## Personalizacion de colores (pywal)

NixVim soporta integracion completa con pywal:

1. Instala pywal: `nix-env -iA nixpkgs.pywal`
2. Genera colores: `wal -i /ruta/a/wallpaper.jpg`
3. Abre nvim: los colores se aplican automaticamente

### Que se colorea con pywal

- Fondo de todas las ventanas (transparente)
- Logo y textos del dashboard
- Signos de git en el gutter
- Menu de autocompletado
- Borders de ventanas flotantes
- Statusline
- Line numbers
- Diagnostics

### Sin pywal

Si pywal no esta instalado, NixVim usa bamboo.nvim con colores
Catppuccin de fallback (todo funciona normalmente).

---

## Comandos utiles de Neovim

| Comando | Descripcion |
|---------|-------------|
| `:Lazy` | Gestor de plugins |
| `:Mason` | Gestor de LSP servers |
| `:LspInfo` | Info del LSP actual |
| `:ConformInfo` | Info de formateadores |
| `:checkhealth` | Verificar salud de Neovim |
| `:e $MYVIMRC` | Abrir init.lua |
| `:source %` | Recargar archivo actual |

---

## Solucion de problemas

### Plugins no cargan

```bash
rm -rf ~/.config/nvim/lazy
nvim  # re-instala lazy.nvim
```

### LSP no funciona

```bash
# Verificar Mason
:Mason

# Verificar LSP activo
:LspInfo

# Reinstalar servidor
:MasonInstall <nombre>
```

### Formateo no funciona

```bash
# Verificar formateadores disponibles
:ConformInfo

# Verificar que stylua/prettier estan en PATH
which stylua prettier
```

### Arduino no detecta board

```bash
# Verificar arduino-cli
arduino-cli board list

# Verificar permisos del puerto
ls -la /dev/ttyUSB0
```

### Pywal no aplica colores

```bash
# Verificar que pywal genero colores
ls -la ~/.cache/wal/colors

# Regenerar colores
wal -i /ruta/a/wallpaper.jpg
```

---

## Informacion extra

- NixVim v1.0
- Neovim 0.12+
- 43 plugins via lazy.nvim
- Pywal integration con fondo transparente
- Dashboard personalizado con reloj en tiempo real
