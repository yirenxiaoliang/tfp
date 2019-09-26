//
//  TFPunchCardCell.h
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFPutchRecordModel.h"

@protocol TFPunchCardCellDelegate <NSObject>

@optional
-(void)punchCardCellDidChange:(TFPutchRecordModel *)model;
-(void)addCardCellDidChange:(TFPutchRecordModel *)model;

@end

@interface TFPunchCardCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIImageView *statusImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *pcTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *pcStatusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *pcTypeImgV;
@property (weak, nonatomic) IBOutlet UILabel *pcTypeLab;
@property (weak, nonatomic) IBOutlet UILabel *updateLab;
@property (weak, nonatomic) IBOutlet UILabel *line;


@property (nonatomic, weak) id <TFPunchCardCellDelegate>delegate;
//配置数据
- (void)configPunchCardCellWithModel:(TFPutchRecordModel *)model;

+ (instancetype)PunchCardCellWithTableView:(UITableView *)tableView;

@end
