//
//  TFContactHeaderView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFContactHeaderViewDelegate <NSObject>

@optional
-(void)contactHeaderViewDidClickedSearchWithTextField:(UITextField *)textField;
-(void)contactHeaderViewDidClickedCompanyPeople;
-(void)contactHeaderViewDidClickedChatGroup;
-(void)contactHeaderViewDidClickedRobot;
-(void)contactHeaderViewDidClickedOftenPeople;
-(void)contactHeaderViewDidClickedOutPeople;


@end

@interface TFContactHeaderView : UIView

/** delegate */
@property (nonatomic, weak) id<TFContactHeaderViewDelegate>delegate;

@end
