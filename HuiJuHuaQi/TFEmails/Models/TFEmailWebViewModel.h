//
//  TFEmailWebViewModel.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFEmailWebViewHeadModel.h"

@interface TFEmailWebViewModel : JSONModel

//jo.put("head", getHeadJson());
//jo.put("html", htmlContent);
//jo.put("type", 1);
//jo.put("device", 0);

@property (nonatomic, strong) TFEmailWebViewHeadModel <Optional>*head;

//@property (nonatomic, copy) NSString <Optional>*head;

@property (nonatomic, copy) NSString <Optional>*html;

@property (nonatomic, strong) NSNumber <Optional>*type;

@property (nonatomic, strong) NSNumber <Optional>*device;

@property (nonatomic, strong) NSNumber <Optional>*width;

@end
