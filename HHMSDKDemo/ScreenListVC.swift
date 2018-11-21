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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let aVc = segue.destination as? WebBrowser {
            let isList = segue.identifier == "mediclist"
            
            aVc.urlString = isList ? HHMSDK.default.getMedicList(userToken: testToken) : HHMSDK.default.getMedicDetail(userToken: testToken, medicId: testMedicId)
            print(aVc.urlString ?? "")
        }
    }
    

}
