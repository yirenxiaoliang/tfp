//
//  HQBaseCell.m
//  HuiJuHuaQi
//
//  Created by hq002 on 16/3/23.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

#define  LineHeight 0.5

@interface HQBaseCell ()
@end

@implementation HQBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}


- (void)setup{
    
    UIView *topLine = [[UIView alloc] init];
    [self.contentView addSubview:topLine];
    topLine.backgroundColor = CellSeparatorColor;
    self.topLine = topLine;
    
    UIView *bottomLine = [[UIView alloc] init];
    [self.contentView addSubview:bottomLine];
    bottomLine.backgroundColor = CellSeparatorColor;
    self.bottomLine = bottomLine;
    self.topLine.hidden = YES;
    self.bottomLine.hidden = YES;
    
    self.headMargin = 15;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat topX = self.headMargin;
    CGFloat topY = 0;
    CGFloat topW = SCREEN_WIDTH;
    CGFloat topH = LineHeight;
    self.topLine.frame = CGRectMake(topX, topY, topW, topH);
    
    CGFloat bottomX = self.headMargin;
    CGFloat bottomY = self.height - LineHeight;
    CGFloat bottomW = SCREEN_WIDTH;
    CGFloat bottomH = LineHeight;
    self.bottomLine.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
}

- (void)setHeadMargin:(NSInteger)headMargin{
    _headMargin = headMargin;
    CGFloat bottomX = self.headMargin;
    CGFloat bottomY = self.height - LineHeight;
    CGFloat bottomW = SCREEN_WIDTH;
    CGFloat bottomH = LineHeight;
    self.bottomLine.frame = CGRectMake(bottomX, bottomY, bottomW, bottomH);
    self.topLine.frame = CGRectMake(bottomX, 0, bottomW, bottomH);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
