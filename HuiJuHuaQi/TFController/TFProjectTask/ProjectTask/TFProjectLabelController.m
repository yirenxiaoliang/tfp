//
//  TFProjectLabelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectLabelController.h"
#import "TFProjectTaskBL.h"
#import "TFProjectLabelCell.h"
#import "HQTFSearchHeader.h"
#import "TFProjectLabelModel.h"

@interface TFProjectLabelController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate,TFProjectLabelCellDelegate,UIAlertViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** labels */
@property (nonatomic, strong) NSMutableArray *labels;

/** selectModel */
@property (nonatomic, strong) TFProjectLabelModel *selectModel;

/** allLabels */
@property (nonatomic, strong) NSMutableArray *allLabels;

/** privilege */
@property (nonatomic, copy) NSString *privilege;

/** keyword */
@property (nonatomic, copy) NSString *keyword;


@property (nonatomic, strong) NSMutableArray *saveSelects;

@end

@implementation TFProjectLabelController
-(NSMutableArray *)saveSelects{
    if (!_saveSelects) {
        _saveSelects = [NSMutableArray array];
    }
    return _saveSelects;
}

-(NSMutableArray *)labels{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

-(NSMutableArray *)allLabels{
    if (!_allLabels) {
        _allLabels = [NSMutableArray array];
    }
    return _allLabels;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.saveSelects addObjectsFromArray:self.selectLabels];
    
    [self setupTableView];
    
    if (self.type == 0) {
        
        [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];
        [self.projectTaskBL requsetGetProjectLabelWithProjectId:self.projectId keyword:@"" type:self.type];
        self.navigationItem.title = @"项目标签";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addLabel) image:@"加号" highlightImage:@"加号"];
    }else if (self.type == 1) {
        
        [self.projectTaskBL requsetGetLabelRepositoryWithProjectId:self.projectId keyword:@"" type:self.type];
        self.navigationItem.title = @"添加标签";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(addSure) text:@"确定" textColor:GreenColor];
        
    }else{
        
        
    }
}

- (void)addSure{
    
//    NSMutableArray *models = [NSMutableArray array];
//    NSString *str = @"";
//    for (TFProjectLabelModel *model in self.labels) {
//
//        for (TFProjectLabelModel *label in model.childList) {
//
//            if ([label.select isEqualToNumber:@1]) {
//                [models addObject:label];
//                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[label.id description]]];
//            }
//        }
//    }
    
    if (self.saveSelects.count == 0) {
        [MBProgressHUD showError:@"请选择标签" toView:self.view];
        return;
    }
    
    NSString *str = @"";
    for (TFProjectLabelModel *label in self.saveSelects) {
//        if ([label.select isEqualToNumber:@1]) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[label.id description]]];
//        }
    }
    if (str.length) {
        str = [str substringToIndex:str.length - 1];
    }
    [self.projectTaskBL requsetAddProjectLabelWithProjectId:self.projectId ids:str];
    
}

