//
//  TFNoteListSearchController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFNoteListSearchController : HQBaseViewController

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

@property (nonatomic, assign) NSInteger style;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, strong) NSNumber *fileId;

@end
