//
//  TaskViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/12/16.
//  Copyright © 2016年 杉内茜. All rights reserved.
//


import UIKit
import Alamofire

class TaskViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate {
    
    // ボタンを作成.
    @IBOutlet weak var headerMenuButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var taskSummaryField: UITextField!
    @IBOutlet weak var taskDetailField: UITextField!
    
    @IBOutlet weak var createBtn: UIButton!
    private var startDateField: UITextField!
    var endDatePicker: UIDatePicker = UIDatePicker()
    
    @IBAction func createBtnClicked(){
        
        print ("create button clicked!!!")
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let endDate = formatter.string(from: endDatePicker.date)
        let url = "http://52.196.55.156:1323/task/regist"
        
        let params =  [
            "user_id": 1,
            "title": taskSummaryField.text!,
            "sub_task": taskDetailField.text!,
            "dtend": endDate
            ] as [String : Any]
        Alamofire.request(url, parameters: params).responseJSON { response in
            print (response.result)
        }
        
        print ("create request done!")
        
        let storyboard: UIStoryboard = self.storyboard!
        let nextView = storyboard.instantiateViewController(withIdentifier: "index")
        self.present(nextView, animated: true, completion: nil)
    }
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
    @IBAction func donebuttonClicked(){
        print ("done button clicked!")
        
        // 遷移するViewを定義.
        let topController: UIViewController = ViewTabBarController()
        
        // アニメーションを設定.
        topController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        // Viewの移動.
        self.present(topController, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func applyEvent() {
        if taskSummaryField.text == nil {
            return
        }
        
        taskSummaryField.text = ""
        taskDetailField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // headerTitleのサイズを定義.
        let tWidth: CGFloat = 100
        let tHeight: CGFloat = 35
        
        // 配置する座標を定義(画面の中心).
        let tPosX: CGFloat = self.view.bounds.width/2 - tWidth/2
        let tPosY: CGFloat = (80/2) - tHeight/2
        // ラベル生成
        let headerTitle: UILabel = UILabel(frame: CGRect(x: tPosX, y: tPosY, width: tWidth, height: tHeight))
        headerTitle.text = "新規タスク作成"
        headerTitle.textColor = UIColor.white
        headerTitle.sizeToFit()
        headerTitle.textAlignment = .center
        self.view.addSubview(headerTitle)
        
        
        // datePickerのサイズを定義.
        let pWidth: CGFloat = 250
        let pHeight: CGFloat = 100
        
        // 配置する座標を定義(画面の中心).
        let pPosX: CGFloat = self.view.bounds.width/2 - pWidth/2
        let pPosY: CGFloat = 250 - pHeight/2
        
        // datePickerを設定（デフォルトでは位置は画面上部）する.
        endDatePicker.frame = CGRect(x:pPosX, y:pPosY, width:pWidth, height:pHeight)
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.datePickerMode = UIDatePickerMode.date
        endDatePicker.backgroundColor = UIColor.white
        endDatePicker.layer.cornerRadius = 5.0
        endDatePicker.layer.shadowOpacity = 0.5
        
        endDatePicker.addTarget(self, action: #selector(EventViewController.onDidChangeDate(sender:)), for: .valueChanged)
        self.view.addSubview(endDatePicker)
        
        // textFieldのサイズを定義.
        let fWidth: CGFloat = 260
        let fHeight: CGFloat = 35
        /*
         // 選択した日付を表示するTextFieldを作成
         startDateField = UITextField(frame: CGRect(x:pPosX, y:(pPosY+20), width:fWidth, height:fHeight))
         startDateField.text = "2016-11-19 18:00"
         startDateField.borderStyle = UITextBorderStyle.roundedRect
         startDateField.layer.position = CGPoint(x: self.view.bounds.width/2,y: (pPosY + 50));
         self.view.addSubview(startDateField)
         */
        
        taskSummaryField = UITextField()
        taskSummaryField = UITextField(frame: CGRect(x:0,y:40,width:fWidth,height:fHeight))
        taskSummaryField.text = "イベント名"
        taskSummaryField.borderStyle = UITextBorderStyle.roundedRect
        taskSummaryField.layer.position = CGPoint(x: self.view.bounds.width/2,y: tPosY + 120);
        self.view.addSubview(taskSummaryField)
        
        taskDetailField = UITextField(frame: CGRect(x:pPosX, y:(pPosY+pHeight+20), width:fWidth, height:fHeight))
        taskDetailField.text = ""
        taskDetailField.borderStyle = UITextBorderStyle.roundedRect
        taskDetailField.layer.position = CGPoint(x: self.view.bounds.width/2,y: (pPosY + pHeight + 50));
        self.view.addSubview(taskDetailField)
        
    }
    
    /*
     DatePickerが選ばれた際に呼ばれる.
     */
    internal func onDidChangeDate(sender: UIDatePicker){
        
        print (sender)
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        // 日付をフォーマットに則って取得.
        let selectedDate: NSString = formatter.string(from: sender.date) as NSString
        print (selectedDate)
    }
    
}
