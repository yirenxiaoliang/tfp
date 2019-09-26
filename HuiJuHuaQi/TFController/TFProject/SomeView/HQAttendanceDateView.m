//
//  HQAttendanceDateView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/10/11.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAttendanceDateView.h"
#import "NSDate+Calendar.h"
#import "NSDate+NSString.h"

@interface HQAttendanceDateView ()
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (weak, nonatomic) IBOutlet UIButton *leftArrow;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end

@implementation HQAttendanceDateView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.time.textColor = BlackTextColor;
    self.time.font = FONT(18);
    self.currentDate = [NSDate date];
    self.time.text = [self.currentDate getVerticalYearMonthDay];
    [self.leftArrow addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    [self.rightArrow addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    [self.leftArrow setTitleColor:HexAColor(0xcacad0, 1) forState:UIControlStateNormal];
    [self.leftArrow setTitleColor:HexAColor(0xcacad0, 1) forState:UIControlStateHighlighted];
    [self.rightArrow setTitleColor:HexAColor(0xcacad0, 1) forState:UIControlStateNormal];
    [self.rightArrow setTitleColor:HexAColor(0xcacad0, 1) forState:UIControlStateHighlighted];
    [self.leftArrow setTitle:@"<" forState:UIControlStateNormal];
    [self.leftArrow setTitle:@"<" forState:UIControlStateHighlighted];
    [self.rightArrow setTitle:@">" forState:UIControlStateNormal];
    [self.rightArrow setTitle:@">" forState:UIControlStateHighlighted];
    self.layer.cornerRadius = 15;
    self.layer.masksToBounds = YES;
    self.backgroundColor = WhiteColor;
    
    self.time.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeClick)];
    [self.time addGestureRecognizer:tap];
    
}

- (void)timeClick{
    
    if ([self.delegate respondsToSelector:@selector(attendanceDateViewDidClickedTimeWithDate:)]) {
        [self.delegate attendanceDateViewDidClickedTimeWithDate:self.currentDate];
    }
}

- (void)leftClick{
    
    if (self.type == 0) {
        self.currentDate = [self.currentDate previousDay];
        self.time.text = [self.currentDate getVerticalYearMonthDay];
    }else{
        self.currentDate = [self.currentDate previousMonth];
        self.time.text = [self.currentDate getYearMonth];
    }

    if ([self.delegate respondsToSelector:@selector(attendanceDateViewWithDate:)]) {
        [self.delegate attendanceDateViewWithDate:self.currentDate];
    }
}
- (void)rightClick{
    
    if (self.type == 0) {
        self.currentDate = [self.currentDate followingDay];
        self.time.text = [self.currentDate getVerticalYearMonthDay];
    }else{
        self.currentDate = [self.currentDate followingMonth];
        self.time.text = [self.currentDate getYearMonth];
    }
    
    if ([self.delegate respondsToSelector:@selector(attendanceDateViewWithDate:)]) {
        [self.delegate attendanceDateViewWithDate:self.currentDate];
    }
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    
    if (self.type == 0) {
        self.time.text = [self.currentDate getVerticalYearMonthDay];
    }else{
        self.time.text = [self.currentDate getYearMonth];
    }
}
- (void)setType:(NSInteger)type{
    _type = type;
    
    if (type == 0) {
        self.time.text = [self.currentDate getVerticalYearMonthDay];
    }else{
        self.time.text = [self.currentDate getYearMonth];
    }
}

+ (instancetype)attendanceDateView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HQAttendanceDateView" owner:self options:0] lastObject];
    
}

- (void)layoutSubviews{
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
