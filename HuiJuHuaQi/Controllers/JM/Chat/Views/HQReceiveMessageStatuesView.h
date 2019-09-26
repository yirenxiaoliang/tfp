//
//  HQReceiveMessageStatuesView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger , HQReceiveMessageStatuesViewStyle){
    HQReceiveMessageStatuesViewStyleNormal,
    HQReceiveMessageStatuesViewStyleNoConnect,
    HQReceiveMessageStatuesViewStyleConnecting,
    HQReceiveMessageStatuesViewStyleReceiving
};

@interface HQReceiveMessageStatuesView : UIView

/** style */
@property (nonatomic, assign) HQReceiveMessageStatuesViewStyle style;

@property (nonatomic, strong) UIColor *color;

/** activity的类型 */
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityType;


@end
