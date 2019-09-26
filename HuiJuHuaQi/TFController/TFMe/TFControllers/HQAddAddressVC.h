//
//  HQAddAddressVC.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFMyAddressModel.h"

@interface HQAddAddressVC : HQBaseViewController

@property (nonatomic, copy) NSString *addressStr;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) TFMyAddressModel *model;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *contentStr;

@end
