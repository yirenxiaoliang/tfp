//
//  HQTFProgressView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ProgressViewMonth,
    ProgressViewSeason,
    ProgressViewYear
}HQTFProgressViewType;

@interface HQTFProgressView : UIView

/** 固定写法 type */
@property (nonatomic, assign) HQTFProgressViewType type;

+(instancetype)progressView;

/** 用于cell中 */
-(void)refreshProgressWithTotalTask:(NSInteger)total finish:(NSInteger)finish;

@end
