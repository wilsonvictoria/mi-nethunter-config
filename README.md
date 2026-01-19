# 🐉 NetHunter Ultimate Installer v2.0 (GitHub Edition)

Este repositorio contiene una configuración automatizada para desplegar **Kali NetHunter Full** en Termux, optimizada con **Gemini CLI**, **Fastfetch (Modo Dragón)** y un **Asistente de GitHub**.

> **Autor:** @betovittoria  
> **Rama:** feature/auto-github (Experimental)

---

## 🚀 Características Nuevas

*   **🔐 Auto-Conexión GitHub:** El instalador te preguntará si quieres conectar tu cuenta. Si dices "Sí", instalará GitHub CLI (`gh`), iniciará sesión y configurará tus claves SSH y tu usuario de Git automáticamente.
*   **Instalación Desatendida:** Prepara Termux, descarga y configura Kali sin intervención.
*   **Fix Gemini AI:** Instala `pnpm` y `gemini-cli-core` con enlaces simbólicos para que funcione nativamente.
*   **Estética Cyberpunk:** Incluye fuente *MesloLGS NF*, tema *Atomic* y el Dragón al inicio.

---

## 🛠️ Instrucciones de Instalación

### 1. Clonar y Cambiar a la Rama Experimental
Para usar esta versión con el asistente de GitHub, debes seleccionar la rama correcta:

```bash
# Clona el repositorio
git clone https://github.com/wilsonvictoria/mi-nethunter-config.git

# Entra y cambia a la versión con GitHub
cd mi-nethunter-config
git checkout feature/auto-github

# Ejecuta el instalador
bash installer.sh
```

### 2. Durante la Instalación
El script hará todo automático, pero casi al final verás esto:

> **¿Quieres conectar tu cuenta de GitHub ahora? (s/n)**

*   **Si dices SÍ:** Te pedirá autorizar en el navegador y luego tu Nombre/Email para dejar todo listo.
*   **Si dices NO:** Saltará este paso y terminará la instalación normal.

### 3. Configuración del Entorno
Si no entraste automáticamente al terminar:

```bash
nh
./activar.sh
```

---

## 🤖 Uso Diario

1.  **Inteligencia Artificial:** `gemini "pregunta"` o solo `gemini` para chat.
2.  **Mantenimiento:** `update` para actualizar todo el sistema.
3.  **Git:** ¡Ya puedes hacer `git push` sin contraseñas gracias a la configuración automática!

---
*Disfruta de tu entorno de pentesting conectado a la nube.*