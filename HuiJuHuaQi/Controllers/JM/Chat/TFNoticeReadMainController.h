//
//  TFNoticeReadMainController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "YPTabBarController.h"

@interface TFNoticeReadMainController : YPTabBarController

/** 群id */
@property (nonatomic, strong) NSNumber *groupId;

/** readerList */
@property (nonatomic, strong) NSArray *readerList;

@property (nonatomic, copy) NSString *readpeoples;

@end
