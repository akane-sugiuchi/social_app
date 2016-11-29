//
//  eventDetailViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/11/13.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit
import Alamofire

class eventDetailViewController: UIViewController {

    @IBOutlet weak var startDatelabel: UILabel!
    @IBOutlet weak var eventSummarylabel: UILabel!
    @IBOutlet weak var endDatelabel: UILabel!
    @IBOutlet weak var startTimelabel: UILabel!
    @IBOutlet weak var endTimelabel: UILabel!
    @IBOutlet weak var eventDetaillabel: UILabel!
    
    var event: [String: Any] = [:]
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
    @IBAction func deletebuttonClicked(){
        
         print ("delete button clicked!!!")

        let url = "http://52.196.55.156:1323/calender/delete"
        let params =  [
            "id": event["id"]!,
            "user_id": 1
            ] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { response in
            print (response.result)
        }

         // Viewの移動
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "index")
        self.present(nextView, animated: true, completion: nil)
 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setEventDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setEventDetail() {
        let lWidth: CGFloat = 200
        let lHeight: CGFloat = 35
        
        let dateWidth: CGFloat = 100
        let dateHeight: CGFloat = 25
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/3 - lWidth/2
        let posY: CGFloat = self.view.bounds.height/6 - lHeight/2
        let eventSummarylabel: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: lWidth, height: lHeight))
        let eventDetaillabel: UILabel = UILabel(frame: CGRect(x: posX, y: (posY+lHeight+dateHeight*2+150), width: lWidth, height: lHeight))
        
        let startDatelabel: UILabel = UILabel(frame: CGRect(x: posX, y: (posY+100), width: dateWidth, height: dateHeight))
        let endDatelabel: UILabel = UILabel(frame: CGRect(x: (posX+200), y: (posY+100), width: dateWidth, height: dateHeight))
        let startTimelabel: UILabel = UILabel(frame: CGRect(x: posX, y: (posY+150), width: dateWidth, height: dateHeight))
        let endTimelabel: UILabel = UILabel(frame: CGRect(x: (posX+200), y: (posY+150), width: dateWidth, height: dateHeight))
        
        let calendar = Calendar.current
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dsString = formatter.date(from: event["dtstart"] as! String)
        let startDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dsString!)
        let deString = formatter.date(from: event["dtend"] as! String)
        let endDate = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: deString!)
        
        eventSummarylabel.text = event["summary"] as! String?
        eventDetaillabel.text = event["description"] as! String?
        startDatelabel.text = "\(startDate.year!)/\(startDate.month!)/\(startDate.day!)"
        endDatelabel.text   = "\(endDate.year!)/\(endDate.month!)/\(endDate.day!)"
        startTimelabel.text = "\(startDate.hour!):\(startDate.minute!)"
        endTimelabel.text = "\(endDate.hour!):\(endDate.minute!)"
        
        eventSummarylabel.sizeToFit()
        eventDetaillabel.sizeToFit()
        startDatelabel.sizeToFit()
        endDatelabel.sizeToFit()
        startTimelabel.sizeToFit()
        endTimelabel.sizeToFit()
        
        self.view.addSubview(eventSummarylabel)
        self.view.addSubview(eventDetaillabel)
        self.view.addSubview(startDatelabel)
        self.view.addSubview(endDatelabel)
        self.view.addSubview(startTimelabel)
        self.view.addSubview(endTimelabel)

    }
}
