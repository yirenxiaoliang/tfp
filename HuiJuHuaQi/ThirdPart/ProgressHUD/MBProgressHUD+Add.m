//
//  MBProgressHUD+Add.m
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

@implementation MBProgressHUD (Add)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = ([text isEqualToString:@"未能连接到服务器"] || [text isEqualToString:@"网络连接已中断。"]) ? @"网络异常" : text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:2.0];
}

#pragma mark 显示错误信息
+ (void)showImageError:(NSString *)error toView:(UIView *)view
{
    if (!error || [error isEqualToString:@""]) {
        return;
    }
    [self show:error icon:@"error" view:view];
}

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    if (!error || [error isEqualToString:@""]) {
        return;
    }
    [self show:error icon:nil view:view];
}

#pragma mark 显示成功信息
+ (void)showImageSuccess:(NSString *)success toView:(UIView *)view
{
    if (!success || [success isEqualToString:@""]) {
        return;
    }
    [self show:success icon:@"success" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    if (!success || [success isEqualToString:@""]) {
        return;
    }
    [self show:success icon:nil view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view {
    
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"loading"]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    
    return hud;
}

#pragma mark 自定义提示信息
/** 自定义提示信息 */
+ (MBProgressHUD *)showHUDTip:(NSString *)labelText image:(UIImage *)img showView:(UIView *)view {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = labelText;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelColor = [UIColor whiteColor];
    hud.animationType = MBProgressHUDAnimationFade;
    hud.minSize = CGSizeMake(110, 110);
    UIImage *image = img;
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imgView;
    [hud hide:YES afterDelay:2.0];
    
    return hud;
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view{
    return [self showMessag:message toView:view];
}
+ (MBProgressHUD *)showMessage:(NSString *)message view:(UIView *)view{
    return [self showMessag:message toView:view];
}

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view hideState:(BOOL)hideState
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    
    
    if (hideState == YES) {
        
        [hud hide:YES afterDelay:1.5];
    }
    
    return hud;
}


+ (MBProgressHUD *)showMessag:(NSString *)message
                       toView:(UIView *)view
                    hideState:(BOOL)hideState
                   delayBlock:(NSBlockOperation *)delayBlock
{
    MBProgressHUD *hud = [MBProgressHUD showMessag:message toView:view hideState:hideState];
    
//    
//    if (delayBlock) {
//        
//        
//    }
    
    
    return hud;
}
@end
