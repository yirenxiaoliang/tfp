//
//  TFProviceCityDistrictCell.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/26.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit

class TFProviceCityDistrictCell: UITableViewCell {

    @objc @IBOutlet weak var titleLabel: UILabel!
    @objc @IBOutlet weak var selectBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = BlackTextColor
        titleLabel.font = UIFont.systemFont(ofSize: 16)
    }
    
    class func proviceCityDistrictCell() -> TFProviceCityDistrictCell {
        return Bundle.main.loadNibNamed("TFProviceCityDistrictCell", owner: self, options: nil)?.last as! TFProviceCityDistrictCell
    }
    
    @objc class func proviceCityDistrictCell(_ tableView: UITableView) ->TFProviceCityDistrictCell{
        let indetifier = "TFProviceCityDistrictCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: indetifier)
        if cell == nil {
            cell = proviceCityDistrictCell()
        }
        cell?.layer.masksToBounds = true
        return cell as! TFProviceCityDistrictCell
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
