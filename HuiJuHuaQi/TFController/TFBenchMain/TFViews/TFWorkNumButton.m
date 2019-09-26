//
//  TFNumButton.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkNumButton.h"

@implementation ButtonInfo



@end

@interface TFWorkNumButton ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numW;
@property (weak, nonatomic) IBOutlet UILabel *numlLabel;
@property (weak, nonatomic) IBOutlet UIView *numBg;


@end

@implementation TFWorkNumButton

- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameLabel.textColor = GrayTextColor;
    self.numlLabel.textColor = WhiteColor;
    self.numBg.backgroundColor = RedColor;
    self.numBg.layer.cornerRadius = 7.5;
    self.numBg.layer.masksToBounds = YES;
    self.nameLabel.backgroundColor = ClearColor;
    self.numlLabel.backgroundColor = ClearColor;
    self.nameLabel.font = FONT(10);
    self.numlLabel.font = FONT(10);
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];
    self.backgroundColor = ClearColor;
}

-(void)tapClicked{
    if ([self.delegate respondsToSelector:@selector(workNumButtonDidClicked:)]) {
        [self.delegate workNumButtonDidClicked:self.tag];
    }
}

-(void)setInfo:(ButtonInfo *)info{
    _info = info;
    self.imageView.image = IMG(info.image);
    self.nameLabel.text = info.name;
    self.number = info.number;
}

-(void)setNumber:(NSInteger)number{
    _number = number;
    if (number == 0) {
        self.numBg.hidden = YES;
        self.numW.constant = 0;
        self.numlLabel.text= [NSString stringWithFormat:@"%ld",number];
    }else{
        self.numBg.hidden = NO;
        if (number < 10) {
            self.numW.constant = 15;
            self.numlLabel.text= [NSString stringWithFormat:@"%ld",number];
        }else if (number < 100){
            self.numW.constant = 25;
            self.numlLabel.text= [NSString stringWithFormat:@"%ld",number];
        }else{
            self.numW.constant = 35;
            self.numlLabel.text= [NSString stringWithFormat:@"99+"];
        }
    }
}

+(instancetype)workNumButton{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFWorkNumButton" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
