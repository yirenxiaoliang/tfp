//
//  TFManagerSetController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFManagerSetController.h"
#import "TFSelectChatPeopleController.h"

#import "TFManagerCell.h"
#import "TFAddPersonsCell.h"

#import "HQEmployModel.h"
#import "TFManagePersonsModel.h"
#import "TFSelectFirstLevelPeopleController.h"
#import "TFFileBL.h"

@interface TFManagerSetController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFAddPersonsCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) NSMutableArray *peoples;

@property (nonatomic, strong) NSMutableArray *canSelects;

@property (nonatomic, strong) TFManagePersonsModel *personModel;

@end

@implementation TFManagerSetController

- (TFManagePersonsModel *)personModel {
    
    if (!_personModel) {
        
        _personModel = [[TFManagePersonsModel alloc] init];
    }
    return _personModel;
}

- (NSMutableArray *)canSelects {

    if (!_canSelects) {
        
        _canSelects = [NSMutableArray array];
    }
    
    return _canSelects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"子管理员";
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self requestData];
    
    [self setupTableView];
}

- (void)requestData {

    [self.fileBL requestQueryManageByIdWithData:self.parentId];
    
    [self.fileBL requestQueryFolderInitDetailWithData:@(self.style) folderId:self.parentId];
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
    
    return _peoples.count+1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        TFAddPersonsCell *cell = [TFAddPersonsCell AddPersonsCellWithTableView:tableView];
        cell.delegate = self;
        return cell;
    }
    else {
    
        TFManageItemModel *model = _peoples[indexPath.row-1];
        
        TFManagerCell *cell = [TFManagerCell ManagerCellWithTableView:tableView];
        
        cell.authlab.hidden = YES;
        cell.topLine.hidden = NO;
        [cell refreshManagerCellWithTableView:model];
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) {
        
        // 只能选一级目录的成员
        TFSelectFirstLevelPeopleController *people = [[TFSelectFirstLevelPeopleController alloc] init];
        people.style = self.style;
        people.lastfolderId = self.parentId;
        people.actionParameter = ^(id parameter) {
            
            NSString *manage = @"";
            
            for (HQEmployModel *model in parameter) {
                
                BOOL have = NO;
                for (TFManageItemModel *itemModel in _peoples) {
                    
                    if ([model.id isEqualToNumber:itemModel.employee_id]) {
                        
                        have = YES;
                        break;
                    }
                }
                if (!have) {
                    
                    manage = [manage stringByAppendingFormat:@",%@", model.id];
                }
                
            }
            
            if (![manage isEqualToString:@""]) {
                
                manage = [manage substringFromIndex:1];
                
                [self.fileBL requestSavaManageStaffWithData:self.parentId manage:manage fileLevel:@(self.fileSeries)];
            }
            
        };
        
        [self.navigationController pushViewController:people animated:YES];
        
        return;
        
//        TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
//        
//        selectPeople.selectType = 1;
//        selectPeople.isSingleSelect = NO;
//        selectPeople.defaultPoeples = self.managers;
        
        TFSelectChatPeopleController *selectPeople = [[TFSelectChatPeopleController alloc] init];
        
        selectPeople.type = 1;
//        selectPeople.dataPeoples = 
        
        selectPeople.actionParameter = ^(id parameter) {
            
            NSString *manage = @"";
            
            for (HQEmployModel *model in parameter) {
                
                BOOL have = NO;
                for (TFManageItemModel *itemModel in _peoples) {
                    
                    if ([model.id isEqualToNumber:itemModel.employee_id]) {
                        
                        have = YES;
                        break;
                    }
                }
                if (!have) {
                    
                    manage = [manage stringByAppendingFormat:@",%@", model.id];
                }
                
            }
            
            if (![manage isEqualToString:@""]) {
                
                manage = [manage substringFromIndex:1];
                
                [self.fileBL requestSavaManageStaffWithData:self.parentId manage:manage fileLevel:@(self.fileSeries)];
            }
            
        };
        
        [self.navigationController pushViewController:selectPeople animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 35;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 35) title:[NSString stringWithFormat:@"   子管理员（%ld）",_peoples.count] titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:tableView.backgroundColor];
    lab.textAlignment = NSTextAlignmentLeft;
    
    return lab;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark --

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        
        return @"";
    }
    else {
    
        return @"删除";
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        
        return UITableViewCellEditingStyleNone;
    }
    else {
    
        TFManageItemModel *model = _peoples[indexPath.row-1];
        if ([model.sign_type isEqualToString:@"1"] || [[UM.userLoginInfo.employee.id description] isEqualToString:[model.employee_id description]]) {
            
            return UITableViewCellEditingStyleNone;
        }
        else {
        
            return UITableViewCellEditingStyleDelete;
        }
       
    }
    

}
//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLog(@"Action - tableView");
    
    TFManageItemModel *model = _peoples[indexPath.row-1];
    
    [self.fileBL requestDelManageStaffWithData:self.parentId managerId:model.employee_id fileLevel:@(self.fileSeries)];
    
    
}

#pragma mark TFAddPersonsCellDelegate
- (void)addManagers:(NSInteger)tag {


    // 只能选一级目录的成员
    TFSelectFirstLevelPeopleController *people = [[TFSelectFirstLevelPeopleController alloc] init];
    people.style = self.style;
    people.lastfolderId = self.parentId;
    people.actionParameter = ^(id parameter) {
        
        NSString *manage = @"";
        
        for (HQEmployModel *model in parameter) {
            
            BOOL have = NO;
            for (TFManageItemModel *itemModel in _peoples) {
                
                if ([model.id isEqualToNumber:itemModel.employee_id]) {
                    
                    have = YES;
                    break;
                }
            }
            if (!have) {
                
                manage = [manage stringByAppendingFormat:@",%@", model.id];
            }
            
        }
        
        if (![manage isEqualToString:@""]) {
            
            manage = [manage substringFromIndex:1];
            
            [self.fileBL requestSavaManageStaffWithData:self.parentId manage:manage fileLevel:@(self.fileSeries)];
        }
        
    };
    
    [self.navigationController pushViewController:people animated:YES];
    
    return;
    
    TFSelectChatPeopleController *selectPeople = [[TFSelectChatPeopleController alloc] init];
    
    selectPeople.type = 1;
    //        selectPeople.dataPeoples =
    
    selectPeople.actionParameter = ^(id parameter) {
        
        NSString *manage = @"";
        
        for (HQEmployModel *model in parameter) {
            
            BOOL have = NO;
            for (TFManageItemModel *itemModel in _peoples) {
                
                if ([model.id isEqualToNumber:itemModel.employee_id]) {
                    
                    have = YES;
                    break;
                }
            }
            if (!have) {
                
                manage = [manage stringByAppendingFormat:@",%@", model.id];
            }
            
        }
        
        if (![manage isEqualToString:@""]) {
            
            manage = [manage substringFromIndex:1];
            
            [self.fileBL requestSavaManageStaffWithData:self.parentId manage:manage fileLevel:@(self.fileSeries)];
        }
        
    };
    
    [self.navigationController pushViewController:selectPeople animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryManageById) {
        
        _peoples = resp.body;
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_savaManageStaff) {
        
        [self requestData];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_delManageStaff) {
        
        [self requestData];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_queryFolderInitDetail) {
        
        self.personModel = resp.body;
        
        for (HQEmployModel *model in self.personModel.manage) {
            
            [self.canSelects addObject:model];
        }
        
        for (HQEmployModel *model2 in self.personModel.setting) {
            
            [self.canSelects addObject:model2];
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
