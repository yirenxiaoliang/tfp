//
//  TFHeartPeopleListController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHeartPeopleListController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFNoContentView.h"
#import "TFProjectTaskBL.h"

@interface TFHeartPeopleListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFHeartPeopleListController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"点赞人员";
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.taskType == 0 || self.taskType == 1) {
        
        [self.projectTaskBL requestTaskHeartPeopleWithTaskId:self.taskId typeStatus:@(self.taskType + 1)];
    }else{
        
        [self.projectTaskBL requestPersonnelTaskHeartPeopleWithTaskId:self.taskId fromType:self.taskType == 2?@0:@1];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    self.peoples = resp.body;
    
    if (self.peoples.count) {
        self.tableView.backgroundView = [UIView new];
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
    [self.tableView reloadData];
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
    
    if (self.peoples.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    [cell refreshCellWithEmployeeModel:self.peoples[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
