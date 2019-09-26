//
//  TFHelper.swift
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/10/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit
import Foundation

class TFHelper: NSObject {
    
    /* 颜色值及大小创建图片 */
    func createImageWithColor(color: UIColor , size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    
    /* 颜色值创建图片 */
    func createImageWithColor(color: UIColor) -> UIImage {
        
        return self.createImageWithColor(color: color, size: CGSize(width: 1.0, height: 1.0))
    }
    
    /* 检查手机号码 */
    func checkTel(str: NSString) -> Bool {
        if str.length != 11 {
            return false
        }
        let regex = "^\\d{11}$"
        let pred: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isMath: Bool = pred.evaluate(with: str)

        return isMath;
    }
    /* 检查邮箱 */
    func checkEmail(str: NSString) -> Bool {
        if str.length == 0 {
            return false
        }
        let regex = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
        let pred: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isMath: Bool = pred.evaluate(with: str)
        
        return isMath;
    }
    /* 检查网址 */
    func checkUrl(str: NSString) -> Bool {
        if str.length == 0 {
            return false
        }
        let regex = "((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"
        let pred: NSPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isMath: Bool = pred.evaluate(with: str)
        
        return isMath;
    }
}
