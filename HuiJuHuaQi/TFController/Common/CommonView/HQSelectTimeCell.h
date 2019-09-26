//
//  HQSelectTimeCell.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/15.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"

@protocol HQSelectTimeCellDelegate <NSObject>

@optional
- (void)arrowClicked:(NSInteger)index section:(NSInteger)section;

@end

@interface HQSelectTimeCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UILabel *requireLabel;

/** title */
@property (weak, nonatomic) IBOutlet UILabel *timeTitle;

/** 时间 */
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titltW;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *timeTitleWidthLayout;


@property (weak, nonatomic) IBOutlet UIImageView *arrow;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowWidth;

/** borderView */
@property (nonatomic, weak) UIView *borderView;

@property (assign, nonatomic) BOOL arrowShowState;   //YES为SHOW

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

/** 点击索引 */
@property (nonatomic, assign) NSInteger index;

/** 箭头显示状态  */
@property (assign, nonatomic) BOOL arrowType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailW;

- (void)arrowHidden;

@property (nonatomic, weak) id <HQSelectTimeCellDelegate>delegate;

/** 创建cell */
+ (instancetype)selectTimeCellWithTableView:(UITableView *)tableView;


+ (CGFloat)getSelectTimeCellHeight:(NSString *)title
                           content:(NSString *)content
                    arrowShowState:(BOOL)arrowShowState;



@end
