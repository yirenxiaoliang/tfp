//
//  HQTFRepeatSelectView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRepeatSelectView.h"

#define PickerWidth Long(100)
#define PickerRowHeight Long(50)
#define PivkerViewHeight Long(245)


@interface HQTFRepeatSelectView ()<UIPickerViewDelegate,UIPickerViewDataSource>


/** hours */
@property (nonatomic, strong) NSMutableArray *hours;
/** minutes */
@property (nonatomic, strong) NSMutableArray *minutes;

/** date1 */
@property (nonatomic, weak) UIPickerView *date1;
/** date2 */
@property (nonatomic, weak) UIPickerView *date2;
/** time */
@property (nonatomic, weak) UILabel *time;
/** time */
@property (nonatomic, weak) UILabel *timeDesc;

/** UIView *pickContent */
@property (nonatomic, weak) UIView *pickContent;
/** UIView *repeatView */
@property (nonatomic, weak) UIView *repeatView;
/** UIView *topView */
@property (nonatomic, weak) UIView *topView;
/** UIView *view */
@property (nonatomic, weak) UIView *bottomView;
/**
 * 事件回调处理函数(带参数)
 */
@property (nonatomic, copy) ActionArray timeSpArray;

/** 关闭函数 */
@property (nonatomic, strong) ActionHandler onDismiss;

/** type */
@property (nonatomic, assign) NSInteger type;


/** 开始hour */
@property (nonatomic, copy) NSString *startHour;
/** 开始minute */
@property (nonatomic, copy) NSString *startMinute;

/** 标题 */
@property (nonatomic, copy) NSString *title;

@end

@implementation HQTFRepeatSelectView





-(NSMutableArray *)hours{
    if (!_hours) {
        
        _hours = [NSMutableArray array];
        
        NSMutableArray *hour = [NSMutableArray array];
        
        if (self.type == 0) {
            
            for (NSInteger i = 0; i < 31; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
                
                if (i==0) {
                    str = @"从不";
                }
                [hour addObject:str];
            }

            
        }else if (self.type == 1){
            for (NSInteger i = 0; i < 30; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
                
                [hour addObject:str];
            }
        }else if (self.type == 2){
            for (NSInteger i = 0; i < 3; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
                
                if (i == 0) {
                    str = @"分钟";
                }
                if (i == 1) {
                    str = @"小时";
                }
                if (i == 2) {
                    str = @"天";
                }
                [hour addObject:str];
            }
        }else{
            
            for (NSInteger i = 0; i < 2; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
                
                if (i == 0) {
                    str = @"小时";
                }
                if (i == 1) {
                    str = @"天";
                }
                [hour addObject:str];
            }
            
        }
        
        
        for (NSInteger i = 0; i < 7; i ++) {
            
            [_hours addObjectsFromArray:hour];
        }
        
    }
    return _hours;
}
-(NSMutableArray *)minutes{
    if (!_minutes) {
        _minutes = [NSMutableArray array];
        
        
        NSMutableArray *minute = [NSMutableArray array];
        
        
        if (self.type == 0) {
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                NSString *str = [NSString stringWithFormat:@""];
                [minute addObject:str];
            }
            
        }else if (self.type == 1){
            
            for (NSInteger i = 0; i < 31; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
                
                if (i ==0) {
                    str = @"从不";
                }
                [minute addObject:str];
            }
            
        }else if (self.type == 2){
            for (NSInteger i = 1; i < 61; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%ld",i];
              
                [minute addObject:str];
            }
        }else{
            
            for (NSInteger i = 1; i < 49; i ++) {
                
                NSString *str = [NSString stringWithFormat:@"%.1lf",i*0.5];
                
                [minute addObject:str];
            }
        }
        
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            [_minutes addObjectsFromArray:minute];
        }
        
    }
    return _minutes;
}


- (instancetype)initWithFrame:(CGRect)frame withType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithType:type];
    }
    return self;
}

- (void)setupChildOne{
    
    
}

