//
//  TFStatisticsItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TFStatisticsItemView;
@protocol TFStatisticsItemViewDelegate <NSObject>

@optional
-(void)statisticsItemViewClicked:(TFStatisticsItemView *)view;

@end

@interface TFStatisticsItemView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic, weak) id <TFStatisticsItemViewDelegate>delegate;

+(instancetype)statisticsItemView;
@end

NS_ASSUME_NONNULL_END
