//
//  TFHighseaModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFHighseaModel : JSONModel

/** id */
@property (nonatomic, strong) NSNumber <Optional>*id;

/** title */
@property (nonatomic, copy) NSString <Optional>*title;

/** id */
@property (nonatomic, strong) NSNumber <Ignore>*open;


@end
