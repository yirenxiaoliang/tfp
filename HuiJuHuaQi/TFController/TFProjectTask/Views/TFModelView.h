//
//  TFModelView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFApplicationModel.h"
#import "TFModuleModel.h"

@class TFModelView;

@protocol TFModelViewDelegate <NSObject>
@optional
-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module;
-(void)didClickedHandleBtnWithModelView:(TFModelView *)modelView module:(TFModuleModel *)module;

@end

@interface TFModelView : UIView

+ (instancetype)modelView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *handleBtn;
/** delegate */
@property (nonatomic, weak) id <TFModelViewDelegate>delegate;
/** type 0:无 1:+ 2:- */
-(void)refreshViewWithApplication:(TFApplicationModel *)appliction type:(NSInteger)type;
/** type 0:无 1:+ 2:- */
-(void)refreshViewWithModule:(TFModuleModel *)module type:(NSInteger)type;

@end
