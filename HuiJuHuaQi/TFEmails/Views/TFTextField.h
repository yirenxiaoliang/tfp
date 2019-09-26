//
//  TFTextField.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFTextField;



@protocol TFTextFieldDelegate <NSObject>

- (void)tfTextFieldDeleteBackward:(TFTextField *)textField;

@end

@interface TFTextField : UITextField

@property (nonatomic, assign) id <TFTextFieldDelegate> tf_delegate;

@end
