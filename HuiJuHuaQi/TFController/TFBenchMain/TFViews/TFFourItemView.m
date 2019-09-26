//
//  TFFourItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFourItemView.h"

@interface TFFourItemView ()

@property (weak, nonatomic) IBOutlet UIButton *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

@implementation TFFourItemView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.nameLabel.textColor = WhiteColor;
    self.nameLabel.font = BFONT(12);
    self.nameLabel.text = @"";
    
    self.descLabel.textColor = WhiteColor;
    self.descLabel.alpha = 0.5;
    self.descLabel.font = BFONT(10);
    self.descLabel.text = @"";
    
    self.numberLabel.textColor = WhiteColor;
    self.numberLabel.font = BFONT(12);
    self.numberLabel.text = @"0";
    
    self.backgroundColor = ClearColor;
    self.imageView.backgroundColor = ClearColor;
    self.layer.masksToBounds = NO;
//    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.imageView.contentMode = UIViewContentModeScaleToFill;
    
//    self.layer.shadowColor = LightGrayTextColor.CGColor;
//    self.layer.shadowRadius = 8;
//    self.layer.shadowOffset = CGSizeZero;
//    self.layer.shadowOpacity = 0.5;
}
- (IBAction)itemClicked:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(fourItemViewDidClicked:)]) {
        [self.delegate fourItemViewDidClicked:self];
    }
}


+(instancetype)fourItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFFourItemView" owner:self options:nil] lastObject];
}

-(void)setTaskCount:(NSInteger)taskCount{
    _taskCount = taskCount;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",taskCount];
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    switch (type) {
        case 0:
        {
            [self.imageView setImage:IMG(@"超期item") forState:UIControlStateNormal];
            self.nameLabel.text = @"超期任务";
            self.descLabel.text = @"Overdue";
        }
            break;
        case 1:
        {
            [self.imageView setImage:IMG(@"今日item") forState:UIControlStateNormal];
            self.nameLabel.text = @"今日任务";
            self.descLabel.text = @"Today";
        }
            break;
        case 2:
        {
            [self.imageView setImage:IMG(@"明日item") forState:UIControlStateNormal];
            self.nameLabel.text = @"明日任务";
            self.descLabel.text = @"Tomorrow";
        }
            break;
        case 3:
        {
            [self.imageView setImage:IMG(@"以后item") forState:UIControlStateNormal];
            self.nameLabel.text = @"以后任务";
            self.descLabel.text = @"Later";
        }
            break;
            
        default:
            break;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
