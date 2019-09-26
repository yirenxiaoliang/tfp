//
//  TFReferanceModelView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFRelevanceTradeModel;
@protocol TFReferanceModelViewDelegate<NSObject>

@optional
-(void)referanceModelViewDidReferance:(TFRelevanceTradeModel *)referance;

@end

@interface TFReferanceModelView : UIView

+(instancetype)referanceModelView;

-(void)showAnimation;

-(void)refreshReferanceViewWithModels:(NSArray *)models;

/** delegate */
@property (nonatomic, weak) id <TFReferanceModelViewDelegate>delegate;

@end
