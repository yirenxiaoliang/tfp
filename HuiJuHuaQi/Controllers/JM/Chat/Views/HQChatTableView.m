//
//  HQChatTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/11/24.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQChatTableView.h"

@implementation HQChatTableView

@dynamic delegate;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.delegate conformsToProtocol:@protocol(HQChatTableViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [self.delegate tableView:self touchesBegan:touches withEvent:event];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
