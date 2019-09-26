 //
//  HQAddressPickView.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/18.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAddressView.h"
#import "HQAreaManager.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2


@interface HQAddressView() <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIPickerView *picker;
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    
    CGRect pickViewRect;
    
    UIView *headView;
    
    HQAreaManager *_areaManager;
    NSInteger selectPraovinceInt;
    NSInteger selectCityInt;
    NSInteger selectDistrictInt;
    
}
@property (nonatomic, assign) NSInteger components;

@end


@implementation HQAddressView


- (UIView *)initWithFrame:(CGRect)frame
{
    //大小固定
    self = [super initWithFrame:frame];
//    self.top = SCREEN_HEIGHT;
//    pickViewRect = frame;
    self.components = 3;
    if (self) {
        
        [self initWithAddressData];
        
        [self initWithAddressPickViewFrame:frame];
    }
    
    return self;
}


- (void)initWithAddressPickViewFrame:(CGRect)frame
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
    lineOne.backgroundColor = CellSeparatorColor;
    [headView addSubview:lineOne];
    
    UILabel * lineTwo = [[UILabel alloc] init];
    lineTwo.frame = CGRectMake(0, 43, SCREEN_WIDTH, 1);
    lineTwo.backgroundColor = CellSeparatorColor;
    [headView addSubview:lineTwo];
    

    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(headView.right-60, 0, 60, headView.height)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtn) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.titleLabel.font = FONT(17.0);
    [headView addSubview:sureBtn];
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, headView.height)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = FONT(17.0);
    [headView addSubview:cancelBtn];

    
    
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.height-Long(220), headView.width, Long(220))];
    picker.backgroundColor = [UIColor whiteColor];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    [picker selectRow: 0 inComponent: 0 animated: YES];
    [self addSubview: picker];
    
    selectedProvince = [province objectAtIndex: 0];
    
    
    headView.top = self.height;
    picker.top = headView.bottom;
    self.backgroundColor = HexAColor(0x323232, 0);
    self.hidden = YES;

}


