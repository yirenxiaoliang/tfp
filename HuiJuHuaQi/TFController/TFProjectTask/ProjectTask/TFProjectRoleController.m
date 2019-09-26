//
//  TFProjectRoleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectRoleController.h"
#import "HQBaseCell.h"
#import "TFProjectTaskBL.h"

@interface TFSelectMarkModel : NSObject

/** select */
@property (nonatomic, assign) NSInteger select;
/** name */
@property (nonatomic, copy) NSString *name;
/** roleId */
@property (nonatomic, strong) NSNumber *roleId;



@end

@implementation TFSelectMarkModel

@end


@interface TFProjectRoleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** roles */
@property (nonatomic, strong) NSMutableArray *roles;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;
/** selectModel */
@property (nonatomic, strong) TFSelectMarkModel *selectModel;

@end

@implementation TFProjectRoleController

-(NSMutableArray *)roles{
    if (!_roles) {
        _roles = [NSMutableArray array];
    }
    return _roles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requsetGetProjectRoleListWithProjectId:self.projectId pageNum:@1 pageSize:@100];
    
    
    [self setupTableView];
    self.navigationItem.title = @"项目角色";
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_getProjectRoleList) {
        
        for (NSDictionary *di in resp.body) {
            TFSelectMarkModel *model = [[TFSelectMarkModel alloc] init];
            model.name = [di valueForKey:@"name"];
            model.roleId = [di valueForKey:@"id"];
            [self.roles addObject:model];
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_updateProjectRole) {
        
        if (self.actionParameter) {
        self.actionParameter(@{@"roleId":self.selectModel.roleId,@"roleName":self.selectModel.name});
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
    return self.roles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    TFSelectMarkModel *model = self.roles[indexPath.row];
    if (model.select == 1) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"选中"]];
    }else{
        cell.accessoryView = nil;
    }
    cell.textLabel.text = model.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    for (TFSelectMarkModel *model in self.roles) {
        
        model.select = 0;
    }
    
    TFSelectMarkModel *model = self.roles[indexPath.row];
    model.select = 1;
    self.selectModel = model;
    [tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.projectTaskBL requsetUpdateProjectRoleWtihRecordId:self.recordId projectRole:model.roleId projectTaskRole:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
