//
//  HQWorkDetailTextView.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/10.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQWorkDetailTextView : UITextView

/**
 * 提示文字
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 * 提示文字的颜色
 */
@property (nonatomic, strong) UIColor *placeholderColor;


/**
 * 最大字符数
 */
@property (nonatomic, assign) NSInteger maxCharNum;


/**
 * 最大字数
 */
@property (nonatomic, assign) NSInteger maxTextNum;


@end
