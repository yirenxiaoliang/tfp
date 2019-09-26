//
//  TFCustomPageModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"

@protocol TFCustomPageModel

@end

@interface TFCustomPageModel : JSONModel

/** 总页数 */
@property (nonatomic, strong) NSNumber <Optional>*totalPages;

/** 总行数 */
@property (nonatomic, strong) NSNumber <Optional>*totalRows;

/** 一页多少条 */
@property (nonatomic, strong) NSNumber <Optional>*pageSize;

/** 当前页数量 */
@property (nonatomic, strong) NSNumber <Optional>*curPageSize;

/** 第几页 */
@property (nonatomic, strong) NSNumber <Optional>*pageNum;



@end
