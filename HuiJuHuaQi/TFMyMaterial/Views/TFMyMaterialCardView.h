//
//  TFMyMaterialCardView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFEmpInfoModel.h"

@protocol TFMyMaterialCardViewDelegate <NSObject>

@optional
- (void)editPersonalMaterial;

- (void)editPersonalSign;

- (void)zanClicked;

@end

@interface TFMyMaterialCardView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)refreshCardViewWithData:(TFEmpInfoModel *)model;

@property (nonatomic, weak) id <TFMyMaterialCardViewDelegate>delegate;

@end
