package main

import (
	"fmt"
	"os"
)

func main() {
	deleteDir := []string{
		"./elpaca/",
		"./eln-cache/",
	}
	if len(os.Args) > 1 {
		args(deleteDir)
		return
	}
	for _, directory := range deleteDir {
		if err := os.RemoveAll(directory); err != nil {
			fmt.Printf("Error removing directory %s: %s\n", directory, err)
		} else {
			fmt.Printf("Deleted: %s\n", directory)
		}
	}
}

func args(deleteDir []string) {
	if os.Args[1] == "--help" {
		fmt.Println("Usage: emacs-util")
		fmt.Println()
		fmt.Println("Options:")
		fmt.Println("--help\t\tShow this help menu")
		fmt.Println("--dry-run\tSee what gets deleted if run without flag")
		return
	}
	if os.Args[1] == "--dry-run" {
		for _, directory := range deleteDir {
			fmt.Printf("Will delete: %s\n", directory)
		}
		return
	}
}
