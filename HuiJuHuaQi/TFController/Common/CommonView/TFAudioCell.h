//
//  TFAudioCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/6/6.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAudioModel.h"

@class TFAudioCell;

@protocol TFAudioCellDelegate <NSObject>

@optional
-(void)audioCell:(TFAudioCell *)audioCell withPlayer:(AVAudioPlayer *)player;

@end

@interface TFAudioCell : HQBaseCell

+ (instancetype)audioCellWithTableView:(UITableView *)tableView;

-(void)refreshAudioCellWithAudioModel:(HQAudioModel *)model withType:(NSInteger)type;

/** delegate */
@property (nonatomic, weak) id <TFAudioCellDelegate>delegate;
@end
