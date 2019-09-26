//
//  TFPCPeoplesCell.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPCPeoplesCell.h"

@interface TFPCPeoplesCell ()

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation TFPCPeoplesCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.photoBtn.layer.cornerRadius = self.photoBtn.width/2.0;
    self.photoBtn.layer.masksToBounds = YES;
    
    self.statusBtn.layer.cornerRadius = 4.0;
    self.statusBtn.layer.masksToBounds = YES;
    
}


/** 打卡人员 */
- (void)configPCPeoplesCellWithModel:(TFEmployModel *)model {
    
    self.photoBtn.hidden = YES;
    [self.photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        self.photoBtn.hidden = NO;
        if (image == nil) {
            
            [self.photoBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [self.photoBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.photoBtn setBackgroundColor:HeadBackground];
        }else{
            
            [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
            [self.photoBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.photoBtn setBackgroundColor:WhiteColor];
        }
    }];
    
    self.nameLab.text = TEXT(model.employee_name);
    
    self.positionLab.text = IsStrEmpty(model.post_name) ? @"--"  : TEXT(model.post_name);
    
    if (model.statusList.count) {
        [self.statusBtn setTitle:model.statusList.firstObject forState:UIControlStateNormal];
        self.statusBtn.hidden = NO;
    }else{
        self.statusBtn.hidden = YES;
    }
    
    self.statusBtn.layer.borderWidth = 1.0;
}

//配置排班详情数据
- (void)configClassesDetailCellWithData:(HQEmployModel *)model {
    
//    [self.photoBtn setImage:IMG(@"企信-企信小助手") forState:UIControlStateNormal];
    if (![model.picture isEqualToString:@""] && model.picture !=nil) {

        [self.self.photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [self.self.photoBtn setTitle:@"" forState:UIControlStateNormal];
    }
    else {

        [self.self.photoBtn sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [self.self.photoBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [self.self.photoBtn setTitleColor:kUIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        [self.self.photoBtn setBackgroundColor:GreenColor];
    }

    
    self.nameLab.text = model.employee_name;
    
    self.positionLab.text = model.position;
    
    [self.statusBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];

}

//配置排行榜数据
- (void)configStatisticsChartsCellWithModel:(TFRankPeopleModel *)model index:(NSInteger)index{
    
    [self.photoBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            
            [self.photoBtn setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [self.photoBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.photoBtn setBackgroundColor:HeadBackground];
        }else{
            
            [self.photoBtn setTitle:@"" forState:UIControlStateNormal];
            [self.photoBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.photoBtn setBackgroundColor:WhiteColor];
        }
    }];
    self.nameLab.text = model.employee_name;
    
    self.positionLab.text = model.post_name;
    
    self.statusBtnW.constant = 40.0;
    self.statusBtnH.constant = 40.0;
    self.statusBtn.hidden = NO;
    if (index == 0) {
        [self.statusBtn setImage:IMG(@"第一名icon") forState:UIControlStateNormal];
    }else if (index == 1){
        [self.statusBtn setImage:IMG(@"第二名icon") forState:UIControlStateNormal];
    }else if (index == 2){
        [self.statusBtn setImage:IMG(@"第三名icon") forState:UIControlStateNormal];
    }else{
        self.statusBtn.hidden = YES;
    }
    self.memberLab.text = @"";
    if (model.real_punchcard_time) {
        self.memberLab.text = [HQHelper nsdateToTime:[model.real_punchcard_time longLongValue] formatStr:@"HH:mm"];
    }
    if (model.month_work_time) {
        NSInteger hour = [model.month_work_time longLongValue] / 60;
        NSInteger minute = [model.month_work_time longLongValue] % 60;
        if (hour == 0) {
            self.memberLab.text = [NSString stringWithFormat:@"%ld分钟",minute];
        }else{
            self.memberLab.text = [NSString stringWithFormat:@"%ld小时%ld分钟",hour,minute];
        }
    }
    if (model.late_time_number && model.late_count_number) {
        
        NSInteger hour = [model.late_time_number longLongValue] / 60;
        NSInteger minute = [model.late_time_number longLongValue] % 60;
        if (hour == 0) {
            self.memberLab.text = [NSString stringWithFormat:@"%@次  共%@分钟",model.late_count_number,model.late_time_number];
        }else{
            self.memberLab.text = [NSString stringWithFormat:@"%@次  共%ld小时%ld分钟",model.late_count_number,hour,minute];
        }
        self.memberLab.textColor = HexColor(0xF9A244);
        self.statusBtnH.constant = 0;
    }
}

+ (instancetype)TFPCPeoplesCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPCPeoplesCell" owner:self options:nil] lastObject];
}

+ (instancetype)PCPeoplesCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"TFPCPeoplesCell";
    TFPCPeoplesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self TFPCPeoplesCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
