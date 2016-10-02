package main


import (
  "github.com/labstack/echo"
  "github.com/labstack/echo/engine/standard"
  "github.com/labstack/echo/middleware"
  "./tool"
)

func main(){

  e := echo.New()

  e.Use(middleware.Logger())
  e.Use(middleware.Recover())
  
  e.Get("/json",tool.Res_json())
  e.Get("/email",tool.Res_mysql())
  e.Run(standard.New(":1323"))
}