- (void)sureBtn
{
    if (_sureAddressBlock) {
        _sureAddressBlock([self getSelectAddress]);
    }
    
    [self cancelView];
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
- (void)showViewWithComponents:(NSInteger)components selectRows:(NSArray *)selectRows
{
    
    self.hidden = NO;
    self.components = components == 2 ? 2 : 3;
    
    // 此处说明有默认值或者已选中了某列
    // 传进来的为["111000:北京市","111000:北京市"]
    if (selectRows && selectRows.count == self.components) {
        
        // 选中省
        NSString *proviceCode = [[selectRows[0] componentsSeparatedByString:@":"] firstObject];// 拿到省编码
        NSString *cityCode = [[selectRows[1] componentsSeparatedByString:@":"] firstObject];// 拿到市编码
        NSString *districtCode = @"";
        if (self.components == 3) {
            districtCode = [[selectRows[2] componentsSeparatedByString:@":"] firstObject];// 拿到区编码
        }
        for (NSInteger i = 0; i < province.count; i ++) {
            NSDictionary *dict = province[i];
            NSString *code = [dict valueForKey:@"id"];
            if ([proviceCode isEqualToString:code]) {
                selectPraovinceInt = i;
                break;
            }
        }
        // 选中市
        city = [NSMutableArray arrayWithArray:_areaManager.cityArr[selectPraovinceInt]];
        for (NSInteger i = 0; i < city.count; i ++) {
            NSDictionary *dict = city[i];
            NSString *code = [dict valueForKey:@"id"];
            if ([cityCode isEqualToString:code]) {
                selectCityInt = i;
                break;
            }
        }
        // 选中区
        if (self.components == 3) {
            district = [NSMutableArray arrayWithArray:_areaManager.areaArr[selectPraovinceInt][selectCityInt]];
            
            for (NSInteger i = 0; i < district.count; i ++) {
                NSDictionary *dict = district[i];
                NSString *code = [dict valueForKey:@"id"];
                if ([districtCode isEqualToString:code]) {
                    selectDistrictInt = i;
                    break;
                }
            }
        }
    }
    // 更新每列的数据源
    [picker reloadAllComponents];
    // 选中默认值or选中值的那一列
    [picker selectRow:selectPraovinceInt inComponent:PROVINCE_COMPONENT animated:YES];
    [picker selectRow:selectCityInt inComponent:CITY_COMPONENT animated:YES];
    if (self.components == 3) {
        [picker selectRow:selectDistrictInt inComponent:DISTRICT_COMPONENT animated:YES];
    }
    
    [UIView animateWithDuration:0.35
                     animations:^{
                         
                         picker.bottom = self.height;
                         headView.bottom = picker.top;
                         self.backgroundColor = HexAColor(0x323232, 0.5);
                     } completion:^(BOOL finished) {
                         
                     }];
}


- (void)initWithAddressData
{
    
    _areaManager = [HQAreaManager defaultAreaManager];

    selectPraovinceInt = 0;
    selectCityInt = 0;
    province = [NSMutableArray arrayWithArray:_areaManager.provinceArr];
    city     = [NSMutableArray arrayWithArray:_areaManager.cityArr[selectPraovinceInt]];
    district = [NSMutableArray arrayWithArray:_areaManager.areaArr[selectPraovinceInt][selectCityInt]];
}



#pragma mark- button clicked

- (NSDictionary *)getSelectAddress{
    
    
    NSInteger provinceIndex = [picker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [picker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = 0;
    if (self.components == 3) {
        districtIndex = [picker selectedRowInComponent: DISTRICT_COMPONENT];
    }
    
    NSDictionary *provinceDic = [province objectAtIndex: provinceIndex];
    NSDictionary *cityDic     = @{};
    NSDictionary *districtDic = @{};
    if (city.count) {
        
        cityDic = [city objectAtIndex: cityIndex];
        
    }
    if (self.components == 3) {
        
        if (district.count) {
            districtDic = [district objectAtIndex:districtIndex];
        }
    }
    
    
    NSString *provinceStr = provinceDic[@"name"];
    NSString *cityStr     = cityDic[@"name"];
    NSString *districtStr = districtDic[@"name"];
    
    NSString *showMsg = [NSString stringWithFormat: @"%@ %@ %@", provinceStr, cityStr, districtStr];
    
    NSString *showId = [NSString stringWithFormat: @"%@,%@,%@", provinceDic[@"id"], cityDic[@"id"], districtDic[@"id"]];
    
    
    NSString *dataStr = [NSString stringWithFormat:@"%@:%@,%@:%@,%@:%@",provinceDic[@"id"],provinceStr,cityDic[@"id"],cityStr, districtDic[@"id"],districtStr];
    
    
    if (cityStr == nil || [cityStr isEqualToString:@""]) {
        districtStr = @"";
        
        showMsg = provinceStr;
        showId = provinceDic[@"id"];
        dataStr = [NSString stringWithFormat:@"%@:%@",provinceDic[@"id"],provinceStr];
        
    }
    else if (districtStr == nil || [districtStr isEqualToString:@""]) {
        
        showMsg = [NSString stringWithFormat: @"%@ %@", provinceStr, cityStr];
        
        showId = [NSString stringWithFormat: @"%@,%@", provinceDic[@"id"], cityDic[@"id"]];
        
        dataStr = [NSString stringWithFormat:@"%@:%@,%@:%@",provinceDic[@"id"],provinceStr,cityDic[@"id"],cityStr];
    }
    
    
    NSDictionary *dic = @{
                          @"name": showMsg,
                          @"id"  : showId,
                          @"data": dataStr
                        };

    return dic;
}



#pragma mark- Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.components;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == PROVINCE_COMPONENT) {
        
        selectedProvince = [province objectAtIndex:row];
        selectPraovinceInt = row;
        city = [NSMutableArray arrayWithArray:_areaManager.cityArr[selectPraovinceInt]];
        
        NSArray *subArr = _areaManager.areaArr[selectPraovinceInt];
        if (subArr.count > 0) {
            district = [NSMutableArray arrayWithArray:subArr[0]];
        }else {
            district = [NSMutableArray array];
        }
        
        [picker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
        [picker reloadComponent: CITY_COMPONENT];
        if (self.components == 3) {
            
            [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [picker reloadComponent: DISTRICT_COMPONENT];
        }
        
    
    
    
    }else if (component == CITY_COMPONENT) {
        
        
        selectCityInt = row;
        
        NSArray *subArr = _areaManager.areaArr[selectPraovinceInt];
        if (subArr.count > 0) {
            district = [NSMutableArray arrayWithArray:subArr[selectCityInt]];
        }else {
            district = [NSMutableArray array];
        }
        if (self.components == 3) {
            [picker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [picker reloadComponent: DISTRICT_COMPONENT];
        }
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return SCREEN_WIDTH/self.components;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH/self.components, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dic = [province objectAtIndex:row];
        myView.text = dic[@"name"];
        myView.font = FONT(16.0);
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH/self.components, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dic = [city objectAtIndex:row];
        myView.text = dic[@"name"];
        myView.font = FONT(16.0);
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH/self.components, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        NSDictionary *dic = [district objectAtIndex:row];
        myView.text = dic[@"name"];
        myView.font = FONT(16.0);
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}



//
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
//    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
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
//        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
//        [provinceTmp addObject: [tmp objectAtIndex:0]];
//    }
//
//    province = [[NSArray alloc] initWithArray: provinceTmp];
//
//
//
//    NSString *index = [sortedArray objectAtIndex:0];
//    NSString *selected = [province objectAtIndex:0];
//    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
//
//    NSArray *cityArray = [dic allKeys];
//    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
//    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
//
//
//    NSString *selectedCity = [city objectAtIndex: 0];
//    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
//
//
//
//    NSMutableArray *provinceMutArr = [[NSMutableArray alloc] init];
//
//
//    //从资源文件中获取images.xml文件
//    NSString *strPathXml = [[NSBundle mainBundle] pathForResource:@"ProvinceAndCity" ofType:@"xml"];
//    NSString *xmlString = [NSString stringWithContentsOfFile:strPathXml encoding:NSUTF8StringEncoding error:nil];
//
////    NSString* xml = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
//
//    GDataXMLDocument* doc = [[GDataXMLDocument alloc]initWithXMLString:xmlString options:0 error:nil];
//
//    //  全部节点取得后显示
//    NSArray* nodes = [doc.rootElement children];
//
//
//    for (int i = 0; i < [nodes count]; i++) {
//        GDataXMLElement *ele = [nodes objectAtIndex:i];
//
//        // 根据标签名判断
//        if ([[ele name] isEqualToString:@"Province"]) {
//
//            [provinceMutArr addObject:ele.name];
//
//            // 读标签里面的属性
//            HQLog(@"name --> %@", [[ele attributeForName:@"value"] stringValue]);
//        } else {
//            // 直接读标签间的String
//            HQLog(@"age --> %@", [ele stringValue]);
//        }
//
//    }



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
