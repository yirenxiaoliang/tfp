//
//  TFAddFileModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAddFileModel : JSONModel

//{
//    "name":"子级测试",  名称
//    "color":"#CCCC",   颜色
//    "type":0,     // 0 公有 1私有
//    "style":1,       目录 1 公司文件 2 应用文件 3 个人 4 我共享 与我共享
//    "manage_by":"1", 管理员
//    "member_by":"",  成员
//    "parent_id":8   子级传父ID
//}

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*color;

@property (nonatomic, copy) NSString <Optional>*type;

@property (nonatomic, strong) NSNumber <Optional>*style;

@property (nonatomic, copy) NSString <Optional>*manage_by;

@property (nonatomic, copy) NSString <Optional>*member_by;

@property (nonatomic, copy) NSString <Optional>*parent_id;

@end
