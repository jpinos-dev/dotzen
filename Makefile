BINARY_NAME=dotzen
VERSION=$(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
BUILD_TIME=$(shell date +%Y-%m-%d_%H:%M:%S)
LDFLAGS=-ldflags "-X main.Version=$(VERSION) -X main.BuildTime=$(BUILD_TIME)"

BIN_DIR=bin
DIST_DIR=dist

PLATFORMS=darwin/amd64 linux/amd64 linux/arm64 windows/amd64

.PHONY: all build clean test help install build-all release

help:
	@echo "Commandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

build:
	@echo "🔨 Compilando para la plataforma actual..."
	@mkdir -p $(BIN_DIR)
	go build $(LDFLAGS) -o $(BIN_DIR)/$(BINARY_NAME) ./cmd/dotzen
	@echo "✅ Compilación completada: $(BIN_DIR)/$(BINARY_NAME)"

build-all: ## Compila para todas las plataformas
	@echo "🔨 Compilando para todas las plataformas..."
	@mkdir -p $(BIN_DIR)
	@for platform in $(PLATFORMS); do \
		os=$$(echo $$platform | cut -d'/' -f1); \
		arch=$$(echo $$platform | cut -d'/' -f2); \
		output_name=$(BINARY_NAME)-$$os-$$arch; \
		if [ $$os = "windows" ]; then output_name=$$output_name.exe; fi; \
		echo "📦 Compilando para $$os/$$arch..."; \
		GOOS=$$os GOARCH=$$arch go build $(LDFLAGS) -o $(BIN_DIR)/$$output_name ./cmd/dotzen; \
		if [ $$? -ne 0 ]; then \
			echo "❌ Error compilando para $$os/$$arch"; \
			exit 1; \
		fi; \
	done
	@echo "✅ Todas las compilaciones completadas"

release: build-all
	@echo " Creando release..."
	@mkdir -p $(DIST_DIR)
	@for platform in $(PLATFORMS); do \
		os=$$(echo $$platform | cut -d'/' -f1); \
		arch=$$(echo $$platform | cut -d'/' -f2); \
		binary_name=$(BINARY_NAME)-$$os-$$arch; \
		if [ $$os = "windows" ]; then binary_name=$$binary_name.exe; fi; \
		archive_name=$(BINARY_NAME)-$(VERSION)-$$os-$$arch; \
		if [ $$os = "windows" ]; then \
			zip -j $(DIST_DIR)/$$archive_name.zip $(BIN_DIR)/$$binary_name README.md; \
		else \
			tar -czf $(DIST_DIR)/$$archive_name.tar.gz -C $(BIN_DIR) $$binary_name -C ../. README.md; \
		fi; \
		echo "📦 Creado: $(DIST_DIR)/$$archive_name"; \
	done
	@echo "✅ Release completado en $(DIST_DIR)/"

install: build
	@echo "📥 Instalando $(BINARY_NAME)..."
	@sudo cp $(BIN_DIR)/$(BINARY_NAME) /usr/local/bin/
	@echo "✅ $(BINARY_NAME) instalado en /usr/local/bin/"

clean: 
	@echo "🧹 Limpiando..."
	@rm -rf $(BIN_DIR) $(DIST_DIR)
	@echo "✅ Limpieza completada"

test: 
	@echo "🧪 Ejecutando tests..."
	go test -v ./...

run: build	@echo "🚀 Ejecutando $(BINARY_NAME)..."
	./$(BIN_DIR)/$(BINARY_NAME)

version: 
	@echo "Versión: $(VERSION)"
	@echo "Tiempo de compilación: $(BUILD_TIME)"
