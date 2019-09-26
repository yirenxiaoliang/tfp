//
//  TFChangePeopleView.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TFChangePeopleViewDelegate <NSObject>

@optional
-(void)changePeopleViewDidClickedPeople;

@end

@interface TFChangePeopleView : UIView

+(instancetype)changePeopleView;


@property (nonatomic, assign) NSString *auth;

@property (nonatomic, assign) NSInteger taskCount;

@property (nonatomic, weak) id <TFChangePeopleViewDelegate>delegate;

-(void)refreshChangePeopleViewPeoples:(NSArray *)peoples;

@end

NS_ASSUME_NONNULL_END
