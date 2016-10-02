package main

import (
  "database/sql"
  "fmt"
  _ "github.com/go-sql-driver/mysql"
)

func get_connect() *sql.DB{
  db,err := sql.Open("mysql","root:tomohi6@tcp(192.168.60.55:3306)/social-app")
  if err != nil {
    panic(err.Error())
  }
  return db
}

func get_email(db *sql.DB) {
  rows, _ := db.Query("select * from test")
  fmr.Println(rows)
}

func Res_mysql() echo.HandlerFunc {
  return func(c echo.Context) error {
    db := get_connect()
    rows, err := db.Query("select * from test")
    if err != nil {
      return err
    }
    values := make([]sql.RawBytes,1)
    scanArgs := make([]interfave{},1)
    for i := range values {
      scanArgs[i] = &values[i]
    }
    value := ""
    for i,col := range values {
      if col == nil {
        value = "NULL"
      } else {
        value = string(col)
      }
    }
    return c.String(http.StatusOK,value)
  }
}
