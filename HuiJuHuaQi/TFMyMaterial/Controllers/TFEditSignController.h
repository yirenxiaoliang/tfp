//
//  TFEditSignController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFEditSignController : HQBaseViewController

@property (nonatomic, copy) ActionParameter actionParameter;

@property (nonatomic, copy) ActionParameter refreshAction;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, strong) NSNumber *emoNum;

@property (nonatomic, copy) NSString *emoStr;

@end