-(NSAttributedString *)attributeStringWithString:(NSString *)start withString:(NSString *)end{
    
    NSString *totalString = [NSString stringWithFormat:@"%@%@",start,end];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:totalString];
    [string addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:[totalString rangeOfString:start]];
    [string addAttribute:NSForegroundColorAttributeName value:FinishedTextColor range:[totalString rangeOfString:end]];
    [string addAttribute:NSFontAttributeName value:FONT(16) range:[totalString rangeOfString:start]];
    [string addAttribute:NSFontAttributeName value:FONT(14) range:[totalString rangeOfString:end]];
    
    return string;
}

-(void)setType:(NSInteger)type{
    
    _type = type;
    
    switch (type) {
        case 0:
        {
            self.repeatView.hidden = YES;
            self.date2.hidden = YES;
            self.height = 55 + 60 + PivkerViewHeight;
        }
            break;
        case 1:
        {
            self.repeatView.hidden = NO;
            self.date2.hidden = NO;
            self.height = 55 + 120 + PivkerViewHeight;
        }
            break;
        case 2:
        {
            self.repeatView.hidden = YES;
            self.date2.hidden = NO;
            self.height = 55 + 60 + PivkerViewHeight;
        }
            break;
        case 3:
        {
            self.repeatView.hidden = YES;
            self.date2.hidden = NO;
            self.height = 55 + 60 + PivkerViewHeight;
        }
            break;
            
        default:
            break;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.type) {
        case 0:
        {
            self.topView.frame = (CGRect){0,0,SCREEN_WIDTH,55};
            self.pickContent.frame = (CGRect){0,55,SCREEN_WIDTH,PivkerViewHeight};
            self.date1.frame = self.pickContent.bounds;
            self.bottomView.frame = (CGRect){0,55 + PivkerViewHeight,SCREEN_WIDTH,60};
        }
            break;
        case 1:
        {
            self.topView.frame = (CGRect){0,0,SCREEN_WIDTH,55};
            self.repeatView.frame = (CGRect){0,55.5,SCREEN_WIDTH,60};
            self.pickContent.frame = (CGRect){0,115,SCREEN_WIDTH,PivkerViewHeight};
            self.date1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.date2.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.bottomView.frame = (CGRect){0,115 + PivkerViewHeight,SCREEN_WIDTH,60};
        }
            break;
        case 2:
        {
            self.topView.frame = (CGRect){0,0,SCREEN_WIDTH,55};
            self.pickContent.frame = (CGRect){0,55,SCREEN_WIDTH,PivkerViewHeight};
            self.date1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.date2.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.bottomView.frame = (CGRect){0,55 + PivkerViewHeight,SCREEN_WIDTH,60};
        }
            break;
        case 3:
        {
            self.topView.frame = (CGRect){0,0,SCREEN_WIDTH,55};
            self.pickContent.frame = (CGRect){0,55,SCREEN_WIDTH,PivkerViewHeight};
            self.date1.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.date2.frame = CGRectMake( SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, PivkerViewHeight);
            self.bottomView.frame = (CGRect){0,55 + PivkerViewHeight,SCREEN_WIDTH,60};
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setupWithType:(NSInteger)type{
    
    
    UIView *repeatView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,60}];
    [self addSubview:repeatView];
    self.repeatView = repeatView;
    repeatView.layer.borderColor = HexAColor(0xf2f2f2, 1).CGColor;
    repeatView.layer.borderWidth = 0.5;
    repeatView.backgroundColor = WhiteColor;
    
    UILabel *repeatTime = [[UILabel alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH/2,60}];
    [repeatView addSubview:repeatTime];
    repeatTime.textAlignment = NSTextAlignmentCenter;
    
    UILabel *repeatNum = [[UILabel alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,0,SCREEN_WIDTH/2,60}];
    [repeatView addSubview:repeatNum];
    repeatNum.textAlignment = NSTextAlignmentCenter;
    
    repeatTime.attributedText = [self attributeStringWithString:@"重复频率" withString:@"(天)"];
    repeatNum.attributedText = [self attributeStringWithString:@"重复次数" withString:@"(次)"];
    
    UIView *pickContent = [[UIView alloc] initWithFrame:(CGRect){0,55,SCREEN_WIDTH,PivkerViewHeight}];
    [self addSubview:pickContent];
    self.pickContent = pickContent;
    
   
    
    UIPickerView *date1 = [[UIPickerView alloc] initWithFrame:(CGRect){(SCREEN_WIDTH/2-PickerWidth)/2,0,PickerWidth,PivkerViewHeight}];
    date1.delegate = self;
    date1.showsSelectionIndicator = YES;
    [pickContent addSubview:date1];
    date1.tag = 0x1111;
    self.date1 = date1;
    
    
    UIPickerView *date2 = [[UIPickerView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2 + (SCREEN_WIDTH/2-2*PickerWidth)/2-10,0,PickerWidth,PivkerViewHeight}];
    date2.delegate = self;
    date2.showsSelectionIndicator = YES;
    [pickContent addSubview:date2];
    date2.tag = 0x1112;
    self.date2 = date2;
    
    
    UIView *topView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,55}];
    [self addSubview:topView];
    topView.backgroundColor = WhiteColor;
