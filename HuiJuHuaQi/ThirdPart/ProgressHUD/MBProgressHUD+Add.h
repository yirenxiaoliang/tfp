//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showImageError:(NSString *)error toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showImageSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view hideState:(BOOL)hideState;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message view:(UIView *)view;

/** 自定义提示信息 */
+ (MBProgressHUD *)showHUDTip:(NSString *)labelText image:(UIImage *)img showView:(UIView *)view;

@end
