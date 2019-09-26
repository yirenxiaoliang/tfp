//
//  HQTFNoContentCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFNoContentCell.h"

@interface HQTFNoContentCell ()
@property (nonatomic, weak) UIImageView *tipImage;
@property (nonatomic, weak) UILabel *tipWord;

@end

@implementation HQTFNoContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withImage:(NSString *)image withText:(NSString *)text
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChildWithImage:(NSString *)image withText:(NSString *)text];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (HQTFNoContentCell *)noContentCellWithTableView:(UITableView *)tableView withImage:(NSString *)image withText:(NSString *)text
{
    static NSString *indentifier = @"HQTFNoContentCell";
    HQTFNoContentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFNoContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier withImage:(NSString *)image withText:(NSString *)text];
    }
    cell.topLine.hidden = YES;
//    cell.bottomLine.hidden = YES;
    cell.tipImage.image = [UIImage imageNamed:image];
    cell.tipWord.text = text;
    return cell;
}

- (void)setupChildWithImage:(NSString *)image withText:(NSString *)text{
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){(SCREEN_WIDTH-Long(150))/2,Long(10),Long(150),Long(150)}];
    imageView.image = [UIImage imageNamed:image];
    [self.contentView addSubview:imageView];
    self.tipImage = imageView;
    
    UILabel *titleLabel = [HQHelper labelWithFrame:(CGRect){0,CGRectGetMaxY(imageView.frame)+Long(22),180,22} text:text textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(16)];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    self.tipWord = titleLabel;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.tipImage.frame = (CGRect){(SCREEN_WIDTH-Long(100))/2,Long(10),Long(100),Long(100)};
    self.tipWord.frame = (CGRect){(SCREEN_WIDTH-180)/2,CGRectGetMaxY(self.tipImage.frame)+Long(22),180,44};
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
