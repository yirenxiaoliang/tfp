//
//  TFEmailsBottomView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFEmailsBottomViewDelegate <NSObject>

@optional

- (void)emailBottomButtonClicked:(NSInteger)buttonIndex;

@end

@interface TFEmailsBottomView : UIView

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) NSArray *images;

- (instancetype)initWithBottomViewFrame:(CGRect)frame labs:(NSArray *)labes image:(NSArray *)images;

@property (nonatomic, weak) id <TFEmailsBottomViewDelegate>delegate;

- (void)refreshButtonTitle:(NSString *)title index:(NSInteger)index;

@end
