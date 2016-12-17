//
//  TaskDetailViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/12/16.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit
import Alamofire

class TaskDetailViewController: UIViewController {
    
    //@IBOutlet weak var startDatelabel: UILabel!
    //@IBOutlet weak var eventSummarylabel: UILabel!
    //@IBOutlet weak var eventDetaillabel: UILabel!
    
    var task: [String: Any] = [:]
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
    @IBAction func deletebuttonClicked(){
        
        print ("delete button clicked!!!")
        
        //let url = "http://52.196.55.156:1323/calender/delete"
        let url = "http://52.196.55.156:1323/task/delete"
        let params =  [
            "id": task["id"]!,
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
        setTaskDetail()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setTaskDetail() {
        let lWidth: CGFloat = 200
        let lHeight: CGFloat = 35
        
        let dateWidth: CGFloat = 100
        let dateHeight: CGFloat = 25
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/3 - lWidth/2
        let posY: CGFloat = self.view.bounds.height/6 - lHeight/2
        let taskSummarylabel: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: lWidth, height: lHeight))
        let taskDetaillabel: UILabel = UILabel(frame: CGRect(x: posX, y: (posY+lHeight+dateHeight*2+150), width: lWidth, height: lHeight))
        
        let endDatelabel: UILabel = UILabel(frame: CGRect(x: posX, y: (posY+100), width: dateWidth, height: dateHeight))

        
        let calendar = Calendar.current
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dsString = formatter.date(from: task["dtend"] as! String)
        let endDate = calendar.dateComponents([.year, .month, .day], from: dsString!)
        
        taskSummarylabel.text = task["title"] as! String?
        taskDetaillabel.text = task["sub_task"] as! String?
        endDatelabel.text = "\(endDate.year!)/\(endDate.month!)/\(endDate.day!)"

        taskSummarylabel.sizeToFit()
        taskDetaillabel.sizeToFit()
        endDatelabel.sizeToFit()
        
        self.view.addSubview(taskSummarylabel)
        self.view.addSubview(taskDetaillabel)
        self.view.addSubview(endDatelabel)
        
    }
}

