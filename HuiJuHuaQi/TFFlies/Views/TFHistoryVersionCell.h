//
//  TFHistoryVersionCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFFolderListModel.h"

@protocol TFHistoryVersionCellDelegate <NSObject>

@optional

- (void)moreOperationClick:(NSInteger)index;

@end

@interface TFHistoryVersionCell : HQBaseCell

@property (nonatomic ,strong)UIImageView *typeImg;

@property (nonatomic ,strong)UILabel *titlelab;

@property (nonatomic ,strong)UILabel *nameLab;

@property (nonatomic ,strong)UILabel *timeLab;

@property (nonatomic ,strong)UILabel *sizeLab;

@property (nonatomic ,strong)UILabel *versionLab;

@property (nonatomic, strong)UIImageView *moreImgV;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, weak) id <TFHistoryVersionCellDelegate>delegate;

+ (TFHistoryVersionCell *)HistoryVersionCellWithTableView:(UITableView *)tableView;

//配置数据
- (void)refreshHistoryVersionDataWithModel:(TFFolderListModel *)model;

//配置数据
- (void)refreshFileListDataWithModel:(TFFolderListModel *)model;

//聊天文件
- (void)refreshChatFileDataWithModel:(TFFolderListModel *)model;

@end
