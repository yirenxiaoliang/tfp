//
//  TFVideoModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/25.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFVideoModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*title;
@property (nonatomic, copy) NSString <Optional>*url;

@end

NS_ASSUME_NONNULL_END
