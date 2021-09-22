package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"chatterbox.com/v/internal/models"
	firebase "firebase.google.com/go"
	"firebase.google.com/go/messaging"

	// "github.com/appleboy/go-fcm"
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

// func initRoutesWithMiddleware(db *models.DB) (n *negroni.Negroni) {

// 	fmt.Print(db)
// 	router := mux.NewRouter().StrictSlash(true)
// 	api.InitRouter(router, db)

// 	n = negroni.New()
// 	n.Use(&middleware.Logger{})
// 	n.UseHandler(router)

// 	return n
// }

func main() {

	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/sendMessage", sendMessage)
	log.Fatal(http.ListenAndServe(":8090", router))

	// config :=
	// 	database.Config{
	// 		ServerName: "localhost:3306",
	// 		User:       "root",
	// 		Password:   "12345678",
	// 		DB:         "chatterbox",
	// 	}

	// dbConStr := database.GetConnectionString(config)
	// var serverPort = "8090"
	// bippCtx is a Context object which is passed around
	// var bippCtx = context.Background()
	// var err error
	// // connect to backend database
	// // db := &models.DB{}
	// // db, err = models.NewDatabaseClient(bippCtx, dbConStr)
	// if err != nil {
	// 	panic(err)
	// }
	// handler := initRoutesWithMiddleware(db)

	// var s *http.Server

	// s = &http.Server{
	// 	Addr:    ":" + serverPort,
	// 	Handler: handler,
	// }

	// err = s.ListenAndServe()
	// if err != nil {
	// 	fmt.Printf("Failed to start bipp api server : %s", err.Error())
	// } else {
	// 	fmt.Print("server listening")
	// }

}

func sendMessage(w http.ResponseWriter, r *http.Request) {

	var (
		err  error
		uReq models.ChatterBoxUserMessage
	)
	err = json.NewDecoder(r.Body).Decode(&uReq)
	if err != nil {
		panic("error in getting request data")

	}

	app, err := firebase.NewApp(context.Background(), nil)
	if err != nil {
		log.Fatalf("error initializing app: %v\n", err)
	}

	// Obtain a messaging.Client from the App.
	ctx := context.Background()
	client, err := app.Messaging(ctx)
	if err != nil {
		log.Fatalf("error getting Messaging client: %v\n", err)
	}

	// This registration token comes from the client FCM SDKs.
	registrationToken := uReq.DeviceID

	message := &messaging.Message{
		Notification: &messaging.Notification{
			Title: uReq.Title,
			Body:  uReq.NotificationBody,
		},
		Data: map[string]string{
			"username": uReq.Username,
			"name":     uReq.Name,
			"counter":  uReq.Counter,
		},
		Token: registrationToken,
	}

	// Send a message to the device corresponding to the provided
	// registration token.
	response, err := client.Send(ctx, message)
	if err != nil {
		log.Fatalln(err)
	}
	// Response is a message ID string.
	fmt.Println("Successfully sent message:", response)

	//==============

	// // init client
	// client := fcm.NewClient("AAAADeNFmf8:APA91bHyg0xLrO1Jgc-MvPo6-gHC8wYFgrNC9aMwKsWObwpBCu1wbjVufAxdLE_HZ5kdZhDaNss_UXQp6UApNdvvWXTiQ6yWQ5TcCJrp2q2y35qBIhS7EO0jlgmDnWnTUbNfsCO49-7b")
	// // if err != nil {
	// // 	panic("not connected")
	// // }
	// // You can use your HTTPClient
	// //client.SetHTTPClient(client)

	// data := map[string]interface{}{
	// 	"message": "From Go-FCM",
	// 	"details": map[string]string{
	// 		"name":  "Name",
	// 		"user":  "Admin",
	// 		"thing": "none",
	// 	},
	// }

	// // You can use PushMultiple or PushSingle
	// // client.PushMultiple([]string{"dy3V64wvT8OvRqgkWEB8vN:APA91bHYOKrQvIi5jRQIjdiG0xuuRyhEOpNJ8hdalOOqOLIbqTjBETVEj203wiugqI9bX6JGjZKOaQhi9rmGb9RCMell0ZdZfn6TjEMjlEyA3Jv-_BW7xE0YUxGL2gJvxpayyfEIOOVa", "token 2"}, data)
	// client.PushSingle("eRdX1cYUSRSG3IoLsZZe3d:APA91bG8Iy_lKOtxourylaXCulE9ezgCNOa5EBV667ZirDw_oa3A5ZShIuak_kghFWdENlTKDn3tVOnSuoJsstSHcPvu9bQThx9-KHCfvtutjsKVtCDpQU_eIWf-yUxTiObwkUeopeGI", data)

	// // registrationIds remove and return map of invalid tokens
	// badRegistrations := client.CleanRegistrationIds()
	// log.Println(badRegistrations)

	// status, err := client.Send()
	// if err != nil {
	// 	log.Fatalf("error: %v", err)
	// } else {
	// 	fmt.Println(status.StatusCode)
	// 	fmt.Println(status.Err)
	// 	fmt.Println(status.Success)
	// 	fmt.Println(status.MultiCastId)
	// 	fmt.Println(status.CanonicalIds)
	// 	fmt.Println(status.Failure)
	// 	fmt.Println(status.Results)
	// 	fmt.Println(status.MsgId)
	// 	fmt.Println(status.RetryAfter)
	// }

}

// var httpClient = &http.Client{}

// func verifyIdToken(idToken string) (*oauth2.Tokeninfo, error) {
// 	oauth2Service, err := oauth2.New(httpClient)
// 	tokenInfoCall := oauth2Service.Tokeninfo()
// 	tokenInfoCall.IdToken(idToken)
// 	tokenInfo, err := tokenInfoCall.Do()
// 	if err != nil {
// 		return nil, err
// 	}
// 	return tokenInfo, nil
// }
