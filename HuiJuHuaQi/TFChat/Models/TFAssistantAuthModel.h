//
//  TFAssistantAuthModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFAssistantAuthModel : JSONModel

//{
//    "moduleId" : 1,
//    "readAuth" : 0,
//    "del_status" : "0"
//}

/**  */
@property (nonatomic, strong) NSNumber <Optional>*moduleId;

/** 阅读权限 0:有 1:没有 */
@property (nonatomic, strong) NSNumber <Optional>*readAuth;

/** 数据是否还有 0:有 1:没有 */
@property (nonatomic, copy) NSString <Optional>*del_status;

@end
