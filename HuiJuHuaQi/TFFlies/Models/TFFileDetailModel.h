//
//  TFFileDetailModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

#import "TFFolderListModel.h"

@interface TFFileDetailModel : JSONModel

//{
//    "basics" : {
//        "id" : 19,
//        "status" : "0",
//        "model_id" : "",
//        "table_id" : 1,
//        "parent_id" : 17,
//        "create_by" : 4,
//        "employee_name" : "陈宇亮",
//        "url" : "company3\/11company\/17company\/1517371548306.jpg",
//        "siffix" : ".jpg",
//        "color" : "",
//        "size" : 50928,
//        "create_time" : 1517371548428,
//        "name" : "201801311204560.jpg",
//        "sign" : "1"
//    },
//    "upload" : 1,
//    "is_manage" : 1,
//    "download" : 1,
//    "fabulous_count" : 0,
//    "comment_count" : 1,
//    "fabulous_status" : 0
//},

@property (nonatomic, strong) NSNumber <Optional>*fabulous_status;

@property (nonatomic, strong) NSNumber <Optional>*fabulous_count;

@property (nonatomic, strong) NSNumber <Optional>*comment_count;

@property (nonatomic, copy) NSString <Optional>*upload;

@property (nonatomic, strong) NSNumber <Optional>*is_manage;

@property (nonatomic, strong) NSNumber <Optional>*download;

@property (nonatomic, strong) TFFolderListModel <Optional>*basics;

@end
