//
//  TFDepartmentManageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFDepartmentManageController.h"
#import "TFPositionManageCell.h"
#import "TFCreateDepartmentController.h"
#import "HQDepartmentModel.h"
#import "AlertView.h"
#import "HQTFProjectDescController.h"
#import "TFDepartmentManageController.h"
#import "TFPeopleBL.h"

@interface TFDepartmentManageController ()<UITableViewDataSource,UITableViewDelegate,TFPositionManageCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** departments */
@property (nonatomic, strong) NSMutableArray *departments;

/** HQDepartmentModel  */
@property (nonatomic, strong) HQDepartmentModel *selectModel;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

@end

@implementation TFDepartmentManageController

-(NSMutableArray *)departments{
    if (!_departments) {
        _departments = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 10; i++) {
//            HQDepartmentModel *model = [[HQDepartmentModel alloc] init];
//            model.departmentName = [NSString stringWithFormat:@"部门%ld",i];
//            model.isSelect = @0;
//            [_departments addObject:model];
//        }
        
    }
    return _departments;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.peopleBL requestDepartmentListWithParentDepartmentId:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
//    [self.peopleBL requestGetDepartmentWithPageNo:1 pageSize:100];
}

- (void)setupNavi{
    if (self.type == 0) {
        self.navigationItem.title = @"选择部门";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }else{
        self.navigationItem.title = @"部门管理";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(positionCreate) image:@"加号" highlightImage:@"加号"];
    }
    
}
- (void)sure{
    
    if (self.actionParameter) {
        
        NSMutableArray *selects = [NSMutableArray array];
        for (HQDepartmentModel *depart in self.departments) {
            
            if ([depart.isSelect isEqualToNumber:@1]) {
                [selects addObject:depart];
            }
        }
        
        if (selects.count == 0) {
            [MBProgressHUD showError:@"请选择部门" toView:self.view];
            return;
        }
        
        self.actionParameter(selects);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)positionCreate{
    TFCreateDepartmentController *creat = [[TFCreateDepartmentController alloc] init];
    [self.navigationController pushViewController:creat animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.departments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFPositionManageCell *cell = [TFPositionManageCell positionManageCellWithTableView:tableView withType:self.type];
    HQDepartmentModel *model = self.departments[indexPath.row];
    [cell refreshPositionManageCellWithDepartmentModel:model];
    cell.delegate = self;
    if (self.type == 0) {
        
        cell.select = ([model.isSelect isEqualToNumber:@0] || model.isSelect == nil)?NO:YES;
    }
    
    if (self.departments.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {
        
        if (self.isMutiSelect) {
            
            HQDepartmentModel *model = self.departments[indexPath.row];
            model.isSelect = ([model.isSelect isEqualToNumber:@0] || model.isSelect == nil)?@1:@0;
        }else{
            
            self.selectModel.isSelect = @0;
            
            HQDepartmentModel *model = self.departments[indexPath.row];
            model.isSelect = ([model.isSelect isEqualToNumber:@0] || model.isSelect == nil)?@1:@0;
            
            self.selectModel = model;
        }
        
        [tableView reloadData];
    }
    
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
#pragma mark - TFPositionManageCellDelegate
-(void)positionManageCellDidEditBtnWithDepartmentModel:(HQDepartmentModel *)model{
    
    
    HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
    desc.type = 4;
    desc.descString = model.departmentName;
    desc.descAction = ^(NSString *desc){
        
        if (desc.length <= 0) {
            [MBProgressHUD showError:@"部门名字不能为空" toView:self.view];
            return ;
        }
        
//        [self.peopleBL requestAddOrUpdateDepartmentWithDepartmentName:desc departmentId:model.id parentDepartmentId:model.parentDepartmentId];
        
        model.departmentName = desc;
        
    };
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)positionManageCellDidDeleteBtnWithDepartmentModel:(HQDepartmentModel *)model{
    [AlertView showAlertView:@"删除部门" msg:@"你确定要删除此部门吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
        
    } onRightTouched:^{
        
//        [self.peopleBL requestDepartmnetDeleteWithDepartmentId:model.id];
        [self.departments removeObject:model];
    }];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
