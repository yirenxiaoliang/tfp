//
//  TFCustomDetailRefrenceModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFRelevanceTradeModel.h"
#import "TFFieldNameModel.h"

@interface TFCustomDetailRefrenceModel : JSONModel

/** isOpenProcess */
@property (nonatomic, strong) NSNumber <Optional>*isOpenProcess;

/** 关联模块 */
@property (nonatomic, strong) NSArray <TFRelevanceTradeModel,Optional>*refModules;

/** 页签数据 */
@property (nonatomic, strong) NSArray <TFRelevanceTradeModel,Optional>*dataList;

/** 标题名字 */
@property (nonatomic, strong) TFFieldNameModel <Optional>*operationInfo;


@end
