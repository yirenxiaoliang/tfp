//
//  TFProjectTaskItemCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowFrameModel.h"

@class TFProjectTaskItemCell;
@protocol TFProjectTaskItemCellDelegate<NSObject>
@optional
-(void)projectTaskItemCell:(TFProjectTaskItemCell *)cell didClickedFinishBtnWithModel:(id)model;
-(void)projectTaskItemCellDidClickedClearBtn:(TFProjectTaskItemCell *)cell;

@end

@interface TFProjectTaskItemCell : UITableViewCell

+(instancetype)projectTaskItemCellWithTableView:(UITableView *)tableView;

/** frameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *frameModel;

/** delegate */
@property (nonatomic, weak) id <TFProjectTaskItemCellDelegate>delegate;

@property (nonatomic, assign) NSInteger knowledge;
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, weak) UIImageView *selectImage;

@end
