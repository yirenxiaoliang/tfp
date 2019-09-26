//
//  HQAdviceTextView.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/4.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQAdviceTextView : UITextView
/**
 * 提示文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 * 提示文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;



@end