//    topView.layer.borderColor = CellSeparatorColor.CGColor;
//    topView.layer.borderWidth = 0.5;
    self.topView = topView;
    
    UILabel *timeDesc = [[UILabel alloc] init];
    [topView addSubview:timeDesc];
    timeDesc.font = FONT(16);
    timeDesc.textColor = ExtraLightBlackTextColor;
    
    if (type == 0) {
        
        timeDesc.text = @"重复次数  ";
    }else if (type == 1){
        
        timeDesc.text = @"";
    }else if (type == 2){
        
        timeDesc.text = @"截止时间：";
    }else{
        timeDesc.text = @"时间天数：";
    }
    [timeDesc sizeToFit];
    timeDesc.origin = CGPointMake(15, (55-timeDesc.size.height)/2);
    self.timeDesc = timeDesc;
    
    UILabel *time = [[UILabel alloc] init];
    [topView addSubview:time];
    time.font = FONT(20);
    time.textColor = LightBlackTextColor;
    time.text = @"18:18 - 18:50";
    time.size = CGSizeMake(200, 21);
    time.origin = CGPointMake(CGRectGetMaxX(timeDesc.frame)+10, (55-time.size.height)/2);
    self.time = time;
    
    
    UIButton *finishBtn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH-55-10,0,55,55} target:self action:@selector(clearTime)];
    [finishBtn setTitle:@"清空" forState:UIControlStateNormal];
    [finishBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [topView addSubview:finishBtn];
    
    
    self.backgroundColor = HexAColor(0xf2f2f2, 1);
    
    
//    UIView *middleView = [[UIView alloc] initWithFrame:(CGRect){0,(PivkerViewHeight+55-PickerRowHeight-55-3)/2+55,SCREEN_WIDTH,PickerRowHeight+3}];
//    middleView.userInteractionEnabled = NO;
//    [pickContent addSubview:middleView];
//    middleView.layer.borderWidth = 0.5;
//    middleView.layer.borderColor = CellSeparatorColor.CGColor;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,55+PivkerViewHeight,SCREEN_WIDTH,60}];
    [self addSubview:view];
    self.bottomView = view;
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/2 * i,0,SCREEN_WIDTH/2,60} target:self action:@selector(twoBtnClicked:)];
        [view addSubview:btn];
        btn.backgroundColor = WhiteColor;
        btn.titleLabel.font = FONT(20);
        btn.tag = 0x123 + i;
        if (i == 0) {
            
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateHighlighted];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        }else{
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitle:@"确定" forState:UIControlStateHighlighted];
            [btn setTitleColor:GreenColor forState:UIControlStateNormal];
            [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        }
    }
    
    
    UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,0,0.5,20}];
    sepeview.backgroundColor = CellSeparatorColor;
    sepeview.centerY = view.height/2;
    [view addSubview:sepeview];
    
    self.type = type;
}

