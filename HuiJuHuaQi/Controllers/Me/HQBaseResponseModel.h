//
//  HQBaseResponseModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/10/27.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQResponseModel.h"

@interface HQBaseResponseModel : JSONModel

/**
 * 响应
 */
@property (nonatomic , strong) HQResponseModel <Optional> *response;
@end
