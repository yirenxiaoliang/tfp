//
//  TFProjectListView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFProjectListViewDelegate <NSObject>

@optional
-(void)filterViewDidClicked:(BOOL)show;
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict;

@end

@interface TFProjectListView : UIView

+ (instancetype)projectListView;

/** delegate */
@property (nonatomic, weak) id <TFProjectListViewDelegate>delegate;

- (void)hideAnimation;
- (void)showAnimation;

/** conditions */
@property (nonatomic, strong) NSMutableArray *conditions;
@end
