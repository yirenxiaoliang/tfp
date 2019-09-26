//
//  TFDownloadRecordModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFDownloadRecordModel : JSONModel

//{
//    "number" : 1,
//    "employee_id" : 1,
//    "file_id" : 59,
//    "id" : 17,
//    "picture" : "http:\/\/192.168.1.9:8080\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1515471361299.201801091217210.jpg",
//    "lately_time" : "1515655918508",
//    "employee_name" : "项羽"
//}

@property (nonatomic, strong) NSNumber <Optional>*number;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, strong) NSNumber <Optional>*file_id;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, copy) NSString <Optional>*lately_time;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@end
