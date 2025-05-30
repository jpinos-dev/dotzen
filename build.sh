#!/bin/bash

# Configuration
BINARY_NAME="dotzen"
BIN_DIR="bin"
DIST_DIR="dist"
VERSION=$(git describe --tags --always --dirty 2>/dev/null || echo "dev")

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Funciones
show_help() {
    echo e "${GREEN}DotZen Build Script${NC}"
    echo ""
    echo "Uso: ./build.sh [opciones]"
    echo ""
    echo "Opciones:"
    echo "  -a, --all       Compila para todas las plataformas"
    echo "  -c, --clean     Limpia los archivos generados"
    echo "  -r, --release   Crea release con archivos comprimidos"
    echo "  -i, --install   Instala el binario localmente"
    echo "  -h, --help      Muestra esta página de ayuda"
}

build_current() {
    echo -e "${YELLOW}🔨 Compilando para la plataforma actual...${NC}"
    
    mkdir -p "$BIN_DIR"

    go build -ldflags "-X main.Version=$VERSION" -o "$BIN_DIR/$BINARY_NAME" ./cmd/dotzen

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Compilación completada: $BIN_DIR/$BINARY_NAME${NC}"
    else
        echo -e "${RED}❌ Error en la compilación${NC}"
        exit 1
    fi
}

build_all() {
    echo -e "${YELLOW}🔨 Compilando para todas las plataformas...${NC}"

    mkdir -p "$BIN_DIR"

    platforms=("darwin/amd642" "darwin/arm64" "linux/amd64" "linux/arm64" "windows/amd64")

    for platform in "${platforms[@]}"; do
        os=$(echo "$platform" | cut -d'/' -f1)
        arch=$(echo "$platform" | cut -d'/' -f2)
        output_name="$BINARY_NAME-$os-$arch"

        if [ "$os" = "windows" ]; then
            output_name="$output_name.exe"
        fi

        echo -e "${CYAN}📦 Compilando para $os/$arch...${NC}"

        GOOS=$os GOARCH=$arch go build -ldflags "-X main.Version=$VERSION" -o "$BIN_DIR/$output_name" ./cmd/dotzen

        if [ $? -ne 0 ]; then 
            echo -e "${RED}❌ Error compilando para $os/$arch${NC}"
            exit 1
        fi
    done

    echo -e "${GREEN}✅ Todas las compilaciones completadas${NC}"
}

create_release() {
    build_all

    echo -e "${YELLOW}📦 Creando release...${NC}"
    mkdir -p "$DIST_DIR"

    platforms=("darwin/amd64" "darwin/arm64" "linux/amd64" "linux/arm64" "windows/amd64")

    for platform in "${platforms[@]}"; do
        os=$(echo "$platform" | cut -d'/' -f1)
        arch=$(echo "$platform" | cut -d'/' -f2)
        binary_name="$BINARY_NAME-$os-$arch"

        if [ "$os" = "windows" ]; then
            binary_name="$binary_name.exe"
        fi 

        archive_name="$BINARY_NAME-$VERSION-$os-$arch"

        if [ "$os" = "windows" ]; then
            zip -j "$DIST_DIR/$archive_name.zip" "$BIN_DIR/$binary_name" README.md
        else
            tar -czf "$DIST_DIR/$archive_name.tar.gz" -C "$BIN_DIR" "$binary_name" -C ../. README.md
        fi

        echo -e "${CYAN}📦 Creado: $DIST_DIR/$archive_name${NC}"
    done

    echo -e "${GREEN}✅ Release completado en $DIST_DIR/${NC}"
}

install_local() {
    build_current

    echo -e "${YELLOW}📥 Instalando $BINARY_NAME...${NC}"
    sudo cp "$BIN_DIR/$BINARY_NAME" /usr/local/bin/
    sudo -r "${GREEN}✅ $BINARY_NAME instalado en /usr/local/bin/${NC}"
}

clean_files() {
    echo -e "${YELLOW}🧹 Limpiando archivos generados...${NC}"
    rm -rf "$BIN_DIR" "$DIST_DIR"
    echo -e "${GREEN}✅ Limpieza completada${NC}"
}

chmod +x "$0"

case "${1:-}" in
    -a|--all)
        build_all
        ;;
    -c|--clean)
        clean_files
        ;;
    -r|--release)
        create_release
        ;;
    -i|--install)
        install_local
        ;;
    -h|--help)
        show_help
        ;;
    "")
        build_current
        ;;
    *)
        echo -e "${RED}Opcion desconocida: $1${NC}"
        show_help
        exit 1
        ;;
esac
