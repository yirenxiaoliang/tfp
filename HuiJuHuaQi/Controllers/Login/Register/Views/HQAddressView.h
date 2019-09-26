//
//  HQAddressPickView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureAddressBlock)(id result);

@interface HQAddressView : UIView

@property (nonatomic, copy) SureAddressBlock sureAddressBlock;

- (void)showView;
- (void)showViewWithComponents:(NSInteger)components selectRows:(NSArray *)selectRows;

- (void)cancelView;

@end
