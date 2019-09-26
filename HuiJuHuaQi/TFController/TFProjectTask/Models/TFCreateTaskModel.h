//
//  TFCreateTaskModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFCreateTaskModel : NSObject


/** projectId */
@property (nonatomic, strong) NSNumber *projectId;

/** sectionId */
@property (nonatomic, strong) NSNumber *sectionId;

/** taskRowId */
@property (nonatomic, strong) NSNumber *taskRowId;

/** id */
@property (nonatomic, strong) NSNumber *id;

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 可见 0：不可见 1：可见 */
@property (nonatomic, assign) NSInteger visible;

/** 执行人 */
@property (nonatomic, strong) HQEmployModel *execute;

/** 开始时间 */
@property (nonatomic, assign) long long startTime;

/** 截止时间 */
@property (nonatomic, assign) long long endTime;

/** 描述 */
@property (nonatomic, copy) NSString *descript;

/** 标签s */
@property (nonatomic, strong) NSMutableArray *labels;


@end
