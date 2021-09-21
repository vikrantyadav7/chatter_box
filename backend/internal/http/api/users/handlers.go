package users

import (
	"encoding/json"
	"fmt"
	"net/http"

	"chatterbox.com/v/internal/models"
)

func CreateUserHandler(w http.ResponseWriter, r *http.Request, db *models.DB) {

	var (
		err  error
		uReq models.ChatterBoxUser
		uRes *models.ChatterBoxUser
	)

	// tenantID := r.Header.Get("X-Org-ID")

	err = json.NewDecoder(r.Body).Decode(&uReq)

	uRes, err = db.CreateUser(&uReq)

	fmt.Print("request -----")
	fmt.Print(uReq.Email)
	fmt.Print(uReq.DisplayName)
	fmt.Print(uReq.PhoneNumber)
	body, err := json.Marshal(&uRes)
	if err != nil {

		panic("erro in creating user")

	}

	fmt.Print(body)
}

func sendUserMessageHandler(w http.ResponseWriter, r *http.Request, db *models.DB) {
	var (
		err  error
		uReq models.ChatterBoxUserMessage
		uRes *models.ChatterBoxUserMessage
	)

	err = json.NewDecoder(r.Body).Decode(&uReq)

	fmt.Print("request -----")
	// fmt.Print(uReq.Email)
	// fmt.Print(uReq.DisplayName)
	// fmt.Print(uReq.PhoneNumber)
	body, err := json.Marshal(&uRes)
	if err != nil {

		panic("erro in creating user")

	}

	fmt.Print(body)
}
