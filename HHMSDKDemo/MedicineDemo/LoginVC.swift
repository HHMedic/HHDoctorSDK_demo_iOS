//
//  LoginVC.swift
//  HHMedicineDemo
//
//  Created by Shi Jian on 5/21/19.
//  Copyright © 2019 shmily. All rights reserved.
//

import UIKit
import SVProgressHUD
import HHDoctorSDK

class LoginVC: UIViewController {

    @IBOutlet weak var mTextToken: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doChangeEnv(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        
        HHSDKOptions.default.isDevelopment = index == 0
    }
    
    @IBAction func doLogin(_ sender: UIButton) {
        guard let aToken = mTextToken.text, aToken.count > 0 else {
            SVProgressHUD.showError(withStatus: "请输入 userToken")
            return
        }
        
        testToken = aToken
        
        SVProgressHUD.show()
        
        // 登录
        HHMSDK.default.login(userToken: aToken) { [weak self] in
            if let aError = $0 {
                print("登录错误: " + aError.localizedDescription)
                SVProgressHUD.dismiss()
            } else {
                print("登录成功")
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                self?.jump2main()
            }
        }
    }

    func jump2main() {
        performSegue(withIdentifier: "mainScreen", sender: self)
    }
}
