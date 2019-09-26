//
//  HQWriteContentCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQWorkDetailTextView.h"

@interface HQWriteContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet HQWorkDetailTextView *content;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *head;
/** 创建cell */
+ (HQWriteContentCell *)writeContentCellWithTableView:(UITableView *)tableView;

@end
