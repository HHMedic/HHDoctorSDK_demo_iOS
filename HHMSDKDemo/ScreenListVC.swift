//
//  ScreenListVC.swift
//  HHMSDKDemo
//
//  Created by Shi Jian on 2018/6/14.
//  Copyright © 2018年 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK

class ScreenListVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func doExit(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            HHMSDK.default.logout()
        }
        
    }
    
    @IBAction func clearBadge(_ sender: UIBarButtonItem) {
        let badge = HHMSDK.default.markRead()
        UIApplication.shared.applicationIconBadgeNumber -= badge
    }

}
