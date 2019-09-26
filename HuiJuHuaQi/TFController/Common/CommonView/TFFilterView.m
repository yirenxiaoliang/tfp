//
//  TFFilterView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFilterView.h"
#import "AlertView.h"
#import "TFFilterModel.h"
#import "HQEmployModel.h"
#import "HQSelectTimeCell.h"
#import "HQTFTwoLineCell.h"
#import "HQTFInputCell.h"
#import "TFFilterItemModel.h"
#import "HQSelectTimeView.h"
#import "TFMaxMinValueCell.h"
#import "HQAddressView.h"
#import "HQAreaManager.h"
#import "TFEmployModel.h"
#import "TFChangeHelper.h"
#import "TFDepartmentModel.h"

#define MarginWidth 55
#define Color RGBColor(0x3d, 0xb8, 0xc1)


@interface TFFilterView ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,TFMaxMinValueCellDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** HQAddressView */
@property (nonatomic, strong) HQAddressView *addressView;


/** conditions */
@property (nonatomic, strong) NSMutableArray *conditions;

/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;


@end

@implementation TFFilterView

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}

-(HQAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    return _addressView;
}
/** 组件库：
 text:'单行文本',
 textarea:'多行文本',
 picklist:'下拉选项',
 phone:'电话',
 email:'邮箱',
 number:'数字',
 datetime:'时间',
 reference:'引用',
 url:'超链接',
 attachment:'附件',
 picture:'图片',
 location:'定位',
 identifier:'自动编号',
 multi:'复选框',
 functionformula:'公式',
 personnel:'人员',
 subform:'子表单'
 
 */

-(void)setFilters:(NSMutableArray *)filters{
    
    _filters = filters;
    
    for (TFFilterModel *model in filters) {
        model.open = @0;
        
        if ([model.type isEqualToString:@"personnel"]) {// 人员
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in model.options) {
                
                TFEmployModel *emp = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    
                    [arr addObject:[TFChangeHelper tfEmployeeToHqEmployee:emp]];
                }
            }
            
            HQEmployModel *ee = [[HQEmployModel alloc] init];
            ee.employee_name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
        }
        
        if ([model.type isEqualToString:@"department"]) {// 部门
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in model.options) {
                
                TFDepartmentModel *emp = [[TFDepartmentModel alloc] initWithDictionary:dict error:nil];
                
                if (emp) {
                    [arr addObject:emp];
                }
            }
            
            TFDepartmentModel *ee = [[TFDepartmentModel alloc] init];
            ee.name = @"请选择";
            [arr insertObject:ee atIndex:0];
            
            model.entrys = arr;
        }
        
        if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dict in model.options) {
                TFFilterItemModel *model = [[TFFilterItemModel alloc] initWithDictionary:dict error:nil];
                if (model) {
                    model.type = @0;
                    [arr addObject:model];
                }
            }
            model.entrys = arr;
        }
        
        if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"]||[model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"]||[model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"] || [model.type isEqualToString:@"mutlipicklist"]) {
            
            NSArray *names = @[@"输入关键字",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @1;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
        }
        
        if ([model.type isEqualToString:@"number"]) {
            
            NSArray *names = @[@"值",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @3;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
        }
        
        
        if ([model.type isEqualToString:@"area"]) {
            
            NSArray *names = @[@"地区",@"已填写",@"未填写"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                if (k == 0) {
                    item.type = @4;
                }
                item.selectState = @0;
                [arr addObject:item];
            }
            model.entrys = arr;
        }
        
        
        if ([model.type isEqualToString:@"datetime"]) {
            
            NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
            NSMutableArray *arr = [NSMutableArray array];
            
            for (NSInteger k = 0; k < names.count; k ++) {
                TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                item.label = names[k];
                item.type = @0;
                item.selectState = @0;
                
                if (k == names.count-2 || k == names.count - 1) {
                    item.type = @2;
                }
                
                [arr addObject:item];
            }
            model.entrys = arr;
        }

    }
    
    [self.tableView reloadData];
}


