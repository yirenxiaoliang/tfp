//
//  HQBaseListModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/10/27.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "JSONModel.h"
#import "HQBaseResponseModel.h"

@interface HQBaseListModel : HQBaseResponseModel

/**
 * 总页数
 */
@property (nonatomic , strong) NSNumber <Optional>*totalPages;
/**
 * 总行数
 */
@property (nonatomic , strong) NSNumber <Optional>*totalRows;
/**
 * 当前页数量
 */
@property (nonatomic , strong) NSNumber <Optional>*curPageSize;
/**
 * 一页数量
 */
@property (nonatomic , strong) NSNumber <Optional>*pageSize;
/**
 * 第几页
 */
@property (nonatomic , strong) NSNumber <Optional>*pageNum;



@end
