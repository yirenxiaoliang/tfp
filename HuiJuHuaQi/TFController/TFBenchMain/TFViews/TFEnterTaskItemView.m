//
//  TFEnterTaskItemView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/17.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterTaskItemView.h"

@interface TFEnterTaskItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;


@end

@implementation TFEnterTaskItemView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    self.headImage.contentMode = UIViewContentModeScaleToFill;
    
    self.nameLabel.textColor = HexColor(0x748692);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = FONT(12);
    self.nameLabel.text = @"";
    
    self.numLabel.textColor = ExtraLightBlackTextColor;
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = BFONT(16);
    self.numLabel.text = @"0";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked)];
    [self addGestureRecognizer:tap];

}
-(void)tapClicked{
    
    if ([self.delegate respondsToSelector:@selector(enterTaskItemViewClickedWithIndex:)]) {
        [self.delegate enterTaskItemViewClickedWithIndex:self.tag];
    }
}

+(instancetype)enterTaskItemView{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFEnterTaskItemView" owner:self options:nil] lastObject];
}

-(void)setType:(NSInteger)type{
    _type = type;
    switch (type) {
        case 0:
        {
            self.headImage.image = IMG(@"超期任务");
            self.nameLabel.text = @"超期任务";
        }
            break;
        case 1:
        {
            self.headImage.image = IMG(@"今日");
            self.nameLabel.text = @"今日要做";
        }
            break;
        case 2:
        {
            self.headImage.image = IMG(@"明日");
            self.nameLabel.text = @"明日要做";
        }
            break;
        case 3:
        {
            self.headImage.image = IMG(@"以后");
            self.nameLabel.text = @"以后要做";
        }
            break;
            
        default:
            break;
    }
}

-(void)setTaskNum:(NSInteger)taskNum{
    _taskNum = taskNum;
    self.numLabel.text = [NSString stringWithFormat:@"%ld",taskNum];
    if (self.type == 0) {
        if (taskNum == 0) {
            self.numLabel.textColor = ExtraLightBlackTextColor;
            self.nameLabel.textColor = HexColor(0x748692);
        }else{
            self.numLabel.textColor = HexColor(0xFFA416);
            self.nameLabel.textColor = HexColor(0xFFA416);
        }
    }else{
        self.numLabel.textColor = ExtraLightBlackTextColor;
        self.nameLabel.textColor = HexColor(0x748692);
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
