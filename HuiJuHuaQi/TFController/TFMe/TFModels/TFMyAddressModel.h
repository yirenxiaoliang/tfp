//
//  TFMyAddressModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/6/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFMyAddressModel : JSONModel

//"receiverName": "xiaoming",
//"region": "深圳南山",//区域
//"address": "思创大厦",//详细地址
//"postCode": 800155,//邮编
//"telephone": "13524567895",

//"id" : 3430339669065728,
//"postCode" : 412200,
//"employeeId" : 3424581172690944,
//"createDate" : null,
//"disabled" : null,
//"isDefault" : null,
//"userId" : 3414401904771072,
//"receiverName" : "陈宇亮",
//"address" : "思创大厦2楼",
//"createTime" : null,
//"region" : "广东深圳",
//"telephone" : "15974267842",
//"companyId" : 3424581171658752,
//"updateTime" : null

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*isDefault; //是否默认 0:不默认 1:默认

@property (nonatomic, copy) NSString <Optional>*receiverName;

@property (nonatomic, copy) NSString <Optional>*region;

@property (nonatomic, copy) NSString <Optional>*address;

@property (nonatomic, copy) NSString <Optional>*postCode;

@property (nonatomic, copy) NSString <Optional>*telephone;

@end
