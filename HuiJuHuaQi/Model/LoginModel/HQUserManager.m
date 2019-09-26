//
//  HQUserManager.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQUserManager.h"
#import "HQRequestManager.h"
#import "TFRequest.h"

@implementation HQUserManager

+ (instancetype)defaultUserInfoManager {
    static HQUserManager *instance = nil;
    static dispatch_once_t oncetoKen;
    dispatch_once(&oncetoKen, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}


/** 退出登录 */
- (void)loginOutAction
{
    
    [self clearLoginInfo];
    [[HQCoreDataManager defaultCoreDataManager] logoutUpdataIsLogin];
    
    [[HQCoreDataManager defaultCoreDataManager] deleteCurrentEmployeeData];
    
//    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//    [userDefault removeObjectForKey:SaveIMAddressKey];
//    [userDefault removeObjectForKey:SaveIPAddressKey];
//    [userDefault removeObjectForKey:SaveInputUrlRecordKey];
//    [userDefault synchronize];
//    
//    // 回到外网
//    AppDelegate *app = [AppDelegate shareAppDelegate];
//    app.baseUrl = baseUrl;
//    app.serverAddress = serverAddress;
//    app.iMAddress = imServerAddress;
//    app.urlEnvironment = environment;
    
    [HQRequestManager dellocManager];// 销毁单例
    [TFRequest dellocManager];// 销毁单例
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogoutSuccess object:nil];
}


- (void)setUserLoginInfo:(TFUserLoginCModel *)userLoginInfo
{
    [self clearLoginInfo];
    
    _userLoginInfo = userLoginInfo;
}


- (void)clearLoginInfo
{
    _userLoginInfo = nil;
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end
