//
//  HQTFAddLabelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFAddLabelCell : HQBaseCell;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (HQTFAddLabelCell *)addLabelCellWithTableView:(UITableView *)tableView;

- (void)refreshAddLabelCellWithLabels:(NSArray *)labels;

- (void)refreshAddLabelCellWithPriority:(NSNumber *)priority;

+ (CGFloat)refreshAddLabelCellHeightWithLabels:(NSArray *)labels;
@end
