//
//  TFVerificationCodeController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFVerificationCodeController : HQBaseViewController

/** telephone */
@property (nonatomic, copy) NSString *telephone;

/** type 0:注册 1:忘记密码 2:变更手机 */
@property (nonatomic, assign) NSInteger type;

@end
