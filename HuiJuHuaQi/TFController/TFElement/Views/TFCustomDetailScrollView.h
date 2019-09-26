//
//  TFCustomDetailScrollView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFRelevanceTradeModel.h"

@protocol TFCustomDetailScrollViewDelegate <NSObject>

@optional
-(void)customDetailScrollViewDidClickedWithModel:(TFRelevanceTradeModel *)model;

@end

@interface TFCustomDetailScrollView : UIScrollView

-(void)refreshScrollViewWithItems:(NSArray *)items type:(NSInteger)type;

/** line */
@property (nonatomic, strong) UIView *line;

/** delegate */
@property (nonatomic, weak) id <TFCustomDetailScrollViewDelegate>delegate1;

@end
