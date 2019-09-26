
//
//  TFKnowledgeSectionView.swift
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFKnowledgeSectionViewDelegate)
protocol TFKnowledgeSectionViewDelegate:NSObjectProtocol {
    @objc optional func knowledgeSectionViewClicked(index: Int)
}
class TFKnowledgeSectionView: UIView {

    @objc weak var delegate: TFKnowledgeSectionViewDelegate?
    
    var btns = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        
        let images = ["阅读人数","收藏人数","点赞人数","学习人数"]
        
        for i in 0..<4 {
            
            let btn = UIButton(type: .custom)
            self.addSubview(btn)
            btn.setImage(UIImage(named: images[i]), for: .normal)
            btn.setImage(UIImage(named: images[i]), for: .highlighted)
            btn.frame = CGRect(x: SCREEN_WIDTH/4 * CGFloat(i), y: 0, width: SCREEN_WIDTH/4, height: 40)
            btn.setTitle("0", for: .normal)
            btn.setTitle("0", for: .highlighted)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12);
            btn.setTitleColor(ExtraLightBlackTextColor, for: .normal)
            btn.setTitleColor(ExtraLightBlackTextColor, for: .highlighted)
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
            btns.append(btn)
        }
        
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1);
        let line = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0.5))
        self.addSubview(line)
        line.backgroundColor = UIColor(red: 0xf2/255, green: 0xf2/255, blue: 0xf2/255, alpha: 1)
        
    }
    
    @objc func btnClicked(btn: UIButton) {
        
        if delegate != nil {
            delegate?.knowledgeSectionViewClicked!(index: btn.tag)
        }
    }
    
    @objc func refreshNum(see: Int, star: Int, good: Int, learn: Int) {
        
        let btn1 = btns[0]
        btn1.setTitle(" " + see.description, for: .normal)
        btn1.setTitle(" " + see.description, for: .highlighted)
        
        let btn2 = btns[1]
        btn2.setTitle(" " + star.description, for: .normal)
        btn2.setTitle(" " + star.description, for: .highlighted)
        
        let btn3 = btns[2]
        btn3.setTitle(" " + good.description, for: .normal)
        btn3.setTitle(" " + good.description, for: .highlighted)
        
        let btn4 = btns[3]
        btn4.setTitle(" " + learn.description, for: .normal)
        btn4.setTitle(" " + learn.description, for: .highlighted)
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
