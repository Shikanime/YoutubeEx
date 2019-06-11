package config

import (
	"os"
)

func GetPort() string {
	port := os.Getenv("PORT")

	if len(port) == 0 {
		port = "80"
	}

	return port
}
