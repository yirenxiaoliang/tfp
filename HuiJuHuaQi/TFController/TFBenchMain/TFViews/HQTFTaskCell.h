//
//  HQTFTaskCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFTaskCell : HQBaseCell
+ (HQTFTaskCell *)taskCellWithTableView:(UITableView *)tableView;
/** 动态刷新 */
-(void)refreshTaskCellWithModel:(id)model;
/** 动态高度 */
+(CGFloat)refreshTaskCellHeightWithModel:(id)model;
/** 固定刷新 */
-(void)refreshSolidTaskCellWithModel:(id)model;
/** 固定高度 */
+(CGFloat)refreshSolidTaskCellHeightWithModel:(id)model;
@end
