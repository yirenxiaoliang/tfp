//
//  TFEmailNameView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFEmailNameViewDelegate <NSObject>

@optional
- (void)editViewHeight:(float)height type:(NSInteger)type;

//将输入的值传出去
- (void)editViewTextWithArray:(NSMutableArray *)textArr type:(NSInteger)type;

@end

@interface TFEmailNameView : UIView

/** 1:接收人 2:抄送人 3:密送人 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, weak) id <TFEmailNameViewDelegate>delegate;

/** 添加人员 */
-(void)addPeoples:(NSArray *)peoples;

@end
