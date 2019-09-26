//
//  HQTFNumberMoneyCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol HQTFNumberMoneyCellDelegate <NSObject>

@optional
/** value 0:为选中数量  1：为选中金额 */
- (void)numberMoneyCellDidSelectedWithValue:(NSInteger)value;
@end

@interface HQTFNumberMoneyCell : HQBaseCell

+ (HQTFNumberMoneyCell *)numberMoneyCellWithTableView:(UITableView *)tableView;
/** dalegate */
@property (nonatomic, weak) id <HQTFNumberMoneyCellDelegate>delegate;
@end
