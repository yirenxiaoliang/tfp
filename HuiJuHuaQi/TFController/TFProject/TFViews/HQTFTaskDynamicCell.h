//
//  HQTFTaskDynamicCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFTaskDynamicModel.h"
#import "TFTaskDynamicItemModel.h"
#import "TFApprovalDynamicModel.h"
#import "TFApprovalLogModel.h"
#import "TFTaskLogContentModel.h"
#import "TFCustomerCommentModel.h"
#import "TFTaskHybirdDynamicModel.h"

@class HQTFTaskDynamicCell;

@protocol HQTFTaskDynamicCellDelegate <NSObject>

-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickImage:(UIImageView *)imageView;

-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickVoice:(TFFileModel *)voiceUrl;

-(void)taskDynamicCell:(HQTFTaskDynamicCell *)taskDynamicCell didClickFile:(TFFileModel *)voiceUrl;


@end

@interface HQTFTaskDynamicCell : HQBaseCell

+ (HQTFTaskDynamicCell *)taskDynamicCellWithTableView:(UITableView *)tableView;

/** 刷新任务动态 */
- (void)refreshDynamicCellWithModel:(TFTaskDynamicModel *)model;
+ (CGFloat)refreshDynamicCellHeightWithModel:(TFTaskDynamicModel *)model;



/** 刷新自定义评论 */
- (void)refreshCommentCellWithCustomModel:(TFCustomerCommentModel *)model;
+ (CGFloat)refreshCommentCellHeightWithCustomModel:(TFCustomerCommentModel *)model;

/** 刷新混合动态 */
- (void)refreshCommentCellWithHybirdModel:(TFTaskHybirdDynamicModel *)model;
+ (CGFloat)refreshCommentCellHeightWithHybirdModel:(TFTaskHybirdDynamicModel *)model;

/** 刷新任务评论 */
- (void)refreshCommentCellWithTaskDynamicItemModel:(TFTaskDynamicItemModel *)model;
+ (CGFloat)refreshCommentCellHeightWithTaskDynamicItemModel:(TFTaskDynamicItemModel *)model;

/** 刷新任务动态 */
- (void)refreshDynamicCellWithTaskDynamicItemModel:(TFTaskLogContentModel *)model;
+ (CGFloat)refreshDynamicCellHeightWithTaskDynamicItemModel:(TFTaskLogContentModel *)model;

/** 刷新审批评论 */
+ (CGFloat)refreshApproveCellHeightWithModel:(TFApprovalDynamicModel *)model;

/** 刷新审批动态   */
- (void)refreshApproveCellWithLogModel:(TFApprovalLogModel *)model;
+ (CGFloat)refreshApproveCellHeightWithLogModel:(TFApprovalLogModel *)model;

/** delegate */
@property (nonatomic, weak) id <HQTFTaskDynamicCellDelegate>delegate;

@end
