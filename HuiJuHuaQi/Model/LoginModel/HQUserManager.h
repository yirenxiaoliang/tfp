//
//  HQUserManager.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/13.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFUserLoginCModel+CoreDataClass.h"
#import "HQCoreDataManager.h"

#define UM [HQUserManager defaultUserInfoManager]

@interface HQUserManager : NSObject

/** 单例 */
+ (instancetype)defaultUserInfoManager;

/** 用户信息 */
@property (nonatomic, strong) TFUserLoginCModel *userLoginInfo;

/** 退出登录 */
- (void)loginOutAction;


@end
