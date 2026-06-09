#!/bin/bash
#===============================================================================
# PRODUCTIVITY TOOLS SETUP SCRIPT (No sudo required)
# Uses precompiled binaries where possible, builds from source when needed
# Installs to ~/tools (symlinked to ~/.local)
#===============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Directories - Install to remote path, symlink to ~/.local
TOOLS_DIR="$HOME/tools"
LOCAL_DIR="$TOOLS_DIR/.local"
BIN_DIR="$TOOLS_DIR/bin"
TMP_DIR="/tmp/tools_install_$$"

print_header() { echo -e "\n${CYAN}══════════════════════════════════════════════════════════════════${NC}\n${BLUE}  $1${NC}\n${CYAN}══════════════════════════════════════════════════════════════════${NC}"; }
print_step() { echo -e "${GREEN}▶${NC} $1"; }
print_info() { echo -e "${YELLOW}ℹ${NC} $1"; }
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_skip() { echo -e "${YELLOW}⏭${NC} $1 (already installed)"; }

setup_directories() {
    # Create tools directory structure (all in remote path, nothing in home)
    mkdir -p "$TOOLS_DIR"/{bin,lib,share,include,state}
    mkdir -p "$TMP_DIR"
    
    # Create config dir in tools path too
    mkdir -p "$TOOLS_DIR/config"
    
    # Create symlink ~/.local -> tools directory (if not exists)
    if [[ -L "$LOCAL_DIR" ]]; then
        print_info "Symlink ~/.local already exists -> $(readlink "$LOCAL_DIR")"
    elif [[ -d "$LOCAL_DIR" ]]; then
        print_info "~/.local is a directory (not touching it)"
        print_info "Tools will be in: $TOOLS_DIR"
        print_info "Add to PATH: export PATH=\"$TOOLS_DIR/bin:\$PATH\""
    else
        ln -sf "$TOOLS_DIR" "$LOCAL_DIR"
        print_success "Created symlink: ~/.local -> $TOOLS_DIR"
    fi
    
    print_success "Directories ready: $TOOLS_DIR"
}

detect_arch() {
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            ARCH_RUST="x86_64-unknown-linux-musl"
            ARCH_GO="amd64"
            ARCH_GENERIC="x86_64"
            ;;
        aarch64|arm64)
            ARCH_RUST="aarch64-unknown-linux-musl"
            ARCH_GO="arm64"
            ARCH_GENERIC="aarch64"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    print_info "Architecture: $ARCH"
}

