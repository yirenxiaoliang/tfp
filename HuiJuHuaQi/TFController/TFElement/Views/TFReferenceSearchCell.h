//
//  TFReferenceSearchCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFReferenceSearchCell : HQBaseCell

+ (instancetype)referenceSearchCellWithTableView:(UITableView *)tableView;
/** 刷新 */
-(void)refreshCellWithRows:(NSArray *)rows;
/** 高度 */
+(CGFloat)refreshCellHeightWithRows:(NSArray *)rows;
@end
