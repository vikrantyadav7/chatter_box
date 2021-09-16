package models

// all functions related to Bipp backend database - MySQL

import (
	"context"
	"fmt"
	"github.com/jinzhu/gorm"
)

// DB represents a database client object
type DB struct {
	Conn *gorm.DB
}

var dbInstance DB

// GetDBInstance returns an instance of the database client connection
func GetDBInstance() (client *DB) {
	return &dbInstance
}

// NewDatabaseClient creates a new database client and fills the DBClient object in the application context
func NewDatabaseClient(ctx context.Context, connString string) (client *DB, err error) {

	// more info on allowed parameters: https://github.com/go-sql-driver/mysql#parameters
	conn, err := gorm.Open("mysql", connString)

	if err != nil {
		fmt.Print(err.Error())
	}
	res := fmt.Sprintf("successfully connected to %s database %s", conn.Dialect().GetName(), conn.Dialect().CurrentDatabase())
	fmt.Print(res)

	// verify if the connection to the database is alive, establishing a connection if necessary.
	if err = conn.DB().Ping(); err != nil {
		// e = excp.ErrDBPing
		// e.Err = err
		fmt.Print(err.Error())
		// return nil, &e
	}

	client = &DB{
		Conn: conn,
	}

	conn.AutoMigrate(&User{})

	dbInstance.Conn = conn

	return
}

// Close terminates a database connection
// func Close(client *DB) (err error) {
// 	var e excp.Exception

// 	err = client.Conn.Close()
// 	if err != nil {
// 		e = excp.ErrDBClose
// 		e.Err = err
// 		log.Errorf(e.Error())
// 		return &e
// 	}

// 	return
// }

// // PreCheck checks for the existence of all the tables in the backend database
// func PreCheck(client *DB) (err error) {
// 	db := client.Conn
// 	notFound := []string{}

// 	for _, t := range common.GetDbTables() {
// 		if !db.HasTable(t) {
// 			notFound = append(notFound, t)
// 		}
// 	}

// 	if len(notFound) > 0 {
// 		err = fmt.Errorf("table(s) not found in backend database: %s", strings.Join(notFound, ", "))
// 		return
// 	}

// 	return
// }

// // DBCleanup cleans up the DB
// // WARNING: to be used only by the API tests
// func DBCleanup() (err error) {

// 	var (
// 		ok            bool
// 		val, dbConStr string
// 	)

// 	// environment variable BIPP_TESTDB_CONNECTION allows a test DB  to be different from localhost
// 	val, ok = os.LookupEnv("BIPP_TESTDB_CONNECTION")
// 	if !ok {
// 		// assumes localhost if environment variable not found
// 		dbConStr = common.DbConnStr
// 	} else {
// 		dbConStr = val
// 	}

// 	client, err := NewDatabaseClient(nil, dbConStr)
// 	if err != nil {
// 		log.Error("error encountered opening a DB connection: ", err)
// 		return
// 	}
// 	defer Close(client)

// 	db := client.Conn

// 	for _, table := range common.GetDbTables() {
// 		query := fmt.Sprintf("DELETE FROM %s", table)
// 		if err = db.Exec(query).Error; err != nil {
// 			log.Errorf("error encountered while deleting records from table %s: %s", table, err.Error())
// 			return
// 		}
// 	}

// 	return
// }

// // IsErrRecordNotFound returns true if the given error if of type "record not found"
// func IsErrRecordNotFound(err error) bool {
// 	return gorm.IsRecordNotFoundError(err)
// }

// // DBVersion returns the DB version of the persistence store
// func DBVersion(client *DB) (version string, err error) {

// 	db := client.Conn.DB()

// 	// Query for version of DB
// 	// Note that version() is supported for MySQLv4 onwards. But, MySQLv4 is already
// 	// very old and would expect to be using MySQL >= 4. So, this query is good enough
// 	// for our purpose.
// 	query := "SELECT version()"
// 	row := db.QueryRow(query)

// 	err = row.Scan(&version)
// 	if err != nil {
// 		err = fmt.Errorf("query to get db version failed (err: %s)", err)
// 		return
// 	}

// 	return
// }

// GetInstance returne the DB instance
func (client *DB) GetInstance() *DB {
	return GetDBInstance()
}
