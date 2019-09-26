//
//  TFLookMoreController.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseViewController.h"

@interface TFLookMoreController : HQBaseViewController

/** 0:聊天记录 1:小助手 2:联系人 */
@property (nonatomic, assign) NSInteger type;
/** keyWord */
@property (nonatomic, copy) NSString *keyWord;

/** bean */
@property (nonatomic, copy) NSString *bean;

/** 匹配字段 */
@property (nonatomic, copy) NSString *searchMatch;

/** 值 */
@property (nonatomic, copy) ActionParameter parameterAction;

@property (nonatomic, strong) NSNumber *chatId;

@property (nonatomic, strong) NSArray *dataSources;;

@end
