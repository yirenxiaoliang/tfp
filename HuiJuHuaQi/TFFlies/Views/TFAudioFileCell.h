//
//  TFAudioFileCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/5/16.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "HQAudioModel.h"

@class TFAudioFileCell;

@protocol TFAudioFileCellDelegate <NSObject>

@optional
-(void)audioCell:(TFAudioFileCell *)audioCell withPlayer:(AVAudioPlayer *)player;

@end

@interface TFAudioFileCell : HQBaseCell


+ (instancetype)audioFileCellWithTableView:(UITableView *)tableView;

-(void)refreshAudioFileCellWithAudioModel:(HQAudioModel *)model withType:(NSInteger)type;

/** delegate */
@property (nonatomic, weak) id <TFAudioFileCellDelegate>delegate;

@end
