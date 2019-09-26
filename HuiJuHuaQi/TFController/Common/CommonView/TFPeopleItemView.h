//
//  TFPeopleItemView.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQEmployModel.h"
#import "TFDepartmentModel.h"
#import "TFParameterModel.h"

@protocol TFPeopleItemViewDelegate<NSObject>
@optional
-(void)clearBtnClickedWithEmployee:(HQEmployModel *)employee;

@end

@interface TFPeopleItemView : UIView

/** nameLabel */
@property (nonatomic, weak) UILabel *nameLabel;
/** delegate */
@property (nonatomic, weak) id <TFPeopleItemViewDelegate>delegate;

/** 刷新人 */
-(void)refreshPeopleViewWithEmployee:(HQEmployModel *)employee withClear:(BOOL)clear;
/** 刷新部门 */
-(void)refreshPeopleViewWithDepartment:(TFDepartmentModel *)department withClear:(BOOL)clear;

/** 刷新四种参数 */
-(void)refreshPeopleViewWithParameter:(TFParameterModel *)parameterp withClear:(BOOL)clear;

/** +样式 */
-(void)refreshAddType;

@end
