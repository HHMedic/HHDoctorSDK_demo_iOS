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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 { return }
        var url = ""
        if indexPath.row == 0 {
            url = HHMSDK.default.getAllMedics(userToken: testToken)
        } else if indexPath.row == 1 {
            url = HHMSDK.default.getMedicDetail(userToken: testToken, medicId: testMedicId)
        }
        
        self.navigationController?.pushViewController(HHWebBrowser(url), animated: true)
    }

    @IBAction func doExit(_ sender: UIBarButtonItem) {
        HHMSDK.default.logout()
        self.dismiss(animated: true, completion: nil)
        
    }
}
