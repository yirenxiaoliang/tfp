//
//  HQStarTableCell.h
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQClickStartView.h"
#import "HQEmployModel.h"

@protocol HQStarTableCellDelegate<NSObject>

-(void)senderEmployIdToCtr:(HQEmployModel *)employ;

@end

@interface HQStarTableCell : HQBaseCell

@property (nonatomic,weak)id<HQStarTableCellDelegate>delegate;

+ (HQStarTableCell *)starTableCellWithTableView:(UITableView *)tableView;
/** 刷新cell */
- (void)refreshCellWithPeoples:(NSMutableArray *)peoples;
/** 刷新高度 */
+ (CGFloat)refreshCellHeightWithPeoples:(NSMutableArray *)peoples;




-(void)cellForStart:(NSMutableArray *)peopleName;

+ (CGFloat)theCellForHeight:(NSMutableArray *)peopleName;

@end
