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
    @IBOutlet weak var mTextInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func doLogin(_ sender: UIButton) {
        // 仅用于呼叫其他账户
        tempToken = mTextInfo.text
        
        // 登录
        HHMSDK.default.login(userToken: mTextInfo.text) { [weak self] in
            if let aError = $0 {
                print("登录错误: " + aError.localizedDescription)
            } else {
                print("登录成功")
                self?.jump2main()
                
                HHMSDK.default.skipChatHome()
            }
        }
    }
    
    @IBAction func doSwitchSeg(_ sender: UISegmentedControl) {
        let isTest = sender.selectedSegmentIndex == 0
        let option = HHSDKOptions(sdkProductId: "3000" ,isDebug: true, isDevelop: isTest)
        option.cerName = "2cDevTest"
        HHMSDK.default.start(option: option)
    }
    
    @IBAction func doLogout(_ sender: UIBarButtonItem) {
        HHMSDK.default.logout()
    }
    
    func jump2main() {
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
    
}
