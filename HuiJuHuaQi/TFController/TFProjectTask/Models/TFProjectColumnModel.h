//
//  TFProjectColumnModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "TFProjectSectionModel.h"

@interface TFProjectColumnModel : JSONModel

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;

/** name */
@property (nonatomic, copy) NSString <Optional>*name;

/** subnodeArr */
@property (nonatomic, strong) NSMutableArray <TFProjectSectionModel , Optional>*subnodeArr;

/** level 层级数 */
@property (nonatomic, copy) NSString <Optional>*level;
/** flow_id */
@property (nonatomic, copy) NSString <Optional>*flow_id;
/** hidden:隐藏 */
@property (nonatomic, copy) NSString <Ignore>*hidden;

@end
