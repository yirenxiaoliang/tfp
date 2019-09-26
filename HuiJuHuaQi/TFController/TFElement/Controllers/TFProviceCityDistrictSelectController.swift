//
//  TFProviceCityDistrictSelectController.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

class TFCityModel: NSObject {
    var name: String?
    var bitcode: String?
    var select: String?
    var hidden: String?
}
typealias  SelectCity = (NSArray) ->Void

class TFProviceCityDistrictSelectController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    var enablePanGesture = true
    var tableView: UITableView?
    var cityDatas: NSMutableArray = []
    var totalDatas: NSMutableArray = []
    @objc var selectDatas:NSArray = []
    @objc var isSingle = false
    @objc var selectBlock : SelectCity?
    
    @objc var datas: NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        handleDatas()
        setupTableView()
        navigationItem.title = "请选择"
        
        if !isSingle {
            let btn = UIButton.init(type: .custom)
            btn.setTitle("确定", for: .normal)
            btn.setTitle("确定", for: .highlighted)
            btn.setTitleColor(ExtraLightBlackTextColor, for: .normal)
            btn.setTitleColor(ExtraLightBlackTextColor, for: .highlighted)
            btn.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
            btn.addTarget(self, action: #selector(rightClicked), for: .touchUpInside)
            let item = UIBarButtonItem.init(customView: btn)
            navigationItem.rightBarButtonItem = item
        }
        
    }
    @objc func rightClicked() {
        let arr = NSMutableArray()
        for item in cityDatas {
            let model = item as! TFCityModel
            if model.select == "1"{
                let dict = NSMutableDictionary()
                dict.setValue(model.bitcode!, forKey: "id")
                dict.setValue(model.name!, forKey: "name")
                arr.add(dict)
            }
        }
        if arr.count > 0 {
            selectBlock?(arr)
        }else{
            MBProgressHUD.showError("请选择", to: view)
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleDatas() {
        for item in datas {
            let dict:NSDictionary = item as! NSDictionary
            let city: TFCityModel = TFCityModel()
            city.bitcode = dict.value(forKey: "id") as? String
            city.name = dict.value(forKey: "name") as? String
            city.select = "0"
            for item1 in selectDatas{
                let dict1:NSDictionary = item1 as! NSDictionary
                if (dict1.value(forKey: "id") as! String) == (dict.value(forKey: "id") as! String) {
                    city.select = "1"
                }
            }
            cityDatas .add(city)
        }
        totalDatas.addObjects(from: cityDatas as! [Any])
    }
    
    @objc func setupTableView() {
        tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(NaviHeight)), style: .plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        view.addSubview(tableView!)
        
        let header = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44));
        header.backgroundColor = UIColor.white
        let field = UITextField.init(frame: CGRect(x: 15, y: 7, width: SCREEN_WIDTH-30, height: 30))
        field.borderStyle = UITextField.BorderStyle.roundedRect
        header.addSubview(field)
        field.backgroundColor = UIColor(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1)
        field.placeholder = "请输入关键字"
        field.addTarget(self, action: #selector(textChange(textfield:)), for: .editingChanged)
        tableView?.tableHeaderView = header
        tableView?.tableFooterView = UIView.init()
        
    }
    
    /** ------文字改变------ */
    @objc func textChange(textfield: UITextField) {
        
        if textfield.text?.count == 0 {
            cityDatas.removeAllObjects()
            cityDatas.addObjects(from: totalDatas as! [Any])
            tableView?.reloadData()
            return
        }
        
        let range = textfield.markedTextRange
        if range == nil {
            cityDatas.removeAllObjects()
            for item in totalDatas {
                let model = item as! TFCityModel
                if ((model.name?.range(of: textfield.text!)) != nil) {
                    cityDatas.add(model)
                }
            }
        }
        
        tableView?.reloadData()
    }
    
    /** ------tableViewDelegate------ */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDatas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TFProviceCityDistrictCell.proviceCityDistrictCell(tableView)
        let model = cityDatas[indexPath.row] as! TFCityModel
        cell.titleLabel.text = String.init(format: "\(model.name!)")
        cell.selectBtn.isSelected = (model.select == "1" ? true : false)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated:false)
        
        let model:TFCityModel = cityDatas[indexPath.row] as! TFCityModel
        
        if isSingle {
            for item in cityDatas {
                let model1 = item as! TFCityModel
                model1.select = "0"
            }
            model.select = "1"
            let dict = NSMutableDictionary()
            dict.setValue(model.name!, forKey: "name")
            dict.setValue(model.bitcode!, forKey: "id")
            selectBlock?([dict])
            
        }else{
            if model.select == nil || model.select == "0" {
                model.select = "1"
            }else{
                model.select = "0"
            }
        }
        tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
