package main


import (
  "github.com/labstack/echo"
  "github.com/labstack/echo/engine/standard"
  "github.com/labstack/echo/middleware"
  "database/sql"
  _ "github.com/go-sql-driver/mysql"

  "./tool"
  "./model"
)

func db_connect() *sql.DB {
  db,err := sql.Open("mysql","root:@/social-app")
  if err != nil {
    panic(err.Error())
  }
  return db
}

func main(){

  e := echo.New()
  db := db_connect()

  //ミドルウェアの使用機能
  e.Use(middleware.Logger())
  e.Use(middleware.Recover())

  //モデル
  e.Get("/json",tool.Res_json())
  e.Get("/email",tool.Res_mysql())
  e.Get("/calender",model.Echo_event(db))
  e.Get("/regist",model.Echo_regist(db))

  //サーバー構築 ポート1323
  e.Run(standard.New(":1323"))
}
