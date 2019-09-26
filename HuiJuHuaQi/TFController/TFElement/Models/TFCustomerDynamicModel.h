//
//  TFCustomerDynamicModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFCustomerCommentModel.h"

@interface TFCustomerDynamicModel : JSONModel

/** timeList */
@property (nonatomic, strong) NSArray <TFCustomerCommentModel,Optional>*timeList;
/** timeDate */
@property (nonatomic, copy) NSString <Optional>*timeDate;


@end
