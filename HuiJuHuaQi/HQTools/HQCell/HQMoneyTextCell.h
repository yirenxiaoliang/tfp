//
//  HQMoneyTextCell.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/19.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseTableViewCell.h"

@interface HQMoneyTextCell : HQBaseTableViewCell


@property (strong, nonatomic) IBOutlet UILabel *topTitleLabel;


@property (strong, nonatomic) IBOutlet UITextField *moneyTextField;


@property (strong, nonatomic) IBOutlet UILabel *bottomLabel;


//@property (strong, nonatomic) IBOutlet HQWorkDetailTextView *contentTextView;


@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lineYLayout;



+ (HQMoneyTextCell *)moneyTextCellWithTableView:(UITableView *)tableView;



@end
