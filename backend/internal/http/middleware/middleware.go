package middleware

import (
	"fmt"
	"net/http"
	"time"
)

type Logger struct{}

func (*Logger) ServeHTTP(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	fmt.Println("The logger middleware is executing!")
	t := time.Now()
	next.ServeHTTP(w, r)
	fmt.Printf("Execution time: %s \n", time.Since(t).String())
}

type Auth struct{}

func (*Auth) ServeHTTP(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	fmt.Println("Auth validation")
	fmt.Printf("r: %v\n", r)
	next.ServeHTTP(w, r)
}
