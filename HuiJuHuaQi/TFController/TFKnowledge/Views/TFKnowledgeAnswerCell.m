//
//  TFKnowledgeAnswerCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeAnswerCell.h"

@interface TFKnowledgeAnswerCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottomM;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@end

@implementation TFKnowledgeAnswerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = WhiteColor;
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.font = FONT(14);
    self.contentLabel.numberOfLines = 2;
    self.firstImage.layer.cornerRadius = 4;
    self.firstImage.layer.masksToBounds = YES;
    self.line.backgroundColor = CellSeparatorColor;
    self.headBtn.layer.cornerRadius = 11;
    self.headBtn.layer.masksToBounds = YES;
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(12);
    self.timeLabel.textColor = ExtraLightBlackTextColor;
    self.timeLabel.font = FONT(12);
    self.backgroundColor = BackGroudColor;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


-(void)refreshKnowledgeAnswerCellWithModel:(TFKnowledgeItemModel *)model{
    
    self.contentLabel.text = [HQHelper filterHTML:model.content];
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.create_by.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            self.headBtn.backgroundColor = GreenColor;
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.create_by.employee_name] forState:UIControlStateNormal];
            self.headBtn.titleLabel.font = FONT(10);
        }
    }];
    
    self.nameLabel.text = model.create_by.employee_name;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
    if (model.files.count == 0) {
        self.imageH.constant = 0;
        self.imageBottomM.constant = 0;
        self.firstImage.hidden = YES;
    }else{
        self.firstImage.hidden = NO;
        self.imageH.constant = 60;
        self.imageBottomM.constant = 8;
    }
    if ([[model.top description] isEqualToString:@"1"]) {
        self.topImage.hidden = NO;
    }else{
        self.topImage.hidden = YES;
    }
}

/** 高度 */
+(CGFloat)refreshAnswerHeightWithModel:(TFKnowledgeItemModel *)model{
    
    if (model.files.count == 0) {
        return 110;
    }else{
        return 178;
    }
}

+(instancetype)knowledgeAnswerCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeAnswerCell" owner:self options:nil] lastObject];
}

+(instancetype)knowledgeAnswerCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFKnowledgeAnswerCell";
    TFKnowledgeAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [self knowledgeAnswerCell];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
