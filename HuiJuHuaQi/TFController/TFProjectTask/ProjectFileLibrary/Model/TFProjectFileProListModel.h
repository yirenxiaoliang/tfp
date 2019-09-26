//
//  TFProjectFileProListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFProjectFileProListModel @end

@interface TFProjectFileProListModel : JSONModel

//{
//    "data_id": 155,
//    "file_name": "项目流程",
//    "library_type": "0",
//    "id": 200
//}

@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, strong) NSNumber <Optional>*data_id;
@property (nonatomic, copy) NSString <Optional>*file_name;
@property (nonatomic, copy) NSString <Optional>*library_type;

@end
