package main

import (
	"log"
	"os"

	. "github.com/mholt/archiver/v3"
)

func main() {
	if err := Unarchive(os.Args[1], os.Args[2]); err != nil {
		log.Fatal(err)
	}
}
