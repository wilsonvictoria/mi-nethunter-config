# 🐉 NetHunter Ultimate Installer v2.0 (Media Edition)

Este repositorio contiene la versión definitiva de **Kali NetHunter** para Termux. Incluye Inteligencia Artificial, Conexión a GitHub y una **Suite Multimedia** completa.

> **Autor:** @betovittoria  
> **Rama:** feature/media-tools

---

## 🚀 Características Nuevas

*   **🎬 Descargador de Video (yt-dlp):** Descarga videos de YouTube, TikTok, Twitter, etc. en máxima calidad (4K/8K) con soporte automático para unir audio y video.
*   **🎵 Descargador de Spotify (spotdl):** Descarga playlists, álbumes o canciones de Spotify con carátulas, letras y metadatos originales.
*   **🔐 Auto-Conexión GitHub:** Asistente interactivo para conectar tu cuenta.
*   **🧠 Gemini AI:** Inteligencia Artificial integrada en la terminal.

---

## 🛠️ Instalación

Para obtener esta versión con TODAS las herramientas:

```bash
# Clona el repositorio
git clone https://github.com/wilsonvictoria/mi-nethunter-config.git

# Cambia a la rama Multimedia
cd mi-nethunter-config
git checkout feature/media-tools

# Ejecuta el instalador
bash installer.sh
```

---

## 🤖 Manual de Uso

### 🎬 Descargar Videos
Usa el comando `video` (alias de yt-dlp).

*   **Básico:** `video "URL_DEL_VIDEO"`
*   **Solo Audio (MP3):** `video -x --audio-format mp3 "URL"`
*   **Formato específico:** `video -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4] / bv*+ba/b" "URL"` (Mejor calidad mp4)

### 🎵 Descargar Música
Usa el comando `musica` (alias de spotdl).

*   **Canción:** `musica "https://open.spotify.com/track/..."`
*   **Playlist completa:** `musica "https://open.spotify.com/playlist/..."`
*   **Búsqueda:** `musica "Nombre Canción Artista"`

### 🧠 Inteligencia Artificial
*   `gemini "pregunta"`

### ☁️ Actualizar Sistema
*   `update`

---
*Convierte tu Android en una navaja suiza digital.*
