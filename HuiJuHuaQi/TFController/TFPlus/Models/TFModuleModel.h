//
//  TFModuleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFModuleModel : JSONModel

/**
 "icon" : null,
 "createTime" : 1495715028756,
 "id" : 1110,
 "updateTime" : null,
 "descr" : "项目协作管理，任务进度跟进",
 "moduleStatus" : 0,
 "isFront" : 1,
 "pageUrl" : "task_page",
 "createDate" : null,
 "disabled" : null,
 "name" : "任务" */

/** icon */
@property (nonatomic, copy) NSString<Optional> *icon;
/** descr */
@property (nonatomic, copy) NSString<Optional> *descr;
/** pageUrl */
@property (nonatomic, copy) NSString<Optional> *pageUrl;
/** name */
@property (nonatomic, copy) NSString<Optional> *name;
/** createTime */
@property (nonatomic, strong) NSNumber<Optional> *createTime;
/** id */
@property (nonatomic, strong) NSNumber<Optional> *id;
/** moduleStatus */
@property (nonatomic, strong) NSNumber<Optional> *moduleStatus;
/** isFront */
@property (nonatomic, strong) NSNumber<Optional> *isFront;



@end
