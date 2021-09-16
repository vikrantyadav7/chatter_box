package main

import (
	"chatterbox.com/v1/database"
	"chatterbox.com/v1/internal/http/middleware"
	"chatterbox.com/v1/internal/models"
	"context"
	"fmt"
	"github.com/urfave/negroni"
	"google.golang.org/api/oauth2/v2"
	"log"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	_ "github.com/jinzhu/gorm/dialects/mysql"
)

type User struct {
	FirstName string `json:"firstName"`
	LastName  string `json:"lastName"`
	Email     string `json:"email"`
	Company   string `json:"company"`
}

type DbData struct {
	ID   int       `json:"id"`
	Date time.Time `json:"date"`
	Name string    `json:"name"`
}

func postFunction(w http.ResponseWriter, r *http.Request) {
	// database, err := db.CreateDatabase()
	// if err != nil {
	// 	log.Fatal("Database connection failed")
	// }

	// _, err = database.Exec("INSERT INTO `test` (name) VALUES ('myname')")
	// if err != nil {
	// 	log.Fatal("Database INSERT failed")
	// }

	log.Println("You called a thing!", &r)
	log.Println("You called a thing!", r)
}

func setupRouter(router *mux.Router) {
	router.
		Methods("GET").
		Path("/").
		HandlerFunc(postFunction)

	router.
		Methods("POST").
		Path("/register").
		HandlerFunc(models.CreateUser)
}

func main() {
	config :=
		database.Config{
			ServerName: "localhost:3306",
			User:       "root",
			Password:   "12345678",
			DB:         "chatterbox",
		}

	dbConStr := database.GetConnectionString(config)
	// err := database.Connect(dbConStr)
	// if err != nil {
	// 	panic(err.Error())
	// }

	// bippCtx is a Context object which is passed around
	var bippCtx = context.Background()
	var err error
	// connect to backend database
	db := &models.DB{}

	db, err = models.NewDatabaseClient(bippCtx, dbConStr)
	if err != nil {
		panic(err)
	}

	fmt.Print(db)

	router := mux.NewRouter().StrictSlash(true)

	setupRouter(router)

	n := negroni.New()
	n.Use(&middleware.Logger{})
	n.UseHandler(router)

	err = http.ListenAndServe(":8090", n)
	if err != nil {
		panic(err)
	} else {
		fmt.Println("listening on 8090")
	}
}

var httpClient = &http.Client{}

func verifyIdToken(idToken string) (*oauth2.Tokeninfo, error) {
	oauth2Service, err := oauth2.New(httpClient)
	tokenInfoCall := oauth2Service.Tokeninfo()
	tokenInfoCall.IdToken(idToken)
	tokenInfo, err := tokenInfoCall.Do()
	if err != nil {
		return nil, err
	}
	return tokenInfo, nil
}
