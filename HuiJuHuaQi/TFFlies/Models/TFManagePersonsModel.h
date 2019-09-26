//
//  TFManagePersonsModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFManageItemModel.h"
#import "TFBasicsItemModel.h"
#import "TFSettingItemModel.h"

@interface TFManagePersonsModel : JSONModel

//{
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
//    "basics" : {
//        "name" : "BHB",
//        "type" : "1"
//    },
//    "setting" : [
//                 {
//                     "upload" : "",
//                     "employee_id" : 1,
//                     "file_id" : 53,
//                     "preview" : "1",
//                     "download" : "",
//                     "id" : 11,
//                     "picture" : "http:\/\/192.168.1.58:8281\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1514168698904.201712251025560.jpg",
//                     "employee_name" : "陈宇亮"
//                 },
//                 ]
//}

@property (nonatomic, strong) NSMutableArray <TFManageItemModel,Optional>*manage;

@property (nonatomic, strong) TFBasicsItemModel <Optional>*basics;

@property (nonatomic, strong) NSArray <TFSettingItemModel,Optional>*setting;


@end
