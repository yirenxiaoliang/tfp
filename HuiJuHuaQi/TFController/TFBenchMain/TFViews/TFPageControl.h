//
//  TFPageControl.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFPageControlDelegate <NSObject>

@optional
-(void)pageControlDidClickedWithIndex:(NSInteger)index;

@end

@interface TFPageControl : UIView

@property (nonatomic, assign) NSInteger index;

@property(nonatomic, assign) NSInteger numberOfPages;

@property(nonatomic, assign) NSInteger currentPage;

@property (nonatomic, weak) id <TFPageControlDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
