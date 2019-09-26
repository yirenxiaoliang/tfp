//
//  TFDepartmentItem.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc protocol TFDepartmentItemDelegate {
    @objc optional func deleteBtnClicked(index: NSInteger)
}

class TFDepartmentItem: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var deleteW: NSLayoutConstraint!
    @IBOutlet weak var nameTrailW: NSLayoutConstraint!
    
    weak var delegate:TFDepartmentItemDelegate?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1)
        nameLabel.backgroundColor = UIColor.clear
        deleteBtn.backgroundColor = UIColor.clear
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = BlackTextColor
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .justified
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
    
    func handleEdit(edit: Bool) {
        deleteBtn.isHidden = !edit
        if edit {
            deleteW.constant = 28.0
            nameTrailW.constant = 0.0
        }else{
            deleteW.constant = 0.0
            nameTrailW.constant = 0.0
        }
    }
    
    class func departmentItem() -> TFDepartmentItem{
        return Bundle.main.loadNibNamed("TFDepartmentItem", owner: self, options: nil)!.last as! TFDepartmentItem
    }
    
    @IBAction func deleteClicked(_ sender: UIButton) {
        
        if delegate != nil{
            delegate!.deleteBtnClicked?(index: sender.tag)
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
