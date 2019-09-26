//
//  TFMyHeadPictureController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFMyHeadPictureController : HQBaseViewController

/** 头像url */
@property (nonatomic, copy) NSString *headUrl;

/** refresh */
@property (nonatomic, copy) ActionParameter refresh;
/** refresh */
@property (nonatomic, copy) ActionParameter headRefresh;

@end
