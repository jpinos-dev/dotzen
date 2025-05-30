package git

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
)

// Repository maneja las operaciones del repositorio Git
type Repository struct {
	URL 		string
	LocalPath 	string
}

// New crea una nueva instancia de Repository
func New(url, localPath string) *Repository {
	return &Repository{
		URL: 		url,
		LocalPath: 	localPath,
	}
}

// IsGitInstalled verifica si Git está disponible en el sistema
func IsGitInstalled() error {
	_, err := exec.LookPath("git")
	if err != nil {
		return fmt.Errorf("git no está instalado o no está en el PATH")
	}
	return nil
}

// Exists verifica si el repositorio ya existe localmente
func (r *Repository) Exists() bool {
	gitDir := filepath.Join(r.LocalPath, ".git")
	_, err := os.Stat(gitDir)
	return err == nil
}

// Clone clona el repositorio remoto
func (r *Repository) Clone() error {
	fmt.Println("📥 Clonando repositorio")

	cmd := exec.Command("git", "clone", r.URL, r.LocalPath)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("Error clonando repositorio: %v", err)
	}

	fmt.Println("✅ Repositorio clonado exitosamente")
	return nil
}

// Pull actualiza el repositorio local
func (r *Repository) Pull() error {
	fmt.Println("📥 Repositorio encontrado, actualizando...")

	cmd := exec.Command("git", "pull", "origin", "main")
	cmd.Dir = r.LocalPath
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error haciendo pull: %v", err)
	}

	fmt.Println("✅ Repositorio actualizado correctamente")
	return nil
}

// Sync clona o actualiza el repositorio según sea necesario
func (r *Repository) Sync() error {
	if r.Exists() {
		return r.Pull()
	}

	return r.Clone()
}
