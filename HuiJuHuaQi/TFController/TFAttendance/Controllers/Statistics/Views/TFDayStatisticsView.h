//
//  TFDayStatisticsView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFAttendanceStatisticsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFDayStatisticsViewDelegate <NSObject>

@optional
-(void)dayStatisticsViewDidClickedWithIndex:(NSInteger)index;

@end

@interface TFDayStatisticsView : UIView

@property (nonatomic, weak) id <TFDayStatisticsViewDelegate>delegate;

-(void)refreshViewWithStatasticsModel:(TFAttendanceStatisticsModel *)model;

+(instancetype)dayStatisticsView;
@end

NS_ASSUME_NONNULL_END
