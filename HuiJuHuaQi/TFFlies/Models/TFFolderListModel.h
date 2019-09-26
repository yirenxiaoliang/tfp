//
//  TFFolderListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFFolderListModel @end

@interface TFFolderListModel : JSONModel

//{
//    "upload" : 1,
//    "color" : "#F52E94",
//    "url" : "company9\/10company\/",
//    "id" : 10,
//    "preview" : 1,
//    "download" : 1,
//    "size" : "",
//    "create_time" : 1514966516206,
//    "type" : "0",
//    "name" : "chenyul",
//    "employee_name" : "陈嘉映"
//}

//{
//    "id" : 12,
//    "status" : "0",
//    "model_id" : "",
//    "table_id" : 1,
//    "parent_id" : 1,
//    "create_by" : 1,
//    "employee_name" : "项羽",
//    "picture" : "http:\/\/192.168.1.58:8281\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1514171162304.201712251107010.jpg",
//    "url" : "company5\/2company\/1515384194145.jpg",
//    "siffix" : ".jpg",
//    "color" : "",
//    "size" : 50928,
//    "create_time" : 1515384194197,
//    "name" : "201801081203140.jpg",
//    "sign" : "1"
//}

//{
//    "url" : "company5\/2company\/1515384194145.jpg",
//    "midf_time" : 1515384194418,
//    "file_id" : 12,
//    "id" : 1,
//    "midf_by" : 1,
//    "picture" : "",
//    "name" : "201801081203140.jpg",
//    "employee_name" : ""
//}

@property (nonatomic, copy) NSString <Optional>*color;

@property (nonatomic, copy) NSString <Optional>*url;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, strong) NSNumber <Optional>*size;

@property (nonatomic, strong) NSNumber <Optional>*create_time;

@property (nonatomic, copy) NSString <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*employee_name;

@property (nonatomic, strong) NSNumber <Optional>*parent_id;

@property (nonatomic, strong) NSNumber <Optional>*create_by;

@property (nonatomic, copy) NSString <Optional>*picture;

@property (nonatomic, copy) NSString <Optional>*status;

/** 0:文件夹 1:文件 */
@property (nonatomic, copy) NSString <Optional>*sign;

@property (nonatomic, strong) NSNumber <Optional>*model_id;

@property (nonatomic, strong) NSNumber <Optional>*table_id;

@property (nonatomic, strong) NSNumber <Optional>*upload;

@property (nonatomic, strong) NSNumber <Optional>*preview;

@property (nonatomic, copy) NSString <Optional>*download;

@property (nonatomic, copy) NSString <Optional>*siffix;

@property (nonatomic, copy) NSString <Optional>*suffix;

@property (nonatomic, strong) NSNumber <Optional>*midf_time;

@property (nonatomic, strong) NSNumber <Optional>*file_id;

@property (nonatomic, strong) NSNumber <Optional>*midf_by;

@property (nonatomic, strong) NSNumber <Optional>*role_type;

@property (nonatomic, strong) NSNumber <Optional>*sign_type;

@property (nonatomic, strong) NSNumber <Optional>*is_manage;

/** 版本号 */
@property (nonatomic, strong) NSNumber <Ignore>*versionNum;

/** 所有版本总数 */
@property (nonatomic, strong) NSNumber <Optional>*versionCount;

@property (nonatomic, strong) NSNumber <Optional>*style;

/** 用于文件库选带URL */
@property (nonatomic, copy) NSString <Ignore>*fileUrl;

@end
