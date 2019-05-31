//
//  ScreenListVC.swift
//  HHMedicineDemo
//
//  Created by Shi Jian on 5/21/19.
//  Copyright © 2019 shmily. All rights reserved.
//

import UIKit
import HHDoctorSDK
import HHMedicine
import SVProgressHUD

class ScreenListVC: UITableViewController {
    
    @IBOutlet var mTableView: UITableView!
    @IBOutlet weak var mTxtOrderId: UITextField!
    @IBOutlet weak var mSDKOrderId: UITextField!
    @IBOutlet weak var mMedicOrderId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 呼叫
        if indexPath.section == 0 { return }
        
        var url = ""
        // 病历相关
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                url = HHMSDK.default.getMedicList(userToken: testToken)
            } else if indexPath.row == 1 {
                guard let aMedicId = mMedicOrderId.text, aMedicId.count > 0 else {
                    SVProgressHUD.showError(withStatus: "请输入病历Id")
                    return
                }
                url = HHMSDK.default.getMedicDetail(userToken: testToken, medicId: aMedicId)
            }
            
            let aVC = HHWebBrowser()
            aVC.urlString = url
            
            self.navigationController?.pushViewController(aVC, animated: true)
            return
        }
        
        /// 带药SDK
        jump2index(indexPath.row)
    }
    
    func jump2index(_ index: Int) {
        switch index {
        case 0: // 订单列表
            let aVC = HHMedicine.default.orderList(testToken)
            self.navigationController?.pushViewController(aVC, animated: true)
            
        case 1: // 订单详情
            HHMedicine.default.removeDelegate()
            orderDetail(mTxtOrderId.text)
            
        case 2:
            HHMedicine.default.addDelegate(self)

            orderDetail(mSDKOrderId.text)
            
        case 3: // 和豆明细
            let aVC = HHMedicine.default.payDetail(testToken)
            self.navigationController?.pushViewController(aVC, animated: true)
            
        case 4: // 地址列表
            let aVC = HHMedicine.default.addressList()
            self.navigationController?.pushViewController(aVC, animated: true)
            
        default:
            break
        }
    }
    
    @IBAction func doExit(_ sender: UIBarButtonItem) {
        HHMSDK.default.logout()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func orderDetail(_ text: String?) {
        guard let aOrderId = text, aOrderId.count > 0 else {
            SVProgressHUD.showError(withStatus: "请输入订单Id")
            return
        }
        let aVC = HHMedicine.default.orderDetail(testToken, orderId: aOrderId) {
            print($1)
            $0.navigationController?.popViewController(animated: true)
        }
        self.navigationController?.pushViewController(aVC, animated: true)
    }
    
}

extension ScreenListVC: HHPayMedicable {
    func payInterceptor(_ url: String, scheme: String, callback: @escaping (([AnyHashable : Any]?) -> Void)) -> Bool {
        return AlipaySDK.defaultService()?.payInterceptor(withUrl: url, fromScheme: scheme, callback: callback) ?? false
    }
}
