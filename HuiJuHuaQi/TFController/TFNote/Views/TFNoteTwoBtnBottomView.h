//
//  TFNoteTwoBtnBottomView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFNoteTwoBtnBottomViewDelegate <NSObject>

@optional

//左侧菜单
- (void)bottomViewForLeftMenu;

//新增备忘录
- (void)newNote;

@end

@interface TFNoteTwoBtnBottomView : UIView

+ (instancetype)noteTwoBtnBottomView;

- (void)refreshNoteTwoBtnBottomViewWithType:(NSInteger)count;

@property (nonatomic, weak) id <TFNoteTwoBtnBottomViewDelegate>delegate;

@end
