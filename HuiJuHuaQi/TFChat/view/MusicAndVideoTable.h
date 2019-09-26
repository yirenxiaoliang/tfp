//
//  MusicTable.h
//  ChatTest
//
//  Created by Season on 2017/5/19.
//  Copyright © 2017年 Season. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseFileCell.h"
@interface MusicAndVideoTable : UITableView<UITableViewDelegate,UITableViewDataSource>


/**
 视频信息
 */
@property(nonatomic,strong)NSMutableArray <PHAsset *> *assets;


/**
 音乐信息
 */
@property(nonatomic,strong)NSMutableArray *musics;


/**
 选中数组
 */
@property(nonatomic,strong)NSMutableArray *selectedAssets;


@end
