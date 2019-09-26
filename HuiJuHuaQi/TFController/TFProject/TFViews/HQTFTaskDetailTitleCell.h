//
//  HQTFTaskDetailTitleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjTaskModel.h"

@class HQTFTaskDetailTitleCell;
@protocol HQTFTaskDetailTitleCellDelegate <NSObject>

@optional
-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didDescriptionWithModel:(TFProjTaskModel *)model;

-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didFinishBtn:(UIButton *)finishBtn withModel:(TFProjTaskModel *)model;

-(void)taskDetailTitleCell:(HQTFTaskDetailTitleCell *)taskDetailTitleCell didCheckBtn:(UIButton *)checkBtn withModel:(TFProjTaskModel *)model;

@end

@interface HQTFTaskDetailTitleCell : HQBaseCell

@property (nonatomic, assign) BOOL isCheck;
/** title */
@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBtnT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishBtnW;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *approveStateBtn;
+ (HQTFTaskDetailTitleCell *)taskDetailTitleCellWithTableView:(UITableView *)tableView;
-(void)refreshTaskDetailTitleCellWithModel:(TFProjTaskModel*)model type:(NSInteger)type;

+(CGFloat)refreshTaskDetailTitleCellHeightWithModel:(TFProjTaskModel*)model type:(NSInteger)type;

+(CGFloat)refreshTaskDetailTitleCellHeightWithTitle:(NSString *)title;

-(void)refreshTaskDetailTitleCellWithTitle:(NSString *)title finishi:(NSString *)finish check:(NSString *)check pass:(NSString *)pass;

/** delegate */
@property (nonatomic, weak) id<HQTFTaskDetailTitleCellDelegate>delegate;

/** 刷新审批 */
//-(void)refreshTaskDetailTitleCellWithModel:(TFApprovalDetailModel*)model;
//
//
///** 刷新审批高度 */
//+(CGFloat)refreshTaskDetailTitleCellHeightWithModel:(TFApprovalDetailModel*)model;


@end
