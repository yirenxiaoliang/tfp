//
//  TFTaskLogContentModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseVoModel.h"

@protocol TFTaskLogContentModel 

@end

@interface TFTaskLogContentModel : HQBaseVoModel

/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*employeeName;
/** 员工名 */
@property (nonatomic, copy) NSString <Optional>*position;
/** 头像 */
@property (nonatomic, copy) NSString <Optional>*photograph;
/** 创建人id */
@property (nonatomic, strong) NSNumber <Optional>*employeeId;
/** 内容 */
@property (nonatomic, copy) NSString <Optional>*content;
/** 创建时间 */
@property (nonatomic, strong) NSNumber <Optional>*createTime;


@end
