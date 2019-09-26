//
//  TFNewNoteListView.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFNoteDataListModel.h"

@interface TFNewNoteListView : UIView

+(instancetype)newNoteListView;

//刷新cell
- (void)refreshNewNoteListCellWithModel:(TFNoteDataListModel *)model;

@end
