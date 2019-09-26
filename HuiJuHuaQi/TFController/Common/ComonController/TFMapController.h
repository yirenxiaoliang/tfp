//
//  TFMapController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "TFLocationModel.h"


@interface TFMapController : HQBaseViewController


/** 返回 */
@property (nonatomic, copy) ActionParameter locationAction;

/** LocationType */
@property (nonatomic, assign) LocationType type;

/** 查看位置 */
@property (nonatomic, assign) CLLocationCoordinate2D location;
/** 位置 */
@property (nonatomic, copy) NSString *address;

/** 搜索城市 */
@property (nonatomic, copy) NSString *city;
/** 搜索关键字 */
@property (nonatomic, copy) NSString *keyword;

-(instancetype)initWithType:(LocationType)type;

@end
