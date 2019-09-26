//
//  TFSettingItemModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFSettingItemModel @end

@interface TFSettingItemModel : JSONModel

//{
    //                     "upload" : "",
    //                     "employee_id" : 1,
    //                     "file_id" : 53,
    //                     "preview" : "1",
    //                     "download" : "",
    //                     "id" : 11,
    //                     "picture" : "http:\/\/192.168.1.58:8281\/custom-gateway\/common\/file\/download?bean=user1111&fileName=user1111\/1514168698904.201712251025560.jpg",
    //                     "employee_name" : "陈宇亮"
    //                 },

@property (nonatomic, copy) NSString <Optional>*upload;

@property (nonatomic, strong) NSNumber <Optional>*employee_id;

@property (nonatomic, strong) NSNumber <Optional>*file_id;

@property (nonatomic, copy) NSString <Optional>*preview;

@property (nonatomic, copy) NSString <Optional>*download;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*picture;
@property (nonatomic, copy) NSString <Optional>*photograph;

@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*employeeName;

@property (nonatomic, copy) NSString <Optional>*position;

/** 自己加的字段 */
@property (nonatomic, strong) NSNumber <Ignore>*selectState;

@end
