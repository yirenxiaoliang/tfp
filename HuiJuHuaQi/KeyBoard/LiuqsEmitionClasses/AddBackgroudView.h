//
//  AddBackgroudView.h
//  LiuqsEmoticonkeyboard
//
//  Created by HQ-20 on 2017/12/14.
//  Copyright © 2017年 刘全水. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AddBackgroudView;
@protocol AddBackgroudViewDelegate <NSObject>

@optional
- (void)addBackgroudView:(AddBackgroudView *)addBackgroudView didSelectIndex:(NSInteger)index;

@end

@interface AddBackgroudView : UIScrollView

/** delegate */
@property (nonatomic, weak) id <AddBackgroudViewDelegate>delegate1;

-(instancetype)initWithType:(NSInteger)type;

@end
