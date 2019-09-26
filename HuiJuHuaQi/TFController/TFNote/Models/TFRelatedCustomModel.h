//
//  TFRelatedCustomModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/9/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFRelatedCustomModel : JSONModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *icon_url;
@property (nonatomic, copy) NSString *icon_color;
@property (nonatomic, copy) NSString *icon_type;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *name;

@end
