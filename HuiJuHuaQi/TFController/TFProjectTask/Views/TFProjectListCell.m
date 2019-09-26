//
//  TFProjectListCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/9.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectListCell.h"
#import "TFProjectProgressView.h"

@interface TFProjectListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet TFProjectProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *overImage;


@end

@implementation TFProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgImageView.layer.cornerRadius = 4;
    self.bgImageView.layer.borderColor = CellSeparatorColor.CGColor;
//    self.bgImageView.layer.borderWidth = 0.5;
    self.bgImageView.layer.shadowColor = CellSeparatorColor.CGColor;
    self.bgImageView.layer.shadowOffset = CGSizeMake(4, 4);
    self.bgImageView.layer.shadowRadius = 2;
    self.bgImageView.layer.shadowOpacity = 0.3;
    
    [self.starBtn setImage:[UIImage imageNamed:@"projectNoStar"] forState:UIControlStateNormal];
    [self.starBtn setImage:[UIImage imageNamed:@"projectStar"] forState:UIControlStateSelected];
    self.backgroundColor = ClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.textColor = WhiteColor;
    self.nameLabel.font = FONT(14);
    
    [self.starBtn addTarget:self action:@selector(starBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)starBtnClicked:(UIButton *)button{
    
//    button.selected = !button.selected;
//    if ([self.delegate respondsToSelector:@selector(projectListCellDidClickedStarBtn:)]) {
//        [self.delegate projectListCellDidClickedStarBtn:button];
//    }
}


+ (instancetype)projectListCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectListCell" owner:self options:nil] lastObject];
}

+ (TFProjectListCell *)projectListCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFProjectListCell";
    TFProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self projectListCell];
    }
    return cell;
}


- (void)refreshProjectListCellWithProjectModel:(TFProjectModel *)model{
    
    self.nameLabel.text = model.name;
    
    if (!model.star_level || [model.star_level isEqualToNumber:@0]) {
        self.starBtn.selected = NO;
    }else{
        self.starBtn.selected = YES;
    }
    
    // 超期
    if ([model.deadline_status isEqualToString:@"1"]) {
        self.overImage.image = IMG(@"超期");
    }else{
        self.overImage.image = nil;
    }
    
    if ([model.project_status isEqualToString:@"1"]) {// 归档
        self.overImage.image = IMG(@"归档");
    }else if ([model.project_status isEqualToString:@"2"]) {// 暂停
        self.overImage.image = IMG(@"暂停");
    }else if ([model.project_status isEqualToString:@"3"]) {// 删除
        
    }
    
    if (model.pic_url && ![model.pic_url isEqualToString:@""]) {
        
        [self.bgImageView sd_setImageWithURL:[HQHelper URLWithString:model.pic_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                self.bgImageView.image = [UIImage imageNamed:@"projectBg"];
            }
        }];
    }else{
        
        if (model.system_default_pic && ![model.system_default_pic isEqualToString:@""]) {
            
            self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"modelBg%@",[model.system_default_pic description]]]?:[UIImage imageNamed:[NSString stringWithFormat:@"modelBg1"]];
        }else{
            
            self.bgImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"modelBg%@",[model.temp_id description]]]?:[UIImage imageNamed:[NSString stringWithFormat:@"modelBg1"]];
        }
    }
    
    // 任务进度
    if ([model.project_progress_status isEqualToString:@"1"]) {
        self.progressView.rate = [model.project_progress_content integerValue]/100.0;
    }else{
        if (model.project_progress_number) {
            self.progressView.rate = [model.project_progress_number integerValue]/100.0;
        }else{
            if (model.task_count && model.task_complete_count) {
                if ([model.task_count integerValue] != 0) {
                    self.progressView.rate = [model.task_complete_count integerValue]*1.0/[model.task_count integerValue]*1.0;
                }else{
                    self.progressView.rate = 0;
                }
            }else{
                self.progressView.rate = 0;
            }
        }
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
