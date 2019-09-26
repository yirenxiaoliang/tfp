//
//  TFAddressWayCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddressWayCell.h"

@interface TFAddressWayCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *rangeLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;



@end

@implementation TFAddressWayCell


- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (self.cellType == 1) {
        
//        [self.deleteBtn setTitle:@"filterMulti" forState:UIControlStateNormal];
        [self.deleteBtn setImage:IMG(@"filterMulti") forState:UIControlStateNormal];
    }
    else {
        
        [self.deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        
    }
    
}

//配置地址考勤数据
- (void)configAddressWayCellWithTableView:(TFAtdWatDataListModel *)model {
    
    if (self.cellType != 1) {
        
        self.deleteBtn.layer.borderWidth = 0.5;
        self.deleteBtn.layer.borderColor = GreenColor.CGColor;
        self.deleteBtn.layer.cornerRadius = 4.0;
        self.deleteBtn.layer.masksToBounds = YES;
    }
    
    self.nameLab.text = model.name;
    self.rangeLab.text = [NSString stringWithFormat:@"有效范围：%@",model.effective_range];
//    TFAtdLocationModel *lModel = model.location[0];
    self.addressLab.text = [NSString stringWithFormat:@"考勤地址：%@",model.address];
    
    
}

//配置WiFi考勤数据
- (void)configWiFiWayCellWithTableView:(TFAtdWatDataListModel *)model {
    
    self.deleteBtn.layer.borderWidth = 0;
    self.deleteBtn.layer.borderColor = GreenColor.CGColor;
    self.deleteBtn.layer.cornerRadius = 4.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.nameBottomCons.constant = 10;
    self.addressLabCons.constant = 0;
    self.nameLab.text = model.name;
    self.rangeLab.text = model.address;
    
}

//配置班次管理考勤数据
- (void)configClassesManagerCellWithTableView:(TFAtdClassModel *)model {

    self.deleteBtn.layer.borderWidth = 0.5;
    self.deleteBtn.layer.borderColor = GreenColor.CGColor;
    self.deleteBtn.layer.cornerRadius = 4.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.nameBottomCons.constant = 10;
    self.addressLabCons.constant = 0;
    self.nameLab.text = model.name;
    self.rangeLab.text = [NSString stringWithFormat:@"考勤时间：%@",TEXT(model.classDesc)];
    
}

//配置关联审批单数据
- (void)configRelatedApprovalCellWithModel:(TFReferenceApprovalModel *)model{
    
    self.deleteBtn.layer.borderWidth = 0.5;
    self.deleteBtn.layer.borderColor = GreenColor.CGColor;
    self.deleteBtn.layer.cornerRadius = 4.0;
    self.deleteBtn.layer.masksToBounds = YES;
    
    self.nameBottomCons.constant = 10;
    self.addressLabCons.constant = 0;
    self.nameLab.text = model.relevance_title;
    NSString *str = @"缺卡";
    /** 0：缺卡 1：请假 2： 加班 3：出差 4：销假 5： 外出 */
    switch ([model.relevance_status integerValue]) {
        case 0:
            {
                str = @"缺卡";
            }
            break;
        case 1:
        {
            str = @"请假";
        }
            break;
        case 2:
        {
            str = @"加班";
        }
            break;
        case 3:
        {
            str = @"出差";
        }
            break;
        case 4:
        {
            str = @"销假";
        }
            break;
        case 5:
        {
            str = @"外出";
        }
            break;
            
        default:
            break;
    }
    self.rangeLab.text = [NSString stringWithFormat:@"修正状态：%@",str];
    
}

//配置新增WiFi考勤数据
- (void)configAddWiFiPCCellWithTableView:(NSInteger)select {
    
//    self.deleteBtn.layer.borderWidth = 0.5;
//    self.deleteBtn.layer.borderColor = GreenColor.CGColor;
//    self.deleteBtn.layer.cornerRadius = 4.0;
//    self.deleteBtn.layer.masksToBounds = YES;
//    self.deleteBtn.hidden = YES;
    
    if (select == 1) {
        
        self.deleteBtn.hidden = NO;
        self.deleteBtnTopCons.constant = 37;
        [self.deleteBtn setTitle:@"" forState:UIControlStateNormal];
        [self.deleteBtn setImage:IMG(@"考勤选择") forState:UIControlStateNormal];
    }
    else {
        
        self.deleteBtn.hidden = YES;
    }
    
    self.nameBottomCons.constant = 10;

    NSDictionary *dic = [HQHelper getCurrentWiFiInfo];

    self.nameLab.text = [dic valueForKey:@"WiFiName"];
    self.rangeLab.text = [NSString stringWithFormat:@"MAC地址：%@",[dic valueForKey:@"MacAddress"]];
    
    self.addressLab.text = @"当前连接的Wi-Fi";
}


+ (instancetype)TFAddressWayCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAddressWayCell" owner:self options:nil] lastObject];
}

+ (instancetype)addressWayCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFAddressWayCell";
    TFAddressWayCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFAddressWayCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)deleteAction {
    
    if ([self.delegate respondsToSelector:@selector(deleteClicked:)]) {
        
        [self.delegate deleteClicked:self.index];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
