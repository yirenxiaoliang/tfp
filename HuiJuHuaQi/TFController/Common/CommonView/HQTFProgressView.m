//
//  HQTFProgressView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/16.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProgressView.h"

@interface HQTFProgressView ()
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *progress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressRate;

@end

@implementation HQTFProgressView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.month.textColor = LightBlackTextColor;
    self.number.textColor = GrayTextColor;
    self.bgView.backgroundColor = HexAColor(0xf2f2f2, 1);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    self.progress.layer.cornerRadius = 5;
    self.progress.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setType:(HQTFProgressViewType)type{
    _type = type;
    
    switch (type) {
        case ProgressViewMonth:
        {
            self.month.text = @"本月";
            self.progress.backgroundColor = GreenColor;
        }
            break;
        case ProgressViewSeason:
        {
            self.month.text = @"本季";
            self.progress.backgroundColor = HexAColor(0x00abf9, 1);
        }
            break;
        case ProgressViewYear:
        {
            self.month.text = @"本年";
            self.progress.backgroundColor = HexAColor(0xf19602, 1);
        }
            break;
            
        default:
            break;
    }
}

-(NSAttributedString *)attributeStringWithFinishTask:(NSInteger)finish withTotalTask:(NSInteger)total{
    
    NSString *totalString = [NSString stringWithFormat:@"%ld/%ld",finish,total];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:GreenColor range:[totalString rangeOfString:[NSString stringWithFormat:@"%ld",finish]]];
    [string addAttribute:NSForegroundColorAttributeName value:LightGrayTextColor range:[totalString rangeOfString:[NSString stringWithFormat:@"/%ld",total]]];
    [string addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,totalString.length}];
    
    return string;
}


/** 用于cell中 */
-(void)refreshProgressWithTotalTask:(NSInteger)total finish:(NSInteger)finish{
    
    
    self.month.text = @"任务进度";
    self.month.textColor = ExtraLightBlackTextColor;
    self.progress.backgroundColor = GreenColor;
    
    self.number.textColor = ExtraLightBlackTextColor;
//    self.number.text = [NSString stringWithFormat:@"%ld/%ld",finish,total];
    self.number.attributedText = [self attributeStringWithFinishTask:finish withTotalTask:total];
    
    CGFloat rate = 0;
    
    if (total == 0) {
        rate = 0;
    }else{
        rate = finish * 1.0/total * 1.0;
    }
    
    self.progressRate.constant = (SCREEN_WIDTH-32)*rate;
}


+(instancetype)progressView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFProgressView" owner:self options:nil] lastObject];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
