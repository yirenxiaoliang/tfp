//
//  TFTaskFilterView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFTaskFilterViewDelegate<NSObject>
@optional
- (void)taskFilterViewClickedSortBtn;
- (void)taskFilterViewClickedHandleBtn;


@end

@interface TFTaskFilterView : UIView

/** delegate */
@property (nonatomic, weak) id <TFTaskFilterViewDelegate>delegate;

+ (instancetype)taskFilterView;

- (void)showAnimation;
- (void)hideAnimation;
@end
