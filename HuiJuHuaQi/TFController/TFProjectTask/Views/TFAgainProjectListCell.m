//
//  TFAgainProjectListCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/6.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAgainProjectListCell.h"
#import "TFProjectProgressView.h"

@interface TFAgainProjectListCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIImageView *overImage;
@property (weak, nonatomic) IBOutlet TFProjectProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *pView;
@property (weak, nonatomic) IBOutlet UIView *finishView;
@property (weak, nonatomic) IBOutlet UIView *workingView;
@property (weak, nonatomic) IBOutlet UIView *overingView;
@property (weak, nonatomic) IBOutlet UIView *notWorkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *starW;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *workingViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *overingViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notWorkViewW;

@end

@implementation TFAgainProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgImageView.layer.cornerRadius = 4;
    self.bgImageView.layer.cornerRadius = 4;
    self.bgImageView.layer.borderColor = CellSeparatorColor.CGColor;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.starBtn setImage:[UIImage imageNamed:@"projectNoStar"] forState:UIControlStateNormal];
    [self.starBtn setImage:[UIImage imageNamed:@"projectStar"] forState:UIControlStateSelected];
    self.backgroundColor = ClearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(14);
    [self.starBtn addTarget:self action:@selector(starBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.pView.layer.cornerRadius = 4;
    self.pView.backgroundColor = HexColor(0xd8d8d8);
    self.pView.layer.masksToBounds = YES;
    
    self.finishView.layer.cornerRadius = 5;
    self.finishView.backgroundColor = HexColor(0x0ABF7E);
    self.finishView.layer.borderColor = WhiteColor.CGColor;
    self.finishView.layer.borderWidth = 1;
    
    self.workingView.layer.cornerRadius = 5;
    self.workingView.backgroundColor = GreenColor;
    self.workingView.layer.borderColor = WhiteColor.CGColor;
    self.workingView.layer.borderWidth = 1;
    
    self.overingView.layer.cornerRadius = 5;
    self.overingView.backgroundColor = RedColor;
    self.overingView.layer.borderColor = WhiteColor.CGColor;
    self.overingView.layer.borderWidth = 1;
    
    self.notWorkView.layer.cornerRadius = 5;
    self.notWorkView.backgroundColor = HexColor(0xd8d8d8);
    self.notWorkView.layer.borderColor = WhiteColor.CGColor;
    self.notWorkView.layer.borderWidth = 1;
    
    self.precentLabel.font = FONT(14);
    self.precentLabel.textColor = GrayTextColor;
}

- (void)refreshAgainProjectListCellWithProjectModel:(TFProjectModel *)model{
    
    self.nameLabel.text = model.name;
    
    if (!model.star_level || [model.star_level isEqualToNumber:@0]) {
        self.starBtn.selected = NO;
        self.starBtn.hidden = YES;
        self.starW.constant = 0;
    }else{
        self.starBtn.selected = YES;
        self.starBtn.hidden = NO;
        self.starW.constant = 20;
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
    
    // 完成数字
    NSString *str1 = [NSString stringWithFormat:@"%ld",[NUMBER(model.complete_number) integerValue]];
    NSString *str2 = [NSString stringWithFormat:@"%ld",[NUMBER(model.doing_number) integerValue]];
    NSString *str3 = [NSString stringWithFormat:@"%ld",[NUMBER(model.overdue_no_begin_number) integerValue]];
    NSString *str4 = [NSString stringWithFormat:@"%ld",[NUMBER(model.no_begin_number) integerValue] + [NUMBER(model.stop_number) integerValue]];
    self.precentLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@",str1,str2,str3,str4];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:@""];
    NSAttributedString *str1Attr = [[NSAttributedString alloc] initWithString:str1 attributes:@{NSForegroundColorAttributeName:HexColor(0x0ABF7E)}];
    NSAttributedString *aaa1 = [[NSAttributedString alloc] initWithString:@"/"];
    NSAttributedString *str2Attr = [[NSAttributedString alloc] initWithString:str2 attributes:@{NSForegroundColorAttributeName:GreenColor}];
    NSAttributedString *aaa2 = [[NSAttributedString alloc] initWithString:@"/"];
    NSAttributedString *str3Attr = [[NSAttributedString alloc] initWithString:str3 attributes:@{NSForegroundColorAttributeName:RedColor}];
    NSAttributedString *aaa3 = [[NSAttributedString alloc] initWithString:@"/"];
    NSAttributedString *str4Attr = [[NSAttributedString alloc] initWithString:str4 attributes:@{NSForegroundColorAttributeName:HexColor(0xd8d8d8)}];
    [attr appendAttributedString:str1Attr];
    [attr appendAttributedString:aaa1];
    [attr appendAttributedString:str2Attr];
    [attr appendAttributedString:aaa2];
    [attr appendAttributedString:str3Attr];
    [attr appendAttributedString:aaa3];
    [attr appendAttributedString:str4Attr];
    self.precentLabel.attributedText = attr;
    
    
    if ([NUMBER(model.task_count) integerValue] == 0) {
        self.finishView.hidden = YES;
        self.workingView.hidden = YES;
        self.overingView.hidden = YES;
        self.notWorkView.hidden = YES;
        self.finishViewW.constant = 5;
        self.workingViewW.constant = 0;
        self.overingViewW.constant = 0;
        self.notWorkViewW.constant = 0;
    }else{
        if ([NUMBER(model.complete_number) integerValue] == 0) {
            self.finishViewW.constant = 5;
            self.finishView.hidden = YES;
        }else{
            CGFloat rate = (([NUMBER(model.complete_number) integerValue] * 1.0) / ([NUMBER(model.task_count) integerValue] * 1.0));
            self.finishViewW.constant = rate * (SCREEN_WIDTH - 187)+ 5;
            self.finishView.hidden = NO;
        }
        if ([NUMBER(model.doing_number) integerValue] == 0) {
            self.workingViewW.constant = 5;
            self.workingView.hidden = YES;
        }else{
            CGFloat rate = (([NUMBER(model.doing_number) integerValue] * 1.0) / ([NUMBER(model.task_count) integerValue] * 1.0));
            self.workingViewW.constant = rate * (SCREEN_WIDTH - 187) + 5;
            self.workingView.hidden = NO;
        }
        if ([NUMBER(model.overdue_no_begin_number) integerValue] == 0) {
            self.overingViewW.constant = 5;
            self.overingView.hidden = YES;
        }else{
            CGFloat rate = (([NUMBER(model.overdue_no_begin_number) integerValue] * 1.0) / ([NUMBER(model.task_count) integerValue] * 1.0));
            self.overingViewW.constant = rate * (SCREEN_WIDTH - 187) + 5;
            self.overingView.hidden = NO;
        }
        if ([NUMBER(model.no_begin_number) integerValue] == 0 && [NUMBER(model.stop_number) integerValue] == 0) {
            self.notWorkViewW.constant = 5;
            self.notWorkView.hidden = YES;
        }else{
            CGFloat rate = ((([NUMBER(model.no_begin_number) integerValue] + [NUMBER(model.stop_number) integerValue]) * 1.0) / ([NUMBER(model.task_count) integerValue] * 1.0));
            self.notWorkViewW.constant = rate * (SCREEN_WIDTH - 187) + 5;
            self.notWorkView.hidden = NO;
        }
    }
    
    
}
- (void)starBtnClicked:(UIButton *)button{
    
    //    button.selected = !button.selected;
    //    if ([self.delegate respondsToSelector:@selector(projectListCellDidClickedStarBtn:)]) {
    //        [self.delegate projectListCellDidClickedStarBtn:button];
    //    }
}

+(instancetype)againProjectListCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFAgainProjectListCell" owner:self options:nil] lastObject];
}
+(instancetype)againProjectListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFAgainProjectListCell";
    TFAgainProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFAgainProjectListCell againProjectListCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
