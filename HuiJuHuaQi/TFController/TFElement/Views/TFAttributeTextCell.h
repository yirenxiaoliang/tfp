//
//  TFAttributeTextCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/10.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
@class TFAttributeTextCell;
@protocol TFAttributeTextCellDelegate <NSObject>

@optional
- (void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewHeight:(CGFloat)height;
- (void)attributeTextCell:(TFAttributeTextCell *)attributeTextCell getWebViewContent:(NSString *)content;


@end
@interface TFAttributeTextCell : HQBaseCell

/** type 0:可编辑 1:不可编辑 */
+ (instancetype)attributeTextCellWithTableView:(UITableView *)tableView type:(NSInteger)type index:(NSInteger)index;

/** title */
@property (nonatomic, copy) NSString *title;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

@property (nonatomic, weak) id <TFAttributeTextCellDelegate>delegate;

/** 获取编辑的内容 */
- (void)getEmailContentFromWebview;

/** 重新加载详情内容 */
//-(void)reloadDetailContentWithFinish:(BOOL)finish;
-(void)reloadDetailContentWithContent:(NSString *)content;

@end
