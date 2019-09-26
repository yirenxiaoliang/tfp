//
//  TFEnterMoveCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/21.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFModuleModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFEnterMoveCellDelegate <NSObject>

@optional
-(void)enterMoveCellDidClickedMinusWithModule:(TFModuleModel *)module index:(NSInteger)index;
-(void)enterMoveCellDidClickedAddWithModule:(TFModuleModel *)module index:(NSInteger)index;

@end

@interface TFEnterMoveCell : HQBaseCell


@property (nonatomic, weak) id <TFEnterMoveCellDelegate>delegate;

+(instancetype)enterMoveCellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger type;

-(void)refreshEnterMoveCellWithModel:(TFModuleModel *)model;

@end

NS_ASSUME_NONNULL_END
