//
//  HQTFThreeLabelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFThreeLabelCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

+ (HQTFThreeLabelCell *)threeLabelCellWithTableView:(UITableView *)tableView;

@end
