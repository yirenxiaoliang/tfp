//
//  TFCustomImageCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"
#import "HQBaseCell.h"

@class TFCustomImageCell;
@protocol TFCustomImageCellDelegate <NSObject>

@optional
/** 添加 */
- (void)customImageCellAddImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model;
/** 删除 */
- (void)customImageCellDeleteImageClicked:(NSInteger)index;
/** 查看 */
- (void)customImageCellSeeImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model index:(NSInteger)index;

@end

@interface TFCustomImageCell : HQBaseCell
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;

@property (nonatomic, weak) id <TFCustomImageCellDelegate>delegate;

/** 刷新cell
 *  @param model 模型
 *  @param type  类型 0：无加号  1：有加号
 *  @param column  一行几个
 */
- (void)refreshCustomImageCellWithModel:(TFCustomerRowsModel *)model withType:(NSInteger)type withColumn:(NSInteger)column;

+ (TFCustomImageCell *)CustomImageCellWithTableView:(UITableView *)tableView;

/** 高度 */
+(CGFloat)refreshCustomImageHeightWithModel:(TFCustomerRowsModel *)model withType:(NSInteger)type withColumn:(NSInteger)column;

@end
