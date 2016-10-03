package main

import (
  "net/http"
  "github.com/labstack/echo"
  _ "database/sql"
  _ "fmt"
  _ "github.com/go-sql-driver/mysql"
)

type user_data struct {
  email string
  year int
  month int
}

func (user user_data) init (c echo.Context) error{
  user.email = c.QueryParam("email")
  user.year = c.QueryParam("year")
  user.month = c.QueryParam("month")
}

func (user user_data) get_event() string{
  return user.email +":"+string(user.year)+":"+string(user.month)
}

func Echo_event() echo.HandlerFunc {
  user := new(user_data)
  return func(c echo.Context) error {
    a := user.get_event()
    return c.String(http.StatusOK,a)
  }
}
