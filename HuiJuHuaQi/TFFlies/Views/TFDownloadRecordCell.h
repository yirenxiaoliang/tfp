//
//  TFDownloadRecordCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFDownloadRecordCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *photoImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *numbersLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

+ (instancetype)DownloadRecordCellWithTableView:(UITableView *)tableView;

@end
