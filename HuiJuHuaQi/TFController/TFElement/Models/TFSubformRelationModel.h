//
//  TFSubformRelationModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFSubformRelationModel <NSObject>

@end

@interface TFSubformRelationModel : JSONModel

@property (nonatomic, copy) NSString <Optional>*controlField;

@property (nonatomic, copy) NSString <Optional>*title;

@end

NS_ASSUME_NONNULL_END
