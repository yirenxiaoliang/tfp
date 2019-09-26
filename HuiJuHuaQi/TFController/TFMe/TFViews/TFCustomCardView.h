//
//  TFCustomCardView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/19.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TFCustomCardViewDelegate<NSObject>

@optional
-(void)customCardViewDidClickedBottomIndex:(NSInteger)index models:(NSArray *)models;
-(void)customCardViewDidClickedStyleIndex:(NSInteger)index;
-(void)customCardViewDidClickedHiddenIndex:(NSInteger)index hide:(NSString *)hihe;
-(void)customCardViewDidClickedAdd;

@end

@interface TFCustomCardView : UIView
/** delegate */
@property (nonatomic, weak) id <TFCustomCardViewDelegate>delegate;

-(void)refreshCustomViewWithStyles:(NSArray *)arr choice:(NSInteger)choice hides:(NSArray *)hides;
@end
