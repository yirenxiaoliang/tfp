//
//  HQTFLabelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjLabelModel.h"
#import "TFNoticeCategoryModel.h"


typedef enum {
    LabelCellTypeNothing,  // 无编辑
    LabelCellTypeThreeAll, // 三种编辑
    LabelCellTypeEditAndDelete, // 两种编辑
    LabelCellTypeOnlyStar, // 只有标星
    LabelCellTypeSelect    // 选中
}LabelCellType;

@class HQTFLabelCell;

@protocol HQTFLabelCellDelegate <NSObject>

@optional
/** 用于任务标签 */
-(void)labelCell:(HQTFLabelCell *)labelCell didClickedDeleteBtnWithModel:(TFProjLabelModel *)model;
-(void)labelCellDidClickedEditBtnWithModel:(TFProjLabelModel *)model;
-(void)labelCell:(HQTFLabelCell *)labelCell didClickedStarBtnWithModel:(TFProjLabelModel *)model;

/** 用于公告分类 */
-(void)labelCell:(HQTFLabelCell *)labelCell didClickedDeleteBtnWithNoticeModel:(TFNoticeCategoryModel *)model;
-(void)labelCellDidClickedEditBtnWithNoticeModel:(TFNoticeCategoryModel *)model;

@end

@interface HQTFLabelCell : HQBaseCell



+ (HQTFLabelCell *)labelCellWithTableView:(UITableView *)tableView withType:(LabelCellType)type;

/** 刷新标签 */
- (void)refreshLabelCellWithModel:(TFProjLabelModel *)model;

/** 刷新通知分类 */
- (void)refreshNoticeCellWithModel:(TFNoticeCategoryModel *)model;

/** delegate */
@property (nonatomic, weak) id <HQTFLabelCellDelegate>delegate;
@end
