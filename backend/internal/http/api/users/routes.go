package users

import (
	"net/http"

	"chatterbox.com/v/internal/models"
	"github.com/gorilla/mux"
)

func RegisterUserRoutes(router *mux.Router, serveMux *http.ServeMux, db *models.DB) {

	// create a user
	router.HandleFunc("/app/v1/register", func(w http.ResponseWriter, r *http.Request) {
		CreateUserHandler(w, r, db)
	}).Methods("POST")
}
