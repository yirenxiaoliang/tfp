//
//  TFNewNoteMainCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSliderCell.h"
#import "TFNewNoteListView.h"

@interface TFNewNoteMainCell : TFSliderCell

@property (nonatomic, strong) TFNewNoteListView *noteList;

+ (instancetype)NewNoteMainCellWithTableView:(UITableView *)tableView;

@end
