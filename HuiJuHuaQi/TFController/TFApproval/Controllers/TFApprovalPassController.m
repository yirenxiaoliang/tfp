//
//  TFApprovalPassController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalPassController.h"
#import "TFManyLableCell.h"
#import "TFSelectPeopleCell.h"
#import "HQSelectTimeCell.h"
#import "FDActionSheet.h"
#import "TFCustomBL.h"
#import "HQEmployModel.h"
#import "TFSelectChatPeopleController.h"
#import "TFEmployModel.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFChangeHelper.h"
#import "TFCustomerRowsModel.h"
#import "TFCustomSignatureCell.h"
#import "TFSignatureViewController.h"

@interface TFApprovalPassController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,FDActionSheetDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** approvalAdvise */
@property (nonatomic, copy) NSString *approvalAdvise;

/** passWay */
@property (nonatomic, assign) NSInteger passWay;

/** 下一节点审批人 */
@property (nonatomic, strong) NSMutableArray *approvals;

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;


/** processType 审批类型 0：固定 1：自由 */
@property (nonatomic, strong) NSNumber *processType;
/** approvalSignature 审批签名 0：不需，1：可签, 2：一定 */
@property (nonatomic, strong) NSNumber *approvalSignature;

/** ApprovalFlag 是否有审批人 0：没有（需选人） 1：有（不需） */
@property (nonatomic, strong) NSNumber *approvalFlag;

/** 固定审批需选人 */
@property (nonatomic, strong) NSMutableArray *employeeList;
@property (nonatomic, strong) TFCustomerRowsModel *signRow;

@end

@implementation TFApprovalPassController

-(TFCustomerRowsModel *)signRow{
    if (!_signRow) {
        _signRow = [[TFCustomerRowsModel alloc] init];
        _signRow.label = @"签名";
        TFCustomerFieldModel *field = [[TFCustomerFieldModel alloc] init];
        field.fieldControl = @"0";
        field.structure = @"1";
        _signRow.field = field;
    }
    return _signRow;
}

-(NSMutableArray *)employeeList{
    if (!_employeeList) {
        _employeeList = [NSMutableArray array];
    }
    return _employeeList;
}

-(NSMutableArray *)approvals{
    if (!_approvals) {
        _approvals = [NSMutableArray array];
    }
    return _approvals;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.processType = @0;
    self.approvalFlag = @0;
    self.approvalSignature = @0;
    [self setupTableView];
    [self setupNavi];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.type < 3) {// 通过方式
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestApprovalPassTypeWithBean:self.approvalItem.module_bean processInstanceId:self.approvalItem.process_definition_id taskKey:self.approvalItem.task_key taskId:self.approvalItem.task_id];
    }
    
}

