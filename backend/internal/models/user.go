package models

import (
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/appleboy/go-fcm"
)

// implements the CRUD operations on Users in Bipp

// User defines a user record in persistent store
type User struct {
	ID          string
	Email       string `gorm:"unique"`
	PhoneNumber string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// CreateUser creates a user record in the peristent store of Bipp
func (client *DB) CreateUser(in *ChatterBoxUser) (out *ChatterBoxUser, err error) {
	fmt.Print("create user is called")
	if in.Email == "" {
		err = errors.New("email is required to create an user")
		return
	}

	// Check if this is the 1st user to be created in the tenant
	// If yes, requestor Id check is made pass through. the first user created in a tenant, is an admin
	// If no, check if the user has permission to create an user

	// check if the org id exists
	// if !client.IsTenantByIDExists(tenantID) {
	// 	err = errors.New("organization id not found")
	// 	return
	// }

	// // check if given email id is already registered with Bipp
	email := in.Email
	if client.IsUserByEmailExists(email) {
		err = errors.New("email is already registered")
		return
	}

	return
}

// CreateUser creates a user record in the peristent store of Bipp
func (client *DB) sendMessage(in *ChatterBoxUser) (out *ChatterBoxUser, err error) {
	fmt.Print("this send message was called")
	fcmApiKey := "AIzaSyBxSafjVgcYR0pekArI2meAjdOd8Tq8RXw"
	deviceToken := "dy3V64wvT8OvRqgkWEB8vN:APA91bHYOKrQvIi5jRQIjdiG0xuuRyhEOpNJ8hdalOOqOLIbqTjBETVEj203wiugqI9bX6JGjZKOaQhi9rmGb9RCMell0ZdZfn6TjEMjlEyA3Jv-_BW7xE0YUxGL2gJvxpayyfEIOOVa"
	// Create the message to be sent.
	msg := &fcm.Message{
		To: deviceToken,
		Data: map[string]interface{}{
			"foo": "bar",
		},
		Notification: &fcm.Notification{
			Title: "title",
			Body:  "body",
		},
	}

	// Create a FCM client to send the message.
	cl, err := fcm.NewClient(fcmApiKey)
	if err != nil {
		log.Fatalln(err)
	}

	// Send the message and receive the response without retries.
	response, err := cl.Send(msg)
	if err != nil {
		log.Fatalln(err)
	}

	log.Printf("%#v\n", response)
	return
}

// IsUserByEmailExists returns True if email id is found in a user, else returns false
func (client *DB) IsUserByEmailExists(email string) (exists bool) {

	db := client.Conn
	count := 0
	exists = false

	db.Model(&User{}).Where("email = ?", email).Count(&count)
	if count > 0 {
		exists = true
	}

	return
}
