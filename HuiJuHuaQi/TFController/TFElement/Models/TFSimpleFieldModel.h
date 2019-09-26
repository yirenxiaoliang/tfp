//
//  TFSimpleFieldModel.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/8.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol TFSimpleFieldModel

@end


@interface TFSimpleFieldModel : JSONModel

/** 时间格式类型：yyyy-MM-dd */
@property (nonatomic, copy) NSString <Optional>*formatType;

/** 数字类型：0数字、1整数、2百分比 */
@property (nonatomic, copy) NSString <Optional>*numberType;
/** 小数位：0~4位 */
@property (nonatomic, copy) NSString <Optional>*numberLenth;
/** 公式小数位：0~4位 */
@property (nonatomic, copy) NSString <Optional>*decimalLen;
/** 时间格式 */
@property (nonatomic, copy) NSString <Optional>*chooseType;
/** 分割位数 '0':无分隔符，'1':千分位，'2':万分位 */
@property (nonatomic, copy) NSString <Optional>*numberDelimiter;


@end

NS_ASSUME_NONNULL_END
