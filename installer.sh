#!/data/data/com.termux/files/usr/bin/bash
set -e

# --- COLORES ---
BOLD='\033[1m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
NC='\033[0m'

clear
echo -e "${BLUE}=========================================${NC}"
echo -e "${BOLD}${CYAN}   NetHunter Ultimate Installer v2.0     ${NC}"
echo -e "${NC}             @betovittoria               ${NC}"
echo -e "${BLUE}=========================================${NC}"
sleep 2

# ====================================================
# FASE 1: PREPARACIÓN DEL HOST (TERMUX)
# ====================================================
echo -e "${GREEN}[*] FASE 1: Preparando Termux...${NC}"

termux-setup-storage
echo -e "${BLUE}[+] Actualizando repositorios...${NC}"
pkg update -y -o Dpkg::Options::="--force-confnew" > /dev/null 2>&1
echo -e "${BLUE}[+] Instalando dependencias...${NC}"
pkg install wget curl tar proot openssl net-tools xz-utils pv nano -y

# Fix Fuente
if [ ! -f "$HOME/.termux/font.ttf" ]; then
    echo -e "${BLUE}[+] Instalando fuente Hacker...${NC}"
    mkdir -p ~/.termux
    URL="https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
    wget -q "$URL" -O ~/.termux/font.ttf || curl -L "$URL" -o ~/.termux/font.ttf
    termux-reload-settings
fi

# ====================================================
# FASE 2: DESPLIEGUE DE KALI FULL
# ====================================================
echo -e "${GREEN}[*] FASE 2: Instalando Kali NetHunter...${NC}"

# Limpieza inteligente
if [ -d "kali-arm64" ]; then
    if [ ! -d "kali-arm64/etc" ]; then
        rm -rf kali-arm64
    fi
fi
mkdir -p kali-arm64

# Descarga
IMG_URL="https://kali.download/nethunter-images/current/rootfs/kali-nethunter-rootfs-full-arm64.tar.xz"
if [ -f "kali-full.tar.xz" ]; then
    filesize=$(stat -c%s "kali-full.tar.xz")
    if (( filesize > 1800000000 )); then
        echo -e "${GREEN}[OK] Archivo detectado. Usando caché.${NC}"
    else
        echo -e "${RED}[!] Archivo corrupto. Re-descargando...${NC}"
        rm -f kali-full.tar.xz
        wget -O kali-full.tar.xz "$IMG_URL"
    fi
else
    echo -e "${BLUE}[+] Descargando imagen (2.1 GB)...${NC}"
    wget -O kali-full.tar.xz "$IMG_URL" || curl -L "$IMG_URL" -o kali-full.tar.xz
fi

# Descompresión
echo -e "${GREEN}[*] Descomprimiendo sistema...${NC}"
pv kali-full.tar.xz | proot --link2symlink tar -xJf - -C kali-arm64 --strip-components=1 --exclude='dev' --exclude='sys' --exclude='proc' || :

# Estructura
mkdir -p kali-arm64/{dev,sys,proc,tmp}
echo "nameserver 8.8.8.8" > kali-arm64/etc/resolv.conf

# Crear Lanzador 'nh'
mkdir -p $PREFIX/bin
cat << 'NH_EOF' > $PREFIX/bin/nh
#!/data/data/com.termux/files/usr/bin/bash
unset LD_PRELOAD
command="proot"
command+=" --link2symlink"
command+=" -0"
command+=" -r $HOME/kali-arm64"
command+=" -b /dev"
command+=" -b /proc"
command+=" -b /sys"
command+=" -b $HOME"
command+=" -w /root"
command+=" /usr/bin/env -i"
command+=" HOME=/root"
command+=" PATH=/usr/local/sbin:/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin"
command+=" TERM=$TERM"
command+=" LANG=C.UTF-8"
command+=" /bin/bash --login"
com="$ @"
if [ -z "$1" ];then
    exec $command
else
    $command -c "$com"
fi
NH_EOF
chmod +x $PREFIX/bin/nh

# ====================================================
# FASE 3: AUTO-INICIO (FIX PARA TERMUX)
# ====================================================
echo -e "${GREEN}[*] Configurando auto-arranque en Termux...${NC}"
# Esto asegura que al abrir la app, entre directo a Kali
if ! grep -q "nh" $HOME/.bashrc; then
    echo "nh" >> $HOME/.bashrc
    echo -e "${BLUE}[OK] Auto-inicio configurado.${NC}"
fi

# ====================================================
# FASE 4: INYECCIÓN DE CONFIGURACIÓN INTERNA
# ====================================================
echo -e "${GREEN}[*] Inyectando scripts (Gemini + Dragón)...${NC}"

mkdir -p kali-arm64/root
cat << 'INTERNAL_SCRIPT' > kali-arm64/root/activar.sh
#!/bin/bash
GREEN='\033[1;32m'
BLUE='\033[1;34m'
NC='\033[0m'

clear
echo -e "${BLUE}[*] CONFIGURANDO ENTORNO HACKER...${NC}"

# 1. Update Base
echo -e "${GREEN}[1/5] Actualizando Kali...${NC}"
apt-get update -y > /dev/null 2>&1
DEBIAN_FRONTEND=noninteractive apt-get install -y curl wget git unzip zsh nano > /dev/null 2>&1

# 2. Fastfetch Manual (El Dragón)
echo -e "${GREEN}[2/5] Instalando Fastfetch...${NC}"
rm -rf ff_temp && mkdir ff_temp && cd ff_temp
wget -q -O ff.tar.gz https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-aarch64.tar.gz
tar -xf ff.tar.gz
find . -name "fastfetch" -type f -exec cp {} /usr/bin/fastfetch \;
chmod +x /usr/bin/fastfetch
cd .. && rm -rf ff_temp

