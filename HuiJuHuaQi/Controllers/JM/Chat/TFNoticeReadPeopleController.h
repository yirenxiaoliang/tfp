//
//  TFNoticeReadPeopleController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFNoticeReadPeopleController : HQBaseViewController

/** type 0：未读 1：已读 */
@property (nonatomic, assign) NSInteger type;
/** 群id */
@property (nonatomic, strong) NSNumber *groupId;

/** readerList */
@property (nonatomic, strong) NSArray *readerList;

@property (nonatomic, copy) NSString *readPeoples;


@property (nonatomic, copy) ActionParameter actionParameter;

@end
