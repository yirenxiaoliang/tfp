//
//  TFSearchTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBeanTypeModel.h"
#import "TFAutoMatchRuleModel.h"

@protocol TFSearchTableViewDelegate <NSObject>

@optional
//-(void)searchTableViewDidSelectIndex:(NSInteger)index withText:(NSString *)text;
-(void)searchTableViewDidClickedBackgruod;
-(void)searchTableViewDidSelectModel:(TFBeanTypeModel *)model;
-(void)searchTableViewDidSelectAutoModel:(TFAutoMatchRuleModel *)model;


@end


@interface TFSearchTableView : UIView

/** delegate */
@property (nonatomic, weak) id <TFSearchTableViewDelegate>delegate;

/** 显示 */
-(void)showAnimation;
/** 隐藏 */
-(void)hideAnimationWithCompletion:(void(^)(BOOL finish))completion;

/** 刷新 */
-(void)refreshSearchTableViewWithItems:(NSArray *)items;
/** 刷新 0:自定义 1:自动匹配 */
-(void)refreshSearchTableViewWithItems:(NSArray *)items type:(NSInteger)type;


@end
