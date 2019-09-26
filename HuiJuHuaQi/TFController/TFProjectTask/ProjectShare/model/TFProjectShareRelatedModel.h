//
//  TFProjectShareRelatedModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFProjectShareRelatedModel : JSONModel

//    "projectId":1,                        //项目id
//    "relation_id":2,                      //被引用记录编号，多个使用英文的逗号隔开
//    "module_id":2,                        //被引用模块
//    "module_name":memo,                   //被引用模块的名称
//    "bean_name":1,                        //被引用模块bean
//    "bean_type": 22                       //被引用bean类型 1备忘录 2任务 3自定义 4 审批
//    "share_id": 22                        //分享记录编号

@property (nonatomic, strong) NSNumber *projectId;
@property (nonatomic, copy) NSString *relation_id;
@property (nonatomic, strong) NSNumber *module_id;
@property (nonatomic, copy) NSString *module_name;
@property (nonatomic, copy) NSString *bean_name;
@property (nonatomic, strong) NSNumber *bean_type;
@property (nonatomic, strong) NSNumber *share_id;

@end
