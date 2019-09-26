//
//  TFTaskHybirdDynamicModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFTaskHybirdDynamicModel : JSONModel


/**
 "sign_id" : 10012,
 "employee_id" : 12,
 "information" : "[{\"file_url\":\"\/common\/file\/download?bean=project_task_dynamic&fileName=1\/common\/1557978357528\/201905161146020.jpg&fileSize=64239\",\"upload_time\":1557978357525,\"file_type\":\"jpg\",\"file_name\":\"201905161146020.jpg\",\"serial_number\":1,\"original_file_name\":\"201905161146020.jpg\",\"upload_by\":\"苹果\",\"file_size\":64239}]",
 "id" : 524,
 "content" : "",
 "picture" : "\/common\/file\/imageDownload?bean=company&fileName=12\/image\/1557280195098\/blob&fileSize=5776",
 "relation_id" : 109,
 "create_time" : 1557978358423,
 "employee_name" : "苹果",
 "dynamic_type" : 1
 */

@property (nonatomic, strong) NSNumber <Optional>*sign_id;
@property (nonatomic, strong) NSNumber <Optional>*employee_id;
@property (nonatomic, strong) NSArray <Optional,TFFileModel>*information;
@property (nonatomic, strong) NSNumber <Optional>*id;
@property (nonatomic, copy) NSString <Optional>*content;
@property (nonatomic, copy) NSString <Optional>*picture;
@property (nonatomic, copy) NSString <Optional>*employee_name;
@property (nonatomic, strong) NSNumber <Optional>*relation_id;
@property (nonatomic, strong) NSNumber <Optional>*create_time;
/** 0：全部，1评论，2查看状态，3操作日志 */
@property (nonatomic, strong) NSNumber <Optional>*dynamic_type;

/** show */
@property (nonatomic, strong) NSNumber <Ignore>*show;

@end

NS_ASSUME_NONNULL_END
