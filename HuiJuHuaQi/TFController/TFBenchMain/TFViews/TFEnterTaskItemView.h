//
//  TFEnterTaskItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFEnterTaskItemViewDelegate <NSObject>

@optional
-(void)enterTaskItemViewClickedWithIndex:(NSInteger)index;


@end

@interface TFEnterTaskItemView : UIView
/** 类型 0：超期任务 1：今日要做 2：明日要做 3：以后要做 */
@property (nonatomic, assign) NSInteger type;
/** 任务数量 */
@property (nonatomic, assign) NSInteger taskNum;

+(instancetype)enterTaskItemView;


@property (nonatomic, weak) id <TFEnterTaskItemViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
