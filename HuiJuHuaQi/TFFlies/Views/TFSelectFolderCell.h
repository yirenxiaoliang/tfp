//
//  TFSelectFolderCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFSelectFolderCellDelegate <NSObject>

@optional
- (void)selectFolder:(NSInteger)index;

@end

@interface TFSelectFolderCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImg;
@property (weak, nonatomic) IBOutlet UIImageView *folderImg;
@property (weak, nonatomic) IBOutlet UILabel *folderNameLab;

@property (nonatomic, assign) NSInteger index;

@property (weak, nonatomic) id <TFSelectFolderCellDelegate>delegate;

+ (instancetype)SelectFolderCellWithTableView:(UITableView *)tableView;

@end
