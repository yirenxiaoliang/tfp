//
//  TFFilterHeaderView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFFilterHeaderView;

@protocol TFFilterHeaderViewDelegate <NSObject>
@optional
-(void)filterHeaderViewDidClicked:(TFFilterHeaderView *)filterHeaderView;

@end

@interface TFFilterHeaderView : UIView

/** delegate */
@property (nonatomic, weak) id <TFFilterHeaderViewDelegate>delegate;

/** selected */
@property (nonatomic, assign) BOOL selected;

/** title */
@property (nonatomic, weak) UILabel *title;


@end
