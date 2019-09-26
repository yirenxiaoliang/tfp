//
//  HQTFLabelManageCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjLabelModel.h"

@protocol HQTFLabelManageCellDelegate <NSObject>

@optional
-(void)labelManageCellSelectColorWithColorModel:(TFProjLabelModel *)model;

@end

@interface HQTFLabelManageCell : HQBaseCell

/** type应用场景 0:新增 1：删除 2:选择颜色*/
+(instancetype)labelManageCellWithTableView:(UITableView *)tableView withType:(NSInteger)type;

+(CGFloat)refreshCellHeightWithItems:(NSArray *)items;
-(void)refreshCellWithItems:(NSArray *)items;
-(void)refreshCellItemColorWithItems:(NSArray *)items;

/** delegate */
@property (nonatomic, weak) id <HQTFLabelManageCellDelegate>delegate;

/** selcteColor */
@property (nonatomic, copy) NSString *selcteColor;

@end
