//
//  TaskListViewController.swift
//  social
//
//  Created by 杉内茜 on 2016/12/16.
//  Copyright © 2016年 杉内茜. All rights reserved.
//


import UIKit
import Alamofire

class TaskListViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewTabBar: UITabBar!
    var comps = DateComponents()
    
    //今日の日付を取得
    var calendar = Calendar(identifier: .gregorian)
    var selectMonthDate  = Calendar(identifier: .gregorian).dateComponents([.year, .month, .day, .weekday], from: Date())
    //var currentMonthOfDates = [NSDate]()
    var editRow=0
    
    var weekList = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    var monthList = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var taskList: [(key: Int, value: [AnyObject])] = []
    
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
        let posY: CGFloat = (80/2) - tHeight/2
        
        //表示月のラベル生成
        let headerTitle: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        headerTitle.text = "\(monthList[selectMonthDate.month!-1]) \(selectMonthDate.year!)"
        headerTitle.textColor = UIColor.white
        headerTitle.sizeToFit()
        headerTitle.textAlignment = .center
        self.view.addSubview(headerTitle)
        
        taskList = get_tasks(year: selectMonthDate.year!, month: selectMonthDate.month!)
        print("-------Task#index-------")
        print(taskList)
    }
    
    
    //weeklyカレンダー部分のセルの数を設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return weekList.count
    }
    
    //一覧テーブルのセクション数を設定
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskList.count
    }
    
    //一覧テーブルの各セクションのタイトルを指定
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let calendar = Calendar(identifier: .gregorian)
        let titleDate = calendar.date(from: DateComponents(year: selectMonthDate.year!, month: selectMonthDate.month!, day: taskList[section].key))
        let sectionTitle  = calendar.dateComponents([.year, .month, .day, .weekday], from: titleDate!)
        
        return "\(weekList[sectionTitle.weekday!-1]) \(sectionTitle.month!).\(sectionTitle.day!).\(sectionTitle.year!)"
    }
    
    //一覧テーブルの各セクション内のセル数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList[section].value.count
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let taskTitlelabel = tableView.viewWithTag(1) as! UILabel
        let taskDetaillabel = tableView.viewWithTag(2) as! UILabel
        
        let taskData = taskList[indexPath.section].value[indexPath.row]
        print(taskData[title] as! String?)
        taskTitlelabel.text = taskData["title"] as! String?
        taskDetaillabel.text = taskData["sub_task"] as! String?
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "taskDetailSegue" {
            print ("taskDetailSegue !!")
            
            let taskDetailViewController:TaskDetailViewController = segue.destination as! TaskDetailViewController
            
            //選択したセルの情報を取得
            let index = scheduleTableView.indexPathForSelectedRow?.item
            let section = scheduleTableView.indexPathForSelectedRow?.section
            
            // 選択したイベント情報を遷移先のviewに渡す
            taskDetailViewController.task = taskList[section!].value[index!] as! [String : Any]
            
        }
    }
    
}
