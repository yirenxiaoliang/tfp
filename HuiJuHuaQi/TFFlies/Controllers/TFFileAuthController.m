//
//  TFFileAuthController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFileAuthController.h"
#import "TFAuthAssignController.h"

#import "HQSelectTimeCell.h"
#import "HQTFTwoLineCell.h"
#import "TFAddPersonsCell.h"
#import "TFManagerCell.h"
#import "TFMutilStyleSelectPeopleController.h"

#import "TFManagePersonsModel.h"

#import "TFFileBL.h"

@interface TFFileAuthController ()<UITableViewDelegate,UITableViewDataSource,TFAddPersonsCellDelegate,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) TFManagePersonsModel *mainModel;

@end

@implementation TFFileAuthController

- (TFManagePersonsModel *)mainModel {

    if (!_mainModel) {
        
        _mainModel = [[TFManagePersonsModel alloc] init];
    }
    return _mainModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.naviTitle;
    
    [self setupTableView];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self requestData];
}

- (void)requestData {

    [self.fileBL requestQueryFolderInitDetailWithData:@(self.style) folderId:self.folderId];
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
    
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    else if (section == 1) {
    
        return _mainModel.manage.count+1;
    }
    else {
    
        return _mainModel.setting.count+1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"文件夹类型";
        cell.requireLabel.hidden = NO;
        cell.arrow.hidden = YES;
        
        if ([_mainModel.basics.type isEqualToString:@"0"]) {
            
            cell.time.text = @"公开（企业所有成员可见此文件夹）";
        }
        else {
        
            cell.time.text = @"私有（只有加入成员可见此文件夹）";
        }
        cell.time.numberOfLines = 0;
        cell.arrowWidth = 0;
        
        cell.topLine.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1) {
            
            if (indexPath.row == 0) {
                
                TFAddPersonsCell *cell = [TFAddPersonsCell AddPersonsCellWithTableView:tableView];
                
                cell.tag = 1001;
                cell.delegate = self;
                
                return cell;
            }
            else {
            
                TFManageItemModel *manageModel = _mainModel.manage[indexPath.row-1];
                
                TFManagerCell *cell = [TFManagerCell ManagerCellWithTableView:tableView];
                
                cell.authlab.hidden = YES;
                cell.logoImg.hidden = NO;
                cell.logoImg.image = IMG(@"文件夹管理员");
                
                cell.topLine.hidden = NO;
                [cell refreshManagerCellWithTableView:manageModel];
                
                return cell;
            }
            
            
    }
    else {
    
        if (indexPath.row == 0) {
            
            TFAddPersonsCell *cell = [TFAddPersonsCell AddPersonsCellWithTableView:tableView];
            
            cell.tag = 1002;
            cell.delegate = self;
            
            return cell;
        }
        else {
        
            TFSettingItemModel *settingModel = _mainModel.setting[indexPath.row-1];
            
            TFManagerCell *cell = [TFManagerCell ManagerCellWithTableView:tableView];
            
            cell.authlab.hidden = NO;
            cell.logoImg.hidden = YES;
            
            if ([settingModel.upload isEqualToString:@"1"]) {
                
                cell.authlab.text = @"、上传";
            }
            
            if ([settingModel.download isEqualToString:@"1"]) {
                
                cell.authlab.text = [cell.authlab.text stringByAppendingString:@"、下载"];
            }
            
            if ([settingModel.preview isEqualToString:@"1"]) {
                
                cell.authlab.text = [cell.authlab.text stringByAppendingString:@"、预览"];
            }
            
            cell.authlab.text = [cell.authlab.text substringFromIndex:1];
            cell.topLine.hidden = NO;
            [cell refreshSettingCellWithTableView:settingModel];
            
            return cell;
        }
        

    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    
    if (indexPath.section == 2) {
        
        if (indexPath.row>0) {
            
            TFSettingItemModel *settingModel = _mainModel.setting[indexPath.row-1];
            
            TFAuthAssignController *authAssign = [[TFAuthAssignController alloc] init];
            
            authAssign.id = settingModel.id;
            authAssign.upload = [settingModel.upload integerValue];
            authAssign.download = [settingModel.download integerValue];
            authAssign.folderId = self.folderId;
            authAssign.refreshAction = ^{
              
                
                [self requestData];
            };
            
            [self.navigationController pushViewController:authAssign animated:YES];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 64;
    }
    
    if ([_mainModel.basics.type isEqualToString:@"0"]) { //公开
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            return 0;
        }
    }
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0;
    }
    
//    if ([_mainModel.basics.type isEqualToString:@"0"]) { //公开
//        
//        if (section == 2) {
//            
//            return 0;
//        }
//    }
    
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *title = @"";
    if (section == 1) {
        
       title = [NSString stringWithFormat:@"   管理员（%ld）",_mainModel.manage.count];
    }
    else if (section == 2) {
    
        title = [NSString stringWithFormat:@"   成员（%ld）",_mainModel.setting.count];
    }
    
    UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 35) title:title titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:self.view.backgroundColor];
    lab.textAlignment = NSTextAlignmentLeft;
    
    return lab;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark ---

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_mainModel.basics.type isEqualToString:@"0"]) { //公开文件夹成员不可删除
        
        if (indexPath.section == 2) {
            
            return NO;
        }
        
    }
    
    if (indexPath.section == 1) {
        
        if (_mainModel.manage.count > 0 && indexPath.row>0) {
            
            TFManageItemModel *model = _mainModel.manage[indexPath.row-1];
            
            
            if ([model.employee_id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                
                return NO;
            }
        }
        
    }
    

    
    return YES;
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 1 && indexPath.row != 0) || (indexPath.section == 2 && indexPath.row != 0)) {
        
        return @"删除";
    }
    else {
        
        return @"";;
    }
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ((indexPath.section == 1 && indexPath.row != 0) || (indexPath.section == 2 && indexPath.row != 0)) {
        
        return UITableViewCellEditingStyleDelete;
    }
    else {
        
        return UITableViewCellEditingStyleNone;
    }
    
    
}
//先设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLog(@"Action - tableView");
    
    if (indexPath.section == 1) {
        
        TFManageItemModel *model = _mainModel.manage[indexPath.row-1];
        
        [self.fileBL requestDelManageStaffWithData:self.folderId managerId:model.employee_id fileLevel:@(self.fileSeries)];
    }
    else if (indexPath.section == 2) {
    
        TFSettingItemModel *model = _mainModel.setting[indexPath.row-1];
        
        [self.fileBL requestDelMemberWithData:self.folderId memberId:model.employee_id];
    }
    
    
}