# Helper to download and install a binary
install_binary() {
    local name="$1"
    local url="$2"
    local binary_name="${3:-$name}"
    
    if [[ -f "$BIN_DIR/$binary_name" ]]; then
        print_skip "$name"
        return
    fi
    
    print_step "Installing $name..."
    cd "$TMP_DIR"
    local filename=$(basename "$url")
    curl -fsSL -o "$filename" "$url"
    
    if [[ "$filename" == *.tar.gz ]] || [[ "$filename" == *.tgz ]]; then
        tar -xzf "$filename"
        find . -name "$binary_name" -type f -exec cp {} "$BIN_DIR/" \; 2>/dev/null || true
    elif [[ "$filename" == *.tar.xz ]]; then
        tar -xJf "$filename"
        find . -name "$binary_name" -type f -exec cp {} "$BIN_DIR/" \; 2>/dev/null || true
    elif [[ "$filename" == *.zip ]]; then
        unzip -q -o "$filename"
        find . -name "$binary_name" -type f -exec cp {} "$BIN_DIR/" \; 2>/dev/null || true
    elif [[ "$filename" == *.tbz ]] || [[ "$filename" == *.tar.bz2 ]]; then
        tar -xjf "$filename"
        find . -name "$binary_name" -type f -exec cp {} "$BIN_DIR/" \; 2>/dev/null || true
    else
        # Direct binary download
        cp "$filename" "$BIN_DIR/$binary_name"
    fi
    
    chmod +x "$BIN_DIR/$binary_name"
    rm -rf "$TMP_DIR"/*
    print_success "$name installed"
}

#===============================================================================
# TOOL INSTALLATIONS - ALL PRECOMPILED BINARIES
#===============================================================================

install_fzf() {
    install_binary "fzf" \
        "https://github.com/junegunn/fzf/releases/download/v0.55.0/fzf-0.55.0-linux_${ARCH_GO}.tar.gz" \
        "fzf"
}

install_ripgrep() {
    install_binary "ripgrep" \
        "https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-${ARCH_RUST}.tar.gz" \
        "rg"
}

install_fd() {
    install_binary "fd" \
        "https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-${ARCH_RUST}.tar.gz" \
        "fd"
}

install_eza() {
    install_binary "eza" \
        "https://github.com/eza-community/eza/releases/download/v0.20.10/eza_${ARCH_RUST}.tar.gz" \
        "eza"
}

install_bat() {
    install_binary "bat" \
        "https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-${ARCH_RUST}.tar.gz" \
        "bat"
}

install_sd() {
    install_binary "sd" \
        "https://github.com/chmln/sd/releases/download/v1.0.0/sd-v1.0.0-${ARCH_RUST}.tar.gz" \
        "sd"
}

install_delta() {
    install_binary "delta" \
        "https://github.com/dandavison/delta/releases/download/0.18.2/delta-0.18.2-${ARCH_RUST}.tar.gz" \
        "delta"
}

install_zoxide() {
    install_binary "zoxide" \
        "https://github.com/ajeetdsouza/zoxide/releases/download/v0.9.6/zoxide-0.9.6-${ARCH_RUST}.tar.gz" \
        "zoxide"
}

install_lazygit() {
    install_binary "lazygit" \
        "https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_${ARCH_GENERIC}.tar.gz" \
        "lazygit"
}

install_jq() {
    if [[ -f "$BIN_DIR/jq" ]]; then
        print_skip "jq"
        return
    fi
    print_step "Installing jq..."
    curl -fsSL -o "$BIN_DIR/jq" "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-linux-${ARCH_GO}"
    chmod +x "$BIN_DIR/jq"
    print_success "jq installed"
}

install_yq() {
    if [[ -f "$BIN_DIR/yq" ]]; then
        print_skip "yq"
        return
    fi
    print_step "Installing yq..."
    curl -fsSL -o "$BIN_DIR/yq" "https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_${ARCH_GO}"
    chmod +x "$BIN_DIR/yq"
    print_success "yq installed"
}

install_dust() {
    install_binary "dust" \
        "https://github.com/bootandy/dust/releases/download/v1.1.1/dust-v1.1.1-${ARCH_RUST}.tar.gz" \
        "dust"
}

install_duf() {
    install_binary "duf" \
        "https://github.com/muesli/duf/releases/download/v0.8.1/duf_0.8.1_linux_${ARCH_GENERIC}.tar.gz" \
        "duf"
}

install_procs() {
    install_binary "procs" \
        "https://github.com/dalance/procs/releases/download/v0.14.6/procs-v0.14.6-${ARCH_GENERIC}-linux.zip" \
        "procs"
}

install_btop() {
    if [[ -f "$BIN_DIR/btop" ]]; then
        print_skip "btop"
        return
    fi
    print_step "Installing btop..."
    cd "$TMP_DIR"
    curl -fsSL -o btop.tbz "https://github.com/aristocratos/btop/releases/download/v1.4.0/btop-${ARCH_GENERIC}-linux-musl.tbz"
    tar -xjf btop.tbz
    cp btop/bin/btop "$BIN_DIR/"
    chmod +x "$BIN_DIR/btop"
    rm -rf "$TMP_DIR"/*
    print_success "btop installed"
}

install_direnv() {
    if [[ -f "$BIN_DIR/direnv" ]]; then
        print_skip "direnv"
        return
    fi
    print_step "Installing direnv..."
    curl -fsSL -o "$BIN_DIR/direnv" "https://github.com/direnv/direnv/releases/download/v2.35.0/direnv.linux-${ARCH_GO}"
    chmod +x "$BIN_DIR/direnv"
    print_success "direnv installed"
}

install_broot() {
    if [[ -f "$BIN_DIR/broot" ]]; then
        print_skip "broot"
        return
    fi
    print_step "Installing broot..."
    cd "$TMP_DIR"
    curl -fsSL -o broot.zip "https://github.com/Canop/broot/releases/download/v1.44.5/broot_1.44.5.zip"
    unzip -q -o broot.zip
    cp "${ARCH_GENERIC}-unknown-linux-musl/broot" "$BIN_DIR/" 2>/dev/null || \
    cp "x86_64-unknown-linux-musl/broot" "$BIN_DIR/" 2>/dev/null || \
    find . -name "broot" -type f -exec cp {} "$BIN_DIR/" \;
    chmod +x "$BIN_DIR/broot"
    rm -rf "$TMP_DIR"/*
    
    # Initialize broot shell function
    "$BIN_DIR/broot" --install 2>/dev/null || true
    print_success "broot installed"
    print_info "Run 'broot' or 'br' to launch file navigator"
}

install_just() {
    if [[ -f "$BIN_DIR/just" ]]; then
        print_skip "just"
        return
    fi
    print_step "Installing just..."
    cd "$TMP_DIR"
    curl -fsSL -o just.tar.gz "https://github.com/casey/just/releases/download/1.38.0/just-1.38.0-${ARCH_GENERIC}-unknown-linux-musl.tar.gz"
    tar -xzf just.tar.gz
    cp just "$BIN_DIR/"
    chmod +x "$BIN_DIR/just"
    rm -rf "$TMP_DIR"/*
    print_success "just installed"
    print_info "Create a 'justfile' in your project root"
}

install_tldr() {
    if [[ -f "$BIN_DIR/tldr" ]]; then
        print_skip "tldr"
        return
    fi
    print_step "Installing tldr..."
    curl -fsSL -o "$BIN_DIR/tldr" "https://github.com/dbrgn/tealdeer/releases/latest/download/tealdeer-linux-${ARCH_GENERIC}-musl"
    chmod +x "$BIN_DIR/tldr"
    "$BIN_DIR/tldr" --update 2>/dev/null || true
    print_success "tldr installed"
}

install_neovim() {
    if [[ -f "$BIN_DIR/nvim" ]]; then
        print_skip "neovim"
        return
    fi
    print_step "Installing neovim..."
    cd "$TMP_DIR"
    curl -fsSL -o nvim.tar.gz "https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz"
    tar -xzf nvim.tar.gz
    cp -r nvim-linux64/* "$TOOLS_DIR/"
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    print_success "neovim installed"
}

install_atuin() {
    if [[ -f "$BIN_DIR/atuin" ]]; then
        print_skip "atuin"
        return
    fi
    print_step "Installing atuin..."
    cd "$TMP_DIR"
    curl -fsSL -o atuin.tar.gz "https://github.com/atuinsh/atuin/releases/download/v18.3.0/atuin-${ARCH_RUST}.tar.gz"
    tar -xzf atuin.tar.gz
    find . -name "atuin" -type f -exec cp {} "$BIN_DIR/" \;
    chmod +x "$BIN_DIR/atuin"
    rm -rf "$TMP_DIR"/*
    print_success "atuin installed"
}

install_jetbrains_mono_font() {
    FONT_DIR="$TOOLS_DIR/share/fonts/JetBrainsMonoNerd"
    
    if [[ -d "$FONT_DIR" ]] && [[ -n "$(ls -A "$FONT_DIR" 2>/dev/null)" ]]; then
        print_skip "JetBrains Mono Nerd Font"
        return
    fi
    
    print_step "Installing JetBrains Mono Nerd Font..."
    mkdir -p "$FONT_DIR"
    cd "$TMP_DIR"
    
    # Download JetBrains Mono Nerd Font (includes icons/glyphs)
    curl -fsSL -o JetBrainsMono.zip \
        "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip"
    
    unzip -q -o JetBrainsMono.zip -d "$FONT_DIR" 2>/dev/null || {
        print_info "Failed to extract JetBrains Mono font - continuing anyway"
        return 0
    }
    
    # Remove Windows-compatible fonts to save space (keep only regular ttf)
    rm -f "$FONT_DIR"/*Windows*.ttf 2>/dev/null || true
    
    rm -rf "$TMP_DIR"/*
    
    # Update font cache if fc-cache is available
    if command -v fc-cache &>/dev/null; then
        fc-cache -f "$FONT_DIR" 2>/dev/null || true
    fi
    
    print_success "JetBrains Mono Nerd Font installed to $FONT_DIR"
    print_info "Set your terminal font to 'JetBrainsMono Nerd Font' for icons"
}

install_oh_my_posh() {
    if [[ -f "$BIN_DIR/oh-my-posh" ]]; then
        print_skip "oh-my-posh"
        return
    fi
    print_step "Installing oh-my-posh..."
    curl -fsSL "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-${ARCH_GO}" -o "$BIN_DIR/oh-my-posh"
    chmod +x "$BIN_DIR/oh-my-posh"
    
    # Download themes to tools config dir (not home)
    mkdir -p "$TOOLS_DIR/config/oh-my-posh/themes"
    curl -fsSL "https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/themes.zip" -o /tmp/posh-themes.zip
    unzip -q -o /tmp/posh-themes.zip -d "$TOOLS_DIR/config/oh-my-posh/themes" 2>/dev/null || true
    rm -f /tmp/posh-themes.zip
    
    # Create custom consistent catppuccin theme
    cat > "$TOOLS_DIR/config/oh-my-posh/themes/catppuccin_custom.omp.json" << 'POSH_THEME'
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "palette": {
    "rosewater": "#dc8a78",
    "flamingo": "#dd7878",
    "pink": "#ea76cb",
    "mauve": "#8839ef",
    "red": "#d20f39",
    "maroon": "#e64553",
    "peach": "#fe640b",
    "yellow": "#df8e1d",
    "green": "#40a02b",
    "teal": "#179299",
    "sky": "#04a5e5",
    "sapphire": "#209fb5",
    "blue": "#1e66f5",
    "lavender": "#7287fd",
    "text": "#4c4f69",
    "subtext1": "#5c5f77",
    "subtext0": "#6c6f85",
    "overlay2": "#7c7f93",
    "overlay1": "#8c8fa1",
    "overlay0": "#9ca0b0",
    "surface2": "#acb0be",
    "surface1": "#bcc0cc",
    "surface0": "#ccd0da",
    "base": "#eff1f5",
    "mantle": "#e6e9ef",
    "crust": "#dce0e8"
  },
  "blocks": [
    {
      "type": "prompt",
      "alignment": "left",
      "segments": [
        {
          "type": "session",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:base",
          "background": "p:blue",
          "template": " {{ .UserName }}@{{ .HostName }} "
        },
        {
          "type": "path",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:base",
          "background": "p:mauve",
          "properties": {
            "style": "agnoster_short",
            "max_depth": 3,
            "home_icon": "~"
          },
          "template": " {{ .Path }} "
        },
        {
          "type": "git",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:base",
          "background": "p:green",
          "background_templates": [
            "{{ if or (.Working.Changed) (.Staging.Changed) }}p:yellow{{ end }}",
            "{{ if and (gt .Ahead 0) (gt .Behind 0) }}p:red{{ end }}",
            "{{ if gt .Ahead 0 }}p:peach{{ end }}",
            "{{ if gt .Behind 0 }}p:peach{{ end }}"
          ],
          "properties": {
            "fetch_status": true,
            "fetch_upstream_icon": true,
            "branch_icon": "\ue725 "
          },
          "template": " {{ .HEAD }}{{ if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }} "
        },
        {
          "type": "text",
          "style": "powerline",
          "powerline_symbol": "\ue0b0",
          "foreground": "p:overlay1",
          "background": "transparent",
          "template": ""
        }
      ]
    },
    {
      "type": "prompt",
      "alignment": "left",
      "newline": true,
      "segments": [
        {
          "type": "text",
          "style": "plain",
          "foreground": "p:blue",
          "foreground_templates": [
            "{{ if gt .Code 0 }}p:red{{ end }}"
          ],
          "template": "❯ "
        }
      ]
    }
  ],
  "transient_prompt": {
    "foreground": "p:blue",
    "foreground_templates": [
      "{{ if gt .Code 0 }}p:red{{ end }}"
    ],
    "template": "❯ "
  },
  "final_space": true,
  "version": 2
}
POSH_THEME
    
    print_success "oh-my-posh installed with custom catppuccin theme"
}

#===============================================================================
# SHELL TOOLS (these need git clone, not binaries)
#===============================================================================

install_oh_my_zsh() {
    print_header "Oh My Zsh & Plugins"
    
    # Install to tools dir, not home
    OMZ_DIR="$TOOLS_DIR/oh-my-zsh"
    
    cd "$HOME"
    
    if [[ -d "$OMZ_DIR" ]]; then
        print_info "Oh My Zsh already installed in $OMZ_DIR"
    else
        print_step "Installing Oh My Zsh to $OMZ_DIR..."
        git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
        print_success "Oh My Zsh installed"
    fi
    
    ZSH_CUSTOM="$OMZ_DIR/custom"
    
    # Clone plugins if not exist
    for plugin in \
        "zsh-autosuggestions:https://github.com/zsh-users/zsh-autosuggestions" \
        "zsh-syntax-highlighting:https://github.com/zsh-users/zsh-syntax-highlighting" \
        "zsh-completions:https://github.com/zsh-users/zsh-completions" \
        "zsh-history-substring-search:https://github.com/zsh-users/zsh-history-substring-search" \
        "fzf-tab:https://github.com/Aloxaf/fzf-tab" \
        "autoupdate:https://github.com/TamCore/autoupdate-oh-my-zsh-plugins"
    do
        name="${plugin%%:*}"
        url="${plugin#*:}"
        if [[ ! -d "$ZSH_CUSTOM/plugins/$name" ]]; then
            print_step "Installing $name..."
            git clone --depth 1 "$url" "$ZSH_CUSTOM/plugins/$name" 2>/dev/null
        else
            print_skip "$name"
        fi
    done
    print_success "Oh My Zsh plugins ready"
}

install_tpm() {
    print_header "Tmux Plugin Manager"
    TPM_DIR="$TOOLS_DIR/tmux-plugins/tpm"
    if [[ -d "$TPM_DIR" ]]; then
        print_skip "TPM"
    else
        mkdir -p "$TOOLS_DIR/tmux-plugins"
        git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
        print_success "TPM installed to $TPM_DIR"
    fi
}

#===============================================================================
# TMUX DEPENDENCIES (libevent, ncurses)
#===============================================================================

install_libevent() {
    if [[ -f "$TOOLS_DIR/lib/libevent.a" ]] || [[ -f "$TOOLS_DIR/lib/libevent.so" ]]; then
        print_info "libevent already installed"
        return 0
    fi
    
    cd "$TMP_DIR"
    print_step "Downloading libevent 2.1.12..."
    curl -fsSL -o libevent.tar.gz "https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz" || return 1
    tar -xzf libevent.tar.gz || return 1
    cd libevent-2.1.12-stable || return 1
    
    print_step "Building libevent..."
    ./configure --prefix="$TOOLS_DIR" --disable-openssl || return 1
    make -j$(nproc) || return 1
    make install || return 1
    
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    print_success "libevent installed"
    return 0
}

install_ncurses() {
    if [[ -f "$TOOLS_DIR/lib/libncurses.a" ]] || [[ -f "$TOOLS_DIR/lib/libncurses.so" ]]; then
        print_info "ncurses already installed"
        return 0
    fi
    
    # Try system ncurses first
    if pkg-config --exists ncurses 2>/dev/null; then
        print_info "Using system ncurses"
        return 0
    fi
    
    cd "$TMP_DIR"
    print_step "Downloading ncurses 6.4..."
    curl -fsSL -o ncurses.tar.gz "https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz" || return 1
    tar -xzf ncurses.tar.gz || return 1
    cd ncurses-6.4 || return 1
    
    print_step "Building ncurses..."
    ./configure --prefix="$TOOLS_DIR" --with-shared --with-termlib --enable-pc-files --with-pkg-config-libdir="$TOOLS_DIR/lib/pkgconfig" || return 1
    make -j$(nproc) || return 1
    make install || return 1
    
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    print_success "ncurses installed"
    return 0
}

#===============================================================================
# TMUX (build from source - need 3.2+ for catppuccin)
#===============================================================================

install_tmux() {
    print_header "Tmux 3.5a (building from source)"
    
    if [[ -f "$BIN_DIR/tmux" ]]; then
        local ver=$("$BIN_DIR/tmux" -V 2>/dev/null | awk '{print $2}')
        if [[ "$ver" == "3.5a" ]]; then
            print_skip "tmux 3.5a"
            return
        fi
    fi
    
    # Build dependencies first
    print_step "Installing tmux dependencies..."
    if ! install_libevent; then
        print_error "Failed to build libevent"
        print_info "Using system tmux instead"
        return 1
    fi
    
    # ncurses is usually available on system
    install_ncurses || print_info "Using system ncurses"
    
    cd "$TMP_DIR"
    print_step "Downloading tmux 3.5a source..."
    curl -fsSL -o tmux.tar.gz "https://github.com/tmux/tmux/releases/download/3.5a/tmux-3.5a.tar.gz"
    tar -xzf tmux.tar.gz
    cd tmux-3.5a
    
    print_step "Building tmux..."
    export PKG_CONFIG_PATH="$TOOLS_DIR/lib/pkgconfig:$PKG_CONFIG_PATH"
    ./configure --prefix="$TOOLS_DIR" \
        CFLAGS="-I$TOOLS_DIR/include -I$TOOLS_DIR/include/ncurses" \
        LDFLAGS="-L$TOOLS_DIR/lib -Wl,-rpath,$TOOLS_DIR/lib" \
        LIBEVENT_CFLAGS="-I$TOOLS_DIR/include" \
        LIBEVENT_LIBS="-L$TOOLS_DIR/lib -levent" || {
            print_error "tmux configure failed"
            print_info "Using system tmux instead"
            cd "$HOME"
            return 1
        }
    make -j$(nproc) || {
        print_error "tmux build failed"
        cd "$HOME"
        return 1
    }
    make install
    
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    
    if [[ -f "$BIN_DIR/tmux" ]]; then
        print_success "tmux 3.5a installed"
    else
        print_error "tmux build failed"
        print_info "Using system tmux instead"
    fi
}

#===============================================================================
# TASK & TIME MANAGEMENT (build from source)
#===============================================================================

install_timewarrior() {
    print_header "Timewarrior (building from source)"
    
    if [[ -f "$BIN_DIR/timew" ]]; then
        print_skip "timewarrior"
        return
    fi
    
    cd "$TMP_DIR"
    print_step "Downloading timewarrior source..."
    curl -fsSL -o timew.tar.gz "https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.7.1/timew-1.7.1.tar.gz"
    tar -xzf timew.tar.gz 2>/dev/null
    cd timew-1.7.1
    
    print_step "Building timewarrior..."
    cmake -DCMAKE_INSTALL_PREFIX="$TOOLS_DIR" -DCMAKE_BUILD_TYPE=Release .
    make -j$(nproc)
    make install
    
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    print_success "timewarrior installed"
}

install_rust() {
    # Install Rust to tools directory, not home
    export RUSTUP_HOME="$TOOLS_DIR/rustup"
    export CARGO_HOME="$TOOLS_DIR/cargo"
    
    if [[ -f "$CARGO_HOME/bin/cargo" ]]; then
        export PATH="$CARGO_HOME/bin:$PATH"
        print_info "Rust already installed"
        return 0
    fi
    
    print_step "Installing Rust to $TOOLS_DIR..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
        RUSTUP_HOME="$RUSTUP_HOME" CARGO_HOME="$CARGO_HOME" \
        sh -s -- -y --no-modify-path --profile minimal 2>&1 | tail -5
    
    export PATH="$CARGO_HOME/bin:$PATH"
    
    if [[ -f "$CARGO_HOME/bin/cargo" ]]; then
        print_success "Rust installed to $CARGO_HOME"
        return 0
    else
        print_error "Failed to install Rust"
        return 1
    fi
}

install_taskwarrior() {
    print_header "Taskwarrior 3.4.2 (building from source)"
    
    if [[ -f "$BIN_DIR/task" ]]; then
        print_skip "taskwarrior"
        return
    fi
    
    # Taskwarrior 3.x requires Rust
    install_rust || return 1
    
    cd "$TMP_DIR"
    
    TASK_VERSION="3.4.2"
    print_step "Downloading taskwarrior ${TASK_VERSION} source..."
    curl -fsSL -o task.tar.gz "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v${TASK_VERSION}/task-${TASK_VERSION}.tar.gz"
    tar -xzf task.tar.gz 2>/dev/null
    cd "task-${TASK_VERSION}"
    
    print_step "Building taskwarrior (this may take several minutes)..."
    
    # Set Rust paths for cmake
    export RUSTUP_HOME="$TOOLS_DIR/rustup"
    export CARGO_HOME="$TOOLS_DIR/cargo"
    export PATH="$CARGO_HOME/bin:$PATH"
    
    cmake -DCMAKE_INSTALL_PREFIX="$TOOLS_DIR" \
          -DCMAKE_BUILD_TYPE=Release \
          -DRUSTUP_HOME="$RUSTUP_HOME" \
          -DCARGO_HOME="$CARGO_HOME" \
          . 2>&1 | tail -5
    
    make -j$(nproc) 2>&1 | tail -10
    make install 2>&1 | tail -3
    
    cd "$HOME"
    rm -rf "$TMP_DIR"/*
    
    if [[ -f "$BIN_DIR/task" ]]; then
        print_success "taskwarrior ${TASK_VERSION} installed"
    else
        print_error "taskwarrior build failed"
    fi
}

#===============================================================================
# TASKWARRIOR ECOSYSTEM (bugwarrior, TUI, hooks)
#===============================================================================

install_taskwarrior_tui() {
    if [[ -f "$BIN_DIR/taskwarrior-tui" ]]; then
        # Verify it actually works (glibc compatibility)
        if "$BIN_DIR/taskwarrior-tui" --version &>/dev/null; then
            print_skip "taskwarrior-tui"
            return
        else
            print_info "taskwarrior-tui binary incompatible, rebuilding from source..."
            rm -f "$BIN_DIR/taskwarrior-tui"
        fi
    fi
    
    # Build from source using cargo with musl target for static linking
    # This avoids glibc version issues on older systems
    print_step "Building taskwarrior-tui from source with static linking..."
    print_info "This may take 5-10 minutes..."
    
    # Set up Rust environment
    export RUSTUP_HOME="$TOOLS_DIR/rustup"
    export CARGO_HOME="$TOOLS_DIR/cargo"
    export PATH="$CARGO_HOME/bin:$PATH"
    
    # Ensure Rust is available
    if [[ ! -f "$CARGO_HOME/bin/cargo" ]]; then
        print_info "Rust not installed - skipping taskwarrior-tui"
        print_info "taskwarrior-tui requires Rust. Install taskwarrior first."
        return 0
    fi
    
    # Set default toolchain if not set
    rustup default stable 2>/dev/null || true
    
    # Add musl target for static linking (avoids glibc issues)
    print_step "Adding musl target for static binary..."
    rustup target add x86_64-unknown-linux-musl 2>/dev/null || true
    
    # Build with musl target
    RUSTFLAGS="-C target-feature=+crt-static" cargo install taskwarrior-tui \
        --target x86_64-unknown-linux-musl \
        --root "$TOOLS_DIR" 2>&1 | tail -15 || {
        # Fallback: try regular build if musl fails
        print_info "musl build failed, trying standard build..."
        cargo install taskwarrior-tui --root "$TOOLS_DIR" 2>&1 | tail -10 || {
            print_info "taskwarrior-tui build failed - you can install manually later"
            return 0
        }
    }
    
    if [[ -f "$BIN_DIR/taskwarrior-tui" ]]; then
        print_success "taskwarrior-tui installed (static binary)"
    else
        print_info "taskwarrior-tui not installed - you can install manually later"
    fi
}

install_bugwarrior() {
    print_header "Bugwarrior (Jira/GitHub/GitLab Sync)"
    
    # Check if pip is available
    if ! command -v pip3 &>/dev/null && ! command -v pip &>/dev/null; then
        print_info "pip not found - skipping bugwarrior"
        print_info "Install Python3 and pip, then run: pip install --user bugwarrior"
        return 0  # Don't fail the whole script
    fi
    
    local PIP_CMD="pip3"
    command -v pip3 &>/dev/null || PIP_CMD="pip"
    
    if $PIP_CMD show bugwarrior &>/dev/null; then
        print_skip "bugwarrior"
    else
        print_step "Installing bugwarrior via pip..."
        $PIP_CMD install --user bugwarrior 2>&1 | tail -3 || {
            print_info "bugwarrior pip install failed - you can install manually later"
            return 0
        }
        print_success "bugwarrior installed"
    fi
    
    # Create bugwarrior config directory and sample config
    mkdir -p "$TOOLS_DIR/config/bugwarrior"
    
    if [[ ! -f "$TOOLS_DIR/config/bugwarrior/bugwarriorrc" ]]; then
        print_step "Creating bugwarrior sample config..."
        cat > "$TOOLS_DIR/config/bugwarrior/bugwarriorrc" << 'BUGWARRIOR_CONFIG'
# Bugwarrior Configuration
# Symlink to ~/.config/bugwarrior/bugwarriorrc or set BUGWARRIORRC env var
# Docs: https://bugwarrior.readthedocs.io/

[general]
# Comma-separated list of targets to pull from
targets = jira_work
# targets = jira_work, github_personal

# How to match incoming issues to existing tasks
# Options: taskid, uuid
task_id_method = taskid

# Include annotations from external services
annotation_links = true
annotation_comments = true

#===============================================================================
# JIRA Configuration
#===============================================================================
[jira_work]
service = jira

# Your Jira instance URL
jira.base_uri = https://your-company.atlassian.net

# Authentication (use API token, not password)
jira.username = your.email@company.com
jira.password = @oracle:eval:pass jira-token
# Or use environment variable:
# jira.password = @oracle:env:JIRA_API_TOKEN

# JQL query to fetch issues assigned to you
jira.query = assignee = currentUser() AND resolution = Unresolved ORDER BY priority DESC

# Project mapping
jira.project_template = jira.{{project}}
jira.description_template = {{summary}}

# Import priorities
jira.import_priority_as_tags = true

# Map Jira fields to Taskwarrior
jira.add_tags = jira,work

#===============================================================================
# GitHub Configuration (optional)
#===============================================================================
# [github_personal]
# service = github
# github.login = your_username
# github.token = @oracle:eval:pass github-token
# github.username = your_username
# github.include_repos = repo1,repo2
# github.exclude_repos = fork1,fork2
# github.import_labels_as_tags = true
# github.add_tags = github

#===============================================================================
# GitLab Configuration (optional)
#===============================================================================
# [gitlab_work]
# service = gitlab
# gitlab.host = gitlab.company.com
# gitlab.login = your_username
# gitlab.token = @oracle:eval:pass gitlab-token
# gitlab.owned = true
# gitlab.add_tags = gitlab,work
BUGWARRIOR_CONFIG
        print_success "bugwarrior sample config created"
        print_info "Edit: $TOOLS_DIR/config/bugwarrior/bugwarriorrc"
    fi
}

setup_timewarrior_hook() {
    print_header "Timewarrior Integration Hook"
    
    # Create hooks directory
    mkdir -p "$HOME/.task/hooks"
    
    if [[ -f "$HOME/.task/hooks/on-modify.timewarrior" ]]; then
        print_skip "timewarrior hook"
        return
    fi
    
    print_step "Creating timewarrior integration hook..."
    
    cat > "$HOME/.task/hooks/on-modify.timewarrior" << 'TIMEW_HOOK'
#!/usr/bin/env python3
"""Taskwarrior hook to integrate with Timewarrior.

When a task is started, start tracking time in Timewarrior.
When a task is stopped or completed, stop tracking.
"""
import json
import subprocess
import sys

def main():
    # Read old and new task from stdin
    old_task = json.loads(sys.stdin.readline())
    new_task = json.loads(sys.stdin.readline())
    
    # Get task info
    description = new_task.get('description', 'unknown')
    project = new_task.get('project', '')
    tags = new_task.get('tags', [])
    
    # Build timew tags
    timew_tags = [description]
    if project:
        timew_tags.append(project)
    timew_tags.extend(tags)
    
    # Detect start
    old_start = old_task.get('start')
    new_start = new_task.get('start')
    
    if new_start and not old_start:
        # Task was started
        subprocess.run(['timew', 'start'] + timew_tags, 
                      capture_output=True, text=True)
    
    elif old_start and not new_start:
        # Task was stopped
        subprocess.run(['timew', 'stop'], 
                      capture_output=True, text=True)
    
    # Output the new task (required by taskwarrior)
    print(json.dumps(new_task))
    return 0

if __name__ == '__main__':
    sys.exit(main())
TIMEW_HOOK
    
    chmod +x "$HOME/.task/hooks/on-modify.timewarrior"
    print_success "timewarrior hook installed"
    print_info "Now 'task start' will auto-track time!"
}

create_taskrc() {
    print_header "Creating Taskwarrior Configuration"
    
    if [[ -f "$HOME/.taskrc" ]]; then
        print_info "~/.taskrc already exists - creating backup"
        cp "$HOME/.taskrc" "$HOME/.taskrc.backup.$(date +%Y%m%d)"
    fi
    
    cat > "$HOME/.taskrc" << 'TASKRC_CONTENT'
# Taskwarrior Configuration
# Auto-generated by setup_tools.sh

#===============================================================================
# Data Location
#===============================================================================
data.location=~/.task

#===============================================================================
# User Defined Attributes (UDAs) for Team Management
#===============================================================================

# Assignee - who owns the task
uda.assignee.type=string
uda.assignee.label=Assigned To

# Reviewer - who reviews the work
uda.reviewer.type=string
uda.reviewer.label=Reviewer

# Sprint/Iteration tracking
uda.sprint.type=string
uda.sprint.label=Sprint

# Time estimate
uda.estimate.type=duration
uda.estimate.label=Estimate

# External ticket ID (Jira, GitHub, etc.)
uda.ticket.type=string
uda.ticket.label=Ticket ID

# Story points
uda.points.type=numeric
uda.points.label=Points

#===============================================================================
# Custom Reports
#===============================================================================

# Team workload view
report.team.description=Tasks by assignee
report.team.columns=id,assignee,project,priority,description.truncated,due
report.team.labels=ID,Owner,Project,Pri,Description,Due
report.team.sort=assignee+,priority-,due+
report.team.filter=status:pending

# Sprint board
report.sprint.description=Current sprint tasks
report.sprint.columns=id,assignee,project,status.short,description.truncated,points
report.sprint.labels=ID,Owner,Project,St,Description,Pts
report.sprint.sort=status+,assignee+,priority-
report.sprint.filter=status:pending sprint.not:

# Standup report (what I did, what I'm doing)
report.standup.description=Standup report
report.standup.columns=id,project,description.truncated,status.short
report.standup.labels=ID,Project,Description,Status
report.standup.sort=status-,modified-
report.standup.filter=(status:completed and end.after:yesterday) or (status:pending and start.any:)

# Jira imported tasks
report.jira.description=Tasks from Jira
report.jira.columns=id,ticket,project,priority,description.truncated,due
report.jira.labels=ID,Ticket,Project,Pri,Description,Due
report.jira.sort=priority-,due+
report.jira.filter=status:pending +jira

#===============================================================================
# Colors (Catppuccin Latte inspired)
#===============================================================================
color.active=bold white on blue
color.blocked=white on black
color.blocking=yellow
color.due=yellow
color.due.today=red
color.overdue=bold red
color.tagged=none
color.tag.jira=cyan
color.tag.github=magenta
color.uda.priority.H=bold red
color.uda.priority.M=yellow
color.uda.priority.L=green

#===============================================================================
# Sync Configuration (TW3 - no server needed!)
#===============================================================================
# Uncomment and set path for file-based sync:
# sync.local.server_dir=/path/to/sync/folder

# For team sync via Git:
# sync.local.server_dir=~/git/taskwarrior-team-data

#===============================================================================
# Bugwarrior Integration
#===============================================================================
# Set this to your bugwarrior config location
# Or symlink: ln -s $TOOLS_DIR/config/bugwarrior ~/.config/bugwarrior

#===============================================================================
# Miscellaneous
#===============================================================================
default.command=next
weekstart=Monday
search.case.sensitive=no
json.array=on
TASKRC_CONTENT

    print_success "Created ~/.taskrc with team management UDAs"
}

#===============================================================================
# NOTES
#===============================================================================

print_notes() {
    print_header "Notes"
    echo ""
    echo "  Tools built from source:"
    echo "  • tmux 3.5a  - Built for Catppuccin theme support"
    echo "  • taskwarrior 3.4.2 - Latest with Rust"
    echo "  • timewarrior 1.7.1"
    echo ""
    echo "  Taskwarrior Ecosystem:"
    echo "  • taskwarrior-tui - Terminal UI for tasks"
    echo "  • bugwarrior - Sync from Jira/GitHub/GitLab"
    echo "  • timewarrior hook - Auto time tracking"
    echo ""
    echo "  System tools (if tmux build failed):"
    echo "  • zsh  - $(zsh --version 2>/dev/null || echo 'not found')"
    echo ""
}

#===============================================================================
# CONFIGURATION
#===============================================================================

create_zshrc_tools() {
    print_header "Creating Shell Configuration"
    
    # Create complete .zshrc file
    cat > "$HOME/.zshrc" << 'ZSHRC_CONTENT'
#===============================================================================
# ZSH Configuration - Auto-generated by setup_tools.sh
#===============================================================================

TOOLS_DIR="/remote/us01sgnfs01294/hastakh/tools"
export PATH="$TOOLS_DIR/bin:$PATH"

#===============================================================================
# Oh My Zsh Configuration
#===============================================================================
export ZSH="$TOOLS_DIR/oh-my-zsh"
ZSH_THEME=""  # Disabled - using Oh My Posh instead

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    zsh-history-substring-search
    fzf-tab
    autoupdate
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

#===============================================================================
# Oh My Posh (Prompt Theme)
#===============================================================================
if command -v oh-my-posh &>/dev/null; then
    eval "$(oh-my-posh init zsh --config $TOOLS_DIR/config/oh-my-posh/themes/powerlevel10k_rainbow.omp.json)"
fi

#===============================================================================
# Tool Integrations
#===============================================================================

# Rust (for cargo install)
export RUSTUP_HOME="$TOOLS_DIR/rustup"
export CARGO_HOME="$TOOLS_DIR/cargo"
[[ -d "$CARGO_HOME/bin" ]] && export PATH="$CARGO_HOME/bin:$PATH"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Zoxide (smart cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Direnv
command -v direnv &>/dev/null && eval "$(direnv hook zsh)"

# Atuin (shell history)
command -v atuin &>/dev/null && eval "$(atuin init zsh --disable-up-arrow)"

#===============================================================================
# Aliases
#===============================================================================

# eza (better ls)
if command -v eza &>/dev/null; then
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --icons --group-directories-first --git'
    alias la='eza -a --icons --group-directories-first'
    alias lt='eza --tree --level=2 --icons'
    alias l='eza -l --icons --group-directories-first'
fi

# bat (better cat)
if command -v bat &>/dev/null; then
    alias cat='bat --paging=never'
    alias catp='bat --plain'
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Modern replacements
command -v rg &>/dev/null && alias grep='rg'
command -v dust &>/dev/null && alias du='dust'
command -v duf &>/dev/null && alias df='duf'
command -v procs &>/dev/null && alias ps='procs'
command -v btop &>/dev/null && alias top='btop' && alias htop='btop'
command -v lazygit &>/dev/null && alias lg='lazygit'
command -v nvim &>/dev/null && alias vim='nvim' && alias vi='nvim' && export EDITOR='nvim'

# Git with delta
command -v delta &>/dev/null && export GIT_PAGER='delta'

# Timewarrior & Taskwarrior
command -v timew &>/dev/null && alias tw='timew' && alias tws='timew summary :week'
command -v task &>/dev/null && alias t='task' && alias ta='task add' && alias tl='task list'

#===============================================================================
# Functions
#===============================================================================

# Fuzzy find and edit
fe() { local f=$(fzf --preview 'bat --style=numbers --color=always {}'); [[ -n "$f" ]] && ${EDITOR:-vim} "$f"; }

# Fuzzy cd
fcd() { local d=$(fd --type d | fzf --preview 'eza --tree --level=1 --icons {}'); [[ -n "$d" ]] && cd "$d"; }

# Fuzzy git branch
fbr() { git branch -vv | fzf | awk '{print $1}' | sed 's/^\*//' | xargs git checkout; }
ZSHRC_CONTENT

    print_success "Created ~/.zshrc with Oh My Zsh + Oh My Posh"
}

