//
//  TFRelatedModuleDataCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFRelatedModuleDataCellDelegate <NSObject>

@optional
- (void)deleteRelatedDataWithIndex:(NSIndexPath *)indexPath;
- (void)didSelectRelatedWithIndex:(NSIndexPath *)indexPath;
@end

@interface TFRelatedModuleDataCell : HQBaseCell


+ (TFRelatedModuleDataCell *)relatedModuleDataCellWithTableView:(UITableView *)tableView;

- (void)refreshCellWithTasks:(NSArray *)tasks frames:(NSArray *)frames auth:(BOOL)auth;

+ (CGFloat)refreshRelatedModuleHeightWithFrames:(NSArray*)frames auth:(BOOL)auth;

@property (nonatomic, weak) id <TFRelatedModuleDataCellDelegate>delegate;

@end
