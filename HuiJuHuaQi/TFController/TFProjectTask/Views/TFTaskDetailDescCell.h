//
//  TFTaskDetailDescCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
@class TFTaskDetailDescCell;
@protocol TFTaskDetailDescCellDelegate <NSObject>

@optional
-(void)taskDetailDescCellHeightChange:(CGFloat)height;
- (void)taskDetailDescCel:(TFTaskDetailDescCell *)cell didClickedImage:(NSURL *)url;

@end

@interface TFTaskDetailDescCell : HQBaseCell
@property (weak, nonatomic)  UIImageView *headImage;
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *placehoder;
+(instancetype)taskDetailDescCellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id <TFTaskDetailDescCellDelegate>delegate;
/** 重新加载详情内容 */
-(void)reloadDetailContentWithContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
