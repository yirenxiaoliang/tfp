//
//  TFTransferTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/9/18.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTransferTaskController.h"
#import "HQSelectTimeCell.h"
#import "TFProjectMenberManageController.h"
#import "TFProjectTaskBL.h"


#define Word @"该项目成员下还存在需要执行的任务，请在下方选择任务交接人，交接后可移除成功"

@interface TFTransferTaskController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** 交接人 */
@property (nonatomic, strong) TFProjectPeopleModel *selectPeople;

@end

@implementation TFTransferTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self setupTableView];
    [self setupNavi];
}

#pragma mark - setNavi
- (void)setupNavi{
    
    self.navigationItem.title = @"交接任务";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (!self.selectPeople) {
        [MBProgressHUD showError:@"请选择交接人" toView:self.view];
        return;
    }
    // 交接
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.projectTaskBL requsetDeleteProjectPeopleWithRecordId:self.deletePeople.project_member_id recipient:self.selectPeople.id];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_deleteProjectPeople) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"交接成功" toView:KeyWindow];
        if (self.deleteAction) {
            self.deleteAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.text = @"交接人";
    cell.timeTitle.textColor = BlackTextColor;
    
    if (self.selectPeople) {
        cell.time.textColor = ExtraLightBlackTextColor;
        cell.time.text = self.selectPeople.employee_name;
    }else{
        cell.time.text = @"请选择";
        cell.time.textColor = LightGrayTextColor;
    }
    cell.arrowShowState = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
    member.type = 1;
    member.projectId = self.projectId;
    member.isTransfer = YES;
    member.selectPeoples = @[self.deletePeople];
    member.parameterAction = ^(NSArray *parameter) {
      
        if (parameter.count) {
            self.selectPeople = parameter[0];
            [self.tableView reloadData];
        }
        
    };
    [self.navigationController pushViewController:member animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:Word];
    return size.height+30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,15,SCREEN_WIDTH-30,0}];
    label.text = Word;
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:Word];
    label.height = size.height;
    label.textColor = HexColor(0x666666);
    label.numberOfLines = 0;
    label.font = FONT(14);
    [view addSubview:label];
    
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
