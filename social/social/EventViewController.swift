//
//  EventViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/11/08.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit
import Alamofire

class EventViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate {

    // ボタンを作成.
    @IBOutlet weak var headerMenuButton: UIButton!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var doneButton: UIButton!

    @IBOutlet weak var eventSummaryField: UITextField!

    @IBOutlet weak var eventDetailField: UITextField!
    
    @IBOutlet weak var createBtn: UIButton!
    //@IBOutlet weak var startDatePicker: UIDatePicker!
    private var startDateField: UITextField!
    //@IBOutlet weak var endDatePicker: UIDatePicker!
    private var endDateField: UITextField!
    
    var startDatePicker: UIDatePicker = UIDatePicker()
    var endDatePicker: UIDatePicker = UIDatePicker()
    
    internal func onClickButton(sender: UIButton){
 
    }
    
    @IBAction func tapHeaderMenuBtn(sender: UIButton) {
    }
    
    @IBAction func createBtnClicked(){

        print ("create button clicked!!!")
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let startDate = formatter.string(from: startDatePicker.date)
        let endDate = formatter.string(from: endDatePicker.date)
        let url = "http://52.196.55.156:1323/calender/regist"
        
        let params =  [
            "user_id": 1,
            "summary": eventSummaryField.text!,
            "dtstart": startDate,
            "dtend": endDate,
            "description": eventDetailField.text!
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
        let topController: UIViewController = ViewController()
        
        // アニメーションを設定.
        topController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        // Viewの移動.
        self.present(topController, animated: true, completion: nil)
    }
    
    /*
    @IBAction func getSummartText(sender : UITextField) {
        eventSummaryField.text = sender.text
    }
    */
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func applyEvent() {
        if eventSummaryField.text == nil {
            return
        }
        
        eventSummaryField.text = ""
        eventDetailField.text = ""
    }
    
    override func viewDidLoad() {
        print ("********EventViewContoroller**********")
        super.viewDidLoad()
        
        // headerTitleのサイズを定義.
        let tWidth: CGFloat = 100
        let tHeight: CGFloat = 35
        
        // 配置する座標を定義(画面の中心).
        let tPosX: CGFloat = self.view.bounds.width/2 - tWidth/2
        let tPosY: CGFloat = (80/2) - tHeight/2
        // ラベル生成
        let headerTitle: UILabel = UILabel(frame: CGRect(x: tPosX, y: tPosY, width: tWidth, height: tHeight))
        headerTitle.text = "新規イベント作成"
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
        startDatePicker.frame = CGRect(x:pPosX, y:pPosY, width:pWidth, height:pHeight)
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.backgroundColor = UIColor.white
        startDatePicker.layer.cornerRadius = 5.0
        startDatePicker.layer.shadowOpacity = 0.5
        
        startDatePicker.addTarget(self, action: #selector(EventViewController.onDidChangeDate(sender:)), for: .valueChanged)
        self.view.addSubview(startDatePicker)
        
        endDatePicker.frame = CGRect(x:pPosX, y:(pPosY+150), width:pWidth, height:pHeight)
        endDatePicker.timeZone = NSTimeZone.local
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
        
        endDateField = UITextField(frame: CGRect(x:pPosX, y:(pPosY+pHeight+20), width:fWidth, height:fHeight))
        endDateField.text = "2016-11-20 18:00"
        endDateField.borderStyle = UITextBorderStyle.roundedRect
        endDateField.layer.position = CGPoint(x: self.view.bounds.width/2,y: (pPosY + pHeight + 50));
        self.view.addSubview(endDateField)
        */
        
        eventSummaryField = UITextField()
        eventSummaryField = UITextField(frame: CGRect(x:0,y:40,width:fWidth,height:fHeight))
        eventSummaryField.text = "イベント名"
        //eventSummaryField.delegate = self
        eventSummaryField.borderStyle = UITextBorderStyle.roundedRect
        eventSummaryField.layer.position = CGPoint(x: self.view.bounds.width/2,y: tPosY + 120);
        self.view.addSubview(eventSummaryField)
        
        eventDetailField = UITextField(frame: CGRect(x:0,y:300,width:fWidth,height:fHeight))
        eventDetailField.text = "ex.) 持ち物：ポートフォリオ"
        eventDetailField.borderStyle = UITextBorderStyle.roundedRect
        eventDetailField.layer.position = CGPoint(x: self.view.bounds.width/2,y: (pPosY + pHeight + 200));
        self.view.addSubview(eventDetailField)
        
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
        //endDateField.text = selectedDate as String
    }

}
