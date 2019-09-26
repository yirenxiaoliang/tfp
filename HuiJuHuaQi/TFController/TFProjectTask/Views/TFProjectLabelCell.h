//
//  TFProjectLabelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectLabelModel.h"

@protocol TFProjectLabelCellDelegate<NSObject>
@optional
-(void)projectLabelCellDidClickedSelectBtn:(UIButton *)button;
-(void)projectLabelCellDidClickedDeleteBtn:(UIButton *)button;

@end

@interface TFProjectLabelCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
+ (TFProjectLabelCell *)projectLabelCellWithTableView:(UITableView *)tableView;

-(void)refreshProjectLabelWithModel:(TFProjectLabelModel *)model;
/** type */
@property (nonatomic, assign) NSInteger type;

/** delegate */
@property (nonatomic, weak) id <TFProjectLabelCellDelegate>delegate;

@end
