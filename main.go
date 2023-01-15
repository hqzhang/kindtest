package main

import (
	"fmt"
	"net/http"
    "os"
)

func main() {
        arg := "8089"
        if len(os.Args) > 1 {
           arg = os.Args[1]
        }
        fmt.Println(arg)
        fmt.Println(len(os.Args))
	    http.HandleFunc("/", func (w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Welcome to Hongqi Website!\n")
	})

	fs := http.FileServer(http.Dir("static/"))
	http.Handle("/static/", http.StripPrefix("/static/", fs))

	http.ListenAndServe(":"+arg, nil)
}
