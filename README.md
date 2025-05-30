# 🚀 DotZen

**Una herramienta CLI moderna y elegante para gestionar tus dotfiles con facilidad**

DotZen automatiza la sincronización de tu repositorio de dotfiles y crea symlinks automáticamente, manteniendo tu configuración sincronizada en todos tus sistemas.

## ✨ Características

- 🔄 **Sincronización automática** - Clona o actualiza tu repositorio de dotfiles
- 🔗 **Gestión de symlinks** - Crea automáticamente enlaces simbólicos a tus archivos de configuración
- 🛡️ **Backup automático** - Respalda archivos existentes antes de crear symlinks
- 🌍 **Multi-plataforma** - Compatible con macOS, Linux y Windows
- ⚡ **Rápido y eficiente** - Escrito en Go para máximo rendimiento
- 🎯 **Configuración simple** - Setup mínimo requerido

## 📦 Instalación

### Descarga de Releases

Descarga el binario precompilado para tu sistema desde la página de [Releases](https://github.com/jpinos-dev/dotzen/releases):

#### macOS
```bash
# Intel Macs
curl -L https://github.com/jpinos-dev/dotzen/releases/latest/download/dotzen-darwin-amd64.tar.gz | tar -xz
sudo mv dotzen /usr/local/bin/

# Apple Silicon (M1/M2)
curl -L https://github.com/jpinos-dev/dotzen/releases/latest/download/dotzen-darwin-arm64.tar.gz | tar -xz
sudo mv dotzen /usr/local/bin/
```

#### Linux
```bash
# x86_64
curl -L https://github.com/jpinos-dev/dotzen/releases/latest/download/dotzen-linux-amd64.tar.gz | tar -xz
sudo mv dotzen /usr/local/bin/

# ARM64
curl -L https://github.com/jpinos-dev/dotzen/releases/latest/download/dotzen-linux-arm64.tar.gz | tar -xz
sudo mv dotzen /usr/local/bin/
```

#### Windows
```powershell
# Descargar y extraer manualmente desde GitHub Releases
# Colocar dotzen.exe en tu PATH
```

### Compilación desde código fuente

#### Requisitos
- [Go](https://golang.org/dl/) 1.21 o superior
- Git

#### Instalación
```bash
# Clonar el repositorio
git clone https://github.com/jpinos-dev/dotzen.git
cd dotzen

# Compilar e instalar
make install
```

## 🚀 Uso

### Uso básico
```bash
# Ejecutar DotZen
dotzen
```

Esto hará:
1. ✅ Verificar que Git esté instalado
2. 📥 Clonar o actualizar tu repositorio de dotfiles
3. 🔗 Crear symlinks para todos los archivos configurados
4. 📦 Hacer backup de archivos existentes automáticamente

### Configuración

DotZen busca tu repositorio de dotfiles en: `https://github.com/jpinos-dev/dotfiles.git`

#### Personalizar la configuración

Edita el archivo `internal/config/config.go` para personalizar:

```go
// En la función New(), cambia:
RepoURL: "https://github.com/TU-USUARIO/dotfiles.git",

// En getDefaultSymlinks(), añade tus archivos:
{Source: "nvim", Target: ".config/nvim"},
{Source: "alacritty", Target: ".config/alacritty"},
// ... más configuraciones
```

### Estructura de dotfiles recomendada
```
dotfiles/
├── .vimrc
├── .zshrc
├── .gitconfig
├── .tmux.conf
├── nvim/
│ ├── init.vim
│ └── ...
├── alacritty/
│ └── alacritty.yml
└── README.md
```
## 🛠️ Desarrollo

### Estructura del proyecto
```
dotzen/
├── cmd/dotzen/ # Punto de entrada principal
├── internal/
│ ├── config/ # Configuración
│ ├── git/ # Operaciones Git
│ ├── symlink/ # Gestión de symlinks
│ └── dotfiles/ # Lógica principal
├── bin/ # Binarios compilados
├── dist/ # Releases
├── Makefile
├── build.sh # Script de compilación Unix
├── build.ps1 # Script de compilación Windows
└── README.md
```

### Comandos de desarrollo

```bash
# Compilar para desarrollo
make build

# Compilar para todas las plataformas
make build-all

# Crear release
make release

# Ejecutar tests
make test

# Limpiar archivos generados
make clean

# Ver todos los comandos disponibles
make help
```

### Scripts de compilación

#### Unix/Linux/macOS
```bash
./build.sh           # Compilar local
./build.sh --all     # Todas las plataformas
./build.sh --release # Crear release
./build.sh --install # Instalar local
```

#### Windows
```powershell
.\build.ps1          # Compilar local
.\build.ps1 -All     # Todas las plataformas
.\build.ps1 -Clean   # Limpiar
```

## 🔧 Configuración avanzada

### Symlinks personalizados

Los symlinks se configuran en `internal/config/config.go`:

```go
type SymlinkMapping struct {
    Source string // Archivo en el repo dotfiles
    Target string // Destino en el sistema (relativo a $HOME)
}
```

Ejemplos:
```go
{Source: ".vimrc", Target: ".vimrc"},                    // Archivo simple
{Source: "nvim", Target: ".config/nvim"},                // Directorio completo
{Source: "scripts/my-script.sh", Target: ".local/bin/my-script.sh"}, // Subdirectorio
```

### Variables de entorno

| Variable | Descripción | Por defecto |
|----------|-------------|-------------|
| `HOME` | Directorio home del usuario | Detectado automáticamente |

## 🤝 Contribuir

¡Las contribuciones son bienvenidas! Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

### Reportar bugs

Usa [GitHub Issues](https://github.com/jpinos-dev/dotzen/issues) para reportar bugs o solicitar features.

## 📝 Changelog

### v1.0.0
- ✨ Primera versión estable
- 🔗 Gestión completa de symlinks
- 📦 Backup automático de archivos existentes
- 🌍 Soporte multi-plataforma
- ⚡ Compilación cruzada para todas las plataformas

## 🛡️ Seguridad

- DotZen crea backups automáticos antes de sobrescribir archivos
- Solo modifica archivos en tu directorio home
- No requiere permisos de administrador (excepto para instalación global)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Reconocimientos

- Inspirado por [GNU Stow](https://www.gnu.org/software/stow/) y otros gestores de dotfiles
- Construido con ❤️ usando [Go](https://golang.org/)

## 📞 Soporte

- 📧 Email: [jordypinosdev@gmail.com](mailto:jordypinosdev@gmail.com)
- 🐛 Issues: [GitHub Issues](https://github.com/jpinos-dev/dotzen/issues)
- 💬 Discussions: [GitHub Discussions](https://github.com/jpinos-dev/dotzen/discussions)

---

<p align="center">
  Hecho con ❤️ por <a href="https://github.com/jpinos-dev">@jpinos-dev</a>
</p>

<p align="center">
  <a href="https://golang.org/">
    <img src="https://img.shields.io/badge/Made%20with-Go-00ADD8?style=for-the-badge&logo=go" alt="Made with Go">
  </a>
  <a href="https://github.com/jpinos-dev/dotzen/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge" alt="License: MIT">
  </a>
  <a href="https://github.com/jpinos-dev/dotzen/releases">
    <img src="https://img.shields.io/github/v/release/jpinos-dev/dotzen?style=for-the-badge" alt="Latest Release">
  </a>
</p>
