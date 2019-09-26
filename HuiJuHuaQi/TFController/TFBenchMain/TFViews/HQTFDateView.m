//
//  HQTFDateView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFDateView.h"
#import "HQTFDateTableView.h"
#import "HQTFTimeTableView.h"
#import "NSDate+NSString.h"

@interface HQTFDateView ()<HQTFDateTableViewDelegate,HQTFTimeTableViewDelegate>
@property (weak, nonatomic) IBOutlet HQTFTimeTableView *dateTableView;
@property (weak, nonatomic) IBOutlet UILabel *sheduleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIView *lineT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineTHeight;
@property (weak, nonatomic) IBOutlet UIView *sepeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;
@property (weak, nonatomic) IBOutlet UIImageView *triImage;

@end

@implementation HQTFDateView


+ (instancetype)dateView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HQTFDateView" owner:self options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.sepeH.constant = 0.5;
    self.sepeView.backgroundColor = CellSeparatorColor;
    
    self.lineB.backgroundColor = CellSeparatorColor;
    self.lineT.backgroundColor = CellSeparatorColor;
    self.lineBHeight.constant = 0.5;
    self.lineTHeight.constant = 0.5;
    
    self.sheduleLabel.textColor = LightBlackTextColor;
    self.sheduleLabel.font = FONT(16);
    
    self.dateLabel.textColor = BlackTextColor;
    self.dateLabel.font = FONT(18);
    
    self.dateTableView.delegate = self;
    [self.todayButton addTarget:self action:@selector(todayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.todayButton setTitleColor:HexAColor(0xff6f00, 1) forState:UIControlStateHighlighted];
    [self.todayButton setTitleColor:HexAColor(0xff6f00, 1) forState:UIControlStateNormal];
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",[NSDate date].getVerticalYearMonthDay,[NSDate date].getWeek];
    
    [self.dateTableView refreshTimeTableViewWithSelectTimeSp:[HQHelper getNowTimeSp]];
    
    self.leftWidth.constant = 3*(SCREEN_WIDTH-24)/14+5;
    self.triImage.hidden = YES;
    
    self.lineB.layer.shadowOffset = CGSizeMake(0, 1);
    self.lineB.layer.shadowColor = GrayTextColor.CGColor;
    self.lineB.layer.shadowRadius = 1;
    self.lineB.layer.shadowOpacity = 0.4;
    self.layer.masksToBounds = NO;
}

- (void)dateTableViewWithSelectedDate:(NSDate *)date{
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",date.getVerticalYearMonthDay,date.getWeek];
}


- (void)todayButtonClicked{
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",[NSDate date].getVerticalYearMonthDay,[NSDate date].getWeek];
//    self.dateTableView.selectedDate = [NSDate date];
    [self.dateTableView refreshTimeTableViewWithSelectTimeSp:[HQHelper getNowTimeSp]];
}

-(void)timeTableViewSelectTimeSp:(long long)selectTimeSp{
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:selectTimeSp/1000];
    self.dateLabel.text = [NSString stringWithFormat:@"%@  %@",date.getVerticalYearMonthDay,date.getWeek];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
