//
//  TFOutPunchView.swift
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/1.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

import UIKit



@objc(TFOutPunchViewDelegate)
protocol TFOutPunchViewDelegate:NSObjectProtocol {
    @objc optional func punchViewClickedPhoto()
    @objc optional func punchViewClickedMark()
}


class TFOutPunchView: UIView {
    
    @objc weak var delegate: TFOutPunchViewDelegate?
    
    @IBOutlet weak var myAddress: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var markBtn: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var line1: UILabel!
    @IBOutlet weak var markTitle: UILabel!
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var line2: UILabel!
    
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
    
    @objc func commonInit() {
        backgroundColor = UIColor.white
        myAddress.textColor = BlackTextColor
        myAddress.font = UIFont.systemFont(ofSize: 16)
        descLabel.textColor = GrayTextColor
        descLabel.font = UIFont.systemFont(ofSize: 14)
        markBtn.layer.cornerRadius = 4
        markBtn.layer.masksToBounds = true
        markBtn.layer.borderColor = UIColor.init(red: 0x08/255.0, green: 0xcf/255.0, blue: 0x7b/255.0, alpha: 1.0).cgColor
        markBtn.layer.borderWidth = 0.5
        addressLabel.textColor = GrayTextColor
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        markTitle.textColor = BlackTextColor
        markTitle.font = UIFont.systemFont(ofSize: 16)
        markLabel.textColor = BlackTextColor
        markLabel.font = UIFont.systemFont(ofSize: 16)
        photoBtn.setImage(UIImage.init(named: "相机"), for: .normal)
        photoBtn.setImage(UIImage.init(named: "相机"), for: .highlighted)
        
        line1.backgroundColor = UIColor.init(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1.0)
        line2.backgroundColor = UIColor.init(red: 0xf2/255.0, green: 0xf2/255.0, blue: 0xf2/255.0, alpha: 1.0)
        
        addressLabel.text = "定位中...";
        descLabel.text = "";
        markLabel.text = "";
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapDesc))
        markLabel.isUserInteractionEnabled = true
        markLabel.addGestureRecognizer(tap)
        
        photoBtn.addTarget(self, action: #selector(photoClick), for: .touchUpInside)
    }
    
    @objc func tapDesc() {
        if delegate != nil {
            delegate?.punchViewClickedMark!()
        }
    }
    
    @objc func photoClick() {
        if delegate != nil {
            delegate?.punchViewClickedPhoto!()
        }
    }
    
    @objc class func outPunchView () ->TFOutPunchView{
        return Bundle.main.loadNibNamed("TFOutPunchView", owner: self, options: nil)?.last as! TFOutPunchView
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
