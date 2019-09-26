//
//  TFLeftMenuView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFLeftMenuViewDelegate <NSObject>

@optional
-(void)filterViewDidClicked:(BOOL)show;
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict;
- (void)fileterViewCellDid:(NSInteger)index title:(NSString *)title;

@end

@interface TFLeftMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame unreads:(NSMutableArray *)unreads;

/** delegate */
@property (nonatomic, weak) id <TFLeftMenuViewDelegate>delegate;


- (void)refreshLeftmenuViewWithBoxId:(NSNumber *)boxId;

@end
