//
//  TFTaskDetailFileCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class TFTaskDetailFileCell;
@protocol TFTaskDetailFileCellDelegate <NSObject>

@optional
- (void)deletefileWithIndex:(NSInteger)index;
- (void)addfileClickedWithCell:(TFTaskDetailFileCell *)cell;
- (void)lookWithCell:(TFTaskDetailFileCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index;

@end

@interface TFTaskDetailFileCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** type 0:有删除 1:无删除 */
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, weak) id <TFTaskDetailFileCellDelegate>delegate;

+(instancetype)taskDetailFileCellWithTableView:(UITableView *)tableView;
-(void)refreshTaskDetailCellWithFiles:(NSMutableArray *)files;
+(CGFloat)refreshTaskDetailCellHeightWithFiles:(NSMutableArray *)files;

@end

NS_ASSUME_NONNULL_END
