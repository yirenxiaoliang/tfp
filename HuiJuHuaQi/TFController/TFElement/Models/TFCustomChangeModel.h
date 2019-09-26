//
//  TFCustomChangeModel.h
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFCustomChangeModel 


@end

@interface TFCustomChangeModel : JSONModel

@property (copy, nonatomic) NSString <Optional>*id;
@property (copy, nonatomic) NSString <Optional>*title;

@property (strong, nonatomic) NSNumber <Ignore>*select;


@end
