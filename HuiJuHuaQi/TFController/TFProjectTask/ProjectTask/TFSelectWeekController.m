//
//  TFSelectWeekController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectWeekController.h"
#import "TFTaskRepeatController.h"
#import "HQSelectTimeCell.h"

@interface TFSelectWeekController ()<UITableViewDelegate,UITableViewDataSource>

/** weeks */
@property (nonatomic, strong) NSMutableArray *weeks;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TFSelectWeekController

-(NSMutableArray *)weeks{
    if (!_weeks) {
        _weeks = [NSMutableArray array];
        NSArray *arr = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
        for (NSInteger i = 0; i < arr.count; i ++) {
            TFDateModel *model = [[TFDateModel alloc] init];
            model.name = arr[i];
            model.tag = i;
            [_weeks addObject:model];
        }
        
        for (TFDateModel *mo1 in self.selects) {
            
            for (TFDateModel *mo2 in _weeks) {
                
                if (mo1.tag == mo2.tag) {
                    
                    mo2.select = @1;
                    break;
                }
                
            }
        }
        
    }
    return _weeks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = @"选择重复日期";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFDateModel *model in self.weeks) {
    
        if ([model.select isEqualToNumber:@1]) {
            
            [arr addObject:model];
        }
    }
    
    if (arr.count == 0) {
        
        [MBProgressHUD showError:@"请选择日期" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        self.parameterAction(arr);
        [self.navigationController popViewControllerAnimated:YES];
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
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.weeks.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.topLine.hidden = YES;
    cell.timeTitle.textColor = BlackTextColor;
    cell.timeTitle.font = FONT(16);
    cell.titltW.constant = SCREEN_WIDTH-30;
    cell.requireLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TFDateModel *model = self.weeks[indexPath.row];
    cell.timeTitle.text = model.name;
    if ([model.select isEqualToNumber:@1]) {
        cell.arrow.image = [UIImage imageNamed:@"完成"];
    }else{
        cell.arrow.image = nil;
    }
    cell.bottomLine.hidden = NO;
    cell.arrow.hidden = NO;
    cell.time.textColor = BlackTextColor;
    cell.time.textAlignment = NSTextAlignmentRight;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    TFDateModel *model = self.weeks[indexPath.row];
    model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    [tableView reloadData];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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
