//
//  HQTFTaskProgressCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface HQTFTaskProgressCell : HQBaseCell
+(instancetype)taskProgressCellWithTableView:(UITableView *)tableView;

/** 刷新 */
-(void)refreshTaskProgressCellWithTotalTask:(NSInteger)total finish:(NSInteger)finish;

@end
