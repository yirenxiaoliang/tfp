//
//  TFCustomListItemModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "TFFieldNameModel.h"
#import "TFCustomRowModel.h"

@protocol TFCustomListItemModel

@end


@interface TFCustomListItemModel : JSONModel

/** 颜色 */
@property (nonatomic, copy) NSString <Optional>*color;

/** id */
@property (nonatomic, strong) TFFieldNameModel <Optional>*id;

/** row */
@property (nonatomic, strong) TFCustomRowModel <Optional>*row;

/** select 0:不选择 1：选择 */
@property (nonatomic, strong) NSNumber <Ignore>*select;

/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_color;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_type;
/** icon_color */
@property (nonatomic, copy) NSString <Optional>*icon_url;
/** moduleName */
@property (nonatomic, copy) NSString <Optional>*moduleName;



@end
