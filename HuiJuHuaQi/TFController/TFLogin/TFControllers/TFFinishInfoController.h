//
//  TFFinishInfoController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

typedef enum {
    FinishInfoType_person,
    FinishInfoType_company
}FinishInfoType;

@interface TFFinishInfoController : HQBaseViewController

/** type */
@property (nonatomic, assign) FinishInfoType type;

@end
