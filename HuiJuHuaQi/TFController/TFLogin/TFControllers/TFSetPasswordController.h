//
//  TFSetPasswordController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "HQUserModel.h"

@interface TFSetPasswordController : HQBaseViewController

/** user */
@property (nonatomic, copy) NSString *telephone;

/** type 0:注册 1：忘记密码 */
@property (nonatomic, assign) NSInteger type;


@end
