//
//  TFBasicsItemModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFBasicsItemModel @end

@interface TFBasicsItemModel : JSONModel

//"basics" : {
    //        "name" : "BHB",
    //        "type" : "1"
    //    },

@property (nonatomic, copy) NSString <Optional>*name;

@property (nonatomic, copy) NSString <Optional>*type;

@end
