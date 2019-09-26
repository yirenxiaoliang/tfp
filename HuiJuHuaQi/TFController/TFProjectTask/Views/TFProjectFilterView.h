//
//  TFProjectFilterView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFFilterModel.h"

@protocol TFProjectFilterViewDelegate <NSObject>

@optional
-(void)filterViewDidClicked:(BOOL)show;
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict;
-(void)filterViewDidSelectPeopleWithPeoples:(NSArray *)peoples model:(TFFilterModel *)model;
-(void)filterViewDidSelectDepartmentWithDepartments:(NSArray *)departments model:(TFFilterModel *)model;

@end


@interface TFProjectFilterView : UIView

/** delegate */
@property (nonatomic, weak) id <TFProjectFilterViewDelegate>delegate;

- (void)hideAnimation;
- (void)showAnimation;

/** type 0：项目任务筛选， 1：个人任务筛选 */
@property (nonatomic, assign) NSInteger type;

/** conditions */
@property (nonatomic, strong) NSMutableArray *conditions;

-(void)refresh;

@end
