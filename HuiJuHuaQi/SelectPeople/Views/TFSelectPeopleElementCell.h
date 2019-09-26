//
//  TFSelectPeopleElementCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFDepartmentModel.h"
#import "TFRoleModel.h"
#import "TFDynamicParameterModel.h"
#import "TFEmailAddessBookItemModel.h"

@protocol TFSelectPeopleElementCellDelegate <NSObject>

@optional
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn;

@end

@interface TFSelectPeopleElementCell : HQBaseCell

/** delegate */
@property (nonatomic, weak) id <TFSelectPeopleElementCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/** 部门 */
-(void)refreshCellWithDepartmentModel:(TFDepartmentModel *)model isSingle:(BOOL)isSingle;
/** 人员 */
-(void)refreshCellWithEmployeeModel:(TFEmployModel *)model isSingle:(BOOL)isSingle;
/** 角色 */
-(void)refreshCellWithRoleModel:(TFRoleModel *)model isSingle:(BOOL)isSingle;
/** 参数 */
-(void)refreshCellWithParameterModel:(TFDynamicParameterModel *)model isSingle:(BOOL)isSingle;

/** 创建 */
+ (instancetype)selectPeopleElementCellWithTableView:(UITableView *)tableView index:(NSInteger)index;

/** 邮件通讯录 */
-(void)refreshEmailsAddressBookWithModel:(TFEmailAddessBookItemModel *)model;

@end
