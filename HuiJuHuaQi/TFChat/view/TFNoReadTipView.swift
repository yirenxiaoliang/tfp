//
//  TFNoReadTipView.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFNoReadTipViewDelegate)
protocol TFNoReadTipViewDelegate:NSObjectProtocol {
    @objc optional func noReadTipViewClicked()
}

class TFNoReadTipView: UIView {
    
    let TipWord: String = "条新消息"

    @objc weak var delegate : TFNoReadTipViewDelegate?
    
    @objc var textLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    @objc func setNumber(num: NSInteger) -> Void {
        
        self.textLabel?.text = String(num) + TipWord
    }
    
    @objc func noReadTipHide() -> Void {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
            self.alpha = 1
        }
    }
    
    
    fileprivate func commonInit() -> Void {
        
        self.backgroundColor = UIColor.white
        self.frame.size = CGSize(width: 138, height: 36)
        self.layer.cornerRadius = 18
        self.layer.shadowColor = UIColor(red: 0xb3/255.0, green: 0xb8/255.0, blue: 0xc1/255.0, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 0.4
        
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 18, height: 18))
        imageView.center.y = self.frame.size.height/2
        self.addSubview(imageView)
        imageView.image = UIImage(named: "上翻查看消息")
        
        let textLabel: UILabel = UILabel(frame: CGRect(x: 32, y: 0, width: self.bounds.size.width - 18 - 15, height: self.bounds.size.height))
        self.addSubview(textLabel)
        textLabel.textColor = UIColor(red: 0x18/255.0, green: 0x90/255.0, blue: 0xff/255.0, alpha: 1)
        textLabel.text = TipWord
        textLabel.font = UIFont.systemFont(ofSize: 14)
        self.textLabel = textLabel
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(selfClicked))
        self.addGestureRecognizer(tap)
        
    }
    
    @objc func selfClicked() -> Void {
        
        if delegate != nil {
            
            delegate?.noReadTipViewClicked!()
            self.noReadTipHide()
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
