//
//  TFEnterPeopleView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFEnterPeopleViewDelegate <NSObject>

@optional
-(void)changePeopleViewDidClickedPeople;

@end

@interface TFEnterPeopleView : UIView

+(instancetype)enterPeopleView;


@property (nonatomic, assign) NSString *auth;

@property (nonatomic, assign) NSInteger taskCount;

@property (nonatomic, weak) id <TFEnterPeopleViewDelegate>delegate;

-(void)refreshChangePeopleViewPeoples:(NSArray *)peoples;

@end

NS_ASSUME_NONNULL_END
