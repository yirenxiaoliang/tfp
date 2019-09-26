//
//  TFModalListView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFModalListViewDelegate <NSObject>

@optional
- (void)siftModuleListWithData:(NSInteger)index;

@end

@interface TFModalListView : UIView

@property (nonatomic, weak) id <TFModalListViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSMutableArray *)items;

@end
