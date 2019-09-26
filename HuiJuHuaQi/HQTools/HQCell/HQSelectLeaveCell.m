//
//  HQSelectLeaveCell.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSelectLeaveCell.h"

@implementation HQSelectLeaveCell

+ (instancetype)selectLeaveCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQSelectLeaveCell" owner:self options:nil] lastObject];
}

+ (HQSelectLeaveCell *)selectLeaveCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"selectLeaveCell";
    HQSelectLeaveCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self selectLeaveCell];
    }
    
    
    return cell;
}

@end
