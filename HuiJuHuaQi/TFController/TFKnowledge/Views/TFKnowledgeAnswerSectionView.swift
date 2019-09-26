//
//  TFKnowledgeAnswerSectionView.swift
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFKnowledgeAnswerSectionViewDelegate)
protocol TFKnowledgeAnswerSectionViewDelegate {
    @objc optional func knowledgeAnswerSectionViewDidSort(type: Int , arrow: UIImageView, view: TFKnowledgeAnswerSectionView)
}

class TFKnowledgeAnswerSectionView: UIView {

    @objc var textLabel: UILabel?
    @objc var answerSortLabel: UILabel?
    @objc var arrow: UIImageView?
    let text1 = "按回答时间排序"
    let text2 = "按更新时间排序"
    @objc var type = 0
    
    
    @objc weak var delegete: TFKnowledgeAnswerSectionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setChild()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setChild()
    }
    
    fileprivate func setChild() {
        
        backgroundColor = UIColor(red: 0xf2/255, green: 0xf2/255, blue: 0xf2/255, alpha: 1)
        
        let textLabel = UILabel(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH-30, height: 40))
        addSubview(textLabel)
        textLabel.textColor = ExtraLightBlackTextColor
        textLabel.font = UIFont.systemFont(ofSize: 12)
        self.textLabel = textLabel
        
        let arrow = UIImageView(frame: CGRect(x: SCREEN_WIDTH-20-20, y: 0, width: 20, height: 40))
        addSubview(arrow)
        arrow.image = UIImage(named: "下一级浅灰")
        arrow.transform = .init(rotationAngle: CGFloat(Double.pi/2.0))
        arrow.frame = CGRect(x: SCREEN_WIDTH-15-20, y: 0, width: 20, height: 40)
        arrow.isUserInteractionEnabled = true
        arrow.contentMode = .center
        self.arrow = arrow
        
        let answerSortLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 100, height: 40))
        addSubview(answerSortLabel)
        answerSortLabel.textColor = GrayTextColor
        answerSortLabel.font = UIFont.systemFont(ofSize: 12)
        self.answerSortLabel = answerSortLabel
        answerSortLabel.textAlignment = .right
        answerSortLabel.text = text1
        answerSortLabel.isUserInteractionEnabled = true
        answerSortLabel.right = arrow.left
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked))
        arrow.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer.init(target: self, action: #selector(tapClicked))
        answerSortLabel.addGestureRecognizer(tap1)
    }
    
    @objc func tapClicked() {
        if delegete != nil {
            delegete?.knowledgeAnswerSectionViewDidSort!(type: self.type, arrow: self.arrow! , view: self)
        }
    }
    
    @objc func refreshAnswerType(type: Int) {
        self.type = type
        if type == 0 {
            answerSortLabel?.text = text1
        }else{
            answerSortLabel?.text = text2
        }
    }
    
    @objc func refreshAnswerNum(num: Int) {
        
        textLabel?.text = num.description + "个回答"
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
