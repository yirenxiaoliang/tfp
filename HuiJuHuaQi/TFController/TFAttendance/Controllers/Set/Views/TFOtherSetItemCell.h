//
//  TFOtherSetItemCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFOtherSetItemCellDelegate <NSObject>

@optional
- (void)setButtonClicked:(NSIndexPath *)indexPath;

@end

@interface TFOtherSetItemCell : HQBaseCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UITextField *contentTF;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopCons;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id <TFOtherSetItemCellDelegate>delegate;

//配置数据 type 1:一行 2:两行
- (void)configOtherSetItemCellWithTableView:(NSInteger)type;

+ (instancetype)otherSetItemCellWithTableView:(UITableView *)tableView;

@end
