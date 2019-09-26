//
//  HQTFAddPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFAddPeopleController.h"
#import "HQTFTwoLineCell.h"
#import "HQAddContactsCtrl.h"
#import "HQTFDepartPeopleController.h"
#import "HQTFChoicePeopleController.h"
#import "TFCompanyGroupController.h"
#import "HQTFProjectPeopleManageController.h"

@interface HQTFAddPeopleController ()<UITableViewDataSource,UITableViewDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation HQTFAddPeopleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
}
- (void)setupNavigation{
    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"添加成员";
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    UIButton *header = [HQHelper buttonWithFrame:(CGRect){0,0,SCREEN_WIDTH,85} normalImageStr:@"手机" highImageStr:@"手机" target:self action:@selector(headerClick)];
    header.backgroundColor = WhiteColor;
    [header setTitle:@"    添加手机联系人" forState:UIControlStateNormal];
    [header setTitle:@"    添加手机联系人" forState:UIControlStateHighlighted];
    [header setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [header setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
    tableView.tableHeaderView = header;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)headerClick{
    HQAddContactsCtrl *tele = [[HQAddContactsCtrl alloc] init];
    [self.navigationController pushViewController:tele animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (self.type == ChoicePeopleTypeCreateProjectPrincipal) {
            return 1;
        }else{
            return 2;
        }
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    if (indexPath.section == 0) {
        
        if (self.type == ChoicePeopleTypeCreateProjectPrincipal) {
            if (indexPath.row == 0) {
                [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateNormal];
                [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateHighlighted];
                cell.topLabel.text = @"部门成员";
                cell.bottomLabel.text = @"从公司部门中添加成员";
                cell.bottomLine.hidden = NO;
            }else{
                
                [cell.titleImage setImage:[UIImage imageNamed:@"客户"] forState:UIControlStateNormal];
                [cell.titleImage setImage:[UIImage imageNamed:@"客户"] forState:UIControlStateHighlighted];
                cell.topLabel.text = @"客户成员";
                cell.bottomLabel.text = @"从客户管理中添加成员";
                cell.bottomLine.hidden = YES;
            }
        }else{
            if (indexPath.row == 0) {
                [cell.titleImage setImage:[UIImage imageNamed:@"项目contact"] forState:UIControlStateNormal];
                [cell.titleImage setImage:[UIImage imageNamed:@"项目contact"] forState:UIControlStateHighlighted];
                cell.topLabel.text = @"项目成员";
                cell.bottomLabel.text = @"从项目中添加成员";
                cell.bottomLine.hidden = NO;
            }else if (indexPath.row == 1) {
                [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateNormal];
                [cell.titleImage setImage:[UIImage imageNamed:@"部门"] forState:UIControlStateHighlighted];
                cell.topLabel.text = @"部门成员";
                cell.bottomLabel.text = @"从公司部门中添加成员";
                cell.bottomLine.hidden = NO;
            }else{
                
                [cell.titleImage setImage:[UIImage imageNamed:@"客户"] forState:UIControlStateNormal];
                [cell.titleImage setImage:[UIImage imageNamed:@"客户"] forState:UIControlStateHighlighted];
                cell.topLabel.text = @"客户成员";
                cell.bottomLabel.text = @"从客户管理中添加成员";
                cell.bottomLine.hidden = YES;
            }

        }
        
    }else{
        
        if (indexPath.row == 0) {
            [cell.titleImage setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"扫码"] forState:UIControlStateHighlighted];
            cell.topLabel.text = @"扫一扫";
            cell.bottomLabel.text = @"通过二维码扫码加入项目";
            cell.bottomLine.hidden = NO;
        }else{
            
            [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
            cell.topLabel.text = @"微信邀请";
            cell.bottomLabel.text = @"通过微信连接邀请加入项目";
            cell.bottomLine.hidden = YES;
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (self.type == ChoicePeopleTypeCreateProjectPrincipal) {
            
            if (indexPath.row == 0) {
                
                TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
                depart.type = 2;
                depart.employees = self.employees;
                depart.isSingle = !self.isMutual;
                depart.actionParameter = ^(NSArray *peoples){
                    
                    if (self.actionParameter) {
                        self.actionParameter(peoples);
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                    
                };
                
                [self.navigationController pushViewController:depart animated:YES];
            }
//            else{
//                HQTFDepartPeopleController *depart = [[HQTFDepartPeopleController alloc] init];
//                depart.type = ControllerTypeContact;
//                [self.navigationController pushViewController:depart animated:YES];
//            }

        }else{
            
            if (indexPath.row == 0) {
                
                HQTFProjectPeopleManageController *choice = [[HQTFProjectPeopleManageController alloc] init];
                choice.Id = self.Id;
                choice.projectItem = self.projectItem;
                choice.type = 1;
                choice.isMulti = self.isMutual;
                choice.employees = self.employees;
                choice.peopleAction = ^(NSArray *peoples) {
                    
                    if (self.actionParameter) {
                        self.actionParameter(peoples);
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                };
                
                [self.navigationController pushViewController:choice animated:YES];
                
            }else if (indexPath.row == 1) {
                
                TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
                depart.type = 2;
                depart.employees = self.employees;
                depart.isSingle = !self.isMutual;
                depart.actionParameter = ^(NSArray *peoples){
                    
                    
                    if (self.actionParameter) {
                        self.actionParameter(peoples);
                        [self.navigationController popViewControllerAnimated:NO];
                    }
                };
                
                [self.navigationController pushViewController:depart animated:YES];
            }
//            else{
//                HQTFDepartPeopleController *depart = [[HQTFDepartPeopleController alloc] init];
//                depart.type = ControllerTypeContact;
//                [self.navigationController pushViewController:depart animated:YES];
//            }

        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
