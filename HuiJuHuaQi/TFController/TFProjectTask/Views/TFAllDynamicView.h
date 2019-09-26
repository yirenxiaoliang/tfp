//
//  TFAllDynamicView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TFAllDynamicView;
@protocol TFAllDynamicViewDelegate <NSObject>

@optional
-(void)allDynamicView:(TFAllDynamicView *)view didClickedArrow:(UIButton *)arrow;

@end

@interface TFAllDynamicView : UIView

+(instancetype)allDynamicView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) id <TFAllDynamicViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
