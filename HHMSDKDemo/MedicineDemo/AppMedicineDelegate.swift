//
//  AppDelegate.swift
//  HHMedicineDemo
//
//  Created by Shi Jian on 5/21/19.
//  Copyright © 2019 shmily. All rights reserved.
//

import UIKit
import HHMedicine
import HHDoctorSDK

public var testToken = "28EDBCB5CCA747460573FAC3BF6B637D3F0D04F68EA2608F6783B874E4F50EEF"
public var testMedicId = "1541041785333"

/// HHMedicineDemo 使用的AppDelegate
@UIApplicationMain
class AppMedicineDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        registerNotification()
        
        /// 初始化
        let option = HHSDKOptions(sdkProductId: "9001" ,isDebug: true, isDevelop: true)
        option.cerName = "2cDevTest"
//        HHMSDK.default.start(option: option)
        
        /// 带药SDK初始化
        HHMSDK.default.start(option: option)

    }
    
    func registerNotification() {
        let types: UIUserNotificationType = [.sound , .alert, .badge]
        let settings = UIUserNotificationSettings(types: types, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        HHMSDK.default.updateAPNS(token: deviceToken)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if handleAliUrl(url) { return true }
        return HHMedicine.default.handleOpen(url)
    }
    
    func handleAliUrl(_ url: URL) -> Bool {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: nil)
            return true
        }
        return false
    }
}
