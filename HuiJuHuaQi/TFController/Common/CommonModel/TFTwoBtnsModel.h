//
//  TFTwoBtnsModel.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TFTwoBtnsModel

@end

@interface TFTwoBtnsModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 字体 */
@property (nonatomic, strong) UIFont *font;
/** 颜色 */
@property (nonatomic, strong) UIColor *color;
/** 图片名字 */
@property (nonatomic, copy) NSString *image;

@end

