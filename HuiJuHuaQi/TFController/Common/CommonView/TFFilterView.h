//
//  TFFilterView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFFilterModel.h"

@protocol TFFilterViewDelegate <NSObject>

@optional
-(void)filterViewDidClicked:(BOOL)show;
-(void)filterViewDidSureBtnWithDict:(NSDictionary *)dict;
-(void)filterViewDidSelectPeopleWithPeoples:(NSArray *)peoples model:(TFFilterModel *)model;
-(void)filterViewDidSelectDepartmentWithDepartments:(NSArray *)departments model:(TFFilterModel *)model;

@end


@interface TFFilterView : UIView

/** delegate */
@property (nonatomic, weak) id <TFFilterViewDelegate>delegate;

/** filters */
@property (nonatomic, strong) NSMutableArray *filters;

-(void)refresh;

@end