- (void)twoBtnClicked:(UIButton *)button{
    
    switch (button.tag - 0x123) {
        case 0:
        {
            [self dismiss];
        }
            break;
        case 1:
        {
            [self finished];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)clearTime{
    self.startHour = @"";
    self.startMinute = @"";
    [self finished];
}

- (void)finished{
    
    NSMutableArray *times = [NSMutableArray array];
//    NSString *start = [NSString stringWithFormat:@"%@:%@",self.startHour,self.startMinute];
//    NSString *end = [NSString stringWithFormat:@"%@:%@",self.endHour,self.endMinute];
    
    if (self.type == 0) {
        
        [times addObject:self.startHour];
        
    }else if (self.type == 1){
        
        [times addObject:self.startHour];
        [times addObject:self.startMinute];
    }else{
        
        [times addObject:self.startHour];
        [times addObject:self.startMinute];
    }
    
    
    
    if (self.timeSpArray) {
        self.timeSpArray(times);
    }
    
    [self dismiss];
}


- (void) dismiss {
    if (self.onDismiss) self.onDismiss();
}

/** pickerView 代理 */
// 每个滚动条中有多少row
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
//    switch (pickerView.tag - 0x1111) {
//        case 0:
//        {
//            return self.hours.count;
//        }
//            break;
//        case 1:
//        {
//            return self.minutes.count;
//        }
//            break;
//            
//        default:
//            break;
//    }
//    return 0;
    
    if (pickerView.tag - 0x1111 == 0) {
        
        return self.hours.count;
        
    }else{
        
        if (self.type == 0) {
            return 0;
        }else{
            return self.minutes.count;
        }
    }
    
}

// 有多少滚动条
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
// 每个row中显示字符串
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
//    switch (pickerView.tag - 0x1111) {
//        case 0:
//        {
//            return self.hours[row];
//        }
//            break;
//        case 1:
//        {
//            return self.minutes[row];
//        }
//            break;
//            
//        default:
//            break;
//    }
//    
//    return @"";
    
    if (pickerView.tag - 0x1111 == 0) {
        
        return self.hours[row];
        
    }else{
        
        if (self.type == 0) {
            return @"";
        }else{
            return self.minutes[row];
        }
    }

}

/** 设置初始时间 */
- (void)setBeginTimeWithStartTimeSp:(NSString *)startTimeSp endTimeSp:(NSString *)endTimeSp{
    
    if (self.type == 0) {
        
        for (NSInteger i = 31*3; i<31*4; i ++) {
            NSString *string = self.hours[i];
            NSString *start1 = startTimeSp;
            if ([start1 isEqualToString:string]) {
                [self.date1 selectRow:i inComponent:0 animated:NO];
                self.startHour = start1;
                break;
            }
        }
        
        self.timeDesc.text = @"重复次数  ";
        self.time.text = [NSString stringWithFormat:@"%@次",self.startHour];
        
        
    }else if (self.type == 1){
        
        for (NSInteger i = 30*3; i<30*4; i ++) {
            NSString *string = self.hours[i];
            NSString *start1 = startTimeSp;
            if ([start1 isEqualToString:string]) {
                [self.date1 selectRow:i inComponent:0 animated:NO];
                self.startHour = start1;
                break;
            }
        }
        
        for (NSInteger i = 31*1; i<31*2; i ++) {
            NSString *string = self.minutes[i];
            NSString *start2 = endTimeSp;
            if ([start2 isEqualToString:string]) {
                [self.date2 selectRow:i inComponent:0 animated:NO];
                self.startMinute = start2;
                break;
            }
        }
        
        self.timeDesc.text = @"";
        self.time.text = [NSString stringWithFormat:@"每%@天，重复%@次",self.startHour,self.startMinute];
    }else if (self.type == 2){
        
        for (NSInteger i = 3*3; i<3*4; i ++) {
            NSString *string = self.hours[i];
            NSString *start1 = startTimeSp;
            if ([start1 isEqualToString:string]) {
                [self.date1 selectRow:i inComponent:0 animated:NO];
                self.startHour = start1;
                break;
            }
        }
        
        for (NSInteger i = 60*1; i<60*2; i ++) {
            NSString *string = self.minutes[i];
            NSString *start2 = endTimeSp;
            if ([start2 isEqualToString:string]) {
                [self.date2 selectRow:i inComponent:0 animated:NO];
                self.startMinute = start2;
                break;
            }
        }
        self.timeDesc.text = @"截止时间：";
        self.time.text = [NSString stringWithFormat:@"%@%@",self.startMinute,self.startHour];
    }else{
        
        for (NSInteger i = 3*2; i<2*4; i ++) {
            NSString *string = self.hours[i];
            NSString *start1 = startTimeSp;
            if ([start1 isEqualToString:string]) {
                [self.date1 selectRow:i inComponent:0 animated:NO];
                self.startHour = start1;
                break;
            }
        }
        
        for (NSInteger i = 49*1; i<49*2; i ++) {
            NSString *string = self.minutes[i];
            NSString *start2 = endTimeSp;
            if ([start2 isEqualToString:string]) {
                [self.date2 selectRow:i inComponent:0 animated:NO];
                self.startMinute = start2;
                break;
            }
        }
        self.timeDesc.text = self.title;
        self.time.text = [NSString stringWithFormat:@"%@%@",self.startMinute,self.startHour];
        
    }
    
}



