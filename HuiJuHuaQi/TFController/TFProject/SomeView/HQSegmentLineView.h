//
//  HQSegmentLineView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/7/28.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseView.h"

@protocol HQSegmentLineViewDelegate <NSObject>

- (void)didSegmentLineViewButtonNumber:(int)buttonNum;

@end


@interface HQSegmentLineView : HQBaseView


@property (nonatomic, weak) id <HQSegmentLineViewDelegate> delegate;


//初始化
- (instancetype)initWithFrame:(CGRect)frame
                     titleArr:(NSArray *)titleArr
                     delegate:(id <HQSegmentLineViewDelegate>)delegate;


@property (nonatomic, assign) NSInteger selectedSegmentIndex;


/**
 *  刷新所有红点状态
 *
 *  @param stateArr    所有红点状态数组，数组成员为红点数字
 */
- (void)refreshRedPointStateWithStateArr:(NSArray *)stateArr;



///**
// *  刷新单个红点状态
// *
// *  @param state    YES红点显示
// *  @param index    第几个标签
// */
//- (void)refreshRedPointStateWithState:(BOOL)state index:(NSInteger)index;



@end
