package main

import (
	"fmt"
	"os"
	"dotzen/internal/config"
	"dotzen/internal/dotfiles"
)

func main() {
	cfg, err := config.New()

	if err != nil {
		fmt.Printf("❌  Error obteniendo configuración: %v\n", err)
		os.Exit(1)
	}

	manager := dotfiles.New(cfg)

	if err := manager.Setup(); err != nil {
		fmt.Printf("❌ Error en setup: %v\n", err)
		os.Exit(1)
	}
}

