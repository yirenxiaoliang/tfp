//
//  TFTitleView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFTitleViewDelegate <NSObject>

@optional
-(void)titleViewClickedWithSelect:(BOOL)select;

@end

@interface TFTitleView : UIView

- (void)refreshTitleViewWithTitle:(NSString *)title;

/** selected */
@property (nonatomic, assign) BOOL selected;

/** delegate */
@property (nonatomic, weak) id <TFTitleViewDelegate>delegate;

@end
