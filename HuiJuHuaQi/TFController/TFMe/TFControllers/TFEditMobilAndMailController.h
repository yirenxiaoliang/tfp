//
//  TFEditMobilAndMailController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
    EditInfoTypeMobil,// 座机
    EditInfoTypeMail // 邮箱
}EditInfoType;

@interface TFEditMobilAndMailController : HQBaseViewController

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) EditInfoType type;

@property (nonatomic, copy) Action refresh;

@end
