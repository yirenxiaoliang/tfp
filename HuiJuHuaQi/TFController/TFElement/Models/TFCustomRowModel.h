//
//  TFCustomRowModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFFieldNameModel.h"

@interface TFCustomRowModel : JSONModel

/** row1 */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel>*row1;

/** row2 */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel>*row2;

/** row3 */
@property (nonatomic, strong) NSArray <Optional,TFFieldNameModel>*row3;


@end
