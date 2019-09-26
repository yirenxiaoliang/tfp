//
//  TFConst.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import Foundation
import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let iPhoneX = (SCREEN_HEIGHT > 736.0 ? true : false)
let TabBarHeight = 49.0
let NavigationBarHeight = 64.0
let BottomM = (iPhoneX ? 34.0 : 0.0)
let TopM = (iPhoneX ? 24.0 : 0.0)
let NaviHeight = (NavigationBarHeight + TopM)
let BottomHeight = (TabBarHeight + BottomM)

let BlackTextColor = UIColor(red: 0x11/255.0, green: 0x11/255.0, blue: 0x11/255.0, alpha: 1)
let LightBlackTextColor = UIColor(red: 0x33/255.0, green: 0x33/255.0, blue: 0x33/255.0, alpha: 1)
let ExtraLightBlackTextColor = UIColor(red: 0x66/255.0, green: 0x66/255.0, blue: 0x66/255.0, alpha: 1)
let GrayTextColor = UIColor(red: 0x99/255.0, green: 0x99/255.0, blue: 0x99/255.0, alpha: 1)
let LightGrayTextColor = UIColor(red: 0xcc/255.0, green: 0xcc/255.0, blue: 0xcc/255.0, alpha: 1)