// 每个滚动条row高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return PickerRowHeight;
}

// 每个滚动条row宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    if (self.type == 0) {
        
        return SCREEN_WIDTH;
    }else if (self.type == 1){
        
        return SCREEN_WIDTH/2;
    }else{
        
        return SCREEN_WIDTH/2;
    }
    
}
// 滚动停止选中的row
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (pickerView.tag-0x1111) {
        case 0:
        {
            self.startHour = self.hours[row];
            
            if (self.type == 0) {
                

                for (NSInteger i = 31*3; i<31*4; i ++) {
                    NSString *string = self.hours[i];
                    NSString *start1 = self.startHour;
                    if ([start1 isEqualToString:string]) {
                        [self.date1 selectRow:i inComponent:0 animated:NO];
                        self.startHour = start1;
                        break;
                    }
                }
                
            }else if (self.type == 1){
                
                for (NSInteger i = 30*3; i<30*4; i ++) {
                    NSString *string = self.hours[i];
                    NSString *start1 = self.startHour;
                    if ([start1 isEqualToString:string]) {
                        [self.date1 selectRow:i inComponent:0 animated:NO];
                        self.startHour = start1;
                        break;
                    }
                }
                
            }else if (self.type == 2){
                
                for (NSInteger i = 3*3; i<3*4; i ++) {
                    NSString *string = self.hours[i];
                    NSString *start1 = self.startHour;
                    if ([start1 isEqualToString:string]) {
                        [self.date1 selectRow:i inComponent:0 animated:NO];
                        self.startHour = start1;
                        break;
                    }
                }
            }else{
                
                for (NSInteger i = 2*3; i<2*4; i ++) {
                    NSString *string = self.hours[i];
                    NSString *start1 = self.startHour;
                    if ([start1 isEqualToString:string]) {
                        [self.date1 selectRow:i inComponent:0 animated:NO];
                        self.startHour = start1;
                        break;
                    }
                }
                
            }
            
        }
            break;
        case 1:
        {
            self.startMinute = self.minutes[row];
            
            if (self.type == 0) {
                
            
                
            }else if (self.type == 1){
                
                for (NSInteger i = 31*1; i<31*2; i ++) {
                    NSString *string = self.minutes[i];
                    NSString *start2 = self.startMinute;
                    if ([start2 isEqualToString:string]) {
                        [self.date2 selectRow:i inComponent:0 animated:NO];
                        self.startMinute = start2;
                        break;
                    }
                }
                
            }else if (self.type == 2){
                
                for (NSInteger i = 60*1; i<60*2; i ++) {
                    NSString *string = self.minutes[i];
                    NSString *start2 = self.startMinute;
                    if ([start2 isEqualToString:string]) {
                        [self.date2 selectRow:i inComponent:0 animated:NO];
                        self.startMinute = start2;
                        break;
                    }
                }
            }else{
                
                for (NSInteger i = 49*1; i<49*2; i ++) {
                    NSString *string = self.minutes[i];
                    NSString *start2 = self.startMinute;
                    if ([start2 isEqualToString:string]) {
                        [self.date2 selectRow:i inComponent:0 animated:NO];
                        self.startMinute = start2;
                        break;
                    }
                }
                
            }

        }
            break;
            
            
        default:
            break;
    }
    
    
    if (self.type == 0) {
        
        self.timeDesc.text = @"重复次数  ";
        self.time.text = [NSString stringWithFormat:@"%@次",self.startHour];
        
        if ([self.startHour isEqualToString:@"从不"]) {
            self.time.text = @"从不";
        }
        
        
    }else if (self.type == 1){
        
        self.timeDesc.text = @"";
        self.time.text = [NSString stringWithFormat:@"每%@天，重复%@次",self.startHour,self.startMinute];
        
        if ([self.startMinute isEqualToString:@"从不"]) {
            self.time.text = @"从不";
        }
        
    }else if (self.type == 2){
        
        self.timeDesc.text = @"截止时间：";
        self.time.text = [NSString stringWithFormat:@"%@%@",self.startMinute,self.startHour];
    }else{
        
        self.timeDesc.text = self.title;
        self.time.text = [NSString stringWithFormat:@"%@%@",self.startMinute,self.startHour];
        
    }
    
}

