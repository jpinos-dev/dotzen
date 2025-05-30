package dotfiles

import (
	"fmt"
	
	"dotzen/internal/config"
	"dotzen/internal/git"
	"dotzen/internal/symlink"
)

// Manager orquesta todas las operaciones de dotfiles
type Manager struct {
	config 		*config.Config
	repo 		*git.Repository
	symlinker 	*symlink.Manager
}

// New crea una nueva instancia de Manager
func New(cfg *config.Config) *Manager {
	repo := git.New(cfg.RepoURL, cfg.LocalPath)
	symlinker := symlink.New(cfg.HomeDir, cfg.LocalPath, cfg.Symlinks)

	return &Manager{
		config: 	cfg,
		repo: 		repo,
		symlinker: 	symlinker,
	}
}

// Setup ejecuta todo el proceso de configuración
func (m *Manager) Setup() error {
		fmt.Println("🚀 ¡DotZen funcionando correctamente!")

		if err := git.IsGitInstalled(); err != nil {
			return fmt.Errorf("❌ %v", err)
		}
		fmt.Println("✅ Git encontrado")

		fmt.Println("🏠 Tu directorio home es: ", m.config.HomeDir)
		fmt.Printf("📁 Ruta local: %s\n", m.config.LocalPath)
		fmt.Printf("🌐 Ruta remota: %s\n", m.config.RepoURL)

		if err := m.repo.Sync(); err != nil {
			return fmt.Errorf("❌ %v", err)
		}

		if err := m.symlinker.CreateAll(); err != nil {
			return fmt.Errorf("❌ %v", err)
		}

		fmt.Println("\n🎉 ¡DotZen ha terminado exitosamente!")
		return nil
}

