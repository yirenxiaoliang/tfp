//
//  HQIndustryManager.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/28.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HQIndustryManager : NSObject

+ (instancetype)defaultIndustryManager;


@property (nonatomic, strong) NSMutableArray *industryArr;
/** 根据id找到行业 */
-(NSString *)industryWithIndustryId:(NSString *)industryId;
@end
