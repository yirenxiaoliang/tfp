//
//  TFTaskLogItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/2.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFTaskLogContentModel.h"

@protocol TFTaskLogItemModel

@end

@interface TFTaskLogItemModel : JSONModel

/** 时间 */
@property (nonatomic, strong) NSNumber <Optional>*dateTime;

/** list */
@property (nonatomic, strong) NSArray <TFTaskLogContentModel,Optional>*datas;



@end
