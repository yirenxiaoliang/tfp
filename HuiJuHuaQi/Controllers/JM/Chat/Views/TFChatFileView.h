//
//  TFChatFileView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/5/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TFChatFileView : UIView

/** 刷新FileView */
-(void)refreshFileViewWithFileName:(NSString *)fileName fileSize:(NSInteger)fileSize isReceive:(BOOL)isReceive;

@end
