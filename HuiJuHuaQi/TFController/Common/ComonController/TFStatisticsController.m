//
//  TFStatisticsController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatisticsController.h"
#import "TFStatisticsCell.h"
#import "TFTitleView.h"
#import "TFSearchTableView.h"

@interface TFStatisticsController ()<UITableViewDataSource,UITableViewDelegate,TFSearchTableViewDelegate,TFTitleViewDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** TFTitleView */
@property (nonatomic, weak) TFTitleView *titleView;

/** TFSearchTableView */
@property (nonatomic, strong) TFSearchTableView *searchTableView;


@end

@implementation TFStatisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    [self setupSearchTableView];
}

#pragma - mark 初始化SearchTableView
- (void)setupSearchTableView{
    
    self.searchTableView = [[TFSearchTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight}];
    self.searchTableView.delegate = self;
    
    NSMutableArray<TFBeanTypeModel> *arr = [NSMutableArray<TFBeanTypeModel> array];
    for (NSInteger i = 0; i < 3; i ++) {
        TFBeanTypeModel *model = [[TFBeanTypeModel alloc] init];
        model.name = [NSString stringWithFormat:@"我么的%ld",i];
        [arr addObject:model];
    }
    [self.searchTableView refreshSearchTableViewWithItems:arr];
    
}

#pragma mark - TFSearchTableViewDelegate
-(void)searchTableViewDidSelectModel:(TFBeanTypeModel *)model{
    
    self.titleView.selected = NO;
    
    
}

-(void)searchTableViewDidClickedBackgruod{
    
    self.titleView.selected = NO;
}

- (void)setupNavi{
    
    TFTitleView *titleView = [[TFTitleView alloc] initWithFrame:(CGRect){44,0,SCREEN_WIDTH-2*44,44}];
    self.navigationItem.titleView = titleView;
    self.titleView = titleView;
    [titleView refreshTitleViewWithTitle:@"标题"];
    titleView.delegate = self;
}

-(void)titleViewClickedWithSelect:(BOOL)select{
    
    if (select) {
        
        [self.view insertSubview:self.searchTableView aboveSubview:self.tableView];
        [self.searchTableView showAnimation];
        
    }else{
        
        [self.searchTableView hideAnimationWithCompletion:^(BOOL finish) {
            
            [self.searchTableView removeFromSuperview];
        }];
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFStatisticsCell *cell = [TFStatisticsCell statisticsCellWithTableView:tableView];
    [cell refreshStatisticsCellWithType:indexPath.row];
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 340;
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
