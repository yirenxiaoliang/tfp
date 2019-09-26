//
//  TFEmailApproverAndCoperController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/3/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailApproverAndCoperController.h"
#import "TFAddPeoplesCell.h"
#import "TFEmialApproverModel.h"
#import "TFContactsSelectPeopleController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFSelectChatPeopleController.h"
#import "TFEmailsMainController.h"

#import "TFCustomBL.h"
#import "TFMailBL.h"

@interface TFEmailApproverAndCoperController ()<UITableViewDelegate,UITableViewDataSource,TFAddPeoplesCellDelegate,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *approver;

//@property (nonatomic, strong) NSMutableArray *coper;

@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) TFEmialApproverModel *approveModel;

@end

@implementation TFEmailApproverAndCoperController

- (NSMutableArray *)approver {

    if (!_approver) {
        
        _approver = [NSMutableArray array];
    }
    return _approver;
}

//- (NSMutableArray *)coper {
//
//    if (!_coper) {
//        
//        _coper = [NSMutableArray array];
//    }
//    return _coper;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    self.mailBL = [TFMailBL build];
    self.mailBL.delegate = self;
    
    [self.customBL requestGetCustomApprovalCheckChooseNextApproval];
}

- (void)setNavi {

    self.navigationItem.title = @"设置审批流程";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(submitAction) text:@"提交" textColor:kUIColorFromRGB(0x4A4A4A)];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    if (indexPath.row == 0) {
    
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        cell.titleLabel.text = @"审批人";
        cell.requireLabel.hidden = NO;
        
        cell.delegate = self;
        
        [cell refreshAddPeoplesCellWithPeoples:self.approver structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
//    }
//    else {
//    
//        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
//        cell.titleLabel.text = @"抄送人";
//        cell.requireLabel.hidden = YES;
//        
//        cell.delegate = self;
//        
//        [cell refreshAddPeoplesCellWithPeoples:self.coper structure:0 chooseType:0 showAdd:YES row:indexPath.row];
//        
//        return cell;
//    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 0) {
//        
//        if ([self.approveModel.processType isEqualToNumber:@0] && self.approveModel.choosePersonnel.count == 0) { //固定审批且没有角色数组
//            
//            return 0;
//        }
//    }
//    else {
//    
//        if ([self.approveModel.ccTo isEqualToNumber:@1]) { //不显示抄送人
//            
//            return 0;
//        }
//    }
    
    return 80;
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

#pragma mark TFAddPeoplesCellDelegate
- (void)addPersonel:(NSInteger)index {
    
//    if (index == 0) {
    
        //邮件进入审批流程
        /*
        if ([self.approveModel.processType isEqualToNumber:@0]) { //固定流程

            if (self.approveModel.choosePersonnel.count != 0) { //从角色中选择一人作为审批人

                TFSelectChatPeopleController *selectPeople = [[TFSelectChatPeopleController alloc] init];
                
                NSMutableArray *peoples = [NSMutableArray array];
                for (TFEmailChoosePersonnelModel *model in self.approveModel.choosePersonnel) {
                    
                    HQEmployModel *empModel = [[HQEmployModel alloc] init];
                    
                    empModel.employee_name = model.employee_name;
                    empModel.id = model.id;
                    empModel.picture = model.picture;
                    [peoples addObject:model];
                }
                
                selectPeople.type = 1;
                selectPeople.dataPeoples = peoples;
                
                selectPeople.actionParameter = ^(id parameter) {
                    
                    
                };
                
                [self.navigationController pushViewController:selectPeople animated:YES];


            }

        }
         */
//        else
            if ([self.approveModel.processType isEqualToNumber:@1]) { //自由流程(从公司组织架构选下一个审批人)

            TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
            
            selectPeople.selectType = 1;
            selectPeople.isSingleSelect = YES;
            
            selectPeople.actionParameter = ^(id parameter) {
              
                HQEmployModel *empModel = parameter[0];
                
                [self.approver addObject:empModel];
                
                [self.tableView reloadData];
            };
            
            [self.navigationController pushViewController:selectPeople animated:YES];
        }

//    }
/*
    else if (index == 1) { //抄送人从全公司选
    
//        TFContactsSelectPeopleController *contacts = [[TFContactsSelectPeopleController alloc] init];
//        
//        [self.navigationController pushViewController:contacts animated:YES];
        
        TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
        
        selectPeople.selectType = 1;
        selectPeople.isSingleSelect = NO;
        
        selectPeople.actionParameter = ^(id parameter) {
          
            for (HQEmployModel *model in parameter) {
                
//                [self.coper addObject:model];
            }
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:selectPeople animated:YES];
        
    }
 */

}

- (void)submitAction {

    for (HQEmployModel *model in self.approver) {
        
        self.model.personnel_approverBy = [NSString stringWithFormat:@"%@",model.id];
    }
    
//    NSString *copyStr = @"";
//    for (HQEmployModel *model in self.coper) {
//        
//        copyStr = [copyStr stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
//    }
    
//    copyStr = [copyStr substringFromIndex:1];
//    self.model.personnel_ccTo = copyStr;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.mailBL sendMailWithData:self.model];//发送
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        
        if ([controller isKindOfClass:[TFEmailsMainController class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
        }
    }

}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_CustomApprovalCheckChooseNextApproval) {
        
        self.approveModel = resp.body;
        
        [self.view addSubview:self.tableView];
        
//        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_mailOperationSend) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的邮件已进入审批环节，请在审批模块查看。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate = self;
        [alert show];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
