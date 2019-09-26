//
//  TFTabBarView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/10.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TFTabBarView;
@protocol TFTabBarViewDelegate <NSObject>

@optional
- (void)tabBarView:(TFTabBarView *)tabBarView didSelectIndex:(NSInteger)index;

@end


@interface TFNumButton : UIButton

@end

@protocol TFNumIndex

@end

@interface TFNumIndex : JSONModel

@property (nonatomic , strong) NSNumber <Optional>*type;
@property (nonatomic , strong) NSNumber <Optional>*count;


@end


@interface TFTabBarView : UIView

/** 初始化方法 
 *  @pragma titles 标题数组
 */
-(instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

/** delegate */
@property (nonatomic, weak) id <TFTabBarViewDelegate>delegate;

/** selectIndex */
@property (nonatomic, assign) NSInteger selectIndex;

- (void)refreshNumWithNumbers:(NSArray <TFNumIndex> *)numbers;

@end
