# 🐉 NetHunter Ultimate Installer v2.0

Este repositorio contiene una configuración automatizada para desplegar **Kali NetHunter Full** en Termux, optimizada con **Gemini CLI**, **Fastfetch (Modo Dragón)** y un tema visual hacker.

> **Autor:** @betovittoria  
> **Estado:** Estable

---

## 🚀 Características

*   **Instalación Desatendida:** Prepara Termux, descarga y configura Kali sin intervención.
*   **Auto-Inicio:** Configura Termux para entrar directamente a Kali al abrir la app.
*   **Fix Gemini AI:** Instala `pnpm` y `gemini-cli-core` con enlaces simbólicos para que funcione nativamente como comando global.
*   **Estética Cyberpunk:** Incluye fuente *MesloLGS NF*, tema *Atomic* para la terminal y el logo del Dragón al inicio.

---

## 🛠️ Instrucciones de Instalación

### 1. Preparación y Despliegue
Desde una instalación limpia de Termux, clona este repositorio y ejecuta el instalador maestro.

```bash
# Clona el repositorio
git clone https://github.com/wilsonvictoria/mi-nethunter-config.git

# Entra en la carpeta
cd mi-nethunter-config

# Ejecuta el instalador (asegúrate de darle permisos de almacenamiento si los pide)
bash installer.sh
```

**¿Qué hace este paso?**
*   Configura el almacenamiento y actualiza Termux.
*   Descarga la imagen oficial `rootfs-full-arm64` de Kali.
*   Crea el lanzador `nh` y configura el auto-arranque.
*   Inyecta el script `activar.sh` dentro del sistema Kali.

### 2. Configuración del Entorno Hacker
Una vez termine el paso anterior, verás instrucciones para entrar. Si no entraste automáticamente:

```bash
# Inicia Kali NetHunter
nh
```

Ya dentro de la consola de Kali (verás que es blanca/básica por ahora), ejecuta:

```bash
# Configura el entorno visual y herramientas IA
./activar.sh
```

**¿Qué hace este paso?**
*   Actualiza los repositorios internos de Kali.
*   Instala **Fastfetch** (el dragón).
*   Instala **PNPM** y **Google Gemini CLI**, creando el enlace `/usr/bin/gemini` para que funcione siempre.
*   Aplica el tema *Atomic* y ZSH como shell por defecto.

---

## 🤖 Uso Diario

Una vez instalado todo:

1.  Abre Termux -> Entrará solo a Kali.
2.  Verás el logo del dragón y el estado del sistema.
3.  **Inteligencia Artificial (Gemini):**
    *   Escribe `gemini` y pulsa Enter para abrir el **chat interactivo** (conversación fluida).
    *   O escribe `gemini "tu pregunta"` para una respuesta rápida y directa.
4.  **Actualización del Sistema:**
    *   Escribe simplemente `update`.
    *   *¿Qué hace esto?* Es un atajo creado por el script. Ejecuta automáticamente `apt update && apt upgrade -y` para mantener tu Kali actualizado sin escribir comandos largos.

---

*Disfruta de tu entorno de pentesting avanzado.*
