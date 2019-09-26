//
//  HQTFRepeatRowCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol HQTFRepeatRowCellDelegate <NSObject>

@optional
- (void)repeatRowCellWithIndexs:(NSArray *)indexs;

@end

@interface HQTFRepeatRowCell : HQBaseCell

+(instancetype)repeatRowCellWithTableView:(UITableView *)tableView;

/** dalegate */
@property (nonatomic, weak) id<HQTFRepeatRowCellDelegate>delegate;

@end
