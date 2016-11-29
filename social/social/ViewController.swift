//
//  ViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/10/11.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var calendar = Calendar.current
    var comps = DateComponents()
    //今日の日付を取得
    var currentMonthOfDates = [NSDate]()
    var today = NSDate()
    var editRow=0
    
    var weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var eventList: [(key: Int, value: [AnyObject])] = []
    
    // Sectionで使用する配列を定義する.
    @IBOutlet weak var headerMenuButton: UIButton!
    @IBOutlet weak var AddEventButton: UIButton!
    @IBOutlet weak var calenderHeaderView: UIView!
    @IBOutlet weak var calenderCollectionView: UICollectionView!
    @IBOutlet weak var scheduleTableView: UITableView!
    
    @IBAction func tapHeaderMenuBtn(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // ボタンのサイズを定義.
        let tWidth: CGFloat = 100
        let tHeight: CGFloat = 35
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - tWidth/2
        let posY: CGFloat = (60/2) - tHeight/2
        
        //表示月のラベル生成
        let headerTitle: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        headerTitle.text = "November 2016"
        headerTitle.textColor = UIColor.white
        headerTitle.sizeToFit()
        headerTitle.textAlignment = .center
        self.view.addSubview(headerTitle)
        
        eventList = get_event()
    }
    
    
    //weeklyカレンダー部分のセルの数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return weekList.count
    }
    
    //一覧テーブルのセクション数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventList.count
    }
    
    //一覧テーブルの各セクションのタイトルを指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let calendar = Calendar(identifier: .gregorian)
        let titleDate = calendar.date(from: DateComponents(year: 2016, month: 11, day: eventList[section].key))
        let sectionTitle  = calendar.dateComponents([.year, .month, .day, .weekday], from: titleDate!)
        
        return "\(weekList[sectionTitle.weekday!-1]) \(sectionTitle.month!).\(sectionTitle.day!).\(sectionTitle.year!)"
    }
    
    //一覧テーブルの各セクション内のセル数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList[section].value.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //weeklyカレンダーのデータを返すメソッド
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        //週の初めの日にちを取得
        let weekday = calendar.component(.weekday, from: Date())
        comps.day = -weekday+1
        let startofWeek = calendar.date(byAdding: comps, to: Date())!

        comps.day = indexPath.row
        let showDate = calendar.date(byAdding: comps, to: startofWeek)!
        let showDay  = calendar.component(.day, from: showDate)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath as IndexPath) as! CalenderCollectionViewCell
        cell.DayLabel.text = weekList[indexPath.row]
        cell.DateLabel.text = String(describing: showDay)
        return cell
    }
    
    //セルに格納するデータを返すメソッド（スクロールなどでページを更新する必要が出るたびに呼び出される）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        
        let eventStartTimelabel = tableView.viewWithTag(1) as! UILabel
        let eventEndTimelabel = tableView.viewWithTag(2) as! UILabel
        let eventTitlelabel = tableView.viewWithTag(3) as! UILabel
        
        let eventData = eventList[indexPath.section].value[indexPath.row]

        // 文字列→日付に変換し、時分を取り出し
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let startDateString = formatter.date(from: eventData["dtstart"] as! String)
        let eventStartDate = calendar.dateComponents([.hour, .minute], from: startDateString!)
        let endDateString = formatter.date(from: eventData["dtend"] as! String)
        let eventEndDate = calendar.dateComponents([.hour, .minute], from: endDateString!)
        
        eventStartTimelabel.text = "\(eventStartDate.hour!):\(eventStartDate.minute!)"
        eventEndTimelabel.text = "\(eventEndDate.hour!):\(eventEndDate.minute!)"
        eventTitlelabel.text = eventData["summary"] as! String?
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "eventDetailSegue" {
            print ("eventDetailSegue !!")
            
            let eventDetailViewController:eventDetailViewController = segue.destination as! eventDetailViewController
            
            //選択したセルの情報を取得
            let index = scheduleTableView.indexPathForSelectedRow?.item
            let section = scheduleTableView.indexPathForSelectedRow?.section
            
            // 選択したイベント情報を遷移先のviewに渡す
            eventDetailViewController.event = eventList[section!].value[index!] as! [String : Any]

        }
    }
    
}
