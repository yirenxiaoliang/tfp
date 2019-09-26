//
//  TFRelatedAprrovalController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFRelatedAprrovalController.h"
#import "TFAddressWayCell.h"
#import "TFAddAprrovalListController.h"
#import "TFAttendanceBL.h"
#import "HQTFNoContentView.h"

@interface TFRelatedAprrovalController ()<UITableViewDelegate,UITableViewDataSource,TFAddressWayCellDelegate,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;


@property (nonatomic, strong) NSMutableArray *datas;


@property (nonatomic, strong) TFReferenceApprovalModel *deleteModel;


@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFRelatedAprrovalController
-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"关联审批单";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addRelated) text:@"添加" textColor:GreenColor];
    
    [self setupTableView];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    [self.attendanceBL requestReferenceApprovalList];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceReferenceApprovalList) {
        
        self.datas = resp.body;
        if (self.datas.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceReferenceApprovalDelete) {
        [MBProgressHUD showImageSuccess:@"删除成功" toView:self.view];
        [self.datas removeObject:self.deleteModel];
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
    cell.topLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    [cell configRelatedApprovalCellWithModel:self.datas[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFAddAprrovalListController *add = [[TFAddAprrovalListController alloc] init];
    add.type = 1;
    add.model = self.datas[indexPath.row];
    add.refreshAction = ^{
        [self.attendanceBL requestReferenceApprovalList];
    };
    [self.navigationController pushViewController:add animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 92;
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

#pragma mark TFAddressWayCellDelegate (删除)
- (void)deleteClicked:(NSInteger)index {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后，该类型审批将不会被考勤所统计，是否删除。" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.deleteModel = self.datas[index];
        [self.attendanceBL requestReferenceApprovalDeleteWithReferenceId:self.deleteModel.id];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}


#pragma mark 添加
- (void)addRelated {
    
    TFAddAprrovalListController *addApprovalVC = [[TFAddAprrovalListController alloc] init];
    addApprovalVC.refreshAction = ^{
        [self.attendanceBL requestReferenceApprovalList];
    };
    
    [self.navigationController pushViewController:addApprovalVC animated:YES];
    
}

@end
