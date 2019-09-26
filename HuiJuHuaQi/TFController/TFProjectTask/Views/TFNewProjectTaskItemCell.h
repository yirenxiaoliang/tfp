//
//  TFNewProjectTaskItemCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TFNewProjectTaskItemCell;
@protocol TFNewProjectTaskItemCellDelegate <NSObject>

@optional
-(void)projectTaskItemCellDidClickedClearBtn:(TFNewProjectTaskItemCell *)cell;
-(void)projectTaskItemCell:(TFNewProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(TFProjectRowModel *)model;

@end

@interface TFNewProjectTaskItemCell : UITableViewCell


@property (nonatomic, weak) id <TFNewProjectTaskItemCellDelegate>delegate;

+(instancetype)newProjectTaskItemCellWithTableView:(UITableView *)tableView;

-(void)refreshNewProjectTaskItemCellWithModel:(TFProjectRowModel *)model haveClear:(BOOL)haveClear;
+(CGFloat)refreshNewProjectTaskItemCellHeightWithModel:(TFProjectRowModel *)model haveClear:(BOOL)haveClear;

@end

NS_ASSUME_NONNULL_END
