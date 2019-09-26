//
//  TFApprovalDetailHeaderView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFApprovalDetailHeaderView : UIView

+ (instancetype)approvalDetailHeaderView;

/** 刷新 */
-(void)refreshViewWithDict:(NSDictionary *)dict;


@end