#pragma mark TFAddPersonsCellDelegate
- (void)addManagers:(NSInteger)tag {

    
    TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
    
    selectPeople.selectType = 1;
    selectPeople.isSingleSelect = NO;
    
    selectPeople.actionParameter = ^(id parameter) {
      
        NSMutableArray *peoples = [NSMutableArray array];
        
        if (tag == 1001) {
            
            for (HQEmployModel *model in parameter) { //过滤已经选过的人
                
                BOOL have = NO;
                for (TFManageItemModel *itemModel in _mainModel.manage) {
                    
                    if ([model.id isEqualToNumber:itemModel.employee_id]) {
                        
                        have = YES;
                        break;
                    }
                }
                
                if (!have) {
                    
                    [peoples addObject:model];
                }
            }

        }
        else if (tag == 1002) {
        
            for (HQEmployModel *model in parameter) { //过滤已经选过的人
                
                NSArray *arr = [_mainModel.setting arrayByAddingObjectsFromArray:_mainModel.manage];
                
                BOOL have = NO;
                for (TFManageItemModel *itemModel in arr) {
                    
                    if ([model.id isEqualToNumber:itemModel.employee_id]) {
                        
                        have = YES;
                        break;
                    }
                }
                
                if (!have) {
                    
                    [peoples addObject:model];
                }
            }

        }
        
        
        if (peoples.count > 0) {
            
            NSString *manage = @"";
            for (HQEmployModel *model in peoples) {
                
                manage = [manage stringByAppendingFormat:@",%@", model.id];
            }
            
            manage = [manage substringFromIndex:1];
            
            if (tag == 1001) {
                
                [self.fileBL requestSavaManageStaffWithData:self.folderId manage:manage fileLevel:@(self.fileSeries)];
            }
            else {
                
                [self.fileBL requestSavaMemberWithData:self.folderId memberId:manage];
            }

        }
        
    };
    
    [self.navigationController pushViewController:selectPeople animated:YES];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryFolderInitDetail) {
        
        _mainModel = resp.body;
        
        [self.view addSubview:self.tableView];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_savaManageStaff || resp.cmdId == HQCMD_savaMember || resp.cmdId == HQCMD_delManageStaff || resp.cmdId == HQCMD_delMember) {
        
        [self requestData];
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
