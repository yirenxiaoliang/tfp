//
//  TFSendModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/1.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQEmployModel.h"

@interface TFSendModel : JSONModel

/** 链接内容 */
@property (nonatomic, copy) NSString *content;
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 截止日期 */
@property (nonatomic, copy) NSString *endTime;
/** 输入的文字 */
@property (nonatomic, copy) NSString *inputText;
///** 人员 */
//@property (nonatomic, copy) NSString *people;
///** 人员名 */
//@property (nonatomic, copy) NSString *employeeName;
///** 人员id */
//@property (nonatomic, copy) NSString *employeeId;
///** 人员头像 */
//@property (nonatomic, copy) NSString *photograph;
/** people */
@property (nonatomic, strong) HQEmployModel *people;


@end
