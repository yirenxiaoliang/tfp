//
//  TFProjectPricipalModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/5/31.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQEmployModel.h"


@protocol TFProjectPricipalModel
@end

@interface TFProjectPricipalModel : HQEmployModel

/** 头像 */
@property (nonatomic, copy) NSString <Optional>*principalPhotograph;
/** 位置 */
@property (nonatomic, copy) NSString <Optional>*principalPosition;
/** 名字 */
@property (nonatomic, copy) NSString <Optional>*principalName;
/** id */
@property (nonatomic, strong) NSNumber <Optional>*principalId;


///** 是否是负责人: 0=是=1否*/
//@property (nonatomic, strong) NSNumber <Optional>*isPrincipal;
///**是否是创建人: 0=是=1否*/
//@property (nonatomic, strong) NSNumber <Optional>*isCreator;
/** 任务数量 */
@property (nonatomic, strong) NSNumber <Optional>*taskCount;



@end
