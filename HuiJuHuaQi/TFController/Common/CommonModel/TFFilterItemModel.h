//
//  TFFilterItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TFFilterItemModel


@end

@interface TFFilterItemModel : JSONModel

/** type 0:钩选 1：输入 2：时间选择 3:两个输入框 4:弹框选 */
@property (nonatomic, strong) NSNumber <Optional>*type;

/** title */
@property (nonatomic, copy) NSString <Optional>*label;
/** title */
@property (nonatomic, copy) NSString <Optional>*color;
/** title */
@property (nonatomic, copy) NSString <Optional>*value;

/** content */
@property (nonatomic, copy) NSString <Optional>*content;

/** timeSp */
@property (nonatomic, strong) NSNumber <Optional>*timeSp;

/** selectState */
@property (nonatomic, strong) NSNumber <Optional>*selectState;

/** title */
@property (nonatomic, copy) NSString <Optional>*minValue;

/** title */
@property (nonatomic, copy) NSString <Optional>*maxValue;



@end
