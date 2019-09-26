//
//  TFPersonnelTaskRelationController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPersonnelTaskRelationController.h"
#import "HQSelectTimeCell.h"
#import "TFApprovalSearchView.h"
#import "TFProjectTaskBL.h"
#import "TFSelectCustomListController.h"
#import "TFProjectSelectRowController.h"
#import "TFCustomListItemModel.h"

@interface TFPersonnelTaskRelationController ()<UITableViewDelegate,UITableViewDataSource,TFApprovalSearchViewDelegate,UITextFieldDelegate,HQBLDelegate>

/** models */
@property (nonatomic, strong) NSMutableArray *models;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFApprovalSearchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFPersonnelTaskRelationController

-(NSMutableArray *)models{
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetMyselfCustomModule];
    self.navigationItem.title = @"选择模块";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.models = resp.body;
    
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}




-(TFApprovalSearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [TFApprovalSearchView approvalSearchView];
        _searchView.frame = (CGRect){0,0,SCREEN_WIDTH,46};
        _searchView.type = 1;
        _searchView.textFiled.returnKeyType = UIReturnKeySearch;
        _searchView.textFiled.delegate = self;
        _searchView.textFiled.placeholder = @"请输入关键字搜索";
        _searchView.delegate = self;
        _searchView.textFiled.backgroundColor = CellSeparatorColor;
        _searchView.searchBtn.hidden = YES;
        _searchView.backgroundColor = WhiteColor;
    }
    return _searchView;
}
#pragma mark - TFApprovalSearchViewDelegate
-(void)approvalSearchViewDidClickedStatusBtn{
    
    
}

-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    return YES;
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
    tableView.tableHeaderView = self.searchView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.timeTitle.text = @"项目";
        cell.arrowShowState = YES;
        cell.topLine.hidden = YES;
        return cell;
    }else{
        
        NSDictionary *dict = self.models[indexPath.row];
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.titltW.constant = SCREEN_WIDTH-60;
        cell.timeTitle.text = [dict valueForKey:@"name"];
        cell.arrowShowState = YES;
        cell.topLine.hidden = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        TFProjectSelectRowController *row = [[TFProjectSelectRowController alloc] init];
        row.type = 0;
        row.parameterAction = ^(NSMutableDictionary *parameter) {
            
            if (self.parameterAction) {
                
                [parameter setObject:@"project_custom" forKey:@"beanName"];
                [parameter setObject:@0 forKey:@"type"];
                [self.navigationController popViewControllerAnimated:YES];
                self.parameterAction(parameter);
            }
            
        };
        
        [self.navigationController pushViewController:row animated:YES];
    }else{
        
        NSDictionary *dict = self.models[indexPath.row];
        TFModuleModel *model = [[TFModuleModel alloc] init];
        model.english_name = [dict valueForKey:@"bean"];
        TFSelectCustomListController *custom = [[TFSelectCustomListController alloc] init];
        custom.module = model;
        custom.isSingle = YES;
        custom.parameterAction = ^(NSArray *parameter) {
            
            if (parameter.count) {
                TFCustomListItemModel *item = parameter[0];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:item.id.value forKey:@"dataId"];
                if (item.row.row1.count) {
                    TFFieldNameModel *name = item.row.row1[0];
                    [dict setObject:name.label forKey:@"dataName"];
                }
                [dict setObject:model.english_name forKey:@"beanName"];
                if (self.parameterAction) {
                    
                    [dict setObject:@1 forKey:@"type"];
                    [self.navigationController popViewControllerAnimated:YES];
                    self.parameterAction(dict);
                }
            }
            
        };
        
        [self.navigationController pushViewController:custom animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
