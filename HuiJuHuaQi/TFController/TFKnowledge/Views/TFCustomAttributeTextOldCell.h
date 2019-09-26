//
//  TFCustomAttributeTextOldCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/4.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFCustomerRowsModel.h"

NS_ASSUME_NONNULL_BEGIN

@class TFCustomAttributeTextOldCell;
@protocol TFCustomAttributeTextOldCellDelegate <NSObject>

@optional
- (void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell getWebViewHeight:(CGFloat)height;
- (void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell getWebViewContent:(NSString *)content;
- (void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell didClickedImage:(NSURL *)url;


@end
@interface TFCustomAttributeTextOldCell : UITableViewCell

/** type 0:可编辑 1:不可编辑 */
+ (instancetype)customAttributeTextCellWithTableView:(UITableView *)tableView type:(NSInteger)type index:(NSInteger)index;

/** model */
@property (nonatomic, strong) TFCustomerRowsModel *model;


/** title */
@property (nonatomic, copy) NSString *title;

/** 展示样式 YES：编辑样式  NO: 详情样式 */
@property (nonatomic, assign) BOOL showEdit;

/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

@property (nonatomic, weak) id <TFCustomAttributeTextOldCellDelegate>delegate;

/** 获取编辑的内容 */
- (void)getEmailContentFromWebview;

/** 重新加载详情内容 */
-(void)reloadDetailContentWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
