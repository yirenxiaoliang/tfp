//
//  TFProjectMenberCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@interface TFProjectMenberCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enterImg;

+ (instancetype)projectMenberCellWithTableView:(UITableView *)tableView;

/** type 0:协助 1:选择 */
@property (nonatomic, assign) NSInteger type;


@end
