//
//  TFApprovalItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFApprovalItemView;
@protocol TFApprovalItemViewDelegate <NSObject>

@optional
-(void)approvalItemViewClicked:(TFApprovalItemView *)approvalItemView;

@end

@interface TFApprovalItemView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger number;


@property (nonatomic, weak) id<TFApprovalItemViewDelegate> delegate;

/** 状态 NO:常态 YES：选中态 */
@property (nonatomic, assign) BOOL state;


/** 快速创建 */
+(instancetype)approvalItemView;

@end

NS_ASSUME_NONNULL_END
