//
//  NormalCallVC.swift
//  HHMSDKDemo
//
//  Created by Shi Jian on 2018/6/13.
//  Copyright © 2018年 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK

/// 基础呼叫
class NormalCallVC: UIViewController {

    @IBOutlet weak var mInfoLbl: UILabel!
    @IBOutlet weak var mTokenLbl: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 儿童
    @IBAction func callForChild(_ sender: UIButton) {
//        HHMSDK.default.startCall(.child)
        
        HHMSDK.default.login(userToken: tempToken) {
            if $0 == nil {
                HHMSDK.default.startCall(.child)
            }
        }
    }
    
    // 成人
    @IBAction func callForAdult(_ sender: UIButton) {
//        HHMSDK.default.startCall(.adult)
        
        HHMSDK.default.login(userToken: tempToken) {
            if $0 == nil {
                HHMSDK.default.startCall(.adult)
            }
        }
    }
    
    // 呼叫其他人
    @IBAction func doCallForOther(_ sender: UIButton) {
        if let aToken = mTokenLbl.text, aToken.count > 0 {
            HHMSDK.default.startCallBy(aToken, type: .child, delegate: self)
        } else {
            mInfoLbl.text = "请输入子账户 token"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension NormalCallVC: HHCallDelegate {
    
    func onCallStatus(_ error: Error?) {
        print("--------------------")
        if let aError = error {
            mInfoLbl.text = "呼叫失败: \(aError)"
        } else {
            mInfoLbl.text = "呼叫成功"
        }
    }
    
    func callFinished() {
        HHMSDK.default.logout() {
            if let error = $0 {
                print("退出失败: \(error)")
            } else {
                print("退出成功")
            }
        }
    }
}


var tempToken = ""