create_tmux_conf() {
    print_header "Creating Tmux Configuration"
    
    # Determine which zsh to use
    local ZSH_PATH="$BIN_DIR/zsh"
    if [[ ! -f "$ZSH_PATH" ]]; then
        ZSH_PATH=$(command -v zsh 2>/dev/null || echo "/bin/zsh")
    fi
    
    cat > "$HOME/.tmux.conf" << TMUX_CONF
#===============================================================================
# Tmux Configuration - Auto-generated by setup_tools.sh
#===============================================================================

# TPM Plugin Path
set-environment -g TMUX_PLUGIN_MANAGER_PATH '$TOOLS_DIR/tmux-plugins'

#===============================================================================
# General Settings
#===============================================================================
set -g mouse on
set-option -g default-shell $ZSH_PATH
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"
set -g base-index 1
set -g pane-base-index 1
set-option -g renumber-windows on
set -g history-limit 50000
set -g display-time 4000
set -g status-interval 5
set -g focus-events on
setw -g aggressive-resize on

# Use vi keys
setw -g mode-keys vi

#===============================================================================
# Copy-Paste Settings
#===============================================================================
bind -T copy-mode-vi v send -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
bind P paste-buffer
bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel

#===============================================================================
# Key Bindings
#===============================================================================
# Reload config
bind r source-file ~/.tmux.conf \\; display-message "Reloaded tmux.conf"

# Split panes with | and _
bind-key | split-window -h -c "#{pane_current_path}"
bind-key _ split-window -v -c "#{pane_current_path}"

# Navigate panes with vim keys
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R

# Resize panes
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

#===============================================================================
# Plugins (TPM)
#===============================================================================
set -g @plugin 'catppuccin/tmux'
set -g @plugin 'tmux-plugins/tpm'

#===============================================================================
# Catppuccin Theme Configuration
#===============================================================================
set -g @catppuccin_flavor 'latte'
set -g @catppuccin_window_status_style "custom"
set -g @catppuccin_status_middle_separator  "#[bg=gray]█"
set -g @catppuccin_status_left_separator  "#[bg=gray]"
set -ogqF @catppuccin_window_right_separator ""
set -ogqF @catppuccin_window_current_right_separator ""
set -g @catppuccin_window_middle_separator "|"
set -g @catppuccin_window_default_text " #{window_name}"
set -g @catppuccin_window_current_text "#[bold,italics] #{window_name} #{?window_zoomed_flag,󰊓 ,}"
set -g @catppuccin_status_fill "icon"
set -g @catppuccin_status_connect_separator "yes"

# Status bar
set -g status-left ""
set -g status-right ""
set -ogq "@catppuccin_session_icon" "  "
set -ag status-right "#{E:@catppuccin_status_session}"

#===============================================================================
# Initialize TPM (keep this at the very bottom)
#===============================================================================
run '$TOOLS_DIR/tmux-plugins/tpm/tpm'
TMUX_CONF

    print_success "Created ~/.tmux.conf with Catppuccin theme"
    print_info "Using shell: $ZSH_PATH"
    print_info "Run 'prefix + I' in tmux to install plugins"
}

