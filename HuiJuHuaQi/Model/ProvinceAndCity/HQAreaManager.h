//
//  HQAreaManager.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/5/30.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQAreaManager : NSObject


+ (instancetype)defaultAreaManager;


@property (nonatomic, strong) NSMutableArray *provinceArr;
@property (nonatomic, strong) NSMutableArray *provinceDicts;

@property (nonatomic, strong) NSMutableArray *cityArr;
@property (nonatomic, strong) NSMutableArray *cityDicts;

@property (nonatomic, strong) NSMutableArray *areaArr;
@property (nonatomic, strong) NSMutableArray *areaDicts;



/** 根据id找到地区 */
-(NSString *)regionWithRegionId:(NSString *)regionId;

/** 获取地址 */
-(NSString *)regionWithRegionData:(NSString *)regionData;

@end