#pragma mark - navigation
- (void)setupNavi{
    
    if (self.type == 3) {
        self.navigationItem.title = @"转交";
    }else if (self.type == 4) {
        self.navigationItem.title = @"催办";
    }else{
        self.navigationItem.title = @"通过";
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.type == 3) {// 转交
        
        
        if (self.approvals.count == 0) {
            [MBProgressHUD showError:@"审批人不能为空" toView:self.view];
            return;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        // 数据bean
        if (self.approvalItem.module_bean) {
            
            [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
        // 数据id
        if (self.approvalItem.approval_data_id) {
            
            [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        // 获取流程id
        if (self.approvalItem.process_definition_id) {
        
            [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
        }
        // 当前节点
        if (self.approvalItem.task_id) {
            
            [dict setObject:self.approvalItem.task_id forKey:@"currentTaskId"];
        }
        // 获取任务key
        if (self.approvalItem.task_key) {
            
            [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
        }
        // 获取任务名称
        if (self.approvalItem.task_name) {
            
            [dict setObject:self.approvalItem.task_name forKey:@"taskDefinitionName"];
        }
        // 审批人
        if (self.approvals.count) {
            
            NSString *str = @"";
            for (HQEmployModel *model in self.approvals) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.id description]]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            
            [dict setObject:str forKey:@"approver"];
        }
        // 审批意见
        if (self.approvalAdvise) {
            
            [dict setObject:self.approvalAdvise forKey:@"message"];
        }
        
        // 修改
//        if (self.data) {
        [dict setObject:@{} forKey:@"data"];
//        }
        
        // 20180929 新增参数
        NSMutableDictionary *ddd = [NSMutableDictionary dictionary];
        if (self.approvalItem.approval_data_id) {
            [ddd setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        [ddd setObject:@1 forKey:@"fromType"];
        if (self.approvalItem.task_key) {
            [ddd setObject:self.approvalItem.task_key forKey:@"taskKey"];
        }
        if (self.approvalItem.module_bean) {
            [ddd setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
//        NSString *ssss = [HQHelper dictionaryToJson:ddd];
        [dict setObject:ddd forKey:@"paramFields"];
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestApprovalTransferWithDict:dict];
        
    }else if (self.type == 4) {// 催办
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        // 催办意见
        if (!self.approvalAdvise || [self.approvalAdvise isEqualToString:@""]) {
            
            [MBProgressHUD showError:@"请输入原因" toView:self.view];
            return;
        }else{
            
            [dict setObject:self.approvalAdvise forKey:@"message"];
        }
        
        // 数据bean
        if (self.approvalItem.module_bean) {
            
            [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
        // 获取流程id
        if (self.approvalItem.process_definition_id) {
            
            [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
        }
        // 获取任务key
        if (self.approvalItem.task_key) {
            
            [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
        }
        // 获取任务名称
        if (self.approvalItem.task_name) {
            
            [dict setObject:self.approvalItem.task_name forKey:@"taskDefinitionName"];
        }
        // 数据id
        if (self.approvalItem.approval_data_id) {
            
            [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestApprovalFastWithDict:dict];
        
        
    }else{// 通过
        
        if ([self.approvalFlag isEqualToNumber:@1]) {// 选人
            
            if (!self.approvals.count){
                [MBProgressHUD showError:@"请选择下一节点审批人" toView:self.view];
               return;
            }
        }
        
        if (self.type == 1 || self.type == 2 || self.type == 3) {
            
            if (self.approvals.count == 0) {
                if (self.passWay != 0) {// 非通过且结束
                    
                    [MBProgressHUD showError:@"审批人不能为空" toView:self.view];
                    return;
                }
            }
        }
        if (self.type < 3 && [self.approvalSignature integerValue] == 2) {
                   
           if (self.signRow.selects == 0) {
               
               [MBProgressHUD showError:@"签名不能为空" toView:self.view];
               return;
           }
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        // 数据bean
        if (self.approvalItem.module_bean) {
            
            [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
        // 数据id
        if (self.approvalItem.approval_data_id) {
            
            [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        // 当前节点
        if (self.approvalItem.task_id) {
            
            [dict setObject:self.approvalItem.task_id forKey:@"currentTaskId"];
        }
        // 下一环节审批人
        if (self.approvals.count) {
            
            NSString *str = @"";
            for (HQEmployModel *model in self.approvals) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[model.id description]]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            [dict setObject:str forKey:@"nextAssignee"];
        }
        // 审批意见
        if (self.approvalAdvise) {
            
            [dict setObject:self.approvalAdvise forKey:@"message"];
        }
        
        // 获取流程id
        if (self.approvalItem.process_definition_id) {
            
            [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
        }
        // 获取任务key
        if (self.approvalItem.task_key) {
            
            [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
        }
        // 获取任务名称
        if (self.approvalItem.task_name) {
            
            [dict setObject:self.approvalItem.task_name forKey:@"taskDefinitionName"];
        }
        
        // 修改
        if (self.data) {
            [dict setObject:self.data forKey:@"data"];
        }
        // 20190104 新增oldData 和 layout_data
        if (self.oldData) {
            [dict setObject:self.oldData forKey:@"oldData"];
        }
        if (self.layout_data) {
            [dict setObject:self.layout_data forKey:@"layout_data"];
        }
        
        // 20180929 新增参数
        NSMutableDictionary *ddd = [NSMutableDictionary dictionary];
        if (self.approvalItem.approval_data_id) {
            [ddd setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
        }
        [ddd setObject:@1 forKey:@"fromType"];
        if (self.approvalItem.task_key) {
            [ddd setObject:self.approvalItem.task_key forKey:@"taskKey"];
        }
        if (self.approvalItem.module_bean) {
            [ddd setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
//        NSString *ssss = [HQHelper dictionaryToJson:ddd];
        [dict setObject:ddd forKey:@"paramFields"];
        if (self.type < 3) {
            if (self.signRow.selects) {
                       TFFileModel *file = self.signRow.selects.firstObject;
                       NSDictionary *dd6 = [file toDictionary];
                       if (dd6) {
                           [dict setObject:@[dd6] forKey:@"signature_picture"];
                       }else{
                           [dict setObject:@[] forKey:@"signature_picture"];
                       }
                   }else{
                       [dict setObject:@[] forKey:@"signature_picture"];
                   }
        }
        
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.view endEditing:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestApprovalPassWithDict:dict];
        
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customApprovalPass) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customApprovalTransfer) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customApprovalUrge) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customApprovalPassType) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dict = resp.body;
        
        self.processType = [dict valueForKey:@"processType"];
        if (!([dict valueForKey:@"approvalSignature"] == [NSNull null])) {
            self.approvalSignature = @([[dict valueForKey:@"approvalSignature"] integerValue] + 1);
        }
        self.signRow.field.fieldControl = [[self.approvalSignature description] isEqualToString:@"2"] ? @"2" : @"0";;
        
        self.approvalFlag = [dict valueForKey:@"approvalFlag"];
        NSArray *arr = [dict valueForKey:@"employeeList"];
        
        [self.employeeList removeAllObjects];
        for (NSDictionary *di in arr) {
            
            TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:di error:nil];
            if (model) {
                [self.employeeList addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
            }
        }
        
        
        /** type 0:固定流程有人 1：固定流程无人（指定角色） 2：自由流程 3:转交 4:催办 */
        
        if (self.processType && [self.processType integerValue] == 0) {
            
            self.type = 0;
        }
        if (self.processType && [self.processType integerValue] == 0) {
            
            if ([self.approvalFlag isEqualToNumber:@1]) {// 选人
                self.type = 1;
            }
        }
        
        if (self.processType && [self.processType integerValue] == 1) {
            
            self.type = 2;
        }
        
        
        [self.tableView reloadData];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
    
    if (self.type == 0) {
        return 1 + 1;
    }else if (self.type == 1){
        return 2 + 1;
    }else if (self.type == 2){
        return 3 + 1;
    }else if (self.type == 3){
        return 2;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == 0) {
        
        if (indexPath.row == 0) {

            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"审批意见";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入200字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.approvalAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            if ([self.approvalSignature integerValue] > 0) {
                cell.bottomLine.hidden = NO;
            }else{
                cell.bottomLine.hidden = YES;
            }
            return cell;
            
        }else{
            TFCustomSignatureCell *cell = [TFCustomSignatureCell customSignatureCellWithTableView:tableView];
            cell.model = self.signRow;
            cell.showEdit = YES;
            return cell;
        }
        
        
    }
    else if (self.type == 1){
        
        if (indexPath.row == 0) {
            
            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"审批意见";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入200字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.approvalAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            
            return cell;
            
        }else if (indexPath.row == 1) {
            
            TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"下一节点审批人";
            cell.fieldControl = @"2";
            [cell refreshSelectPeopleCellWithPeoples:self.approvals structure:@"0" chooseType:@"0" showAdd:YES clear:NO];
            
            if ([self.approvalSignature integerValue] > 0) {
                cell.bottomLine.hidden = NO;
            }else{
                cell.bottomLine.hidden = YES;
            }
            return cell;
            
        }else{
            TFCustomSignatureCell *cell = [TFCustomSignatureCell customSignatureCellWithTableView:tableView];
            cell.model = self.signRow;
            cell.showEdit = YES;
            return cell;
        }
        
    }
    else if (self.type == 2){
      
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"通过方式";
            cell.time.text = self.passWay == 0 ? @"通过且结束" : @"通过并转审";
            cell.time.textColor = BlackTextColor;
            
            cell.structure = @"1";
            cell.fieldControl = @"2";
            cell.arrowShowState = YES;
            
            return cell;
            
            
        } else if (indexPath.row == 1) {
            
            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"审批意见";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入200字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.approvalAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            
            return cell;
            
        }else if (indexPath.row == 2){
            
            TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"下一节点审批人";
            cell.fieldControl = @"2";
            [cell refreshSelectPeopleCellWithPeoples:self.approvals structure:@"0" chooseType:@"0" showAdd:YES clear:NO];
            
            if ([self.approvalSignature integerValue] > 0) {
                cell.bottomLine.hidden = NO;
            }else{
                cell.bottomLine.hidden = YES;
            }
            return cell;
            
        }else{
            TFCustomSignatureCell *cell = [TFCustomSignatureCell customSignatureCellWithTableView:tableView];
            cell.model = self.signRow;
            cell.showEdit = YES;
            return cell;
        }
        
    }
    else if (self.type == 3) {
        
        if (indexPath.row == 0) {
            
            TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
            cell.titleLab.text = @"转交理由";
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入50字以内（选填）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
            cell.textVeiw.text = self.approvalAdvise;
            cell.textVeiw.textColor = BlackTextColor;
            cell.structure = @"0";
            cell.fieldControl = @"0";
            cell.textVeiw.userInteractionEnabled = YES;
            
            return cell;
            
        }else{
            
            TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
            cell.titleLabel.text = @"审批人";
            cell.fieldControl = @"2";
            [cell refreshSelectPeopleCellWithPeoples:self.approvals structure:@"0" chooseType:@"0" showAdd:YES clear:NO];
            
            return cell;
            
        }

        
    }
    else{
        
        
        TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
        cell.titleLab.text = @"催办原因";
        cell.textVeiw.delegate = self;
        cell.textVeiw.placeholder = @"请输入50字以内（必填）";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.tag = 0x777 *indexPath.section + indexPath.row;
        cell.textVeiw.text = self.approvalAdvise;
        cell.textVeiw.textColor = BlackTextColor;
        cell.structure = @"0";
        cell.fieldControl = @"2";
        cell.textVeiw.userInteractionEnabled = YES;
        
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (self.type == 0 && indexPath.row == 1) {
        
        kWEAKSELF
        TFSignatureViewController *sign = [[TFSignatureViewController alloc] init];
        sign.bean = self.approvalItem.module_bean;
        sign.images = ^(NSArray *parameter) {
            self.signRow.selects = [NSMutableArray arrayWithArray:parameter];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:sign animated:YES];
    }
    if (self.type == 1) {
        if (indexPath.row == 1) {// 选人
            
            
            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
            select.type = 1;
            select.isSingle = YES;
            select.peoples = self.approvals;
            select.dataPeoples = self.employeeList;
            select.actionParameter = ^(NSArray *parameter) {
                
                [self.approvals addObjectsFromArray:parameter];
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:select animated:YES];
            
        }
        if (indexPath.row == 2) {
               
               kWEAKSELF
               TFSignatureViewController *sign = [[TFSignatureViewController alloc] init];
               sign.bean = self.approvalItem.module_bean;
               sign.images = ^(NSArray *parameter) {
                   self.signRow.selects = [NSMutableArray arrayWithArray:parameter];
                   [weakSelf.tableView reloadData];
               };
               [self.navigationController pushViewController:sign animated:YES];
           }
    }
    
    if (self.type == 2) {
        if (indexPath.row == 0) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"通过方式" delegate:self cancelButtonTitle:@"取消" titles:@[@"通过且结束",@"通过并转审"]];
            [sheet show];
        }else if (indexPath.row == 2){// 选人
            
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = YES;
            scheduleVC.actionParameter = ^(id parameter) {
                
                [self.approvals addObjectsFromArray:parameter];
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
            
//            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
//            select.type = 1;
//            select.isSingle = YES;
//            select.peoples = self.approvals;
//            select.actionParameter = ^(NSArray *parameter) {
//                
//                [self.approvals addObjectsFromArray:parameter];
//                
//                
//                [self.tableView reloadData];
//                
//            };
//            
//            [self.navigationController pushViewController:select animated:YES];
            
        }else if (indexPath.row == 3) {
            
            kWEAKSELF
            TFSignatureViewController *sign = [[TFSignatureViewController alloc] init];
            sign.bean = self.approvalItem.module_bean;
            sign.images = ^(NSArray *parameter) {
                self.signRow.selects = [NSMutableArray arrayWithArray:parameter];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:sign animated:YES];
        }
    }
    
    if (self.type == 3) {
        
        if (indexPath.row == 1) {// 选人
            
            NSMutableArray *noselect = [NSMutableArray array];
            if (self.currentNodeUsers) {
                
                for (NSString *str in self.currentNodeUsers) {
                    HQEmployModel *model = [[HQEmployModel alloc] init];
                    model.id = [NSNumber numberWithInteger:[str integerValue]];
                    [noselect addObject:model];
                }
            }
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.noSelectPoeples = noselect;
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = YES;
            scheduleVC.actionParameter = ^(id parameter) {
                
                [self.approvals addObjectsFromArray:parameter];
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
//            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
//            select.type = 1;
//            select.isSingle = YES;
//            select.peoples = self.approvals;
//            select.actionParameter = ^(NSArray *parameter) {
//                
//                [self.approvals addObjectsFromArray:parameter];
//                
//                
//                [self.tableView reloadData];
//                
//            };
//            
//            [self.navigationController pushViewController:select animated:YES];
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 0) {
        if (indexPath.row == 0) {
            return 227;
        }else{
            if ([self.approvalSignature integerValue] > 0) {
                return 75;
            }else{
                return 0;
            }
        }
    }else if (self.type == 1){
        
        if (indexPath.row == 0) {
            
            return 227;
        }else if (indexPath.row == 1) {
            
            return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"0"];
        }else{
            if ([self.approvalSignature integerValue] > 0) {
                return 75;
            }else{
                return 0;
            }
        }
    }else if (self.type == 2){
        
        if (indexPath.row == 0) {
            
            return 64;
        }else if (indexPath.row == 1) {
            
            return 227;
        }else if (indexPath.row == 2) {
            
            if (self.passWay == 0) {
                return 0;
            }
            return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"0"];
        }else{
            if ([self.approvalSignature integerValue] > 0) {
                return 75;
            }else{
                return 0;
            }
        }
    }else if (self.type == 3){
        if (indexPath.row == 0) {
            
            return 227;
        }else{
            
            return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"0"];
        }
    }else{
        
        return 227;
    }
    
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

#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    self.passWay = buttonIndex;
    [self.tableView reloadData];
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (self.type == 4 || self.type == 3) {
        if (textView.text.length > 50) {
            
            textView.text = [textView.text substringToIndex:50];
            [MBProgressHUD showError:@"最长50个字符" toView:self.view];
        }
    }else{
        
        if (textView.text.length > 200) {
            
            textView.text = [textView.text substringToIndex:200];
            [MBProgressHUD showError:@"最长200个字符" toView:self.view];
        }
        
    }
    self.approvalAdvise = textView.text;
    
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
