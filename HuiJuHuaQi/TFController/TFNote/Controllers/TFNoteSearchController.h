//
//  TFNoteSearchController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFNoteSearchController : HQBaseViewController

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, copy) gradeAction refresh;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon_color;

@property (nonatomic, copy) NSString *icon_url;

@property (nonatomic, copy) NSString *icon_type;



@end
