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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 儿童
    @IBAction func callForChild(_ sender: UIButton) {
        HHMSDK.default.startCall(.child)
    }
    
    // 成人
    @IBAction func callForAdult(_ sender: UIButton) {
        HHMSDK.default.startCall(.adult)
    }
}
