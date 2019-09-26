//
//  TFStyleModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFStyleModel : JSONModel

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;

/** styleId */
@property (nonatomic, strong) NSNumber <Optional>*styleId;

/** url */
@property (nonatomic, strong) NSString <Optional>*url;

/** select */
@property (nonatomic, strong) NSNumber <Ignore>*select;

@end