-(NSMutableArray *)conditions{
    
    if (!_conditions) {
        _conditions = [NSMutableArray array];
        
        NSArray *types = @[@"text",@"textarea",@"area",@"location",@"phone",@"email",@"url",@"picklist",@"personnel",@"datetime",@"number"];
        for (NSInteger i = 0; i < types.count; i ++) {
            
            TFFilterModel *model = [[TFFilterModel alloc] init];
            model.name = types[i];
            model.open = @0;
            model.type = types[i];
            model.id = types[i];
            
            if ([model.type isEqualToString:@"personnel"]) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSInteger j = 0; j < 3; j ++) {
                    
                    HQEmployModel *emp = [[HQEmployModel alloc] init];
                    
                    emp.employeeName = @"张三";
                    emp.selectState = @0;
                    
                    [arr addObject:emp];
                }
                model.entrys = arr;
            }
            if ([model.type isEqualToString:@"datetime"]) {
                
                NSArray *names = @[@"今天",@"昨天",@"过去7天",@"过去30天",@"本月",@"上月",@"本季度",@"上季度",@"开始时间",@"结束时间"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger k = 0; k < names.count; k ++) {
                    TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                    item.label = names[k];
                    item.type = @0;
                    item.selectState = @0;
                    
                    if (k == names.count-2 || k == names.count - 1) {
                        item.type = @2;
                    }
                    
                    [arr addObject:item];
                }
                model.entrys = arr;
            }
            
            if ([model.type isEqualToString:@"number"]) {
                
                NSArray *names = @[@"值",@"已填写",@"未填写"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger k = 0; k < names.count; k ++) {
                    TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                    item.label = names[k];
                    item.type = @0;
                    if (k == 0) {
                        item.type = @3;
                    }
                    item.selectState = @0;
                    [arr addObject:item];
                }
                model.entrys = arr;
            }
            
            if ([model.type isEqualToString:@"area"]) {
                
                NSArray *names = @[@"地区",@"已填写",@"未填写"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger k = 0; k < names.count; k ++) {
                    TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                    item.label = names[k];
                    item.type = @0;
                    if (k == 0) {
                        item.type = @4;
                    }
                    item.selectState = @0;
                    [arr addObject:item];
                }
                model.entrys = arr;
            }
            
            if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"]) {
                
                NSArray *names = @[@"输入关键字",@"已填写",@"未填写"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger k = 0; k < names.count; k ++) {
                    TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                    item.label = names[k];
                    item.type = @0;
                    if (k == 0) {
                        item.type = @1;
                    }
                    item.selectState = @0;
                    [arr addObject:item];
                }
                model.entrys = arr;
            }
            if ([model.type isEqualToString:@"picklist"]) {
                
                    
                NSArray *names = @[@"选项一",@"选项二",@"选项三"];
                NSMutableArray *arr = [NSMutableArray array];
                
                for (NSInteger k = 0; k < names.count; k ++) {
                    TFFilterItemModel *item = [[TFFilterItemModel alloc] init];
                    item.label = names[k];
                    item.type = @0;
                    item.selectState = @0;
        
                    
                    [arr addObject:item];
                }
                model.entrys = arr;
                
            }
            
            [_conditions addObject:model];
        }
        
    }
    return _conditions;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}



