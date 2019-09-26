//
//  HQBaseNavigationController.h
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/5.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQBaseNavigationController : UINavigationController

@property (strong ,nonatomic) NSMutableArray *arrayScreenshot;
#if kUseScreenShotGesture
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
#endif

-(void)popController;



@end
