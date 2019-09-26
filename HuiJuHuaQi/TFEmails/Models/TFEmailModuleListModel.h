//
//  TFEmailModuleListModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFEmailModuleListModel : JSONModel

//{
//    "chinese_name": "邮箱",
//    "data_auth": 2,
//    "id": 2,
//    "english_name": "bean1521617035088"
//}

@property (nonatomic, copy) NSString <Optional>*chinese_name;

@property (nonatomic, strong) NSNumber <Optional>*data_auth;

@property (nonatomic, strong) NSNumber <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*english_name;

@end
