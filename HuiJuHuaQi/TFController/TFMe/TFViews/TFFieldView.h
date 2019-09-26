//
//  TFFieldView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFFieldView;
@protocol TFFieldViewDelegate <NSObject>

-(void)fieldViewClicked:(TFFieldView *)fieldView;

@end

@interface TFFieldView : UIView

/** delegate */
@property (nonatomic, weak) id <TFFieldViewDelegate>delegate;

/** selected */
@property (nonatomic, assign) BOOL selected;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

+ (instancetype)fieldView;

@end
