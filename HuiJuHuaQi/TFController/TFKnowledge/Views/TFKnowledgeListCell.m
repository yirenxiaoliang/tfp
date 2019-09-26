//
//  TFKnowledgeListCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeListCell.h"
#import "TFTagListView.h"

@interface TFKnowledgeListCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet TFTagListView *tagListView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIImageView *middleImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMiddleM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMiddleM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeftM;



@end

@implementation TFKnowledgeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.categoryLabel.textColor = GreenColor;
    self.categoryLabel.font = FONT(12);
    
    self.titleLabel.textColor = LightBlackTextColor;
    self.titleLabel.font = FONT(16);
    
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.font = FONT(14);
    self.contentLabel.numberOfLines = 2;
    
    self.rightImage.layer.cornerRadius = 4;
    self.rightImage.layer.masksToBounds = YES;
    self.middleImage.layer.cornerRadius = 4;
    self.middleImage.layer.masksToBounds = YES;
    self.leftImage.layer.cornerRadius = 4;
    self.leftImage.layer.masksToBounds = YES;
    self.rightImage.contentMode = UIViewContentModeScaleAspectFill;
    self.middleImage.contentMode = UIViewContentModeScaleAspectFill;
    self.leftImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.headBtn.layer.cornerRadius = 11;
    self.headBtn.layer.masksToBounds = YES;
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(12);
    
    self.timeLabel.textColor = GrayTextColor;
    self.timeLabel.font = FONT(12);
    
    self.line.backgroundColor = CellSeparatorColor;
    
    self.backgroundColor = WhiteColor;
    
}


-(void)refreshKnowledgeListCellWithModel:(TFKnowledgeItemModel *)model{
    
    
    self.categoryLabel.text = model.classification_name;
    self.titleLabel.text = model.title;
    if ([model.top isEqualToNumber:@1]) {
        NSString *str = @"[置顶]";
        NSString *total = [NSString stringWithFormat:@"%@ %@",str,model.title];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total];
        [attr addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, total.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:LightBlackTextColor range:NSMakeRange(0, total.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:RedColor range:NSMakeRange(0, str.length)];
        [attr addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(0, str.length)];
        self.titleLabel.attributedText = attr;
    }else{
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.title];
        [attr addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(0, model.title.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:LightBlackTextColor range:NSMakeRange(0, model.title.length)];
        self.titleLabel.attributedText = attr;
    }
    
    
    self.contentLabel.text = model.contentSimple;
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
    
    NSMutableArray *labels = [NSMutableArray array];
    for (TFCategoryModel *cate in model.label_ids) {
        TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
        op.value = [cate.id description];
        op.label = cate.name;
        op.color = @"#cccccc";
        [labels addObject:op];
    }
    [self.tagListView refreshKnowledgeWithOptions:labels];
    
    // 图片
    if (model.files.count == 0) {
        self.contentLeftM.constant = 0;
        self.leftW.constant = 0;
        self.leftMiddleM.constant = 0;
        self.middleW.constant = 0;
        self.rightMiddleM.constant = 0;
        self.rightW.constant = 0;
    }else if (model.files.count == 1){
        self.contentLeftM.constant = 0;
        self.leftW.constant = 0;
        self.leftMiddleM.constant = 0;
        self.middleW.constant = 0;
        self.rightMiddleM.constant = 8;
        self.rightW.constant = 44;
    }else if (model.files.count == 2){
        self.contentLeftM.constant = 0;
        self.leftW.constant = 0;
        self.leftMiddleM.constant = 8;
        self.middleW.constant = 44;
        self.rightMiddleM.constant = 8;
        self.rightW.constant = 44;
    }else{
        self.contentLeftM.constant = 8;
        self.leftW.constant = 44;
        self.leftMiddleM.constant = 8;
        self.middleW.constant = 44;
        self.rightMiddleM.constant = 8;
        self.rightW.constant = 44;
    }
}

+(instancetype)knowledgeListCell{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeListCell" owner:self options:nil] lastObject];
}

+(instancetype)knowledgeListCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFKnowledgeListCell";
    TFKnowledgeListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [TFKnowledgeListCell knowledgeListCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
