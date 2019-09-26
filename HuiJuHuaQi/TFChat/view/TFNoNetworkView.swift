//
//  TFNoNetworkView.swift
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/10/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFNoNetworkViewDelegate)
protocol TFNoNetworkViewDelegate:NSObjectProtocol {
    @objc optional func noNetworkViewClicked()
}

class TFNoNetworkView: UIView {

    @objc weak var delegate : TFNoNetworkViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() -> Void {
        
        self.backgroundColor = UIColor(red: 1, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1)
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 25, y: 0, width: 30, height: 30))
        imageView.center.y = self.frame.size.height/2
        imageView.center.x = 40
        self.addSubview(imageView)
        imageView.image = UIImage(named: "wechat_resendbut5")
        
        let textLabel: UILabel = UILabel(frame: CGRect(x: 70, y: 0, width: self.bounds.size.width - 15 - 70, height: 44))
        self.addSubview(textLabel)
        textLabel.textColor = UIColor(red: 117.0/255.0, green: 93.0/255.0, blue: 93.0/255.0, alpha: 1)
        textLabel.text = "当前网络不可用，请检查你的网络设置"
        textLabel.font = UIFont.systemFont(ofSize: 14)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(selfClicked))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func selfClicked() -> Void {
        
        if delegate != nil {
            
            delegate?.noNetworkViewClicked!()
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
