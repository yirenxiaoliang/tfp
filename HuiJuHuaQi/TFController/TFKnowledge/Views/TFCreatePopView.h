//
//  TFCreatePopView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFCreatePopView : UIView

+(TFCreatePopView *)popViewWithPoint:(CGPoint)point knowledge:(void (^)(void))knowledge question:(void (^)(void))quetion;

-(void)dissmiss;

@end

NS_ASSUME_NONNULL_END
