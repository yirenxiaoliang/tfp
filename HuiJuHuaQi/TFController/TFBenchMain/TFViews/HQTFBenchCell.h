//
//  HQTFBenchCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFBenchCell : HQBaseCell

+ (HQTFBenchCell *)benchCellWithTableView:(UITableView *)tableView;

/** 动态刷新 */
-(void)refreshBenchCellWithModel:(id)model;
/** 固定刷新 */
-(void)refreshSolidBenchCellWithModel:(id)model;

/** 动态高度 */
+(CGFloat)refreshBenchCellHeightWithModel:(id)model;

/** 固定高度 */
+(CGFloat)refreshSolidBenchCellHeightWithModel:(id)model;
@end
