//
//  TFChildTaskCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/8.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFChildTaskCell.h"

@interface TFChildTaskCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *finishCenterY;


@end


@implementation TFChildTaskCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(14);
    [self.timeBtn setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
    self.timeBtn.userInteractionEnabled = NO;
    self.timeBtn.titleLabel.font = FONT(12);
    
    self.headBtn.layer.cornerRadius = 15;
    self.headBtn.layer.masksToBounds = YES;
    self.topLine.hidden = YES;
    self.bottomLine.hidden = YES;
    self.headBtn.titleLabel.font = FONT(12);
    
    [self.selectBtn addTarget:self action:@selector(selectBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectBtnClicked:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(childTaskCellDidClickedSelectBtn:)]) {
        [self.delegate childTaskCellDidClickedSelectBtn:button];
    }
    
}

- (void)refreshChildTaskCellWithModel:(TFProjectRowModel *)model{
    
    self.nameLabel.text = model.taskName;
    if (model.endTime && [model.endTime longLongValue] != 0) {
        [self.timeBtn setImage:IMG(@"时间") forState:UIControlStateNormal];
        [self.timeBtn setTitle:[HQHelper nsdateToTime:[model.endTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"] forState:UIControlStateNormal];
        self.finishCenterY.constant = -10;
        self.timeBtn.hidden = NO;
    }else{
        self.finishCenterY.constant = 0 ;
        self.timeBtn.hidden = YES;
    }
    
    if (model.personnel_principal.count) {
        TFEmployModel *em = model.personnel_principal[0];
        if (IsStrEmpty([em.id description]) && IsStrEmpty([em.employee_id description])) {
            self.headBtn.hidden = YES;
        }else{
            self.headBtn.hidden = NO;
            [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:em.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (image) {
                    [self.headBtn setTitle:@"" forState:UIControlStateNormal];
                }else{
                    [self.headBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                    [self.headBtn setTitle:[HQHelper nameWithTotalName:em.name] forState:UIControlStateNormal];
                }
            }];
        }
    }
    
    self.selectBtn.selected = [[model.finishType description] isEqualToString:@"1"]?YES:NO;
    
}
+ (CGFloat)refreshChildTaskCellHeightWithModel:(id)model{
    
    return 50;
}

+ (instancetype)childTaskCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFChildTaskCell" owner:self options:nil] lastObject];
}

+ (TFChildTaskCell *)childTaskCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFChildTaskCell";
    TFChildTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self childTaskCell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
