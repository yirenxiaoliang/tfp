//
//  TFGeneralSingleOldCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TFGeneralSingleOldCell;
@protocol TFGeneralSingleOldCellDelegate<NSObject>

@optional
/** 高度变化 */
-(void)generalSingleCell:(TFGeneralSingleOldCell *)cell changedHeight:(CGFloat)height;
/** 点击右按钮 */
-(void)generalSingleCellDidClickedRightBtn:(UIButton *)rightBtn;
/** 点击左按钮 */
-(void)generalSingleCellDidClickedLeftBtn:(UIButton *)leftBtn;
/** 触发联动条件 */
-(void)generalSingleCellWithModel:(TFCustomerRowsModel *)model;

@end

@interface TFGeneralSingleOldCell : UITableViewCell

/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 提示图片 */
@property (nonatomic, copy) NSString *tipImage;
/** 右图片 */
@property (nonatomic, copy) NSString *rightImage;
/** 左图片 */
@property (nonatomic, copy) NSString *leftImage;
/** 提示文字 */
@property (nonatomic, copy) NSString *placeholder;
/** textView是否可编辑 */
@property (nonatomic, assign, getter=isEdit) BOOL edit;
/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;

/** 右边图片 */
@property (nonatomic, weak) UIButton *rightBtn;
/** 左边图片 */
@property (nonatomic, weak) UIButton *leftBtn;
/** 输入框 */
@property (nonatomic, weak) HQAdviceTextView *textView;

/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;

/** delegate */
@property (nonatomic, weak) id <TFGeneralSingleOldCellDelegate>delegate;

/** 创建cell */
+(instancetype)generalSingleCellWithTableView:(UITableView *)tableView;

/** cell高度 */
+(CGFloat)refreshGeneralSingleCellHeightWithModel:(TFCustomerRowsModel *)model;

@end

NS_ASSUME_NONNULL_END
