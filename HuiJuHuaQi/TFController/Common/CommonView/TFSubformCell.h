//
//  TFSubformCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerRowsModel.h"

@class TFSubformCell,TFSingleTextCell,TFFileElementCell;

@protocol TFSubformCellDelegate <NSObject>

@optional
/** 子表单高度 */
-(void)subformCell:(TFSubformCell *)subformCell withHeight:(CGFloat)height;
/** 单行文本点击按钮 */
-(void)subformCell:(TFSubformCell *)subformCell singleTextCell:(TFSingleTextCell *)singleTextCell didClilckedEnterBtn:(UIButton *)enterBtn withModel:(TFCustomerRowsModel *)model;
/** 点击选取附件 */
-(void)subformCell:(TFSubformCell *)subformCell fileElementCellDidClickedSelectFile:(TFFileElementCell *)fileElementCell withModel:(TFCustomerRowsModel *)model;
/** 点击查看文件 */
-(void)subformCell:(TFSubformCell *)subformCell fileElementCell:(TFFileElementCell *)fileElementCell didClickedFile:(TFFileModel *)file index:(NSInteger)index withModel:(TFCustomerRowsModel *)model;

/** 选择时间 */
-(void)subformCellSelectTime:(TFSubformCell *)subformCell withModel:(TFCustomerRowsModel *)model;

/** 选择下拉 */
-(void)subformCellSelectPicklist:(TFSubformCell *)subformCell withModel:(TFCustomerRowsModel *)model;

/** 选择复选 */
-(void)subformCellSelectMutil:(TFSubformCell *)subformCell withModel:(TFCustomerRowsModel *)model;

/** 选择人员 */
-(void)subformCellSelectPersonnel:(TFSubformCell *)subformCell withModel:(TFCustomerRowsModel *)model;

/** 选择地区 */
-(void)subformCellSelectArea:(TFSubformCell *)subformCell withModel:(TFCustomerRowsModel *)model;

@end

@interface TFSubformCell : HQBaseCell

/** requireLabel */
@property (nonatomic, weak) UILabel *requireLabel;

+ (TFSubformCell *)subformCellWithTableView:(UITableView *)tableView;

/** delegate */
@property (nonatomic, weak) id <TFSubformCellDelegate>delegate;

/** 刷新新增 */
-(void)refreshSubformCellWithModel:(TFCustomerRowsModel *)model;

/** isEdit */
@property (nonatomic, assign) BOOL isEdit;

/** 刷新 */
-(void)refreshSubformCell;

@end