# 3. PNPM & Gemini (FIX DEFINITIVO)
echo -e "${GREEN}[3/5] Instalando Gemini AI...${NC}"
# Definimos SHELL para que pnpm no falle
export SHELL=/bin/bash
curl -fsSL https://get.pnpm.io/install.sh | sh -
export PNPM_HOME="/root/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# Instalamos Gemini
pnpm config set store-dir ~/.local/share/pnpm-store > /dev/null 2>&1
pnpm add -g @.cache/pnpm/metadata-v1.3/registry.npmjs.org/@google/gemini-cli-core.json > /dev/null 2>&1

# FIX: ENLACE SIMBÓLICO PARA QUE SIEMPRE FUNCIONE
echo -e "${BLUE}[+] Creando enlace directo a Gemini...${NC}"
ln -sf /root/.local/share/pnpm/gemini /usr/bin/gemini

# 4. Tema Atomic
echo -e "${GREEN}[4/5] Configurando tema visual...${NC}"
mkdir -p /usr/local/bin
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-arm64 -O /usr/local/bin/oh-my-posh
chmod +x /usr/local/bin/oh-my-posh
mkdir -p ~/.posh-themes
curl -L -s https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/atomic.omp.json -o ~/.posh-themes/atomic.omp.json

# 5. GITHUB CONNECT (Opción Nueva)
echo -e "${GREEN}[5/6] Preparando GitHub...${NC}"
# Instalar GH CLI manualmente (más seguro en ARM64)
wget -q https://github.com/cli/cli/releases/download/v2.66.1/gh_2.66.1_linux_arm64.tar.gz -O gh.tar.gz
tar -xf gh.tar.gz
cp gh_*_linux_arm64/bin/gh /usr/local/bin/
chmod +x /usr/local/bin/gh
rm -rf gh.tar.gz gh_*_linux_arm64

echo -e "${CYAN}------------------------------------------------${NC}"
echo -e "${BOLD}¿Quieres conectar tu cuenta de GitHub ahora? (s/n)${NC}"
echo -e "${CYAN}------------------------------------------------${NC}"
read -r respuesta
if [[ "$respuesta" =~ ^[Ss]$ ]]; then
    echo -e "${BLUE}[*] Iniciando asistente de conexión...${NC}"
    echo -e "A continuación, selecciona: ${BOLD}GitHub.com -> SSH -> Yes${NC}"
    gh auth login
    
    echo -e "${BLUE}[*] Configurando tu firma de Git...${NC}"
    echo -n "Tu Nombre de Usuario (ej: Wilson): "
    read git_user
    echo -n "Tu Email de GitHub: "
    read git_email
    
    if [ ! -z "$git_user" ] && [ ! -z "$git_email" ]; then
        git config --global user.name "$git_user"
        git config --global user.email "$git_email"
        echo -e "${GREEN}[OK] Git configurado correctamente.${NC}"
    fi
else
    echo -e "Saltando configuración de GitHub."
fi

# 6. MEDIA TOOLS (yt-dlp + spotdl)
echo -e "${GREEN}[6/7] Instalando Suite Multimedia (Video & Música)...${NC}"
echo -e "${BLUE}[+] Instalando dependencias (Python, FFmpeg)...${NC}"
apt-get install -y python3 python3-pip ffmpeg atomicparsley build-essential > /dev/null 2>&1

echo -e "${BLUE}[+] Instalando yt-dlp y spotdl (esto puede tardar)...${NC}"
# Usamos --break-system-packages porque en NetHunter root es el comportamiento deseado
pip install yt-dlp spotdl --break-system-packages > /dev/null 2>&1

# 7. Configurar Shell
echo -e "${GREEN}[7/7] Finalizando...${NC}"
cat << 'ZSH_CFG' > ~/.zshrc
export PNPM_HOME="/root/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH:/usr/sbin:/sbin:/usr/local/bin"
eval "$(oh-my-posh init zsh --config ~/.posh-themes/atomic.omp.json)"
# Alias corregido
alias gemini='gemini' 
alias ll='ls -la --color=auto'
alias c='clear'
alias update='apt update && apt upgrade -y'
alias ff='fastfetch'

# Alias Multimedia
alias video='yt-dlp'
alias musica='spotdl'

if [[ -o interactive ]]; then
    clear
    fastfetch --logo kali --structure Title:Separator:OS:Host:Kernel:Uptime:Packages:Shell:Terminal:CPU:Memory:Break:Colors
    echo ""
    echo -e "  \033[1;31m[ SYSTEM ONLINE ]\033[0m :: \033[1;37mKali NetHunter Full\033[0m"
    echo ""
fi
ZSH_CFG

# Fix ZSH auto-start
if ! grep -q "exec zsh" ~/.bashrc; then
    echo "if [ -x /bin/zsh ]; then exec /bin/zsh; fi" >> ~/.bashrc
fi

echo -e "${GREEN}>>> TODO LISTO. Entrando...${NC}"
exec zsh
INTERNAL_SCRIPT

chmod +x kali-arm64/root/activar.sh

echo -e "${GREEN}=============================================${NC}"
echo -e "${BOLD}   INSTALACIÓN CORRECTA - LISTO PARA USAR    ${NC}"
echo -e "${GREEN}=============================================${NC}"
echo "1. Escribe 'nh' para entrar."
echo "2. Adentro, escribe: ./activar.sh"
