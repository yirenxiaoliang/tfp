//
//  TFEnterItemView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFWorkNumButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFEnterItemViewDelegate <NSObject>

@optional
-(void)enterItemViewDidClickedIndex:(NSInteger)inddex;

@end

@interface TFEnterItemView : UIView


@property (nonatomic, strong) NSArray *items;

/** 高度 */
+(CGFloat)enterItemViewHeightWithItems:(NSArray *)items;

@property (nonatomic, weak) id <TFEnterItemViewDelegate>delegate;

-(void)refreshNums:(NSArray *)nums;

@end

NS_ASSUME_NONNULL_END
