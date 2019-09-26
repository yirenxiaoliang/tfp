//
//  TFSubformSectionView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFSubformSectionView;
@protocol TFSubformSectionViewDelegate <NSObject>

@optional
-(void)subformSectionView:(TFSubformSectionView *)subformSectionView didClickedDeleteBtn:(UIButton *)button;

@end

@interface TFSubformSectionView : UIView

/** titleLabel */
@property (nonatomic, weak) UILabel *titleLabel;

/** deleteBtn */
@property (nonatomic, weak) UIButton *deleteBtn;


+(instancetype)subformSectionView;

/** delegate */
@property (nonatomic, weak) id <TFSubformSectionViewDelegate>delegate;

/** isEdit */
@property (nonatomic, assign) BOOL isEdit;

@end
