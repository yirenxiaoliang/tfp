//
//  TFCustomAttributeTextCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQBaseCell.h"
#import "TFCustomerRowsModel.h"

@class TFCustomAttributeTextCell;
@protocol TFCustomAttributeTextCellDelegate <NSObject>

@optional
- (void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewHeight:(CGFloat)height;
- (void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewContent:(NSString *)content;
- (void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell didClickedImage:(NSURL *)url;


@end
@interface TFCustomAttributeTextCell : HQBaseCell

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

@property (nonatomic, weak) id <TFCustomAttributeTextCellDelegate>delegate;

/** 获取编辑的内容 */
- (void)getEmailContentFromWebview;

/** 重新加载详情内容 */
-(void)reloadDetailContentWithContent:(NSString *)content;

@end