- (void)setupChild{
    
    UIView *bgview = [[UIView alloc] initWithFrame:(CGRect){0,0,MarginWidth,SCREEN_HEIGHT}];
    [self addSubview:bgview];
    
    [self setupTableView];

    UIView *headView = [[UIView alloc] initWithFrame:(CGRect){MarginWidth,SCREEN_HEIGHT-BottomHeight-NaviHeight,SCREEN_WIDTH-MarginWidth,BottomHeight}];
    headView.backgroundColor = WhiteColor;
    [self addSubview:headView];
    
    UILabel *titleView = [[UILabel alloc] init];
    titleView.text = @"筛选";
    titleView.font = BFONT(18);
    [titleView sizeToFit];
    [headView addSubview:titleView];
    titleView.textColor = BlackTextColor;
    titleView.center = CGPointMake(headView.width/2, TabBarHeight/2);
    titleView.hidden = YES;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:sureBtn];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateHighlighted];
    [sureBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [sureBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    sureBtn.frame = CGRectMake( headView.width/2, 0, headView.width/2, 49);
    [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headView addSubview:startBtn];
    [startBtn setTitle:@"重置" forState:UIControlStateNormal];
    [startBtn setTitle:@"重置" forState:UIControlStateHighlighted];
    [startBtn setTitleColor:GreenColor forState:UIControlStateNormal];
    [startBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
    startBtn.frame = CGRectMake(0, 0, headView.width/2, 49);
    [startBtn addTarget:self action:@selector(startClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){headView.width/2,10,0.5,29}];
    line.backgroundColor = CellSeparatorColor;
    [headView addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBgView)];
    [bgview addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgview addGestureRecognizer:pan];
    
    
    self.backgroundColor = RGBAColor(0, 0, 0, 0);
    self.layer.masksToBounds = NO;
}

-(void)startClicked{
    
    
    for (TFFilterModel *model in self.filters) {
        if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"]||[model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"]||[model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"] || [model.type isEqualToString:@"mutlipicklist"]) {
            
            for (TFFilterItemModel *item in model.entrys) {
                
                item.content = @"";
                item.selectState = @0;
            }
            
        }
        
        if ([model.type isEqualToString:@"personnel"]) {
            
            for (HQEmployModel *item in model.entrys) {
                item.selectState = @0;
            }
            
        }
        
        if ([model.type isEqualToString:@"department"]) {
            
            for (TFDepartmentModel *item in model.entrys) {
                item.select = @0;
            }
            
        }
        if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
            
            for (TFFilterItemModel *item in model.entrys) {
                item.selectState = @0;
            }
        }
        
        if ([model.type isEqualToString:@"number"]) {
            
            for (TFFilterItemModel *item in model.entrys) {
                item.minValue = @"";
                item.maxValue = @"";
                item.selectState = @0;
                item.content = @"";
            }
    
        }
        
        if ([model.type isEqualToString:@"datetime"]) {
            
//            NSMutableDictionary *time = [NSMutableDictionary dictionary];
            for (NSInteger i = 0; i < model.entrys.count; i ++) {
                
                TFFilterItemModel *item = model.entrys[i];
                
                item.minValue = @"";
                item.maxValue = @"";
                item.selectState = @0;
                item.content = @"";
                item.timeSp = @0;
                
            }
        }
    }
    [self.tableView reloadData];
    
}

