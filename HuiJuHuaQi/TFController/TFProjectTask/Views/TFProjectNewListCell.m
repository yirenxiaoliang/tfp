//
//  TFProjectNewListCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/16.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectNewListCell.h"

@interface TFProjectNewListCell ()
@property (weak, nonatomic) IBOutlet UIView *cView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenTrailW;

@property (weak, nonatomic) IBOutlet UIView *pView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIImageView *overImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starW;
/** rateLabel */
@property (nonatomic, weak) IBOutlet UILabel *rateLabel;
@end

@implementation TFProjectNewListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pView.layer.cornerRadius = 4;
    self.cView.layer.cornerRadius = 4;
    self.pView.backgroundColor = HexColor(0xd8d8d8);
    self.cView.backgroundColor = GreenColor;
    self.bgImageView.layer.cornerRadius = 4;
    self.bgImageView.layer.cornerRadius = 4;
    self.bgImageView.layer.borderColor = CellSeparatorColor.CGColor;
    self.bgImageView.layer.masksToBounds = YES;
    //    self.bgImageView.layer.borderWidth = 0.5;
//    self.bgImageView.layer.shadowColor = CellSeparatorColor.CGColor;
//    self.bgImageView.layer.shadowOffset = CGSizeMake(4, 4);
//    self.bgImageView.layer.shadowRadius = 2;
//    self.bgImageView.layer.shadowOpacity = 0.3;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;

    
    [self.starBtn setImage:[UIImage imageNamed:@"projectNoStar"] forState:UIControlStateNormal];
    [self.starBtn setImage:[UIImage imageNamed:@"projectStar"] forState:UIControlStateSelected];
    self.backgroundColor = ClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(14);
    self.greenTrailW.constant = 0;
    [self.starBtn addTarget:self action:@selector(starBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)starBtnClicked:(UIButton *)button{
    
    //    button.selected = !button.selected;
    //    if ([self.delegate respondsToSelector:@selector(projectListCellDidClickedStarBtn:)]) {
    //        [self.delegate projectListCellDidClickedStarBtn:button];
    //    }
}

- (void)refreshProjectListCellWithProjectModel:(TFProjectModel *)model{
    
    self.nameLabel.text = model.name;
    
    if (!model.star_level || [model.star_level isEqualToNumber:@0]) {
        self.starBtn.selected = NO;
        self.starBtn.hidden = YES;
        self.starW.constant = 0;
    }else{
        self.starBtn.selected = YES;
        self.starBtn.hidden = NO;
        self.starW.constant = 30;
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
    CGFloat rate = 0;
    if ([model.project_progress_status isEqualToString:@"1"]) {
        rate = [model.project_progress_content integerValue]/100.0;
    }else{
        if (model.project_progress_number) {
            rate = [model.project_progress_number integerValue]/100.0;
        }else{
            if (model.task_count && model.task_complete_count) {
                if ([model.task_count integerValue] != 0) {
                    rate = [model.task_complete_count integerValue]*1.0/[model.task_count integerValue]*1.0;
                }else{
                    rate = 0;
                }
            }else{
                rate = 0;
            }
        }
    }
    self.greenTrailW.constant = rate * self.pView.width;

    NSString *str = [NSString stringWithFormat:@"%.0f%@",rate*100,@"%"];
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:str];
    [att addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:NSMakeRange(0, str.length)];
    [att addAttribute:NSFontAttributeName value:BFONT(20) range:NSMakeRange(0, str.length-1)];
    [att addAttribute:NSFontAttributeName value:BFONT(12) range:NSMakeRange(str.length-1, 1)];
    
    self.rateLabel.attributedText = att;
}

+(instancetype)projectNewListCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFProjectNewListCell" owner:self options:nil] lastObject];
}
+(instancetype)projectNewListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFProjectNewListCell";
    TFProjectNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFProjectNewListCell projectNewListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
