//
//  TFSearchHistoryView.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFSearchHistoryViewDelegate)
protocol TFSearchHistoryViewDelegate:NSObjectProtocol {
    
    @objc optional func searchHistoryViewDidClicked(index: Int)
    @objc optional func searchHistoryViewDidClear(index: Int)
    @objc optional func searchHistoryViewHeight(height: Double)
    
}

class TFSearchHistoryView: UIView,TFSearchHistoryItemDelegate {

    
    var texts: [String] = []
    
    @objc var delegate : TFSearchHistoryViewDelegate?
    

    lazy var buttons: [TFSearchHistoryItem] = {
        return (NSMutableArray() as! [TFSearchHistoryItem])
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setChild()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setChild()
    }
    
    
    @objc func refreshView(items:[String]) {
        
        texts = items
        
        for view in buttons {
            view.removeFromSuperview()
        }
        buttons.removeAll()
        
        let H = 32.0
        let startY = 44.0
        let margin = 12.0
        
        var X = 15.0 , Y = startY
        var index = 0
        
        
        for i in 0..<items.count{
            
            let str = items[i]
            
            let view = TFSearchHistoryItem.searchHistoryItem()
            self.addSubview(view)
            buttons.append(view)
            view.textLabel.text = str
            view.tag = i
            view.clearBtn.tag = i
            view.delegate = self
            
            let wi = TFSearchHistoryItem.refreshItemWidth(text: str as NSString)
            
            if X + wi + margin <= Double(SCREEN_WIDTH - 30){// 同行
                
                view.frame = CGRect(x: X, y: Y, width: wi, height: H)
                X += wi + margin
                
            }else{// 不同行
                
                if index - 1 >= 0{
                    Y += H + margin
                }
                X = 15.0
                view.frame = CGRect(x: X, y: Y, width: wi, height: H)
                X += wi + margin
                index += 1
            }
            
            if index >= 5{
                break;
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let H = 32.0
        let startY = 44.0
        let margin = 12.0
        
        var X = 15.0 , Y = startY
        
        for index in 0..<buttons.count {
            
            let view = buttons[index]
            let str = texts[index]
            
            
            let wi = TFSearchHistoryItem.refreshItemWidth(text: str as NSString)
            
            if X + wi + margin <= Double(SCREEN_WIDTH - 30){// 同行
                
                view.frame = CGRect(x: X, y: Y, width: wi, height: H)
                X += wi + margin
                
            }else{// 不同行
                
                if index - 1 >= 0{
                    Y += H + margin
                }
                X = 15.0
                view.frame = CGRect(x: X, y: Y, width: wi, height: H)
                X += wi + margin
            }
            
        }
        
        if delegate != nil {
            delegate?.searchHistoryViewHeight!(height: Y + H + margin)
        }
    }
    
    fileprivate func setChild(){
        
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: SCREEN_WIDTH-30, height: 44))
        self.addSubview(label)
        
        label.textColor = LightBlackTextColor
        label.text = "搜索历史"
        label.font = UIFont.systemFont(ofSize: 16)
        
        self.backgroundColor = UIColor.white
    }
    
    // TFSearchHistoryItemDelegate
    @objc func searchHistoryDidClickedClearBtn(btn: UIButton) {
        
        if delegate != nil {
            delegate?.searchHistoryViewDidClear!(index: btn.tag)
        }
    }
    @objc func searchHistoryDidClicked(item: TFSearchHistoryItem) {
        
        if delegate != nil {
            delegate?.searchHistoryViewDidClicked!(index: item.tag)
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
