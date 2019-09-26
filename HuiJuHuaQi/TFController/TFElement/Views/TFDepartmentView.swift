//
//  TFDepartmentView.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

@objc
protocol TFDepartmentViewDelegate {
    @objc optional func departmentViewHeight(height: CGFloat)
}

class TFDepartmentView: UIView,TFDepartmentItemDelegate {

    @objc var itemViews: NSMutableArray = []
    @objc var departments: NSMutableArray?
    @objc var edit = true
    @objc var delegate: TFDepartmentViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func refreshDepartment(departments: NSMutableArray, edit: Bool) {
        self.departments = departments
        self.edit = edit
        for item in itemViews{
            let view = item as! TFDepartmentItem
            view.removeFromSuperview()
        }
        itemViews.removeAllObjects()
        var index: NSInteger = 0
        for item in departments {
            let model = item as! TFDepartmentModel
            let itemView = TFDepartmentItem.departmentItem()
            itemView.delegate = self
            itemView.deleteBtn.tag = index
            itemView.handleEdit(edit: edit)
            itemView.nameLabel.text = model.name
            self.addSubview(itemView)
            itemViews.add(itemView)
            
            let size = HQHelper.size(with: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: CGFloat(MAXFLOAT), height:  CGFloat(MAXFLOAT)), titleStr: model.name)
            let margin:CGFloat = 5.0
            let deleteW:CGFloat = 28.0
            
            if edit {
                if size.width > self.width - 2*margin - deleteW{// 一行放不下
                    let size1 = HQHelper.size(with: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: CGFloat(self.width - 2*margin - deleteW), height:  CGFloat(MAXFLOAT)), titleStr: model.name)
                    model.width = NSNumber.init(value: Double(self.width))
                    model.height = NSNumber.init(value: Double(size1.height + 2*margin))
                }else{
                    model.width = NSNumber.init(value: Double(size.width + 2*margin + deleteW))
                    model.height = NSNumber.init(value: Double(deleteW))
                }
                
            } else {
                if size.width > self.width - 2*margin{// 一行放不下
                    let size1 = HQHelper.size(with: UIFont.systemFont(ofSize: 14), maxSize: CGSize(width: CGFloat(self.width - 2*margin), height:  CGFloat(MAXFLOAT)), titleStr: model.name)
                    model.width = NSNumber.init(value: Double(self.width))
                    model.height = NSNumber.init(value: Double(size1.height + 2*margin))
                    
                } else {
                    model.width = NSNumber.init(value: Double(size.width + 2*margin))
                    model.height = NSNumber.init(value: Double(deleteW))
                }
            }
            index += 1
        }
        setNeedsDisplay()
    }
    // 删除按钮点击
    @objc func deleteBtnClicked(index: NSInteger) {
        departments!.removeObject(at: index)
        refreshDepartment(departments: departments!, edit: edit)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if departments != nil{
            var index = 0
            var X:CGFloat = 0.0
            var Y:CGFloat = 0.0
            let margin:CGFloat = 5.0
            
            for item in departments!{
                
                let model = item as! TFDepartmentModel
                let view = itemViews[index] as! TFDepartmentItem
                var lastView:TFDepartmentItem?
                var lastModel:TFDepartmentModel?
                if index != 0{
                    lastModel = departments![index-1] as? TFDepartmentModel
                    lastView = itemViews[index-1] as? TFDepartmentItem
                }
                
                if lastView != nil{
                    if X + CGFloat(model.width.doubleValue) > self.width{// 换行
                        Y += (CGFloat(lastModel!.height.doubleValue) + margin)
                        view.frame = CGRect(x: 0.0, y: Y, width: CGFloat(model.width.doubleValue), height: CGFloat(model.height.doubleValue))
                        X = (CGFloat(model.width.doubleValue) + margin)
                    }else{// 没换行
                        view.frame = CGRect(x: X, y: Y, width: CGFloat(model.width.doubleValue), height: CGFloat(model.height.doubleValue))
                        X += (CGFloat(model.width.doubleValue) + margin)
                    }
                }else{// 第一个
                    view.frame = CGRect(x: X, y: Y, width: CGFloat(model.width.doubleValue), height: CGFloat(model.height.doubleValue))
                    X +=  (CGFloat(model.width.doubleValue) + margin)
                }
                
                index += 1
            }
            if delegate != nil{
                let lastModel = departments?.lastObject as? TFDepartmentModel
                let hei = lastModel?.height.floatValue
                delegate!.departmentViewHeight!(height: (Y + CGFloat(hei ?? 0)))
            }
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
