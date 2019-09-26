//
//  TFCompanyCircleCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/19.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFCompanyCircleFrameModel.h"
#import "HQEmployModel.h"
#import "TFCommentView.h"
@class TFCompanyCircleCell;
@protocol TFCompanyCircleCellDelegate <NSObject>

@optional
/** 点击全文按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedAllWordBtn:(UIButton *)button;
/** 点击删除按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedDeleteBtn:(UIButton *)button;
/** 点击共享按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedShareBtn:(UIButton *)button;
/** 点击点赞按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedGoodBtn:(UIButton *)button;
/** 点击评论按钮 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell withCommentItem:(HQCategoryItemModel *)commentItem didClickedCommentBtn:(UIButton *)button;
/** 点击点赞列表中的人及评论中的人 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedGoodPeople:(HQEmployModel *)people;
/** 点击评论进行回复 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell withCommentItem:(HQCommentItemModel *)commentItem index:(NSInteger)index;
/** 点击头像 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedHeadBtn:(UIButton *)button;
/** 点击地址 */
- (void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedAddressWithLongitude:(NSNumber*)longitude withLatitude:(NSNumber*)latitude;
/** 点击图片 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell pictureViewWithImageViews:(NSArray *)imageViews didImageViewWithIndex:(NSInteger)index;
/** 点击显示分享、赞、评论 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell didClickedShowBtn:(UIButton *)button;
/** 长按删除评论 */
-(void)companyCircleCell:(TFCompanyCircleCell *)cell didLongPressWithCommentItem:(HQCommentItemModel *)commentItem index:(NSInteger)index;

@end

@interface TFCompanyCircleCell : HQBaseCell

/** frameModel */
@property (nonatomic, strong) TFCompanyCircleFrameModel *frameModel;

/** 共享、点赞、评论框 */
@property (nonatomic, weak) TFCommentView *commentView;

+(instancetype)companyCircleCellWithTableView:(UITableView *)tableView;

/** 评论框消失 */
-(void)commentDismiss;

/** delegate */
@property (nonatomic, weak) id<TFCompanyCircleCellDelegate>delegate;

/** 刷新内部tableView */
-(void)refreshInfinorTable;

@end
