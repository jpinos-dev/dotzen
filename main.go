package main

import (
	"os"
	"os/exec"
)

func main() {
	cmd := exec.Command("go", "run", "./cmd/dotzen/")
	cmd.Stderr = os.Stderr
	cmd.Stdout = os.Stdout
	cmd.Run()
}
