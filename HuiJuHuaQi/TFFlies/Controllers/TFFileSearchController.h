//
//  TFFileSearchController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFFileSearchController : HQBaseViewController

/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 根目录 1：公司文件 2：应用文件 3：个人文件 4：我共享的 5：与我共享的 6：项目文件 */
@property (nonatomic, assign) NSInteger style;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, strong) NSNumber *fileId;

@end
