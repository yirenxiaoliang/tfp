//
//  TFChildTaskCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFChildTaskCellDelegate <NSObject>
@optional
-(void)childTaskCellDidClickedSelectBtn:(UIButton *)selectBtn;

@end

@interface TFChildTaskCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/** delegate */
@property (nonatomic, weak) id <TFChildTaskCellDelegate>delegate;

+ (TFChildTaskCell *)childTaskCellWithTableView:(UITableView *)tableView;

- (void)refreshChildTaskCellWithModel:(id)model;
+ (CGFloat)refreshChildTaskCellHeightWithModel:(id)model;

@end
