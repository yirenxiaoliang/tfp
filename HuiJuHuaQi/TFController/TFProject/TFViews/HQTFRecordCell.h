//
//  HQTFRecordCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFTaskLogContentModel.h"

@interface HQTFRecordCell : HQBaseCell

+ (HQTFRecordCell *)recordCellWithTableView:(UITableView *)tableView;

- (void)refreshRecordCellWithModel:(TFTaskLogContentModel *)model;
+ (CGFloat)refreshRecordCellHeightWithModel:(TFTaskLogContentModel *)model;

@end