- (void)sure{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    
    for (TFFilterModel *model in self.filters) {
        if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"]||[model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"]||[model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"] || [model.type isEqualToString:@"mutlipicklist"]) {
            
            NSString *str = @"";
            for (TFFilterItemModel *item in model.entrys) {
                
        
                if (item.content && ![item.content isEqualToString:@""]) {
                    str = item.content;
                }
                if ([item.label isEqualToString:@"已填写"] && [item.selectState isEqualToNumber:@1]) {
                    str = @"ISNOTNULL";
                }
                
                if ([item.label isEqualToString:@"未填写"] && [item.selectState isEqualToNumber:@1]) {
                    str = @"ISNULL";
                }
                
            }
            if (![str isEqualToString:@""]) {
                [dict setObject:str forKey:model.id];
            }
            
        }
        
        if ([model.type isEqualToString:@"personnel"]) {
            
            NSString *str = @"";
            for (HQEmployModel *item in model.entrys) {
                if ([item.selectState isEqualToNumber:@1]) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
                }
            }
            
            if (str.length) {
                [dict setObject:[str substringToIndex:str.length-1] forKey:model.id];
            }
            
        }
        
        if ([model.type isEqualToString:@"department"]) {
            
            NSString *str = @"";
            for (TFDepartmentModel *item in model.entrys) {
                if ([item.select isEqualToNumber:@1]) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
                }
            }
            
            if (str.length) {
                [dict setObject:[str substringToIndex:str.length-1] forKey:model.id];
            }
            
        }
        if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
            
            NSString *str = @"";
            for (TFFilterItemModel *item in model.entrys) {
                if ([item.selectState isEqualToNumber:@1]) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.value description]]];
                }
            }
            if (str.length) {
                [dict setObject:[str substringToIndex:str.length-1] forKey:model.id];
            }
        }
        
        if ([model.type isEqualToString:@"number"]) {
            
            NSMutableDictionary *valueDict = [NSMutableDictionary dictionary];
            NSString *str = @"";
            for (TFFilterItemModel *item in model.entrys) {
                
                if (item.minValue && ![item.minValue isEqualToString:@""]) {
                    
                    [valueDict setObject:item.minValue forKey:@"minValue"];
                }
                if (item.maxValue && ![item.maxValue isEqualToString:@""]) {
                    
                    [valueDict setObject:item.maxValue forKey:@"maxValue"];
                }
                if ([item.label isEqualToString:@"已填写"] && [item.selectState isEqualToNumber:@1]) {
                    str = @"ISNOTNULL";
                }
                
                if ([item.label isEqualToString:@"未填写"] && [item.selectState isEqualToNumber:@1]) {
                    str = @"ISNULL";
                }
                
            }
            if (valueDict.allValues.count) {
                
                [dict setObject:valueDict forKey:model.id];
                
            }else{
                
                if (![str isEqualToString:@""]) {
                    [dict setObject:str forKey:model.id];
                }
            }
            
        }
        
        if ([model.type isEqualToString:@"datetime"]) {
            
            NSMutableDictionary *time = [NSMutableDictionary dictionary];
            for (NSInteger i = 0; i < model.entrys.count; i ++) {
                
                TFFilterItemModel *item = model.entrys[i];
                
                if ([item.type isEqualToNumber:@0]) {// 选item
                    
                    if ([item.selectState isEqualToNumber:@1]) {// 选中
                        // 时间转化
                        [dict setObject:[HQHelper timePeriodWithIndex:i] forKey:model.id];
                        break;
                    }
                }
                
                if ([item.type isEqualToNumber:@2]) {// 选时间
                    
                    if (item.timeSp && ![item.timeSp isEqualToNumber:@0]) {
                        
                        if (i == 8) {
                            [time setObject:item.timeSp forKey:@"startTime"];
                            [dict setObject:time forKey:model.id];
                        }
                        if (i == 9) {
                            [time setObject:item.timeSp forKey:@"endTime"];
                            [dict setObject:time forKey:model.id];
                        }
                    }
                }
            }
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidSureBtnWithDict:)]) {
        [self.delegate filterViewDidSureBtnWithDict:dict];
    }
}

