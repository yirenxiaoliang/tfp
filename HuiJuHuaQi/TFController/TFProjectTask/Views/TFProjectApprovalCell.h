//
//  TFProjectApprovalCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowFrameModel.h"
@class TFProjectApprovalCell;
@protocol TFProjectApprovalCellDelegate <NSObject>

@optional
-(void)projectApprovalCellDidClickedClearBtn:(TFProjectApprovalCell *)cell;

@end

@interface TFProjectApprovalCell : UITableViewCell

+ (TFProjectApprovalCell *)projectApprovalCellWithTableView:(UITableView *)tableView;

/** frameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *frameModel;

@property (nonatomic, assign) NSInteger knowledge;

@property (nonatomic, assign) BOOL edit;


@property (nonatomic, weak) id <TFProjectApprovalCellDelegate>delegate;

@property (nonatomic, weak) UIImageView *selectImage;

@end
