//
//  AddItemButton.h
//  LiuqsEmoticonkeyboard
//
//  Created by HQ-20 on 2017/12/14.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddItemButton : UIButton


/** 图片的比例 默认为0.6 从0--0.6*/
@property (nonatomic, assign) CGFloat scale;
/** 文字距离顶部比例 默认0.6  从0.6--底部 */
@property (nonatomic, assign) CGFloat wordScale;

/** 创建button */
+ (instancetype)rootButton;

@end
