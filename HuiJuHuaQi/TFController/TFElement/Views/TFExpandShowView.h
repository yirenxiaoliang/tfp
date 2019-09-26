//
//  TFExpandShowView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/9.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFExpandShowViewDelegate <NSObject>

@optional
-(void)expandShowViewDidClicked;

@end

@interface TFExpandShowView : UIView

+ (instancetype)expandShowView;

@property (nonatomic, weak) id <TFExpandShowViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
