//
//  HQPageControl.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/8/9.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQPageControl : UIView

@property(nonatomic, assign) NSInteger numberOfPages;

@property(nonatomic, assign) NSInteger currentPage;
/** type 为0时最后一页为加号（+），为1时全部为灰点 */
@property(nonatomic, assign) NSInteger type;


@property (nonatomic, assign) BOOL special;

@end
