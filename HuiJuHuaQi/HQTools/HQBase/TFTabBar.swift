//
//  TFTabBar.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit


@objc(TFTabBarDelegate)
protocol TFTabBarDelegate:NSObjectProtocol {
    
    @objc optional func tabBarDidClickedPlusButton(tabBar: TFTabBar , button: UIButton)
}


class TFTabBar: UITabBar {
    
    @objc weak var delegateTwo : TFTabBarDelegate?

    @objc lazy var plusBtn: UIButton = {
        
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "应用"), for: .normal)
        button.setBackgroundImage(UIImage(named: "应用选中"), for: .selected)
//        button.frame = CGRect(x: 0, y: 0, width: button.currentBackgroundImage?.size.width ?? 49, height: button.currentBackgroundImage?.size.height ?? 49)
        button.frame = CGRect(x: 0, y: 0, width: 49 + 5, height: 49 + 5)
//        button.layer.cornerRadius = (49 + 7) / 2.0;
//        button.layer.masksToBounds = true;
//        button.layer.borderColor = GrayTextColor.cgColor;
//        button.layer.borderWidth = 0.5;
        button.addTarget(self, action: #selector(plusClick), for: .touchUpInside)
        button.tag = 0x123
        button.contentMode = .scaleToFill
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        plusBtn.center = CGPoint(x: centerX, y: (height - CGFloat(BottomM)) * 0.5)
        let tabbarButtonW = SCREEN_WIDTH/5;
        var tabbarButtonIndex : CGFloat = 0.0;
        for child in subviews {
            
            if child.isKind(of: NSClassFromString("UITabBarButton")!){
                child.width = tabbarButtonW
                child.x = tabbarButtonIndex * tabbarButtonW
                
                tabbarButtonIndex += 1
//                if tabbarButtonIndex == 2{
//                    tabbarButtonIndex += 1
//                }
            }
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(plusBtn)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    @objc fileprivate func plusClick() {
        
        if delegateTwo != nil {
            delegateTwo?.tabBarDidClickedPlusButton!(tabBar: self, button: plusBtn)
        }
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