/**
 * 时间选择
 *
 * @param type 类型
 * @param start   第一个
 * @param end     第二个
 * @param timeArray   时间字符串
 */
+ (void) selectTimeViewWithStartWithType:(NSInteger)type
                                   start:(NSString *)start
                                     end:(NSString *)end
                               timeArray:(ActionArray)timeArray
{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    
    HQTFRepeatSelectView *view = [[HQTFRepeatSelectView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-PivkerViewHeight-55-60,SCREEN_WIDTH,PivkerViewHeight+55+60} withType:type];
    
    if (type == 1) {
        view.top = SCREEN_HEIGHT-PivkerViewHeight-55-120;
    }
    
    [view setBeginTimeWithStartTimeSp:start endTimeSp:end];
    view.timeSpArray = timeArray;
    
    __weak UIView *weakView = view;
    view.onDismiss = ^(void){
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        if (type == 1) {
            view.top = SCREEN_HEIGHT-PivkerViewHeight-55-120;
        }else{
            view.y = SCREEN_HEIGHT - (PivkerViewHeight+55+60);
        }
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
    
}

/**
 * 时间选择
 *
 * @param type    类型  0:一个转（选择重复次数） 1：二个转（重复频率和次数）2：二个转（截止时间段）3：时长选择
 * @param start   第一个数值
 * @param end     第二个数值（type==0时，此值传@""）
 * @param timeArray   时间字符串
 */
+ (void) selectTimeViewWithStartWithType:(NSInteger)type
                                   title:(NSString *)title
                                   start:(NSString *)start
                                     end:(NSString *)end
                               timeArray:(ActionArray)timeArray{
    
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x98765] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x98765;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    
    HQTFRepeatSelectView *view = [[HQTFRepeatSelectView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-PivkerViewHeight-55-60,SCREEN_WIDTH,PivkerViewHeight+55+60} withType:type];
    
    if (type == 1) {
        view.top = SCREEN_HEIGHT-PivkerViewHeight-55-120;
    }
    [view setBeginTimeWithStartTimeSp:start endTimeSp:end];
    view.timeSpArray = timeArray;
    view.title = title;
    view.timeDesc.text = title;
    
    __weak UIView *weakView = view;
    view.onDismiss = ^(void){
        [UIView animateWithDuration:0.35 animations:^{
            weakView.y = SCREEN_HEIGHT;
            bgView.alpha = 0;
            
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
        
    };
    view.tag = 0x11111;
    
    [bgView addSubview:view];
    [window addSubview:bgView];
    
    // 动画显示
    [UIView animateWithDuration:0.35 animations:^{
        if (type == 1) {
            view.top = SCREEN_HEIGHT-PivkerViewHeight-55-120;
        }else{
            view.y = SCREEN_HEIGHT - (PivkerViewHeight+55+60);
        }
        bgView.alpha = 1;
        
    }];
    // 显示窗体
    [window makeKeyAndVisible];
    
    
}

+ (void)tapBgView:(UIButton *)tap{
    
    
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.35 animations:^{
        [window viewWithTag: 0x11111].y = SCREEN_HEIGHT;
        [window viewWithTag:0x98765].alpha = 0;
        
    } completion:^(BOOL finished) {
        [[window viewWithTag:0x98765] removeFromSuperview];
    }];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
