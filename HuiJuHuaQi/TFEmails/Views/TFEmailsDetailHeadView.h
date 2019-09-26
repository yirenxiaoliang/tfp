//
//  TFEmailsDetailHeadView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEmailDetailModel.h"

@protocol TFEmailsDetailHeadViewDelegate <NSObject>

@optional

- (void)hideEmailDetailHeadInfo;

@end

@interface TFEmailsDetailHeadView : UIView

- (void)refreshEmailHeadViewWithModel:(TFEmailDetailModel *)model;

+ (instancetype)emailsDetailHeadView;

@property (nonatomic, weak) id <TFEmailsDetailHeadViewDelegate>delegate;

@end
