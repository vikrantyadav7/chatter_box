package api

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

	"chatterbox.com/v/internal/http/api/users"
	"chatterbox.com/v/internal/models"
	"github.com/gorilla/mux"
)

func postFunction(w http.ResponseWriter, r *http.Request) {
	// database, err := db.CreateDatabase()
	// if err != nil {
	// 	log.Fatal("Database connection failed")
	// }

	// _, err = database.Exec("INSERT INTO `test` (name) VALUES ('myname')")
	// if err != nil {
	// 	log.Fatal("Database INSERT failed")
	// }

	// log.Println("You called a thing!", r)
}

func createUser(w http.ResponseWriter, r *http.Request) {
	// log.Println("You called a thing! ", r.Body)
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Printf("Error reading body: %v", err)
		http.Error(w, "can't read body", http.StatusBadRequest)
		return
	}

	fmt.Print(body)

}

// InitRouter initializes the API routes for all the components using a subrouter to support subdomain
// The subrouter logic doesnot seem to work with newer versions of Gorilla Mux after v1.6.2
// An issue opened for this bug was not fixed by the developer: https://github.com/gorilla/mux/issues/522
func InitRouter(router *mux.Router, b *models.DB) (serveMux *http.ServeMux) {

	// r := mux.NewRouter().StrictSlash(true)

	// dynamic subdomain support
	// subdomain name is later available as a variable in the Gorilla mux as follows, just like any other route variable:
	// vars := mux.Vars(r)
	// subdomain := vars["subdomain"]
	// s := r.Host("{subdomain:[a-zA-Z0-9\\-]*}" + "." + "localhost")

	// serveMux = http.NewServeMux()

	// serveMux.Handle("/", s)

	registerV1Routes(router, serveMux, b)

	router.
		Methods("GET").
		Path("/").
		HandlerFunc(postFunction)

	return serveMux
}

func registerV1Routes(router *mux.Router, serveMux *http.ServeMux, db *models.DB) {

	users.RegisterUserRoutes(router, serveMux, db)

}
