//
//  TFMoveSelectCell.h
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/5/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectNodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TFMoveSelectCellDelegate <NSObject>

@optional
-(void)moveSelectCellDidClickedSelectWithModel:(TFProjectNodeModel *)model;

@end

@interface TFMoveSelectCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@property (nonatomic, weak) id <TFMoveSelectCellDelegate>delegate;

+(instancetype)moveSelectCellWithTableView:(UITableView *)tableView;

-(void)refreshMoveSelectCellWithModel:(TFProjectNodeModel *)model;

@end

NS_ASSUME_NONNULL_END
