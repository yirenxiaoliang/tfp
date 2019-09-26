//
//  TFManageItemModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFManageItemModel @end

@interface TFManageItemModel : JSONModel

//    "manage" : [
//                {
//                    "employee_id" : 2,
//                    "id" : 82,
//                    "employee_name" : "陈嘉映",
//                    "picture" : "http:\/\/192.168.1.58:8281\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1514171162304.201712251107010.jpg",
//                    "file_id" : 53,
//                    "sign_type" : "0"
//                }
//                ],

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*employeeName;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, strong) NSNumber <Optional>*file_id;

@property (nonatomic, copy) NSString <Optional>*sign_type;

@end
