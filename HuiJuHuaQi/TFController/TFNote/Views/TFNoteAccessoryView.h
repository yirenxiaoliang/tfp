//
//  TFNoteAccessoryView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFNoteAccessoryViewDelegate <NSObject>

@optional
-(void)noteAccessoryDidSelectedItem:(UIButton *)button AtIndex:(NSUInteger)index;

@end

@interface TFNoteAccessoryView : UIView

-(instancetype)initWithFrame:(CGRect)frame withImages:(NSArray *)images;

/** delegate */
@property (nonatomic, weak) id <TFNoteAccessoryViewDelegate>delegate;

/** check */
@property (nonatomic, assign) BOOL check;

/** num */
@property (nonatomic, assign) BOOL num;

@end
