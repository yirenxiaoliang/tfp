//
//  TFApprovalSearchView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFApprovalSearchViewDelegate <NSObject>

@optional
- (void)approvalSearchViewDidClickedTypeBtn;
- (void)approvalSearchViewDidClickedStatusBtn;
- (void)approvalSearchViewTextChange:(UITextField *)textField;

@end


@interface TFApprovalSearchView : UIView

+ (instancetype)approvalSearchView;

/** type 0:默认有两边的按钮 1:无两边的按钮 2:右边有按钮 */
@property (nonatomic, assign) NSInteger type;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UIButton *statusBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;

/** delegate */
@property (nonatomic, weak) id <TFApprovalSearchViewDelegate>delegate;

@end
