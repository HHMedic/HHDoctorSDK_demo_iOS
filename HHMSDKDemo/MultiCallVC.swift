//
//  MultiCallVC.swift
//  HHMSDKDemo
//
//  Created by 程言方 on 2020/7/21.
//  Copyright © 2020 shmily. All rights reserved.
//

import HHDoctorSDK

class MultiCallVC: UIViewController {

    
    @IBOutlet weak var mUserTokenInput : UITextField!
    
    
    @IBAction func multiCall(_ sender: UIButton){
        var userToken = "D3127C3DDB12A11174D24F083E642CC73F0D04F68EA2608F6783B874E4F50EEF"

        if let aText = mUserTokenInput.text, aText.count > 0 {
            userToken = aText
        }
        
        
        let callee = HHCallerInfo()
        callee.name = "测试用户"
        callee.photourl = "https://image.hh-medic.com/icon/head_logo1.png"
        callee.userToken = userToken
        

        HHMSDK.default.startTeamCall(.adult, callee: callee)
    }
    
    
}
