//
//  TFProjectFileListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectFileModel.h"

@interface TFProjectFileListCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

+ (instancetype)projectFileListCellWithTableView:(UITableView *)tableView;

- (void)refreshProjectFileListCellWithModel:(TFProjectFileModel *)model projectId:(NSNumber *)projectId;

@end
