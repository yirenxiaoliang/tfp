//
//  TFBurWindowView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/28.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFApplicationModel.h"
#import "TFModelView.h"


@protocol TFBurWindowViewDelegate <NSObject>

@optional
-(void)burWindowViewDidClickedModelView:(TFModelView *)modelView module:(TFModuleModel *)module;

-(void)burWindowViewDidClickedAddModule:(TFModuleModel *)module;

@end


@interface TFBurWindowView : UIView
/** delegateq */
@property (nonatomic, weak) id <TFBurWindowViewDelegate>delegate;

-(void)hide;

/** 刷新 */
- (void)refreshItemWithApplication:(TFApplicationModel *)application rect:(CGRect)rect type:(NSInteger)type oftenApplication:(TFApplicationModel *)oftenApplication;
@end
