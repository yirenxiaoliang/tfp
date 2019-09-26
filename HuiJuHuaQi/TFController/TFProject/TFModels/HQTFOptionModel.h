//
//  HQTFOptionModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface HQTFOptionModel : JSONModel
/** 列表id */
@property (nonatomic, strong) NSNumber <Optional>*id;
/** 列表名称 */
@property (nonatomic, copy) NSString <Optional>*listName;
/** 是否公开: 0=仅列表成员可见;1=所有人可见 */
@property (nonatomic, strong) NSNumber <Optional>*isPublic;
/** 项目id */
@property (nonatomic, strong) NSNumber <Optional>*projectId;

/**负责人Id*/
@property (nonatomic, strong) NSNumber <Optional>*principalId;
/**负责人名称*/
@property (nonatomic, copy) NSString <Optional>*principalName;
/**负责人相片地址*/
@property (nonatomic, copy) NSString <Optional>*principalPhotograph;
/*负责人职位*/
@property (nonatomic, copy) NSString <Optional>*principalPosition;



@end
