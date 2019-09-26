//
//  TFNoteDetailHeadView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/25.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteDetailHeadView.h"


@interface TFNoteDetailHeadView ()



@end

@implementation TFNoteDetailHeadView


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.imageView.layer.cornerRadius = 22;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    
    self.positionLabel.textColor = HexColor(0x909090);
    self.positionLabel.font = FONT(11);
    
    self.timeLabel.textColor = HexColor(0x909090);
    self.timeLabel.font = FONT(11);
    
    self.nameLabel.text = @"";
    self.positionLabel.text = @"";
    self.timeLabel.text = @"";
    
//    self.nameLabel.text = @"尹明亮";
//    self.positionLabel.text = @"iOS工程师";
//    self.timeLabel.text = @"2018-03-23 08:00";
//    self.imageView.image = PlaceholderHeadImage;
    
    
    
}


- (void)refreshNoteDetailHeadViewWithPeople:(TFEmployModel *)people createTime:(long long)createTime{
    
    self.nameLabel.text = people.employee_name;
    self.positionLabel.text = people.duty_name;
    self.timeLabel.text = [HQHelper nsdateToTime:createTime formatStr:@"yyyy-MM-dd HH:mm"];
    [self.imageView sd_setImageWithURL:[HQHelper URLWithString:people.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image == nil) {
            [self.imageView setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.imageView setTitle:[HQHelper nameWithTotalName:people.employee_name] forState:UIControlStateNormal];
            self.imageView.backgroundColor = HeadBackground;
            
        }else{
            [self.imageView setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.imageView setTitle:@"" forState:UIControlStateNormal];
            self.imageView.backgroundColor = WhiteColor;
        }
        
    }];
    
}

+(instancetype)noteDetailHeadView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"TFNoteDetailHeadView" owner:self options:nil] lastObject];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
