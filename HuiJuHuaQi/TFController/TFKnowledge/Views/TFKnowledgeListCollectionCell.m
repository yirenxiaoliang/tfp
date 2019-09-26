//
//  TFKnowledgeListCollectionCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeListCollectionCell.h"

@interface TFKnowledgeListCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;

@end

@implementation TFKnowledgeListCollectionCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.textColor = LightBlackTextColor;
    self.titleLabel.font = FONT(16);
    
    self.contentLabel.textColor = ExtraLightBlackTextColor;
    self.contentLabel.font = FONT(14);
    
    self.firstImage.layer.cornerRadius = 4;
    self.firstImage.layer.masksToBounds = YES;
    
    
    self.headBtn.layer.cornerRadius = 11;
    self.headBtn.layer.masksToBounds = YES;
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(12);
    
    self.timeLabel.textColor = GrayTextColor;
    self.timeLabel.font = FONT(12);
    
    self.line.backgroundColor = CellSeparatorColor;
    
    self.backgroundColor = ClearColor;
    
    self.bgView.layer.cornerRadius = 4;
    self.bgView.layer.shadowColor = CellSeparatorColor.CGColor;
    self.bgView.layer.shadowOffset = CGSizeZero;
    self.bgView.layer.shadowRadius = 4;
    self.bgView.layer.shadowOpacity = 0.5;
    
    self.firstImage.contentMode = UIViewContentModeScaleAspectFill;
    self.contentLabel.numberOfLines = 0;
    
}


-(void)refreshKnowledgeListCollectionCellWithModel:(TFKnowledgeItemModel *)model{
    
    self.titleLabel.text = model.title;;
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
    self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy/MM/dd HH:mm"];
    
    if (model.files.count) {
        self.firstImage.hidden = NO;
        self.imageH.constant = 80;
    }else{
        self.firstImage.hidden = YES;
        self.imageH.constant = 0;
    }
}

+(CGSize)refreshKnowledgeListCollectionCellSizeWithModel:(TFKnowledgeItemModel *)model{
    
    CGSize size;
    CGFloat width = (SCREEN_WIDTH-10*(2+1))/2;
    CGFloat height = 30 + 38 + 20;
//#define ITEM_WIDTH   (SCREEN_WIDTH-PADDING*(LINE+1))/LINE
    
    if (model.files.count) {
        height += 90;// 80 + 边距
    }
    CGSize ss = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){width-20,MAXFLOAT} titleStr:[HQHelper filterHTML:model.content]];
    
    height += ss.height;
    
    if (height > 250) {
        height = 250;
    }
    
    size = CGSizeMake(width, height);
    
    return size;
}

@end
