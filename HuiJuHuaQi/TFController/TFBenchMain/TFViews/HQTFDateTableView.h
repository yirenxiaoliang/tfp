//
//  HQTFDateTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQTFDateTableViewDelegate <NSObject>

@optional
- (void)dateTableViewWithSelectedDate:(NSDate *)date;


@end

@interface HQTFDateTableView : UIView

/** tableView */
@property (nonatomic, weak) UITableView *tableView;


/** 选中的日期 */
@property (nonatomic, strong) NSDate *selectedDate;


/** dalegate */
@property (nonatomic, weak) id<HQTFDateTableViewDelegate> delegate;
@end
