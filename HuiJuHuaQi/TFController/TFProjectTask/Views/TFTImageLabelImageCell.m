
//
//  TFTImageLabelImageCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTImageLabelImageCell.h"

@interface TFTImageLabelImageCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleImage;
@property (weak, nonatomic) IBOutlet UIButton *enterImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameTrail;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation TFTImageLabelImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleImage.userInteractionEnabled = NO;
    self.enterImage.userInteractionEnabled = NO;
    self.nameLabel.font = FONT(14);
    self.nameLabel.textColor = ExtraLightBlackTextColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.enterImageName = @"下一级浅灰";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameClicked:)];
    [self.nameLabel addGestureRecognizer:tap];
    
    self.descLabel.font = FONT(14);
    self.descLabel.text = @"";
    self.descLabel.textColor = LightBlackTextColor;
}

-(void)setIsTap:(BOOL)isTap{
    _isTap = isTap;
    if (isTap) {
        self.nameLabel.userInteractionEnabled = YES;
    }else{
        self.nameLabel.userInteractionEnabled = NO;
    }
}

- (void)nameClicked:(UITapGestureRecognizer *)greture{
    
    CGPoint point = [greture locationInView:greture.view];
    
    NSArray *strs = [self.nameLabel.text componentsSeparatedByString:@" > "];
    
    NSString *append = @"";
    for (NSInteger i = 0; i < strs.count; i ++) {
        NSString *str = strs[i];
        append = [append stringByAppendingString:[NSString stringWithFormat:@"%@ > ",str]];
        CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:append];
        if (point.x < size.width) {
            if ([self.delegate respondsToSelector:@selector(imageLabelImageCellDidClickedNamePosition:)]) {
                [self.delegate imageLabelImageCellDidClickedNamePosition:i];
            }
            break;
        }
    }
    
    
}

-(void)setEnterImageHidden:(BOOL)enterImageHidden{
    _enterImageHidden = enterImageHidden;
    self.enterImage.hidden = enterImageHidden;
}

-(void)setTitleImageName:(NSString *)titleImageName{
    _titleImageName = titleImageName;
    
    [self.titleImage setImage:IMG(TEXT(titleImageName)) forState:UIControlStateNormal];
    [self.titleImage setImage:IMG(TEXT(titleImageName)) forState:UIControlStateHighlighted];
}


-(void)setEnterImageName:(NSString *)enterImageName{
    _enterImageName = enterImageName;
    [self.enterImage setImage:IMG(TEXT(enterImageName)) forState:UIControlStateNormal];
    [self.enterImage setImage:IMG(TEXT(enterImageName)) forState:UIControlStateHighlighted];
}

-(void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}
-(void)setDesc:(NSString *)desc{
    _desc = desc;
    self.descLabel.text = desc;
}


+ (instancetype)imageLabelImageCell
{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFTImageLabelImageCell" owner:self options:nil] lastObject];
}

+ (TFTImageLabelImageCell *)imageLabelImageCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"TFTImageLabelImageCell";
    TFTImageLabelImageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [self imageLabelImageCell];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
