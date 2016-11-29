//
//  EventListViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/11/05.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

func get_event() -> [(key: Int, value: [AnyObject])] {
    
    var eventList: [Int:[AnyObject]] = [:]
    var events: [[String: AnyObject?]] = []
    //文字列→日付にする準備
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var keepAlive:Bool = true
    
    let url = "http://52.196.55.156:1323/calender?id=1&year=2016&month=11"
    
    Alamofire.request(url).responseJSON { response in
        let obj = response.result.value
        let json = JSON(obj!)
        let json_data = json["Data"]
        
        json_data.forEach{(i, json_data) in
            let days = json_data["Day"]
            events = []
            days.forEach{(_, days) in
                let event: [String: AnyObject?] = [
                    "id":days["Id"].int as Optional<AnyObject>,
                    "summary":days["summary"].string as Optional<AnyObject>,
                    "dtstart":days["dtstart"].string as Optional<AnyObject>,
                    "dtend":days["dtend"].string as Optional<AnyObject>,
                    "description":days["description"].string as Optional<AnyObject>
                ]
                events.append(event as [String : AnyObject])
            }
            if events.count > 0 {
                eventList[Int(i)!+1] = events as [AnyObject]?
            }
        }
        print(eventList)
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
        /*
        　　{1: [
                {"id": 1, "dtstart": ""},
                {"id": 2, "dtstart": ""}
              ],
            2: [
        　　　　　{"id": 6}, {"id": 9}], .....,
        　　31: [
        　　　　　{"id": 12}
        　　　　　]
        　　}
        */

