//
//  TFLateEarlyCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPCSettingDetailMocel.h"

NS_ASSUME_NONNULL_BEGIN
@class TFLateEarlyCell;
@protocol TFLateEarlyCellDelegate <NSObject>

@optional
-(void)lateEarlyCellDidDeleteBtn:(TFLateEarlyCell *)cell;
-(void)lateEarlyCellDidSetting:(TFLateNigthWalk *)model;

@end

@interface TFLateEarlyCell : HQBaseCell

-(void)refreshLateEarlyCellWithModel:(TFLateNigthWalk *)model;
+(CGFloat)refreshLateEarlyCellHeightWithModel:(TFLateNigthWalk *)model;

@property (nonatomic, weak) id <TFLateEarlyCellDelegate>delegate;

+ (instancetype)lateEarlyCellWithTableView:(UITableView *)tableView ;
@end

NS_ASSUME_NONNULL_END
