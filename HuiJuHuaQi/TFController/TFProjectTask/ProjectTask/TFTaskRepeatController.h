//
//  TFTaskRepeatController.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFDateModel : NSObject

/** name */
@property (nonatomic, copy) NSString *name;

/** tag */
@property (nonatomic, assign) NSInteger tag;

/** select */
@property (nonatomic, strong) NSNumber *select;


@end


@interface TFTaskRepeatController : HQBaseViewController


/** taskType */
@property (nonatomic, assign) NSInteger taskType;

/** taskId */
@property (nonatomic, strong) NSNumber *taskId;



@end
