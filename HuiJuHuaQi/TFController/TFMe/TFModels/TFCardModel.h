//
//  TFCardModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface TFCardModel : JSONModel <NSCopying,NSMutableCopying>

/** choice_tenplate */
@property (nonatomic, copy) NSString <Optional>*choice_template;

/** card_template */
@property (nonatomic, copy) NSString <Optional>*card_template;

/** hide_set */
@property (nonatomic, copy) NSString <Optional>*hide_set;

@end
