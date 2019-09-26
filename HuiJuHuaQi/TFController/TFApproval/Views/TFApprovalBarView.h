//
//  TFApprovalBarView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFApprovalBarViewDelegate <NSObject>

@optional
-(void)approvalBarViewDidClickWithIndex:(NSInteger)index;

@end

@interface TFApprovalBarView : UIView


@property (nonatomic, weak) id<TFApprovalBarViewDelegate>delegate;

-(void)refreshWaitApprovalNumber:(NSInteger)number;
-(void)refreshCopyApprovalNumber:(NSInteger)number;


@property (nonatomic, assign) NSInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
