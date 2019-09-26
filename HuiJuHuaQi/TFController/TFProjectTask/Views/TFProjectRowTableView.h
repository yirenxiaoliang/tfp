//
//  TFProjectRowTableView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFProjectRowTableViewDelegate<NSObject>

@optional
-(void)projectRowTableViewDidRowIndex:(NSInteger)rowIndex;
-(void)projectRowTableViewDidEmpty;

@end

@interface TFProjectRowTableView : UIView

/** delegate */
@property (nonatomic, weak) id <TFProjectRowTableViewDelegate>delegate;

-(void)refreshProjectRowTableViewWithRows:(NSArray *)rows;
- (void)hiddenAnimation;
- (void)showAnimation;
@end
