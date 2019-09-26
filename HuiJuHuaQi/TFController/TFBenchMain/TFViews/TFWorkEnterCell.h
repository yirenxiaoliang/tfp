//
//  TFWorkEnterCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFModuleModel.h"
#import "TFBeanTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFWorkEnterCellDelegate <NSObject>

@optional
-(void)workEnterCellDidClickedItemWithModule:(TFModuleModel *)module index:(NSInteger)index;
-(void)workEnterCellDidClickedSubmenuWithModule:(TFModuleModel *)module beanType:(TFBeanTypeModel *)beanType index:(NSInteger)index;
-(void)workEnterCellDidClickedAddWithModule:(TFModuleModel *)module;
-(void)workEnterCellDidClickedShow:(BOOL)show module:(TFModuleModel *)module;
-(void)workEnterCellEnterMainWithModule:(TFModuleModel *)module;


@end

@interface TFWorkEnterCell : UITableViewCell

+ (TFWorkEnterCell *)workEnterCellWithTableView:(UITableView *)tableView;

-(void)refreshWorkEnterCellWithModule:(TFModuleModel *)module;

/** 高度 */
+(CGFloat)workEnterCellHeightWithModule:(TFModuleModel *)module;


@property (nonatomic, weak) id <TFWorkEnterCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
