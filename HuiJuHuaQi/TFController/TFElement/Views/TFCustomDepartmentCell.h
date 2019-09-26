//
//  TFCustomDepartmentCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFCustomDepartmentCellDelegate <NSObject>

@optional
-(void)customDepartmentCellDidRightBtnWithModel:(TFCustomerRowsModel *)model;
-(void)customDepartmentCellChangeHeightWithModel:(TFCustomerRowsModel *)model;

@end

@interface TFCustomDepartmentCell : HQBaseCell
/** 结构  0：上下， 1：左右 */
@property (nonatomic, copy) NSString *structure;
/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 右图片 */
@property (nonatomic, copy) NSString *rightImage;
/** 提示文字 */
@property (nonatomic, copy) NSString *placeholder;

/** 右边图片 */
@property (nonatomic, weak) UIButton *rightBtn;
/** 可编辑 */
@property (nonatomic, assign) BOOL edit;

/** 右边图片 */
@property (nonatomic, weak) id<TFCustomDepartmentCellDelegate>  delegate;

/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;

-(void)refreshCustomDepartmentCellWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit;

+(CGFloat)refreshCustomDepartmentCellHeightWithModel:(TFCustomerRowsModel *)model edit:(BOOL)edit;


+(instancetype)customDepartmentCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
