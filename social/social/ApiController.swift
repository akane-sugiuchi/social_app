//
//  ApiController.swift
//  social
//
//  Created by 杉内茜 on 2016/12/17.
//  Copyright © 2016年 杉内茜. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

func get_events(year: Int, month: Int) -> [(key: Int, value: [AnyObject])] {
    
    var eventList: [Int:[AnyObject]] = [:]
    var events: [[String: AnyObject?]] = []
    //文字列→日付にする準備
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var keepAlive:Bool = true
    
    let url = "http://52.196.55.156:1323/calender"
    let params =  [
        "user_id": 1,
        "year": year,
        "month": month
        ] as [String : Int]
    
    Alamofire.request(url, parameters: params).responseJSON { response in
        let obj = response.result.value
        let json = JSON(obj!)
        let json_data = json["Data"]
        
        json_data.forEach{(i, json_data) in
            let days = json_data["Day"]
            events = []
            days.forEach{(_, days) in
                let event: [String: AnyObject?] = [
                    "id":days["Id"].int as Optional<AnyObject>,
                    "summary":days["Summary"].string as Optional<AnyObject>,
                    "dtstart":days["Dtstart"].string as Optional<AnyObject>,
                    "dtend":days["Dtend"].string as Optional<AnyObject>,
                    "description":days["Description"].string as Optional<AnyObject>
                ]
                events.append(event as [String : AnyObject])
            }
            if events.count > 0 {
                eventList[Int(i)!+1] = events as [AnyObject]?
            }
        }
        keepAlive = false
    }
    let runLoop = RunLoop.current
    while keepAlive &&
        runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
            // requestが返ってくるまで次の処理の実行をしないで待機
    }
    let sortedEventList = eventList.sorted { $0.0 < $1.0 }
    return sortedEventList
}

func get_tasks(year: Int, month: Int) -> [(key: Int, value: [AnyObject])] {
    
    var taskList: [Int:[AnyObject]] = [:]
    var tasks: [[String: AnyObject?]] = []
    //文字列→日付にする準備
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var keepAlive:Bool = true
    
    let url = "http://52.196.55.156:1323/task"
    let params =  [
        "user_id": 1,
        "year": year,
        "month": month
        ] as [String : Int]
    
    Alamofire.request(url, parameters: params).responseJSON { response in
        let obj = response.result.value
        let json = JSON(obj!)
        let json_data = json["Data"]
        
        json_data.forEach{(i, json_data) in
            let days = json_data["Day"]
            tasks = []
            days.forEach{(_, days) in
                let event: [String: AnyObject?] = [
                    "id":days["Id"].int as Optional<AnyObject>,
                    "title":days["Title"].string as Optional<AnyObject>,
                    "dtend":days["Dtend"].string as Optional<AnyObject>,
                    "sub_task":days["Sub_task"].string as Optional<AnyObject>
                ]
                tasks.append(event as [String : AnyObject])
            }
            if tasks.count > 0 {
                taskList[Int(i)!+1] = tasks as [AnyObject]?
            }
        }
        print(taskList)
        keepAlive = false
    }
    let runLoop = RunLoop.current
    while keepAlive &&
        runLoop.run(mode: RunLoopMode.defaultRunLoopMode, before: NSDate(timeIntervalSinceNow: 0.1) as Date) {
            // requestが返ってくるまで次の処理の実行をしないで待機
    }
    let sortedTaskList = taskList.sorted { $0.0 < $1.0 }
    return sortedTaskList
}

/*
{   
    1: [
        {"id": 1, "dtstart": ""},
        {"id": 2, "dtstart": ""}
    ],
    2: [
 　　　　　{"id": 6}, {"id": 9}
    ], .....,
    31: [
 　　　　　{"id": 12}
    ]
}
 */


