//
//  LoginVC.swift
//  HHMSDKDemo
//
//  Created by Shi Jian on 2018/6/14.
//  Copyright © 2018年 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doLogin(_ sender: UIButton) {
        // 登录
        HHMSDK.default.login(uuid: testUUId) { [weak self] in
            if let aError = $0 {
                print("登录错误: " + aError.localizedDescription)
            } else {
                self?.jump2main()
            }
        }
    }
    
    
    
    func jump2main() {
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
    
}
