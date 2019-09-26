//
//  TFEmailPersonModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFEmailPersonModel @end

@interface TFEmailPersonModel : JSONModel

//"employee_name" = "\U9648\U5b87\U4eae";
//"mail_account" = "chenyul1991@qq.com";

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, copy) NSString <Optional>*mail_account;

/** button */
@property (nonatomic, strong) UIButton <Ignore>*button;


@end
