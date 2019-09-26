//
//  TFSelectMemoCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/1.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFNoteDataListModel.h"

@interface TFSelectMemoCell : HQBaseCell


+ (TFSelectMemoCell *)selectMemoCellWithTableView:(UITableView *)tableView;
- (void)refreshselectMemoCellWithModel:(TFNoteDataListModel *)model;
@end
