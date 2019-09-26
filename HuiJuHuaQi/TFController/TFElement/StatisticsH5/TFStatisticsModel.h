//
//  TFStatisticsModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/31.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface TFValueModel : JSONModel

/** value */
@property (nonatomic, strong) NSNumber *value;

/** name */
@property (nonatomic, copy) NSString *name;

/** 数据源 */
@property (nonatomic, strong) NSArray *data;

/** 平滑 */
@property (nonatomic, assign) BOOL smooth;

@end

@interface TFStatisticsModel : JSONModel

/**  饼状图
 var value = {
 title:'站点数据来源',
 series: [
 { value: 335, name: '直接访问' },
 { value: 310, name: '邮件营销' },
 { value: 234, name: '联盟广告' },
 { value: 135, name: '视频广告' },
 { value: 1548, name:'搜索引擎'}
 ]
 }; */

/** 条状图
 var barValue = {
 title:'站点数据来源',
 yAxis:['巴西','印尼','美国','印度','中国','世界人口(万)'],
 series: [
 { value: [18203, 23489, 29034, 104970, 131744, 630230], name: '2011年' },
 { value: [19325, 23438, 31000, 121594, 134141, 681807], name: '2012年'}
 ]
 }; */


/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 数据源 */
@property (nonatomic, strong) NSArray *series;

/** x轴 */
@property (nonatomic, strong) NSArray *xAxis;
/** y轴 */
@property (nonatomic, strong) NSArray *yAxis;

@end
