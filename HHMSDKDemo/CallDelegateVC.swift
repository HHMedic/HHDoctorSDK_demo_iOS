//
//  CallDelegateVC.swift
//  HHMSDKDemo
//
//  Created by Shi Jian on 2018/6/14.
//  Copyright © 2018年 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK

/// 呼叫 + 代理
class CallDelegateVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        HHMSDK.default.add(delegate: self)
    }
    
    // 儿童
    @IBAction func callForChild(_ sender: UIButton) {
        HHMSDK.default.startCall(.child)
    }
    
    // 成人
    @IBAction func callForAdult(_ sender: UIButton) {
        HHMSDK.default.startCall(.adult)
    }
    
    deinit {
        HHMSDK.default.remove(delegate: self)
    }

}


extension CallDelegateVC: HHMVideoDelegate {
    func receivedOrder(_ orderId: String) {
        print("receivedOrder")
        print(orderId)
    }
    
    func onExtensionDoctor() {
        print("转呼医生")
    }
    
    func callDidEstablish() {
        print("通话已接通")
    }
    
    func callDidFinish() {
        print("通话结束")
    }
    
    func callStateChange(_ state: HHMCallingState) {
        print("视频状态变化:\(state.rawValue)")
    }
    
    func onFail(error: Error) {
        print("通话错误" + error.localizedDescription)
    }
    
    func onCancel() {
        print("用户主动取消")
    }
    
    func onResponse(_ accept: Bool) {
        let status = accept ? "接受" : "拒接"
        print("对方'" + status + "'视频")
    }
    
    func onReceive(_ callID: String) {
        print("收到医生呼叫")
    }
    
    func onLeakPermission(_ type: PermissionType) {
        print("缺少必要权限:\(type.description)")
    }
}
