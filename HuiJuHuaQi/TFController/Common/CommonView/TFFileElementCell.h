//
//  TFFileElementCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@class TFFileElementCell;

@protocol TFFileElementCellDelegate <NSObject>

@optional
-(void)fileElementCellDidClickedSelectFile:(TFFileElementCell *)fileElementCell ;
-(void)fileElementCell:(TFFileElementCell *)fileElementCell didClickedFile:(TFFileModel *)file index:(NSInteger)index;
-(void)fileElementCellDidDeleteFile:(TFFileElementCell *)fileElementCell withIndex:(NSInteger)index;

@end

@interface TFFileElementCell : HQBaseCell

@property (nonatomic, strong) UILabel *requireLabel;
@property (nonatomic, strong) UILabel *titleLab;

/** structure */
@property (nonatomic, copy) NSString *structure;
/** fieldControl */
@property (nonatomic, copy) NSString *fieldControl;

+ (TFFileElementCell *)fileElementCellWithTableView:(UITableView *)tableView;

/** index 0:附件 1：图片 */
- (void)refreshFileElementCellWithFiles:(NSArray *)files withType:(NSInteger)index;

+ (CGFloat)refreshFileElementCellHeightWithFiles:(NSArray *)files structure:(NSString *)structure isEdit:(BOOL)isEdit;

/** delegate */
@property (nonatomic, weak) id <TFFileElementCellDelegate>delegate;

/** isEdit */
@property (nonatomic, assign) BOOL isEdit;


@end
