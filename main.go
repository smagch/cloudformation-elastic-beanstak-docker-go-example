package main

import (
	"database/sql"
	"fmt"
	_ "github.com/lib/pq"
	"log"
	"net/http"
	"flag"
	"os"
)

var (
	db *sql.DB
	id = 1
	flagDatabaseURL = flag.String("database-url", "postgres://:@localhost/test?sslmode=disable", "database url to connect")
	flagAddr = flag.String("addr", ":8080", "http address to listen")
	testEnv = ""
)

func handler(w http.ResponseWriter, r *http.Request) {
	var count int
	err := db.QueryRow(`
		SELECT num
		FROM count
		WHERE id = $1
	`, id).Scan(&count)
	if err != nil {
		log.Fatal(err)
	}
	count += 1
	fmt.Fprintf(w, "Count is %d. Yes?. One more test. %s", count, testEnv)
	_, err = db.Exec(`
		UPDATE count
		SET (num) = ($2)
		WHERE id = $1
	`, id, count)
	if err != nil {
		log.Fatal(err)
	}
}

func handlePing(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
}

func main() {
	flag.Parse()
	var err error
	db, err = sql.Open("postgres", *flagDatabaseURL)
	if err != nil {
		log.Fatal(err)
	}
	_, err = db.Exec(`
		DROP TABLE IF EXISTS count;
		CREATE TABLE count (
			id integer PRIMARY KEY,
			num integer NOT NULL
		);
		INSERT INTO count (id, num) VALUES (1, 0);`)
	if err != nil {
		log.Fatal(err)
	}
	testEnv = os.Getenv("TEST_ENV")
	http.HandleFunc("/", handler)
	http.HandleFunc("/ping", handlePing)
	http.ListenAndServe(*flagAddr, nil)
}
