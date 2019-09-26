//
//  HQSelectTimeCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"
@interface HQSelectTimeCell : HQBaseCell


/** title */
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;

/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *time;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeTitleWidthLayout;


@property (weak, nonatomic) IBOutlet UIImageView *arrow;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidth;


@property (assign, nonatomic) BOOL arrowShowState;   //YES为SHOW


- (void)arrowHidden;


/** 创建cell */
+ (instancetype)selectTimeCellWithTableView:(UITableView *)tableView;


+ (CGFloat)getSelectTimeCellHeight:(NSString *)title
                           content:(NSString *)content
                    arrowShowState:(BOOL)arrowShowState;



@end
