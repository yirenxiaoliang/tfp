//
//  TFCRMSearchView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFCRMSearchViewDelegate <NSObject>

@optional
-(void)crmSearchViewDidClicked:(BOOL)open;
-(void)crmSearchViewDidFilterBtn:(BOOL)show;

@end


@interface TFCRMSearchView : UIView

/** open */
@property (nonatomic, assign) BOOL open;
/** show */
@property (nonatomic, assign) BOOL show;

/** delegate */
@property (nonatomic, weak) id <TFCRMSearchViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

/** 创始化View */
+(instancetype)CRMSearchView;

-(void)refreshSearchViewWithTitle:(NSString *)title number:(NSInteger)number;

@end