setup_git_delta() {
    print_step "Configuring git with delta..."
    git config --global core.pager delta 2>/dev/null || true
    git config --global interactive.diffFilter "delta --color-only" 2>/dev/null || true
    git config --global delta.navigate true 2>/dev/null || true
    git config --global delta.side-by-side true 2>/dev/null || true
    git config --global delta.line-numbers true 2>/dev/null || true
    print_success "Git configured"
}

#===============================================================================
# MAIN
#===============================================================================

cleanup() { 
    cd "$HOME"
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

print_summary() {
    print_header "Installation Complete!"
    echo ""
    echo "  ✓ Tools installed to: $TOOLS_DIR"
    echo "  ✓ ~/.zshrc created with Oh My Zsh + Oh My Posh"
    echo "  ✓ ~/.tmux.conf created with Catppuccin theme"
    echo "  ✓ JetBrains Mono Nerd Font installed"
    echo ""
    echo "  ${GREEN}Installed tools:${NC}"
    echo "    fzf, ripgrep (rg), fd, eza, bat, sd, delta, zoxide"
    echo "    lazygit, jq, yq, dust, duf, procs, btop"
    echo "    direnv, neovim, atuin, tldr, oh-my-posh"
    echo "    tmux 3.5a, timewarrior (timew), taskwarrior (task)"
    echo "    oh-my-zsh (with plugins), tpm"
    echo ""
    echo "  ${GREEN}Font:${NC}"
    echo "    JetBrains Mono Nerd Font (with icons)"
    echo "    Location: $TOOLS_DIR/share/fonts/JetBrainsMonoNerd"
    echo ""
    echo "  ${YELLOW}To activate:${NC}"
    echo "    ${CYAN}source ~/.zshrc${NC}     # Reload shell config"
    echo "    ${CYAN}$TOOLS_DIR/bin/tmux${NC}  # Start new tmux with installed version"
    echo "    ${CYAN}prefix + I${NC}          # Install tmux plugins (in tmux)"
    echo ""
    echo "  ${YELLOW}Font setup:${NC}"
    echo "    Set terminal font to 'JetBrainsMono Nerd Font' for icons"
    echo ""
}

main() {
    print_header "🚀 Productivity Tools Setup"
    
    setup_directories
    detect_arch
    
    print_header "Search & Navigation"
    install_fzf
    install_ripgrep
    install_fd
    install_zoxide
    
    print_header "File & Text Tools"
    install_eza
    install_bat
    install_sd
    install_delta
    install_jq
    install_yq
    
    print_header "System Monitoring"
    install_btop
    install_dust
    install_duf
    install_procs
    
    print_header "Developer Tools"
    install_lazygit
    install_direnv
    install_broot
    install_just
    install_neovim
    install_atuin
    install_tldr
    install_oh_my_posh
    
    print_header "Fonts"
    install_jetbrains_mono_font
    
    # Terminal tools (build from source)
    install_tmux
    
    # Task & Time Management (build from source)
    install_timewarrior
    install_taskwarrior
    
    # Taskwarrior Ecosystem
    install_taskwarrior_tui
    install_bugwarrior
    setup_timewarrior_hook
    create_taskrc
    
    # Shell tools (git clone based)
    install_oh_my_zsh
    install_tpm
    
    # Configuration
    create_zshrc_tools
    create_tmux_conf
    setup_git_delta
    
    print_notes
    print_summary
}

main "$@"
