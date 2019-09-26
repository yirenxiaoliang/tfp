//
//  TFIMLoginData.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFIMHeadData.h"

@interface TFIMLoginData : NSObject

/** 登录账号，如果知道自己的id这个可以不填充 */
//@property (nonatomic, copy) NSString *szUsername;
//
///** 默认1 暂时不用 */
//@property (nonatomic, assign) int8_t chStatus;
//
///** 默认为1 暂时不用 */
//@property (nonatomic, assign) int8_t chUserType;


@property (nonatomic, copy) NSString *TOKEN;


/** 登录数据转为Data */
-(NSData *)loginDataWithHeader:(NSData *)headData;

/** 登录是否成功 */
+ (BOOL)isLoginSuccessWithData:(NSData *)data;

/** 登录返回码 */
+ (int32_t)loginResponseWithData:(NSData *)data;


@end
