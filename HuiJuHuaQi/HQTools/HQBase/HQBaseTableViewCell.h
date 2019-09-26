//
//  HQBaseTableViewCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/26.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *topLine;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(id)model;

@end
