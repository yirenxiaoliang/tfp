//
//  HQCommentTableViewCell.h
//  HuiJuHuaQi
//
//  Created by hq001 on 16/4/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQCommentItemModel.h"

@protocol HQCommentTableViewCellDeleagate <NSObject>

@optional
- (void)pushPeopleImfo:(HQEmployModel *)people;
- (void)didClickContent:(HQCommentItemModel *)commentItem index:(NSInteger)index;
- (void)didLongPressToDelete:(HQCommentItemModel *)commentItem index:(NSInteger)index;

@end

@interface HQCommentTableViewCell : UITableViewCell

@property (nonatomic , weak)id <HQCommentTableViewCellDeleagate> delegate;

+ (HQCommentTableViewCell *)commentTableViewCellWithTableView:(UITableView *)tableView;
/** 刷新cell */
-(void)refreshCellForCommentItemModel:(HQCommentItemModel*)commentItem;
/** 刷新cell高度 */
+(CGFloat)refreshCellHeightwithCommentItemModel:(HQCommentItemModel *)commentItem;


-(void)CellForCommentItemModel:(HQCommentItemModel*)commentItem;

+(CGFloat)commentTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withTheObject:(HQCommentItemModel *)model;

@end
