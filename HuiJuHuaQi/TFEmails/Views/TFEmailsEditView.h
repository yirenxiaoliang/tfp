//
//  TFEmailsEditView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFEmailsEditViewDelegate <NSObject>

@optional
- (void)editViewHeight:(float)height type:(NSInteger)type;

//将输入的值传出去
- (void)editViewTextWithArray:(NSMutableArray *)textArr type:(NSInteger)type;

@end

@interface TFEmailsEditView : UIView

/** 1:接收人 2:抄送人 3:密送人 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isSelect;

- (BOOL)textFieldShouldReturn:(UITextField *)textField;

- (void)createTextField:(NSString *)text;

//+ (CGFloat)refreshEditViewHeight;

@property (nonatomic, weak) id <TFEmailsEditViewDelegate>delegate;

@end
