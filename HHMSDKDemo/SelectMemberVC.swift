//
//  SelectMemberVC.swift
//  HHMSDKDemo
//
//  Created by 程言方 on 2020/9/2.
//  Copyright © 2020 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK

//选人呼叫入口
class SelectMemberVC: UIViewController {
    
    @IBOutlet weak var mMuiltiSwitch : UISwitch!
    
    @IBOutlet weak var mAddMemberSwitch : UISwitch!
    
    
    override func viewDidLoad() {
        
        mMuiltiSwitch.isOn = HHSDKOptions.default.allowMulti
        
        mAddMemberSwitch.isOn = HHSDKOptions.default.allowAddMember
        
    }
    
    @IBAction func onChangeMulti(_ sender : UISwitch){
        
        HHSDKOptions.default.allowMulti = sender.isOn
        
        
    }
    
    @IBAction func onAddMember(_ sender : UISwitch){
        
        HHSDKOptions.default.allowAddMember = sender.isOn
    }

    @IBAction func doSelectMemberForCall(){
        
        HHMSDK.default.startMemberCall()
    }
    
}
