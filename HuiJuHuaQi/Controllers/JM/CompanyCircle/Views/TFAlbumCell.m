//
//  TFAlbumCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAlbumCell.h"
#import "TFAlbumImageView.h"

@interface TFAlbumCell ()

/** UILabel *dateLabel */
@property (nonatomic, weak) UILabel *dateLabel;
/** UITextView *addressText */
@property (nonatomic, weak) UITextView *addressText;
/** TFAlbumImageView *albumView */
@property (nonatomic, weak) TFAlbumImageView *albumView;
/** UITextView *contentText */
@property (nonatomic, weak) UILabel *contentText;
/** UILabel *imageNumLabel */
@property (nonatomic, weak) UILabel *imageNumLabel;

/** model */
@property (nonatomic, strong) HQCategoryItemModel *model;


@end

@implementation TFAlbumCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:(CGRect){10,15,85-20,30}];
    [self addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    UITextView *addressText = [[UITextView alloc] initWithFrame:(CGRect){10,55,85-15,50}];
    addressText.editable = NO;
    addressText.scrollEnabled = NO;
    [self addSubview:addressText];
    self.addressText = addressText;
    addressText.font = FONT(12);
    addressText.textColor = ExtraLightBlackTextColor;
    addressText.contentInset = UIEdgeInsetsMake(-5, -5, -5, 5);
    addressText.selectable = NO;
//    addressText.textAlignment = NSTextAlignmentJustified;
    
    TFAlbumImageView *albumView = [[TFAlbumImageView alloc] initWithFrame:(CGRect){85,15,80,80}];
    [self addSubview:albumView];
    self.albumView = albumView;
    
    UILabel *contentText = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(albumView.frame) + 10,15,SCREEN_WIDTH - (CGRectGetMaxX(albumView.frame) + 10)-15,46}];
    [self addSubview:contentText];
    contentText.numberOfLines = 2;
    self.contentText = contentText;
    contentText.font= FONT(16);
    contentText.textColor = BlackTextColor;
//    contentText.textAlignment = NSTextAlignmentJustified;
    
    UILabel *imageNumLabel = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(albumView.frame) + 10,CGRectGetMaxY(albumView.frame)-20,(CGRectGetMaxX(albumView.frame) + 10)-24,20}];
    [self addSubview:imageNumLabel];
    self.imageNumLabel = imageNumLabel;
    imageNumLabel.font = FONT(12);
    imageNumLabel.textColor = ExtraLightBlackTextColor;
    
}

-(void)refreshAlbumCellWithModel:(HQCategoryItemModel *)model{
    
    self.model = model;
    
    
    if (model.images.count) {
        
        if (!model.address || [model.address isEqualToString:@""]) {
            self.addressText.hidden = YES;
        }else{
            self.addressText.hidden = NO;
        }
        self.albumView.hidden = NO;
        self.imageNumLabel.hidden = NO;
        
    }else{
        
        self.addressText.hidden = YES;
        self.albumView.hidden = YES;
        self.imageNumLabel.hidden = YES;
    }

    self.dateLabel.attributedText = [self dateWithTime:model.datetimeCreateDate];
    self.addressText.text = model.address;
    self.contentText.text = model.info;
    self.imageNumLabel.text = [NSString stringWithFormat:@"共%ld张",model.images.count];
    [self.albumView refreshAlbumImageViewWithImages:model.images];
    
}


+ (CGFloat)refreshAlbumCellHeightWithModel:(HQCategoryItemModel *)model{
    
    if (model.images.count) {
        
        return 110;
    }else{
        
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-85-15,MAXFLOAT} titleStr:model.info];
        
        
        if (size.height < 30) {
            return 30  + 30;
        }else{
            return 54 + 30;
        }
    }
}

-(NSAttributedString *)dateWithTime:(NSNumber *)time{
    
    if ([[HQHelper nsdateToTime:[time longLongValue] formatStr:@"MMdd"] isEqualToString:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"MMdd"]]) {
        
        NSString *str = @"今天";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
        
        [string addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:(NSRange){0,str.length}];
        [string addAttribute:NSFontAttributeName value:BFONT(28) range:(NSRange){0,str.length}];
        return string;
    }else{
        
        NSString *month = [HQHelper nsdateToTime:[time longLongValue] formatStr:@"MM"];
        NSString *day = [HQHelper nsdateToTime:[time longLongValue] formatStr:@"dd"];
        NSString *totalStr = [NSString stringWithFormat:@"%@ %@月",day,month];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalStr];
        [string addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:(NSRange){0,totalStr.length}];
        [string addAttribute:NSFontAttributeName value:BFONT(26) range:[totalStr rangeOfString:day]];
        [string addAttribute:NSFontAttributeName value:FONT(12) range:[totalStr rangeOfString:[NSString stringWithFormat:@"%@月",month]]];
        
        return string;
    }
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.model.images.count) {
        
        self.contentText.frame = (CGRect){CGRectGetMaxX(self.albumView.frame) + 10,15,SCREEN_WIDTH - (CGRectGetMaxX(self.albumView.frame) + 10)-15,40};
        self.contentText.backgroundColor = ClearColor;
    }else{
        
        self.contentText.frame = (CGRect){85,15,SCREEN_WIDTH-85-15,46};
        self.contentText.backgroundColor = BackGroudColor;
        
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-85-15,MAXFLOAT} titleStr:self.model.info];
        
        if (size.height < 30) {
            self.contentText.height = 30;
        }else{
            self.contentText.height = 44;
        }
        
    }
//    self.addressText.backgroundColor = BackGroudColor;
//    self.contentText.backgroundColor = BackGroudColor;
}


+(instancetype)albumCellWithTableView:(UITableView *)tableView{
    
    static NSString *indentifier = @"TFAlbumCell";
    TFAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    return cell;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
