//
//  TFEmailAddessBookModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFPageInfoModel.h"
#import "TFEmailAddessBookItemModel.h"

@interface TFEmailAddessBookModel : JSONModel

//{
//    "dataList": [
//                 {
//                     "create_time": 1520327647593,
//                     "employee_id": 1,
//                     "name": "陈宇亮",
//                     "del_status": "0",
//                     "id": 3,
//                     "mail_address": "chenyul1991@qq.com"
//                 },
//                 {
//                     "create_time": 1520327631467,
//                     "employee_id": 1,
//                     "name": "陈宇亮",
//                     "del_status": "0",
//                     "id": 2,
//                     "mail_address": "chenyul1991@qq.com"
//                 },
//                 {
//                     "create_time": 1520327342706,
//                     "employee_id": 1,
//                     "name": "陈宇亮",
//                     "del_status": "0",
//                     "id": 1,
//                     "mail_address": "chenyul1991@qq.com"
//                 }
//                 ],
//    "pageInfo": {
//        "totalPages": 1,
//        "pageSize": 10,
//        "totalRows": 3,
//        "pageNum": 1,
//        "curPageSize": 3
//    }
//},

@property (nonatomic, strong) NSArray <TFEmailAddessBookItemModel,Optional>*dataList;

@property (nonatomic, strong) TFPageInfoModel <Optional>*pageInfo;

@end