- (void)tapBgView{
    
    if ([self.delegate respondsToSelector:@selector(filterViewDidClicked:)]) {
        [self.delegate filterViewDidClicked:NO];
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan{

    CGPoint point = [pan translationInView:pan.view];
    
//    HQLog(@"=%@=",NSStringFromCGPoint(point));
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.left = point.x;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.left += point.x-self.left;
            
            if (self.left <= 0) {
                self.left = 0.0;
            }else if (self.left >= SCREEN_WIDTH){
                self.left = SCREEN_WIDTH;
            }
            
            CGFloat alpha = self.left/(SCREEN_WIDTH-MarginWidth);
            HQLog(@"=======%f=====",0.5-0.5*alpha);
            
            self.backgroundColor = RGBAColor(0, 0, 0, 0.5-0.5*alpha);
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            if (self.left > MarginWidth) {

                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0);
                    self.left = SCREEN_WIDTH;
                }completion:^(BOOL finished) {
                    
                    [self tapBgView];
                }];
            }else{
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    self.backgroundColor = RGBAColor(0, 0, 0, 0.5);
                    self.left = 0;
                }];
            }
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(MarginWidth, 0, SCREEN_WIDTH-MarginWidth, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, BottomHeight+8, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.filters.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFFilterModel *model = self.filters[section];
    
    if ([model.open isEqualToNumber:@1]) {
        
        return model.entrys.count + 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFFilterModel *model = self.filters[indexPath.section];
    
    if (indexPath.row == 0) {
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = model.name;
        cell.titltW.constant = SCREEN_WIDTH-MarginWidth-60;
        cell.backgroundColor = WhiteColor;
        cell.time.textColor = WhiteColor;
        cell.time.text = @"";
        cell.timeTitle.textColor = ExtraLightBlackTextColor;
        if ([model.open isEqualToNumber:@1]) {
            [cell.arrow setImage:[UIImage imageNamed:@"展开"]];
        }else{
            [cell.arrow setImage:[UIImage imageNamed:@"下拉"]];
        }
        [self hiddenToplineForCell:cell indexPath:indexPath];
        return cell;
    }else{
        
        if ([model.type isEqualToString:@"personnel"]) {
            
            if (indexPath.row == 1) {
                HQEmployModel *emp = model.entrys[indexPath.row - 1];
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = emp.employee_name;
                cell.titltW.constant = SCREEN_WIDTH-MarginWidth-60;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
            }else{
                HQEmployModel *emp = model.entrys[indexPath.row - 1];
                
                HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
                [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:emp.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
                        [cell.titleImage setBackgroundImage:image forState:UIControlStateHighlighted];
                        [cell.titleImage setBackgroundImage:emp.image forState:UIControlStateSelected];
                    }else{
                        [cell.titleImage setTitle:[HQHelper nameWithTotalName:emp.employeeName?:emp.employee_name] forState:UIControlStateNormal];
                        [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
                        [cell.titleImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
                        cell.titleImage.titleLabel.font = FONT(12);
                        emp.image = nil;
                    }
                }];
               
                cell.enterImgTrailW.constant = -18;
                cell.titleImage.layer.cornerRadius = 15;
                cell.titleImage.layer.masksToBounds = YES;
                cell.titleImageWidth = 30;
                cell.type = TwoLineCellTypeOne;
                cell.topLabel.text = emp.employeeName?:emp.employee_name;
                cell.topLabel.textColor = WhiteColor;
                cell.backgroundColor = Color;
                if ([emp.selectState isEqualToNumber:@1]) {
                    
                    [cell.enterImage setImage:[UIImage imageNamed:@"filterMulti"] forState:UIControlStateNormal];
                }else{
                    
                    [cell.enterImage setImage:[UIImage imageNamed:@"filterNo"] forState:UIControlStateNormal];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }
            
            
        }
        if ([model.type isEqualToString:@"department"]) {
            
            if (indexPath.row == 1) {
                TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = emp.name;
                cell.titltW.constant = SCREEN_WIDTH-MarginWidth-60;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
            }else{
                TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                
                HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
                
                [cell.titleImage setBackgroundImage:IMG(@"部门") forState:UIControlStateNormal];
                
                cell.enterImgTrailW.constant = -18;
                cell.titleImage.layer.cornerRadius = 15;
                cell.titleImage.layer.masksToBounds = YES;
                cell.titleImageWidth = 30;
                cell.type = TwoLineCellTypeOne;
                cell.topLabel.text = emp.name;
                cell.topLabel.textColor = WhiteColor;
                cell.backgroundColor = Color;
                if ([emp.select isEqualToNumber:@1]) {
                    
                    [cell.enterImage setImage:[UIImage imageNamed:@"filterMulti"] forState:UIControlStateNormal];
                }else{
                    
                    [cell.enterImage setImage:[UIImage imageNamed:@"filterNo"] forState:UIControlStateNormal];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }
            
            
        }
        else if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"]||[model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"]||[model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"] || [model.type isEqualToString:@"mutlipicklist"]) {
            
            
                TFFilterItemModel *item = model.entrys[indexPath.row-1];
    
                if ([item.type isEqualToNumber:@0]) {
    
                    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                    cell.timeTitle.text = item.label;
                    cell.backgroundColor = Color;
                    cell.time.textColor = WhiteColor;
                    cell.time.text = @"";
                    cell.timeTitle.textColor = WhiteColor;
                    if ([item.selectState isEqualToNumber:@1]) {
                        [cell.arrow setImage:[UIImage imageNamed:@"filterSingle"]];
                    }else{
                        [cell.arrow setImage:[UIImage imageNamed:@"filterNo"]];
                    }
                    [self hiddenToplineForCell:cell indexPath:indexPath];
                    return cell;
    
                }else if ([item.type isEqualToNumber:@1]) {
    
                    HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
                    [cell refreshInputCellWithType:0];
                    cell.inputLeftW.constant = 10;
                    cell.titleLabel.text = @"";
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:item.label attributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(14)}];
                    cell.textField.attributedPlaceholder = str;
                    cell.backgroundColor = Color;
                    cell.titleLabel.textColor = WhiteColor;
                    cell.textField.tag = indexPath.section * 0x222 + indexPath.row-1;
                    cell.delegate = self;
                    cell.textField.text = item.content;
                    [self hiddenToplineForCell:cell indexPath:indexPath];
                    return cell;
    
                }
            
        }else if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]){
            TFFilterItemModel *item = model.entrys[indexPath.row-1];
            
            if ([item.type isEqualToNumber:@0]) {
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                if ([item.selectState isEqualToNumber:@1]) {
                    [cell.arrow setImage:[UIImage imageNamed:@"filterMulti"]];
                }else{
                    [cell.arrow setImage:[UIImage imageNamed:@"filterNo"]];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }

            
        }else if ([model.type isEqualToString:@"datetime"]){
            
            
            TFFilterItemModel *item = model.entrys[indexPath.row-1];
            
            if ([item.type isEqualToNumber:@0]) {
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                if ([item.selectState isEqualToNumber:@1]) {
                    [cell.arrow setImage:[UIImage imageNamed:@"filterSingle"]];
                }else{
                    [cell.arrow setImage:[UIImage imageNamed:@"filterNo"]];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }else if ([item.type isEqualToNumber:@2]){
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.timeTitle.textColor = WhiteColor;
                cell.time.textColor = WhiteColor;
                if (!item.timeSp || [item.timeSp isEqualToNumber:@0]) {
                    
                    cell.time.text = @"年-月-日";
                }else{
                    cell.time.text = [HQHelper nsdateToTime:[item.timeSp longLongValue] formatStr:@"yyyy年MM月dd日"];
                }
                if ([item.selectState isEqualToNumber:@1]) {
                    [cell.arrow setImage:nil];
                }else{
                    [cell.arrow setImage:nil];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
            }
            
        }else if ([model.type isEqualToString:@"number"]){
            
            TFFilterItemModel *item = model.entrys[indexPath.row-1];
            if ([item.type isEqualToNumber:@0]) {
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                if ([item.selectState isEqualToNumber:@1]) {
                    [cell.arrow setImage:[UIImage imageNamed:@"filterSingle"]];
                }else{
                    [cell.arrow setImage:[UIImage imageNamed:@"filterNo"]];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }else if ([item.type isEqualToNumber:@3]){
                
                TFMaxMinValueCell *cell = [TFMaxMinValueCell maxMinValueCellWithTableView:tableView];
                cell.delegate = self;
                cell.tag = indexPath.section * 0x555 + indexPath.row-1;
                cell.textField1.text = item.minValue;
                cell.textField2.text = item.maxValue;
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
            }

        }else if ([model.type isEqualToString:@"area"]){
            
            TFFilterItemModel *item = model.entrys[indexPath.row-1];
            if ([item.type isEqualToNumber:@0]) {
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.time.textColor = WhiteColor;
                cell.time.text = @"";
                cell.timeTitle.textColor = WhiteColor;
                if ([item.selectState isEqualToNumber:@1]) {
                    [cell.arrow setImage:[UIImage imageNamed:@"filterSingle"]];
                }else{
                    [cell.arrow setImage:[UIImage imageNamed:@"filterNo"]];
                }
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
                
            }else if ([item.type isEqualToNumber:@4]){
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = item.label;
                cell.backgroundColor = Color;
                cell.timeTitle.textColor = WhiteColor;
                cell.time.textColor = WhiteColor;
                if (!item.content || [item.content isEqualToString:@""]) {
                    
                    cell.time.text = @"";
                }else{
                    cell.time.text = [self.areaManager regionWithRegionData:item.content];
                }
                [cell.arrow setImage:[UIImage imageNamed:@"下一级浅灰"]];
                [self hiddenToplineForCell:cell indexPath:indexPath];
                return cell;
            }
            
        }
        
    }
    static NSString *ID = @"cell";
    HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"";
    [self hiddenToplineForCell:cell indexPath:indexPath];
    return cell;
    
}
    
- (void)hiddenToplineForCell:(HQBaseCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section  == 0) {
            cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中

    TFFilterModel *model = self.filters[indexPath.section];
    
    if (indexPath.row == 0) {
        
        model.open = [model.open isEqualToNumber:@0]?@1:@0;
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        
        if ([model.type isEqualToString:@"personnel"]) {
            
            if (indexPath.row == 1) {
                // 此处跳转选人控件
                
                if ([self.delegate respondsToSelector:@selector(filterViewDidSelectPeopleWithPeoples:model:)]) {
                    NSMutableArray *arrff = [NSMutableArray arrayWithArray:model.entrys];
                    if (arrff.count) {
                        [arrff removeObjectAtIndex:0];
                    }
                    [self.delegate filterViewDidSelectPeopleWithPeoples:arrff model:model];
                }
                
            }else{
                
                HQEmployModel *emp = model.entrys[indexPath.row - 1];
                emp.selectState = [emp.selectState isEqualToNumber:@1]?@0:@1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
        else if ([model.type isEqualToString:@"department"]) {
            
            if (indexPath.row == 1) {
                // 此处跳转选部门控件
                if ([self.delegate respondsToSelector:@selector(filterViewDidSelectDepartmentWithDepartments:model:)]) {
                    NSMutableArray *arrff = [NSMutableArray arrayWithArray:model.entrys];
                    if (arrff.count) {
                        [arrff removeObjectAtIndex:0];
                    }
                    [self.delegate filterViewDidSelectDepartmentWithDepartments:arrff model:model];
                }
                
            }else{
                
                TFDepartmentModel *emp = model.entrys[indexPath.row - 1];
                emp.select = [emp.select isEqualToNumber:@1]?@0:@1;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }
        else{
            
            __block TFFilterItemModel *item = model.entrys[indexPath.row - 1];
            
            
            if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"textarea"] ||[model.type isEqualToString:@"email"] ||[model.type isEqualToString:@"phone"] ||[model.type isEqualToString:@"url"] ||[model.type isEqualToString:@"location"] ||[model.type isEqualToString:@"reference"]||[model.type isEqualToString:@"identifier"]||[model.type isEqualToString:@"serialnum"]||[model.type isEqualToString:@"functionformula"]||[model.type isEqualToString:@"citeformula"]||[model.type isEqualToString:@"subform"]||[model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"barcode"] || [model.type isEqualToString:@"multitext"] || [model.type isEqualToString:@"mutlipicklist"]) {
                
                
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    
                    BOOL haveTime = NO;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        if ([secItem.type isEqualToNumber:@1]) {
                            if (secItem.content && ![secItem.content isEqualToString:@""]) {
                                haveTime = YES;
                                break;
                            }
                        }
                    }
                    
                    if (haveTime) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.selectState = @0;
                        }
                    }
                    
                    item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                    
                    NSInteger index = 0;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        
                        if ([secItem.selectState isEqualToNumber:@1]) {
                            index ++;
                        }
                    }
                    
                    if (index >= 2) {// 单选处理
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.selectState = @0;
                        }
                        item.selectState = @1;
                    }
                    
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
            
            }
            
            if ([model.type isEqualToString:@"picklist"]) {
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
            if ([model.type isEqualToString:@"datetime"]) {
                
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    BOOL haveTime = NO;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        if ([secItem.type isEqualToNumber:@2]) {
                            if (secItem.timeSp && ![secItem.timeSp isEqualToNumber:@0]) {
                                haveTime = YES;
                                break;
                            }
                        }
                    }
                    
                    if (haveTime) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.selectState = @0;
                            secItem.timeSp = @0;
                        }
                    }
                    item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                    
                    
                    NSInteger index = 0;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        
                        if ([secItem.selectState isEqualToNumber:@1]) {
                            index ++;
                        }
                    }
                    
                    if (index >= 2) {// 单选处理
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.selectState = @0;
                        }
                        item.selectState = @1;
                    }

                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    
                }
                
                if ([item.type isEqualToNumber:@2]) {
                    
                    for (TFFilterItemModel *secItem in model.entrys) {// 选择时间时，取消时间点选择
                        secItem.selectState = @0;
                    }
                    
                    [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDay timeSp:(!item.timeSp || [item.timeSp isEqualToNumber:@0])?[HQHelper getNowTimeSp]:[item.timeSp longLongValue] LeftTouched:^{
                        
                    } onRightTouched:^(NSString *time) {
                        
                        item.timeSp = [NSNumber numberWithLongLong:[HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]];
                        
//                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
            }
            
            if ([model.type isEqualToString:@"area"]) {
                
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    BOOL haveTime = NO;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        if ([secItem.type isEqualToNumber:@4]) {
                            if (secItem.content && ![secItem.content isEqualToString:@""]) {
                                haveTime = YES;
                                break;
                            }
                        }
                    }
                    
                    if (haveTime) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.selectState = @0;
                        }
                    }
                    
                    item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                    
                    
                    NSInteger index = 0;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        
                        if ([secItem.selectState isEqualToNumber:@1]) {
                            index ++;
                        }
                    }
                    
                    if (index >= 2) {// 单选处理
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.maxValue = @"";
                            secItem.minValue = @"";
                            secItem.selectState = @0;
                        }
                        item.selectState = @1;
                    }

                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
                
                if ([item.type isEqualToNumber:@4]) {
                    
                    for (TFFilterItemModel *secItem in model.entrys) {// 选择时间时，取消时间点选择
                        secItem.selectState = @0;
                    }
                    
                    
                    __weak TFFilterView *this = self;
                    [self insertSubview:self.addressView aboveSubview:self.tableView];
                    [self.addressView showView];
                    self.addressView.sureAddressBlock = ^(id result) {
                        
                        
                        item.content = result[@"id"];
                        
                        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                        [this.addressView cancelView];
                        [this.addressView removeFromSuperview];
                    };
                }
                
                
            }
            
            if ([model.type isEqualToString:@"number"]) {
                
                if ([item.type isEqualToNumber:@0]) {
                    
                    
                    BOOL haveTime = NO;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        if ([secItem.type isEqualToNumber:@3]) {
                            if ((secItem.minValue && ![secItem.minValue isEqualToString:@""]) || (secItem.maxValue && ![secItem.maxValue isEqualToString:@""]) ) {
                                haveTime = YES;
                                break;
                            }
                        }
                    }
                    
                    if (haveTime) {
                        
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.minValue = @"";
                            secItem.maxValue = @"";
                            secItem.selectState = @0;
                        }
                    }
                    
                    item.selectState = [item.selectState isEqualToNumber:@1]?@0:@1;
                    
                    NSInteger index = 0;
                    for (TFFilterItemModel *secItem in model.entrys) {
                        
                        if ([secItem.selectState isEqualToNumber:@1]) {
                            index ++;
                        }
                    }
                    
                    if (index >= 2) {// 单选处理
                        for (TFFilterItemModel *secItem in model.entrys) {
                            secItem.content = @"";
                            secItem.minValue = @"";
                            secItem.maxValue = @"";
                            secItem.selectState = @0;
                        }
                        item.selectState = @1;
                    }
                    
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFMaxMinValueCellDelegate
-(void)maxMinValueCell:(TFMaxMinValueCell *)maxMinValueCell withTextField:(UITextField *)textField{
    
    NSInteger section = maxMinValueCell.tag / 0x555;
    NSInteger row = maxMinValueCell.tag % 0x555;
    TFFilterModel *model = self.filters[section];
    
    TFFilterItemModel *item = model.entrys[row];
    
    if (textField.tag == 0x111) {
        
        item.minValue = textField.text;
    }
    
    if (textField.tag == 0x222) {
        
        item.maxValue = textField.text;
    }
    
    for (TFFilterItemModel *item in model.entrys) {
        
        item.selectState = @0;
        
    }
    
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.entrys.count inSection:section],[NSIndexPath indexPathForRow:model.entrys.count-1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    NSInteger section = textField.tag / 0x222;
    NSInteger row = textField.tag % 0x222;
    
    TFFilterModel *model = self.filters[section];
    
    TFFilterItemModel *item = model.entrys[row];
    item.content = textField.text;
    
    for (TFFilterItemModel *item in model.entrys) {
        
        item.selectState = @0;
        
    }
    
        
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.entrys.count inSection:section],[NSIndexPath indexPathForRow:model.entrys.count-1 inSection:section]] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)refresh{
    [self.tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
