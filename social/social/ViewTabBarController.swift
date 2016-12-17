//
//  ViewTabBarController.swift
//  social
//
//  Created by 杉内茜 on 2016/12/16.
//  Copyright © 2016年 杉内茜. All rights reserved.
//

import UIKit

class ViewTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //タスク一覧画面を初期選択にする。
        self.selectedIndex = 0
    }
    
    
    //ボタン押下時の呼び出しメソッド
    func tabBar(tabBar: UITabBar, didSelect item: UITabBarItem) {
        //バッチを消す。
        item.badgeValue = "1"
    }

}
