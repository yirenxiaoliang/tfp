//
//  HQSearchView.h
//  HuiJuHuaQi
//
//  Created by XieLB on 16/8/31.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQSearchView : UIView

/** 线 */
@property (nonatomic, weak) UIView *line;
/** searchTextFiled */
@property (nonatomic, weak) UITextField *searchTextFiled;


- (instancetype)initViewWithFrame:(CGRect)frame
                textFiledDelegate:(id)delegate;

@end
