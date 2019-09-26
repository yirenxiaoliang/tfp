//
//  TFChatCustomView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/7/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFChatCustomModel.h"

@interface TFChatCustomView : UIView

-(void)refreshCustomViewWithModel:(TFChatCustomModel *)model isReceive:(BOOL)isReceive;

@end
