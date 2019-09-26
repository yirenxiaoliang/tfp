//
//  TFEnterModelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEnterModelController.h"
#import "HQSelectTimeCell.h"

@interface TFEnterModelController ()<UITableViewDelegate,UITableViewDataSource>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** titles */
@property (nonatomic, strong) NSArray *titles;


@end

@implementation TFEnterModelController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"邀请成员加入企业",@"新建协作项目",@"管理企业文件",@"新建我的日程",@"创建工作笔记"];
    [self setupTableView];
    [self setupHeader];
    [self setupFooter];
    self.enablePanGesture = NO;
    self.navigationItem.title = @"完善资料";
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
- (void)setupHeader{
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(140)}];
    
    UILabel *company = [[UILabel alloc] initWithFrame:(CGRect){20,Long(25),SCREEN_WIDTH-40,Long(41)}];
    [header addSubview:company];
    company.textColor = BlackTextColor;
    company.textAlignment = NSTextAlignmentLeft;
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(company.frame)+ Long(25) ,SCREEN_WIDTH,Long(20)}];
    [header addSubview:welcome];
    welcome.textColor = ExtraLightBlackTextColor;
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.font = FONT(20);
        
    company.text = @"基本信息设置完成";
    welcome.text = @"轻松开启工作之旅";
    company.font = FONT(24);
    
    
    self.tableView.tableHeaderView = header;
}

- (void)setupFooter{
    
    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(180)}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,Long(130),SCREEN_WIDTH-50,Long(50)} target:self action:@selector(finished)];
    [footer addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.backgroundColor = GreenColor;
    button.titleLabel.font = FONT(20);
    
    button.frame = (CGRect){25,Long(70),SCREEN_WIDTH-50,Long(50)};
        
    [button setTitle:@"进入工作台" forState:UIControlStateNormal];
    [button setTitle:@"进入工作台" forState:UIControlStateHighlighted];
    
    self.tableView.tableFooterView = footer;
}

- (void)finished{

    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.text = self.titles[indexPath.row];
    cell.time.text = @"";
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
