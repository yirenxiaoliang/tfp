//
//  TFCustomAttachmentsOldCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    AttachmentsCellEdit,// 编辑
    AttachmentsCellDetail // 详情
}AttachmentsCellType;

@class TFCustomAttachmentsOldCell;
@protocol TFCustomAttachmentsOldCellDelegate <NSObject>

@optional
- (void)deleteAttachmentsWithIndex:(NSInteger)index;
- (void)addAttachmentsClickedWithCell:(TFCustomAttachmentsOldCell *)cell;
- (void)customAttachmentsCell:(TFCustomAttachmentsOldCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index;

@end


@interface TFCustomAttachmentsOldCell : UITableViewCell
/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 必填控制 */
@property (nonatomic, copy) NSString *fieldControl;
/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;
/** 类型 */
@property (nonatomic, assign) AttachmentsCellType type;

@property (nonatomic, weak) id <TFCustomAttachmentsOldCellDelegate>delegate;

/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithModel:(TFCustomerRowsModel *)model type:(AttachmentsCellType)type;

/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithFiles:(NSArray *)files;

+ (TFCustomAttachmentsOldCell *)CustomAttachmentsCellWithTableView:(UITableView *)tableView;

@end


NS_ASSUME_NONNULL_END
