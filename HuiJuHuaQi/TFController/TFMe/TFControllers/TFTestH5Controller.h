//
//  TFTestH5Controller.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/10.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFTestH5Controller : HQBaseViewController


@property(nonatomic,strong) NSString *htmlUrl;

/**  */
@property (nonatomic, assign) NSInteger type;

/**  */
@property (nonatomic, copy) ActionParameter action;

/**  */
@property (nonatomic, copy) NSString *obj;

@end
