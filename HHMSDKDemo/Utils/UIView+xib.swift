//
//  UIView+xib.swift
//  HHMSDKDemo
//
//  Created by Shi Jian on 2018/6/19.
//  Copyright © 2018年 shmily. All rights reserved.
//
import UIKit

// MARK: - Interface Builder中显示UIView的属性
extension UIView
{
    // 圆角
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    // 边界宽度
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            self.layer.masksToBounds = true
            layer.borderWidth = newValue
        }
    }
    // 边界颜色
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
