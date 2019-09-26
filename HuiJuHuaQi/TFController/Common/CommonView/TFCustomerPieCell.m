//
//  TFCustomerPieCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerPieCell.h"
#import "JHChartHeader.h"
#import "GCFunnelChart.h"
#import "GCChartModel.h"

@interface TFCustomerPieCell ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** type */
@property (nonatomic, assign) NSInteger type;

/** pieChart */
@property (nonatomic, weak) JHPieChart *pieChart;
/** funnelChart */
@property (nonatomic, weak) GCFunnelChart *funnelChart;

/** models */
@property (nonatomic, strong) NSMutableArray *models;



@end

@implementation TFCustomerPieCell

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (instancetype)initWithCoder:(NSCoder *)coder withType:(NSInteger)type
{
    self.type = type;
    self = [super initWithCoder:coder];
    if (self) {
        [self setupTableView];
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withType:(NSInteger)type{
    self.type = type;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupTableView];
    }
    return self;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.type == 0) {
        [self showPieChartUpView];
    }else{
        [self showFunnelChart];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(2*SCREEN_WIDTH/3-15, 15, SCREEN_WIDTH/3, 2*SCREEN_WIDTH/3-30) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.contentView addSubview:tableView];
    self.tableView = tableView;
    
    self.layer.masksToBounds = YES;
    self.contentView.layer.masksToBounds = YES;
}


/**
 *  饼状图
 */
- (void)showPieChartUpView{
    
    JHPieChart *pie = [[JHPieChart alloc] initWithFrame:CGRectMake(15, 15, 2*SCREEN_WIDTH/3, 2*SCREEN_WIDTH/3-5)];
    pie.backgroundColor = [UIColor whiteColor];
    
    pie.center = CGPointMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3);
    /* Pie chart value, will automatically according to the percentage of numerical calculation */
    pie.valueArr = @[@18,@14,@25,@40,@18,@18,@25,@40];
    /* The description of each sector must be filled, and the number must be the same as the pie chart. */
    pie.descArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
    //    pie.backgroundColor = [UIColor whiteColor];
    pie.didClickType = JHPieChartDidClickTranslateToBig;
    pie.animationDuration = 1.0;
    [self.contentView addSubview:pie];
    /*    When touching a pie chart, the animation offset value     */
    pie.positionChangeLengthWhenClick = 5;
    pie.showDescripotion = NO;
    pie.animationType = 0;
    pie.colorArr = @[[UIColor greenColor],[UIColor redColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor blueColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor yellowColor]];
    /*        Start animation         */
    [pie showAnimation];
    self.pieChart = pie;
}

-(void)refreshCellWithModels:(NSArray *)models{
    
    NSArray *colors = @[[UIColor greenColor],[UIColor redColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor blueColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor yellowColor]];
    NSArray *names = @[@"大米",@"黄瓜",@"萝卜",@"白菜",@"西红柿",@"土豆",@"菠菜",@"草鱼"];
    NSArray *values = @[@123,@524,@254,@252,@823,@163,@993,@553];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < names.count; i ++) {
        GCChartModel *model = [[GCChartModel alloc] init];
        model.color = colors[i];
        model.value = [values[i] floatValue];
        model.name = names[i];
        if (i == names.count-1) {
            model.isBottom = YES;
        }
        [dataArray addObject:model];
    }
    
    self.models = dataArray;
    if (self.type == 0) {
        
        [self.pieChart reloadChartWithDataSource:dataArray];
    }else{
        
        [self.funnelChart reloadChartWithDataSource:dataArray];
        
    }
    
}


- (void)showFunnelChart{
//    
//    NSMutableArray *dataArray = [NSMutableArray array];
//    GCChartModel *model1 = [[GCChartModel alloc] init];
//    model1.value = 200;
//    model1.name = @"20%";
//    [dataArray addObject:model1];
//    GCChartModel *model2 = [[GCChartModel alloc] init];
//    model2.value = 100;
//    model2.name = @"40%";
//    [dataArray addObject:model2];
//    GCChartModel *model3 = [[GCChartModel alloc] init];
//    model3.value = 50;
//    model3.name = @"60%";
//    [dataArray addObject:model3];
//    GCChartModel *model7 = [[GCChartModel alloc] init];
//    model7.value = 150;
//    model7.name = @"90%";
//    [dataArray addObject:model7];
//    GCChartModel *model4 = [[GCChartModel alloc] init];
//    model4.value = 10;
//    model4.name = @"80%";
//    [dataArray addObject:model4];
//    GCChartModel *model5 = [[GCChartModel alloc] init];
//    model5.value = 60;
//    model5.name = @"100%";
//    model5.isBottom = YES;
//    [dataArray addObject:model5];
//    //    GCChartModel *model6 = [[GCChartModel alloc] init];
//    //    model6.value = 350;
//    //    model6.name = @"100%";
//    //    model6.isBottom = YES;
//    //    [dataArray addObject:model6];
    
    GCFunnelChart *chartView = [[GCFunnelChart alloc] initWithFrame:CGRectMake(15, 20, 2*SCREEN_WIDTH/3-30, 2*SCREEN_WIDTH/3-30) chartModelArray:@[] showLegend:NO];
    chartView.backgroundColor = [UIColor whiteColor];
    
    chartView.center = CGPointMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3+5);
    chartView.sliceSelectedBlock = ^(NSInteger idx,GCChartModel *model){
        
    };
    [self.contentView addSubview:chartView];
    [chartView selectSliceWithIndex:-1];
    self.funnelChart = chartView;
}


+ (TFCustomerPieCell *)customerPieCellWithTableView:(UITableView *)tableView withType:(NSInteger)type
{
    static NSString *indentifier = @"TFCustomerPieCell";
    TFCustomerPieCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[TFCustomerPieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier withType:(NSInteger)type];
    }
    cell.topLine.hidden = YES;
//    cell.bottomLine.hidden = YES;
    return cell;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    GCChartModel *model = self.models[indexPath.row];
    
    cell.imageView.image = [HQHelper createImageWithColor:model.color size:(CGSize){15,15}];
    cell.textLabel.text = model.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (2*SCREEN_WIDTH/3-30)/8;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
