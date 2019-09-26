//
//  TFSearchHistoryItem.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc(TFSearchHistoryItemDelegate)
protocol TFSearchHistoryItemDelegate: NSObjectProtocol{
    @objc optional func searchHistoryDidClickedClearBtn(btn: UIButton)
    @objc optional func searchHistoryDidClicked(item: TFSearchHistoryItem)
}


class TFSearchHistoryItem: UIView {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var clearBtn: UIButton!
    weak var delegate:TFSearchHistoryItemDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    class func searchHistoryItem() -> TFSearchHistoryItem {
        
        return Bundle.main.loadNibNamed("TFSearchHistoryItem", owner: self, options: nil)?.last as! TFSearchHistoryItem
    }
        
    fileprivate func commonInit() -> Void {
        
        backgroundColor = UIColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1)
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
        
        textLabel.font = UIFont.systemFont(ofSize: 15)
        textLabel.textAlignment = .left
        textLabel.textColor = UIColor(red: 0x33/255.0, green: 0x33/255.0, blue: 0x33/255.0, alpha: 1)
        
        clearBtn.setImage(UIImage(named: "关闭"), for: .normal)
        clearBtn.setImage(UIImage(named: "关闭"), for: .highlighted)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemClicked))
        self .addGestureRecognizer(tap)
    }
    
    @IBAction func clearBtnClicked(_ sender: UIButton) {
        
        if delegate != nil {
            delegate?.searchHistoryDidClickedClearBtn!(btn: clearBtn)
        }
    }
    
    @objc func itemClicked(){
        
        if delegate != nil {
            delegate?.searchHistoryDidClicked!(item: self)
        }
    }
    
    
    func refreshItem(text: NSString){
        
        textLabel.text = text as String
    }
    
    
    class func refreshItemWidth(text: NSString) -> Double{
        var width = 60.0
        
        let rect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: NSDictionary(objects: [UIFont.systemFont(ofSize: 15)], forKeys: [NSAttributedString.Key.font as NSCopying]) as? [NSAttributedString.Key : Any], context: nil)
        
        width += Double(rect.size.width)
        
        return width > Double(SCREEN_WIDTH-30.0) ? Double(SCREEN_WIDTH-30.0) : width
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