- (void)addLabel{

    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    TFProjectLabelController *add = [[TFProjectLabelController alloc] init];
    add.type = 1;
    add.projectId = self.projectId;
    add.selectLabels = self.allLabels;
    add.refreshAction = ^{
        [self.projectTaskBL requsetGetProjectLabelWithProjectId:self.projectId keyword:@"" type:self.type];
    };
    [self.navigationController pushViewController:add animated:YES];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"32"]) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        [self.tableView reloadData];
    }
    
    
    if (resp.cmdId == HQCMD_getProjectLabel) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.selectModel) {
            
            [MBProgressHUD showImageSuccess:@"删除成功" toView:KeyWindow];
            self.selectModel = nil;
            
        }
            
        self.labels = resp.body;
        [self.allLabels removeAllObjects];
        for (TFProjectLabelModel *label in self.labels) {
            for (TFProjectLabelModel *la in label.childList) {
                [self.allLabels addObject:la];
            }
        }
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_repositoryLabel) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.labels = resp.body;
        
        for (TFProjectLabelModel *lal in self.saveSelects) {
            for (TFProjectLabelModel *label in self.labels) {
                for (TFProjectLabelModel *la in label.childList) {
                    if ([lal.id isEqualToNumber:la.id]) {
                        la.select = @1;
                    }
                }
            }
        }
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_addProjectLabel) {
        
        if (self.selectModel) {
    
            [self.projectTaskBL requsetGetProjectLabelWithProjectId:self.projectId keyword:@"" type:self.type];
            
        }else{
            
            if (self.refreshAction) {
                self.refreshAction();
            }
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showImageSuccess:@"添加成功" toView:KeyWindow];
        }
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    tableView.tableHeaderView = view;
    headerSearch.backgroundColor = WhiteColor;
    headerSearch.textField.backgroundColor = BackGroudColor;
    headerSearch.image.backgroundColor = BackGroudColor;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.labels.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    TFProjectLabelModel *model = self.labels[section];
    return model.childList.count;
        
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectLabelCell *cell = [TFProjectLabelCell projectLabelCellWithTableView:tableView];
    cell.type = self.type;
    cell.delegate = self;
    cell.deleteBtn.tag = indexPath.section * 0x111 + indexPath.row;
    cell.selectBtn.tag = indexPath.section * 0x111 + indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TFProjectLabelModel *parent = self.labels[indexPath.section];
    TFProjectLabelModel *model = parent.childList[indexPath.row];
    [cell refreshProjectLabelWithModel:model];
    
    if ([HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"33"]) {
        cell.deleteBtn.hidden = NO;
    }else{
        cell.deleteBtn.hidden = YES;
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TFProjectLabelModel *parent = self.labels[section];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BackGroudColor;
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,40}];
    label.text = parent.name;
    label.textColor = LightGrayTextColor;
    label.font = FONT(14);
    [view addSubview:label];
    return view;
        
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - HQTFSearchHeaderDelegate
-(void)searchHeaderTextChange:(UITextField *)textField{
    
    self.keyword = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {
        [self.projectTaskBL requsetGetProjectLabelWithProjectId:self.projectId keyword:textField.text type:self.type];
    }else{
        [self.projectTaskBL requsetGetLabelRepositoryWithProjectId:self.projectId keyword:textField.text type:self.type];
    }
    return YES;
}


#pragma mark - TFProjectLabelCellDelegate
-(void)projectLabelCellDidClickedDeleteBtn:(UIButton *)button{
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    NSInteger section = button.tag / 0x111;
    NSInteger row = button.tag % 0x111;
    
    TFProjectLabelModel *parent = self.labels[section];
    TFProjectLabelModel *model = parent.childList[row];
    
    self.selectModel = model;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要移除此标签吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.delegate = self;
    [alert show];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        NSMutableArray *models = [NSMutableArray array];
        NSString *str = @"";
        for (TFProjectLabelModel *model in self.labels) {
            
            for (TFProjectLabelModel *label in model.childList) {
                
                if (![self.selectModel.id isEqualToNumber:label.id]) {
                    [models addObject:label];
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[label.id description]]];
                }
            }
        }
        
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requsetAddProjectLabelWithProjectId:self.projectId ids:str];
    }
}


-(void)projectLabelCellDidClickedSelectBtn:(UIButton *)button{
    
    NSInteger section = button.tag / 0x111;
    NSInteger row = button.tag % 0x111;
    
    TFProjectLabelModel *parent = self.labels[section];
    TFProjectLabelModel *model = parent.childList[row];
    
    if (button.selected) {
        model.select = @1;
        [self.saveSelects addObject:model];
    }else{
        model.select = @0;
        for (TFProjectLabelModel *la in self.saveSelects) {
            if ([la.id isEqualToNumber:model.id]) {
                [self.saveSelects removeObject:la];
                break;
            }
        }
    }
    [self.tableView reloadData];
    
    
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
