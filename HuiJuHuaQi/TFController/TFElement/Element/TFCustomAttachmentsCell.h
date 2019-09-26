//
//  TFCustomAttachmentsCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"
#import "HQBaseCell.h"

typedef enum {
    AttachmentsCellEdit,// 编辑
    AttachmentsCellDetail // 详情
}AttachmentsCellType;

@class TFCustomAttachmentsCell;
@protocol TFCustomAttachmentsCellDelegate <NSObject>

@optional
- (void)deleteAttachmentsWithIndex:(NSInteger)index;
- (void)addAttachmentsClickedWithCell:(TFCustomAttachmentsCell *)cell;
- (void)customAttachmentsCell:(TFCustomAttachmentsCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index;

@end


@interface TFCustomAttachmentsCell : HQBaseCell
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

@property (nonatomic, weak) id <TFCustomAttachmentsCellDelegate>delegate;

/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithModel:(TFCustomerRowsModel *)model type:(AttachmentsCellType)type;

/** 刷新cell高度 */
+ (CGFloat)refreshCustomAttachmentsCellHeightWithFiles:(NSArray *)files;

+ (TFCustomAttachmentsCell *)CustomAttachmentsCellWithTableView:(UITableView *)tableView;

@end
