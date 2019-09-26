//
//  TFPunchCardHeader.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/3/22.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPunchCardHeader.h"
#import "TFSelectDateView.h"

@interface TFPunchCardHeader()

@property (weak, nonatomic) IBOutlet UIButton *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) long long timeSp;

@end

@implementation TFPunchCardHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    self.timeSp = [HQHelper getNowTimeSp];
    self.backgroundColor = WhiteColor;
    self.headImage.layer.cornerRadius = 20;
    self.headImage.layer.masksToBounds = YES;
    [self.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:UM.userLoginInfo.employee.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            
            [self.headImage setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setBackgroundColor:HeadBackground];
        }else{
            
            [self.headImage setTitle:@"" forState:UIControlStateNormal];
            [self.headImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.headImage setBackgroundColor:WhiteColor];
        }
    }];
    
    self.nameLabel.textColor = BlackTextColor;
    self.nameLabel.font = FONT(16);
    self.nameLabel.text = UM.userLoginInfo.employee.employee_name;
    self.positionLabel.textColor = HexColor(0x49629C);
    self.positionLabel.font = FONT(14);
    self.positionLabel.text = @"";
    self.positionLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(positionClicked)];
    [self.positionLabel addGestureRecognizer:tap1];
    
    
    self.dateLabel.textColor = GreenColor;
    self.dateLabel.font = FONT(14);
    self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, M_PI_2);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDate)];
    [self.dateLabel addGestureRecognizer:tap];
    self.dateLabel.userInteractionEnabled = YES;
    self.dateLabel.text = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"];
    
}

-(void)positionClicked{
    
    if ([self.delegate respondsToSelector:@selector(punchCardHeaderClickedPosition)]) {
        [self.delegate punchCardHeaderClickedPosition];
    }
    
}

-(void)selectDate{
    [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:self.timeSp onRightTouched:^(NSString *time) {
        
        long long che = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
        long long now = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"];
        if (che > now) {
            [MBProgressHUD showError:@"不能查看将来的数据" toView:KeyWindow];
            return ;
        }
        self.dateLabel.text = time;
        self.timeSp = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PutchDardChangeTime" object:@(self.timeSp)];
        
    }];
}

+(instancetype)punchCardHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFPunchCardHeader" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
