//
//  TFProjectFileModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjectFileModel @end

@interface TFProjectFileModel : JSONModel

//    "project_type": 3,
//    "color": "",
//    "create_time": 1530850247944,
//    "file_name": "20180706121045951.mp3",
//    "library_type": "1",
//    "del_status": "0",
//    "employee_name": "请叫我娣娣",
//    "sort": "",
//    "suffix": ".mp3",
//    "type": 0,
//    "url": "project2/59/372/391/1530850247897.mp3",
//    "create_by": 4,
//    "size": 43351,
//    "data_id": 395,
//    "parent_id": 392,
//    "id": 396

@property (nonatomic, strong) NSNumber <Optional>*project_type;
@property (nonatomic, copy) NSString <Optional>*color;
@property (nonatomic, strong) NSNumber <Optional>*create_time;
@property (nonatomic, copy) NSString <Optional>*file_name;
@property (nonatomic, copy) NSString <Optional>*library_type;
@property (nonatomic, copy) NSString <Optional>*del_status;
@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, copy) NSString <Optional>*sort;
@property (nonatomic, copy) NSString <Optional>*suffix;
@property (nonatomic, strong) NSNumber <Optional>*type;
@property (nonatomic, copy) NSString <Optional>*url;
@property (nonatomic, strong) NSNumber <Optional>*create_by;
@property (nonatomic, strong) NSNumber <Optional>*size;
@property (nonatomic, strong) NSNumber <Optional>*data_id;
@property (nonatomic, strong) NSNumber <Optional>*parent_id;
@property (nonatomic, strong) NSNumber <Optional>*id;

@end
