//
//  TFEmailsHeadView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFEmailsHeadViewDelegate <NSObject>

@optional

- (void)markAllEmailsReaded;

@end

@interface TFEmailsHeadView : UIView

/**  */
@property (nonatomic, strong) UILabel *titleLab;

/** 数量 */
@property (nonatomic, strong) UILabel *numsLab;

/** 标记为已读 */
@property (nonatomic, strong) UIButton *flagBtn;

- (instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic, weak) id <TFEmailsHeadViewDelegate>delegate;

- (void)refreshEmailsHeadViewWithData:(NSString *)title number:(NSInteger)number type:(NSInteger)type;

@end
