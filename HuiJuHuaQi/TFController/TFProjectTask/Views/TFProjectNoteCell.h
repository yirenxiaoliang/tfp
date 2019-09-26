//
//  TFProjectNoteCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFProjectRowFrameModel.h"
@class TFProjectNoteCell;
@protocol TFProjectNoteCellDelegate <NSObject>

@optional
-(void)projectNoteCellDidClickedClearBtn:(TFProjectNoteCell *)cell;

@end

@interface TFProjectNoteCell : UITableViewCell

+ (TFProjectNoteCell *)projectNoteCellWithTableView:(UITableView *)tableView;

/** frameModel */
@property (nonatomic, strong) TFProjectRowFrameModel *frameModel;

@property (nonatomic, weak) id <TFProjectNoteCellDelegate>delegate;

@property (nonatomic, assign) NSInteger knowledge;
@property (nonatomic, assign) BOOL edit;

@property (nonatomic, weak) UIImageView *selectImage ;
@end
