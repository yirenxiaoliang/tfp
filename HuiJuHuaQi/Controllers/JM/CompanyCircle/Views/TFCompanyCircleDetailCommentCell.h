//
//  TFCompanyCircleDetailCommentCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQCommentItemModel.h"

@protocol TFCompanyCircleDetailCommentCellDeleagate <NSObject>

@optional
- (void)companyCircleDetailCommentCellWithPeopleImfo:(HQEmployModel *)people;
- (void)companyCircleDetailCommentCellDidClickContent:(HQCommentItemModel *)commentItem index:(NSInteger)index;
- (void)didLongPressToDelete:(HQCommentItemModel *)commentItem index:(NSInteger)index;

@end

@interface TFCompanyCircleDetailCommentCell : HQBaseCell

/** 显示图标 */
@property (nonatomic, assign) BOOL hiddenMark;


@property (nonatomic , weak)id <TFCompanyCircleDetailCommentCellDeleagate> delegate;

+(instancetype)companyCircleDetailCommentCellWithTableView:(UITableView *)tableView;

+(CGFloat)refreshCompanyCircleDetailCommentCellHeightWithModel:(HQCommentItemModel *)model;
-(void)refreshCompanyCircleDetailCommentCellForCommentItemModel:(HQCommentItemModel*)commentItem;
@end
