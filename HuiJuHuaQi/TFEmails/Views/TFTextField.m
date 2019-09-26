//
//  TFTextField.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTextField.h"

@implementation TFTextField

- (void)deleteBackward {
    //！！！这里要调用super方法，要不然删不了东西
    [super deleteBackward];
    
    if ([self.tf_delegate respondsToSelector:@selector(tfTextFieldDeleteBackward:)]) {
        [self.tf_delegate tfTextFieldDeleteBackward:self];
    }
}
@end
