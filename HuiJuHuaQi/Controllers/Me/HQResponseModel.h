//
//  HQResponseModel.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/2/25.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@interface HQResponseModel : JSONModel

@property (nonatomic, strong) NSNumber <Optional>*code;

@property (nonatomic, copy) NSString <Optional> *describe;

//myResponse =     {
//    code = 0;
//    describe = "";
//};

@end
