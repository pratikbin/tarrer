package main

import (
	"fmt"
	"log"
	"os"

	"github.com/mholt/archiver/v3"
)

func main() {
	if len(os.Args) <= 1 || len(os.Args) > 2 {
		fmt.Println("Usage: tarrer <archive path> <dest dir>")
		os.Exit(1)
	}
	if err := archiver.Unarchive(os.Args[1], os.Args[2]); err != nil {
		log.Fatal(err)
	}
}
