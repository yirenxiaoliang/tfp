//
//  TFSelectPeopleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/7.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQEmployModel.h"

@class TFSelectPeopleCell;

@protocol TFSelectPeopleCellDelegate<NSObject>

@optional
-(void)selectPeopleCell:(TFSelectPeopleCell *)selectPeopleCell clearedEmployee:(HQEmployModel *)employee;

@end


@interface TFSelectPeopleCell : HQBaseCell

/** delegate */
@property (nonatomic, weak) id <TFSelectPeopleCellDelegate>delegate;

/** UILabel *lable */
@property (nonatomic, weak) UILabel *titleLabel;

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;

/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;
/** 高度 */
+(CGFloat)refreshSelectPeopleCellHeightWithStructure:(NSString *)structure;

/** 刷新人员 */
-(void)refreshSelectPeopleCellWithPeoples:(NSArray *)peoples structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd clear:(BOOL)clear;
/** 刷新部门 */
-(void)refreshSelectPeopleCellWithDepartments:(NSArray *)departments structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd clear:(BOOL)clear;
/** 创建cell */
+ (instancetype)selectPeopleCellWithTableView:(UITableView *)tableView;

/** isHiddenName */
@property (nonatomic, assign) BOOL isHiddenName;

/** 刷新四种参数 */
-(void)refreshSelectPeopleCellWithParameters:(NSArray *)parameters structure:(NSString *)structure chooseType:(NSString *)chooseType showAdd:(BOOL)showAdd clear:(BOOL)clear;

@end
