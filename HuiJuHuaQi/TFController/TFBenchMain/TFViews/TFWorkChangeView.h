//
//  TFWorkChangeView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/10/31.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFWorkChangeViewDelegate <NSObject>

@optional
-(void)workChangeViewDidClickedPeople;

@end

@interface TFWorkChangeView : UIView

+(instancetype)workChangeView;


@property (nonatomic, assign) NSString *auth;

@property (nonatomic, assign) NSInteger taskCount;

@property (nonatomic, weak) id <TFWorkChangeViewDelegate>delegate;

-(void)refreshWorkChangeViewWithPeoples:(NSArray *)peoples;



@end

NS_ASSUME_NONNULL_END
