//
//  UITableView+Extension.m
//  HuiJuHuaQi
//
//  Created by hq001 on 16/1/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)
/**
 隐藏多余的cell
 */

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}
@end
