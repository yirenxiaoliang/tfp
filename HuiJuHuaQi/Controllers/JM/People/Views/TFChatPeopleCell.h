//
//  TFChatPeopleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFChatPeopleCell : HQBaseCell

+(instancetype)chatPeopleCellWithTableView:(UITableView *)tableView;
/** 刷新cell
 *  @param items 人员数组
 *  @param type  类型 0：无加减号  1：有加号  2：有加减号
 *  @param column  一行几个
 */
-(void)refreshCellWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column;
+(CGFloat)refreshCellHeightWithItems:(NSArray *)items withType:(NSInteger)type withColumn:(NSInteger)column;


@end
