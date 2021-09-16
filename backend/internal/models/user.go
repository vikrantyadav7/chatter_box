package models

import (
	"errors"
	"fmt"
	"time"
)

// implements the CRUD operations on Users in Bipp

// User defines a user record in persistent store
type User struct {
	ID          string
	Email       string `gorm:"unique"`
	Password    string
	DisplayName string
	CreatedAt   time.Time
	UpdatedAt   time.Time
}

// CreateUser creates a user record in the peristent store of Bipp
func (client *DB) CreateUser(requestorID string, in *ChatterBoxUser) (out *ChatterBoxUser, err error) {
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
