package model

import (
  "net/http"
  "github.com/labstack/echo"
  "database/sql"
  _ "fmt"
  _ "github.com/go-sql-driver/mysql"
)

type user_data struct {
  user_id string
  year string
  month string
}

type event struct {
  Summary string `json:"Summary"`
  Dtstart string `json:"dtstart"`
  Dtend string  `json:"dtend"`
  Description string `json:"dtstart"`
}

func initation(c echo.Context) user_data{
  return user_data{c.QueryParam("user_id"),c.QueryParam("year"),c.QueryParam("month")}
}

func (user user_data) get_data(db *sql.DB) []string {
  query := "select * from Event where user_id=" + user.user_id
  rows, err := db.Query(query)
  var value []string
  if err != nil {
    value = append(value,"false")
    return value
  }
  colum,err := rows.Columns()
  values := make([]sql.RawBytes,len(colum))
  scanArgs := make([]interface{},len(values))
  for i := range values {
    scanArgs[i] = &values[i]
  }
  for rows.Next(){
    err = rows.Scan(scanArgs...)
    for _,col := range values {
      if col == nil {
        value = append(value,"faluse")
      } else {
        value = append(value,string(col))
      }
    }
  }
  return value
}

func (user user_data) get_event(db *sql.DB) string{
  data := user.get_data(db)
  st := ""
  for _,line := range data {
    st += line + ":"
  }
  return st
}

func Echo_event(db *sql.DB) echo.HandlerFunc {
  return func(c echo.Context) error {
    user := initation(c)
    json := user.get_event(db)
    return c.String(http.StatusOK,json)
  }
}
