//
//  TFSingleAttachmentCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TFSingleAttachmentCellDelegate <NSObject>

@optional
- (void)deleteAttachmentAction:(NSInteger)index;

@end

@interface TFSingleAttachmentCell : UITableViewCell

/** type 0:有删除 1:无删除 */
@property (nonatomic, assign) NSInteger type;


+ (TFSingleAttachmentCell *)SingleAttachmentCellWithTableView:(UITableView *)tableView;

/** 刷新cell */
- (void)refreshSingleAttachmentCellWithModel:(TFFileModel *)model;

@property (nonatomic, weak)id <TFSingleAttachmentCellDelegate>delegate;

@property (nonatomic, assign) NSInteger btnIndex;

@end
