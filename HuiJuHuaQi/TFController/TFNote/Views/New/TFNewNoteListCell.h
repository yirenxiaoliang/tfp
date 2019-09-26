//
//  TFNewNoteListCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/22.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSliderCell.h"
#import "TFNoteDataListModel.h"

@interface TFNewNoteListCell : TFSliderCell

+ (instancetype)NewNoteListCellWithTableView:(UITableView *)tableView;
//刷新cell
- (void)refreshNewNoteListCellWithModel:(TFNoteDataListModel *)model;


@end
