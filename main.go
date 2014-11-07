package main

import (
	"fmt"
	"html"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
}

func main() {
	http.HandleFunc("/", handler)
	log.Println("start server")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
