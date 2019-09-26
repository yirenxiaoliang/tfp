//
//  HQChangeAddressVC.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import "TFMyAddressModel.h"

@interface HQChangeAddressVC : HQBaseViewController

@property (nonatomic, strong) NSNumber *addressId;

@property (nonatomic, strong) TFMyAddressModel *model;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *contentStr;

@end
