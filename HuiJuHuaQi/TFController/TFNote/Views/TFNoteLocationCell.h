//
//  TFNoteLocationCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/23.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFLocationModel.h"

@protocol TFNoteLocationCellDelegate <NSObject>
@optional
-(void)noteLocationCellDidDeleteBtn:(UIButton *)deleteBtn;

@end

@interface TFNoteLocationCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

+ (instancetype)noteLocationCellWithTableView:(UITableView *)tableView;

-(void)refreshNoteLocationCellWithModel:(TFLocationModel *)model;

/** delegate */
@property (nonatomic, weak) id <TFNoteLocationCellDelegate>delegate;

@end
