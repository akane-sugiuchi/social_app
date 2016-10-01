package main


import (
  "github.com/labstack/echo"
  "github.com/labstack/echo/engine/standard"
  "github.com/labstack/echo/middleware"

  "./model"
)

func main(){

  e := echo.New()

  e.Use(middleware.Logger())
  e.Use(middleware.Recover())
  
  e.Get("/json",model.Res_json())
  e.Run(standard.New(":1323"))
}
