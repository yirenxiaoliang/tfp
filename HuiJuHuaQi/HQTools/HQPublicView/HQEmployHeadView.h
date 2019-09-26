//
//  HQEmployHeadView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/8.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HQEmployHeadViewDelegate <NSObject>


@optional
/**
 *  点击头像回调
 *
 *  @param employId  点击人员ID
 *  @param quitState 离职状态，YES为离职
 */
- (void)didEmployHeadViewWithEmployId:(NSNumber *)employId
                            quitState:(BOOL)quitState;

@end

@interface HQEmployHeadView : UIView

@property (nonatomic, assign) id<HQEmployHeadViewDelegate> delegate;

@property (nonatomic, strong) UIFont *titleFont;

- (void)refreshEmployHeadViewWithId:(NSNumber *)employId;


@end
