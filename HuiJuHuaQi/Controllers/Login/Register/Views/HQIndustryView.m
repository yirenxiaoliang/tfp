//
//  HQIndustryView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQIndustryView.h"
#import "HQIndustryManager.h"

@interface HQIndustryView () <UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIPickerView *picker;
    NSArray *industryArr;
    CGRect pickViewRect;
    UIView *headView;
}

@end

@implementation HQIndustryView


- (UIView *)initWithFrame:(CGRect)frame
{
    //大小固定
    self = [super initWithFrame:frame];
//    self.top = SCREEN_HEIGHT;
//    pickViewRect = frame;
    if (self) {
        
        [self initWithIndustryData];
        
        [self initWithIndustryPickViewFrame:frame];
    }
    
    return self;
}


- (void)initWithIndustryPickViewFrame:(CGRect)frame
{
    
    self.backgroundColor = HexAColor(0x323232, 0.5);
    
    UIButton *bgBtn = [HQHelper buttonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                         target:self
                                         action:@selector(cancelView)];
    bgBtn.backgroundColor = [UIColor clearColor];
    [self addSubview:bgBtn];
    
    
    
    
    
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-44-Long(220), frame.size.width, 44.0)];
    headView.backgroundColor = HexAColor(0xf7f8fa, 1);
    [self addSubview:headView];
    
    
    UILabel * lineOne = [[UILabel alloc] init];
    lineOne.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
    lineOne.backgroundColor = HexAColor(0xd9d9d9, 1);
    [headView addSubview:lineOne];
    
    UILabel * lineTwo = [[UILabel alloc] init];
    lineTwo.frame = CGRectMake(0, 43, SCREEN_WIDTH, 1);
    lineTwo.backgroundColor = HexAColor(0xd9d9d9, 1);
    [headView addSubview:lineTwo];
    
    
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(headView.right-60, 0, 60, headView.height)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:NaviItemColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [headView addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, headView.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [headView addSubview:cancelBtn];
    
    
    
    
    picker = [[UIPickerView alloc] initWithFrame: CGRectMake(0, self.height-Long(220), headView.width, Long(220))];
    picker.backgroundColor = [UIColor whiteColor];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self addSubview: picker];
    
    
    headView.top = self.height;
    picker.top = headView.bottom;
    self.backgroundColor = HexAColor(0x323232, 0);
    self.hidden = YES;
}



- (void)sureBtn
{
    if (_sureIndustryBlock) {
        _sureIndustryBlock([self getSelectIndustry]);
    }
    
    [self cancelView];
}


- (void)setHideState:(BOOL)hideState
{
    
    _hideState = hideState;
    if (hideState) {
        
        [self cancelView];
    }else {
        
        [self showView];
    }
}


- (void)cancelView
{
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         headView.top = self.height;
                         picker.top = headView.bottom;
                         self.backgroundColor = HexAColor(0x323232, 0);
                     } completion:^(BOOL finished) {
                         
                         self.hidden = YES;
                     }];
}



- (void)showView
{
    self.hidden = NO;
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         picker.bottom = self.height;
                         headView.bottom = picker.top;
                         self.backgroundColor = HexAColor(0x323232, 0.5);
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (NSDictionary *)getSelectIndustry
{
    NSInteger industryIndex = [picker selectedRowInComponent:0];
    NSDictionary *industryDic = [industryArr objectAtIndex: industryIndex];
    return industryDic;
}


- (void)initWithIndustryData
{
    
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *plistPath = [bundle pathForResource:@"industry" ofType:@"plist"];
//    NSDictionary *areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    
//    NSArray *components = [areaDic allKeys];
//    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
//        
//        if ([obj1 integerValue] > [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedDescending;
//        }
//        
//        if ([obj1 integerValue] < [obj2 integerValue]) {
//            return (NSComparisonResult)NSOrderedAscending;
//        }
//        return (NSComparisonResult)NSOrderedSame;
//    }];
//    
//    
//    
//    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
//    for (int i=0; i<[sortedArray count]; i++) {
//        NSString *index = [sortedArray objectAtIndex:i];
//        NSArray *tmp = [areaDic objectForKey: index];
//        [provinceTmp addObject:tmp];
//    }
    
    
    industryArr = [HQIndustryManager defaultIndustryManager].industryArr;
    
}



#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return industryArr.count;
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dic = industryArr[row];
    return dic[@"value"];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;

    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [industryArr objectAtIndex:row][@"value"];
    myView.font = FONT(16.0);
    myView.backgroundColor = [UIColor clearColor];
    
    return myView;
}

@end
