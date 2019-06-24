package api

import (
	"os"
)

func GetPort() string {
	e := os.Getenv("PORT")

	if len(e) == 0 {
		e = "4047"
	}

	return e
}

func GetPostfixHost() string {
	e := os.Getenv("POSTFIX_HOST")

	if len(e) == 0 {
		e = "127.0.0.1"
	}

	return e
}

func GetPostfixPort() string {
	e := os.Getenv("POSTFIX_PORT")

	if len(e) == 0 {
		e = "25"
	}

	return e
}

func GetPostfixUsername() string {
	e := os.Getenv("POSTFIX_HOST")

	if len(e) == 0 {
		e = "postmaster"
	}

	return e
}

func GetPostfixPassword() string {
	e := os.Getenv("POSTFIX_PASSWORD")

	if len(e) == 0 {
		e = "password"
	}

	return e
}
