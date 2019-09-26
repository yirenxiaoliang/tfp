//
//  TFProjectHandleView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFProjectHandleViewDelegate <NSObject>

@optional
-(void)projectHandleViewDidClickedIndex:(NSInteger)index btn:(UIButton *)btn;

@end

@interface TFProjectHandleView : UIView

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id <TFProjectHandleViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
