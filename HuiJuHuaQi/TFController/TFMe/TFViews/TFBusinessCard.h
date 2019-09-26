//
//  TFBusinessCard.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFBusinessCard : UIView

+ (instancetype)businessCard;
-(void)refreshViewWithStyle:(NSInteger)style hiddens:(NSArray *)hiddens;
@end
