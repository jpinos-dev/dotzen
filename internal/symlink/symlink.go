package symlink

import (
	"fmt"
	"os"
	"path/filepath"
	"dotzen/internal/config"
)

// Manager maneja la creación y gestión de symlins
type Manager struct {
	homeDir			string
	dotfilesPath 	string
	mappings 		[]config.SymlinkMapping
}

// New crea una nueva instancia de Manager
func New(homeDir, dotfilesPath string, mappings []config.SymlinkMapping) *Manager {
	return &Manager{
		homeDir: 		homeDir,
		dotfilesPath: 	dotfilesPath,
		mappings: 		mappings,
	}
}

// CreateAll crea todos los symlinks configurados
func (m *Manager) CreateAll() error {
	fmt.Println("\n🔗 Creando symlinks...")

	for _, mapping := range m.mappings {
		if err := m.createSingle(mapping); err != nil {
			fmt.Printf("❌ Error creando symlink para %s: %v\n", mapping.Target, err)
		}
	}

	fmt.Println("✅ Proceso de symlinks completado")
	return nil
}

// createSingle crea un symlink individual
func (m *Manager) createSingle(mapping config.SymlinkMapping) error {
	sourcePath := filepath.Join(m.dotfilesPath, mapping.Source)
	targetPath := filepath.Join(m.homeDir, mapping.Target)

	if _, err := os.Stat(sourcePath); os.IsNotExist(err) {
		fmt.Printf("⚠️ Archivo fuente no encontrado, saltando: %s\n", sourcePath)
		return nil
	}

	if _, err := os.Lstat(targetPath); err == nil {
		if err := m.handleExisting(sourcePath, targetPath); err != nil {
			return err
		}
	}

	if err := os.MkdirAll(filepath.Dir(targetPath), 0755); err != nil {
		return fmt.Errorf("error creando directorio %s: %v", filepath.Dir(targetPath), err)
	}

	if err := os.Symlink(sourcePath, targetPath); err != nil {
		return fmt.Errorf("error creando symlink %s -> %s: %v", targetPath, sourcePath, err)
	}

	fmt.Printf("✅ Symlink creado: %s -> %s\n", targetPath, sourcePath)
	return nil
}

func (m *Manager) handleExisting(sourcePath, targetPath string) error {
	if link, err := os.Readlink(targetPath); err == nil {
		if link == sourcePath {
			fmt.Printf("✓ Symlink ya existe: %s -> %s\n", targetPath, sourcePath)
			return nil
		}

		fmt.Printf("⚠️ Actualizando symlink existente: %s\n", targetPath)
	} else {
		fmt.Printf("⚠️ Archivo existente encontrado: %s (creando backup)\n", targetPath)

		backupPath := targetPath + ".backup"
		if err := os.Rename(targetPath, backupPath); err != nil {
			return fmt.Errorf("error creando backup de %s: %v", targetPath, err)
		}

		fmt.Printf("📦 Backup creado: %s\n", backupPath)
	}

	if err := os.Remove(targetPath); err != nil {
		return fmt.Errorf("error eliminando %s: %v", targetPath, err)
	}

	return nil
}


