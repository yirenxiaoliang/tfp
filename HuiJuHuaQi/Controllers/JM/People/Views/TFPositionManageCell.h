//
//  TFPositionManageCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPositionModel.h"
#import "HQDepartmentModel.h"

@protocol TFPositionManageCellDelegate <NSObject>

@optional
-(void)positionManageCellDidEditBtnWithPositionModel:(TFPositionModel *)model;
-(void)positionManageCellDidDeleteBtnWithPositionModel:(TFPositionModel *)model;
-(void)positionManageCellDidEditBtnWithDepartmentModel:(HQDepartmentModel *)model;
-(void)positionManageCellDidDeleteBtnWithDepartmentModel:(HQDepartmentModel *)model;

@end

@interface TFPositionManageCell : HQBaseCell

/** select */
@property (nonatomic, assign) BOOL select;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/** type 0:选择 1：管理 */
+ (TFPositionManageCell *)positionManageCellWithTableView:(UITableView *)tableView withType:(NSInteger)type;

- (void)refreshPositionManageCellWithPositionModel:(TFPositionModel *)model;
- (void)refreshPositionManageCellWithDepartmentModel:(HQDepartmentModel *)model;


/** delegate */
@property (nonatomic, weak) id <TFPositionManageCellDelegate> delegate;

@end
