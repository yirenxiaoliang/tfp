//
//  TFEndlessView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFEndlessView : UIView

-(void)refreshEndlessViewWithImages:(NSArray *)images;


/** 有没有边框 */
@property (nonatomic, assign) BOOL isBorder;

@end
