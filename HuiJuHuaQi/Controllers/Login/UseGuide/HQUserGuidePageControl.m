//
//  HQUserGuidePageControl.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/8/22.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQUserGuidePageControl.h"

@implementation HQUserGuidePageControl


-(id) initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    
    return self;
    
}


-(void) updateDots
{
    for (int i=0; i<[self.subviews count]; i++) {
        
        UIImageView* dot = [self.subviews objectAtIndex:i];
        CGRect frame;
        frame.size.height = 7;
        frame.origin = dot.frame.origin;
        
        if (i == self.currentPage) {
            
            frame.size.width = 23;      //自定义圆点的大小
        }else {
            
            frame.size.width = 7;      //自定义圆点的大小
        }
        
        
        if (i >= 1) {
            
            UIImageView* twoDot = [self.subviews objectAtIndex:0];
            
            if (i > self.currentPage) {
                
                frame.origin.x = twoDot.left + 14 * i + 16;
            }else {
            
                frame.origin.x = twoDot.left + 14 * i;
            }
        }
        
//        NSLog(@"%f", frame.origin.x);
        
        
        [dot setFrame:frame];
    }
    
}

-(void)setCurrentPage:(NSInteger)page
{
    
    [super setCurrentPage:page];
    
    [self updateDots];
}


@end
