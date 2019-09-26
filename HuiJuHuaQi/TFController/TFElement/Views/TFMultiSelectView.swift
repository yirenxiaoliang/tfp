//
//  TFMultiSelectView.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

class TFMultiSelectView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView?
    var datas:NSArray?
    var selectDatas:NSMutableArray = []
    var sureBlock: ((NSMutableArray) ->Void)?
    var cancelBlock: (() ->Void)?
    var dismissBlock: (() ->Void)?
    var single = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupChild()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupChild() {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        self.addSubview(view)
        view.backgroundColor = UIColor.white
        self.backgroundColor = UIColor.white
        let line = UIView.init(frame: CGRect(x: 0, y: 44, width: SCREEN_WIDTH, height: 1))
        self.addSubview(line)
        line.backgroundColor = UIColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1)
        
        let cancel = UIButton.init(type: .custom)
        cancel.setTitle("取消", for: .normal)
        cancel.setTitle("取消", for: .highlighted)
        cancel.setTitleColor(ExtraLightBlackTextColor, for: .normal)
        cancel.setTitleColor(ExtraLightBlackTextColor, for: .highlighted)
        cancel.frame = CGRect(x: 0, y: 0, width: 60, height: 44)
        view.addSubview(cancel)
        cancel.addTarget(self, action: #selector(cancelClicked), for: .touchUpInside)
        
        let sure = UIButton.init(type: .custom)
        sure.setTitle("确定", for: .normal)
        sure.setTitle("确定", for: .highlighted)
        sure.setTitleColor(UIColor(red: 0x36/255.0, green: 0x36/255.0, blue: 0x36/255.0, alpha: 1), for: .normal)
        sure.setTitleColor(UIColor(red: 0x36/255.0, green: 0x36/255.0, blue: 0x36/255.0, alpha: 1), for: .highlighted)
        sure.frame = CGRect(x: SCREEN_WIDTH-60, y: 0, width: 60, height: 44)
        view.addSubview(sure)
        sure.addTarget(self, action: #selector(sureClicked), for: .touchUpInside)
        
        tableView = UITableView.init(frame: CGRect(x: 0, y: 45, width: SCREEN_WIDTH, height: self.height-45), style: .plain)
        self.addSubview(tableView!)
        tableView!.backgroundColor = UIColor.white
        tableView!.delegate = self
        tableView!.dataSource = self
        tableView?.tableFooterView = UIView.init()
    }
    
    @objc func cancelClicked() {
        dismissBlock?()
        for item in datas!{
            let model = item as! TFCustomerOptionModel
            var have = false
            for item1 in selectDatas{
                let model1 = item1 as! TFCustomerOptionModel
                if model.label == model1.label{
                    have = true
                }
            }
            if !have{
                model.open = NSNumber.init(value: 0)
            }
        }
    }
    @objc func sureClicked() {
        let selectDatas:NSMutableArray = []
        
        for item in datas! {
            let model = item as! TFCustomerOptionModel
            if model.open != nil {
                if model.open.intValue == 1{
                    selectDatas.add(model)
                }
            }
        }
        
        if selectDatas.count == 0{
            MBProgressHUD.showError("请选择", to: UIApplication.shared.keyWindow)
            return
        }
        sureBlock?(selectDatas)
        dismissBlock?()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TFCustomSelectCell(tableView: tableView)
        let option = datas?[indexPath.row] as? TFCustomerOptionModel
        cell?.refreshCustomMultiCell(with: option)
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let option = datas?[indexPath.row] as! TFCustomerOptionModel
        if single {
            
            for item in datas!{
                let model = item as! TFCustomerOptionModel
                model.open = NSNumber.init(value: 0)
            }
            option.open = NSNumber.init(value: 1)
        }else{
            if option.open == nil{
                option.open = NSNumber.init(value: 1)
            }else{
                option.open = option.open.intValue == 1 ? NSNumber.init(value: 0) : NSNumber.init(value: 1)
            }
        }
        
        tableView.reloadData()
    }
    
    @objc class func showMultiSelectView(single: Bool ,options: NSArray, sureBlock: @escaping (NSMutableArray) ->Void , cancelBlock: @escaping () ->Void){
        
        let window = UIApplication.shared.keyWindow
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        view.tag = 0x5999
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        window?.addSubview(view)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewClicked))
        view.addGestureRecognizer(tap)
        
        let selectView = TFMultiSelectView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 244))
        selectView.tag = 0x6999
        selectView.datas = options
        selectView.tableView?.reloadData()
        selectView.sureBlock = sureBlock
        selectView.cancelBlock = cancelBlock
        selectView.single = single
        for item in options {
            let model = item as! TFCustomerOptionModel
            if model.open != nil && model.open.intValue == 1{
                selectView.selectDatas.add(model)
            }
        }
        selectView.dismissBlock = {
            UIView.animate(withDuration: 0.25, animations: {
                view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                selectView.y = SCREEN_HEIGHT
            }, completion: { _ in
                view.removeFromSuperview()
                selectView.removeFromSuperview()
            })
        }
        window?.addSubview(selectView)
        
        UIView.animate(withDuration: 0.25) {
            selectView.y = SCREEN_HEIGHT - 244
            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
        
    }
    @objc class func viewClicked() {
        let view = UIApplication.shared.keyWindow?.viewWithTag(0x5999)
        let selectView = UIApplication.shared.keyWindow?.viewWithTag(0x6999) as? TFMultiSelectView
        UIView.animate(withDuration: 0.25, animations: {
            view?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            selectView?.y = SCREEN_HEIGHT
        }) { _ in
            view?.removeFromSuperview()
            selectView?.removeFromSuperview()
            for item in selectView!.datas!{
                let model = item as! TFCustomerOptionModel
                var have = false
                for item1 in selectView!.selectDatas{
                    let model1 = item1 as! TFCustomerOptionModel
                    if model.label == model1.label{
                        have = true
                    }
                }
                if !have{
                    model.open = NSNumber.init(value: 0)
                }
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
