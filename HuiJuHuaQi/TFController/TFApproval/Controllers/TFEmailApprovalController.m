//
//  TFEmailApprovalController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailApprovalController.h"
#import "TFEmailsDetailHeadCell.h"
#import "TFMailBL.h"
#import "TFEmailsDetailWebViewCell.h"
#import "HQTFTwoLineCell.h"
#import "TFApprovalFlowProgramCell.h"
#import "TFCustomBL.h"
#import "TFApprovalFlowModel.h"
#import "TFSelectPeopleCell.h"
#import "TFTwoBtnsView.h"
#import "TFApprovalPassController.h"
#import "TFApprovalRejectController.h"
#import "TFCustomerCommentController.h"
#import "FDActionSheet.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFAddCustomController.h"

@interface TFEmailApprovalController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFEmailsDetailHeadCellDelegate,TFEmailsDetailWebViewCellDelegate,TFTwoBtnsViewDelegate,FDActionSheetDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFEmailReceiveListModel *model;

@property (nonatomic, assign) float webViewHeight;

@property (nonatomic, strong) TFMailBL *mailBL;
/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 流程 */
@property (nonatomic, strong) NSMutableArray *approvals;

/** bottomView */
@property (nonatomic, weak) TFTwoBtnsView *bottomView;

/** 详情数据 */
@property (nonatomic, strong) NSDictionary *detailDict;

/** isSelf */
@property (nonatomic, assign) BOOL isSelf;

/** height */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** type 0:新增 1:详情 2：编辑 3：复制 */
@property (nonatomic, assign) NSInteger type;

/** 当前currentTaskKey */
@property (nonatomic, copy) NSString *currentTaskKey;

@end

@implementation TFEmailApprovalController


-(NSMutableArray *)approvals{
    if (!_approvals) {
        _approvals = [NSMutableArray array];
    }
    return _approvals;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //    manager.enable = NO;
    
    if (self.translucent) {
        
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            
            [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
        }
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(20)}];
    }
    NSAssert(self.tableViewHeight > 0, @"tableView的高度要大于0，请设置tableView的高度，否则看不见tableView。");
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    //    manager.enable = YES;
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height, 0);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 1;
    self.tableViewHeight = SCREEN_HEIGHT - NaviHeight - 70;
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    
    [self.customBL requsetApprovalWholeFlowWithProcessDefinitionId:self.approvalItem.process_definition_id bean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id];
    
    if (self.type != 0) {
        [self.customBL requsetCustomDetailWithBean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id taskKey:self.approvalItem.task_key processFieldV:self.approvalItem.process_field_v];
    }
    
    [self setupTableView];
    [self setupNavi];
    
    
    if (self.listType == 1) {
        
        [self.customBL requestApprovalCopyReadWithProcessDefinitionId:self.approvalItem.task_id type:@1];
    }
    if (self.listType == 3) {
        
        [self.customBL requestApprovalCopyReadWithProcessDefinitionId:self.approvalItem.process_definition_id type:@3];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)setupNavi{
    
    self.navigationItem.title = [NSString stringWithFormat:@"审批详情"];
        
}

/** 是否有菜单按钮 */
- (void)setupMenu{
    // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交
    NSInteger processStatus = [[self.detailDict valueForKey:@"process_status"] integerValue];
    if (self.listType == 0) {
        
        if (processStatus == 4 || processStatus == 6) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
            
        }else{
            
            if ([self haveAuthWithId:3]) {
                
                self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
            }
        }
        
    }else if (self.listType == 1){
        if ([self haveAuthWithId:4]) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
        }
    }else if (self.listType == 2){
        
        if ([self haveAuthWithId:4]) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
        }
    }else{
        
        if ([self haveAuthWithId:5]) {
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menu) image:@"菜单" highlightImage:@"菜单"];
        }
    }
    
}

- (void)menu{
    
    // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交
    NSInteger processStatus = [[self.detailDict valueForKey:@"process_status"] integerValue];
    if (self.listType == 0) {
        
        if (processStatus == 4 || processStatus == 6) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:@[@"编辑",@"删除"]];
            sheet.tag = 0x22;
            [sheet show];
            
        }else{
            
            if ([self haveAuthWithId:3]) {
                
                FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:@[@"抄送"]];
                sheet.tag = 0x11;
                [sheet show];
            }
        }
        
    }else if (self.listType == 1){
        if ([self haveAuthWithId:4]) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:@[@"抄送"]];
            sheet.tag = 0x11;
            [sheet show];
        }
    }else if (self.listType == 2){
        
        if ([self haveAuthWithId:4]) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:@[@"抄送"]];
            sheet.tag = 0x11;
            [sheet show];
        }
    }else{
        
        if ([self haveAuthWithId:5]) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" titles:@[@"抄送"]];
            sheet.tag = 0x11;
            [sheet show];
        }
    }
    
}
#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (sheet.tag == 0x11) {// 抄送
        
        if (buttonIndex == 0) {
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = NO;
            scheduleVC.actionParameter = ^(id parameter) {
                
                NSString *str = @"";
                for (HQEmployModel *em in parameter) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%lld,",[em.id longLongValue]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                
                if (self.approvalItem.process_definition_id) {
                    [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
                }
                if (self.approvalItem.task_key) {
                    [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
                }
                if (self.approvalItem.task_id) {
                    [dict setObject:self.approvalItem.task_id forKey:@"taskDefinitionId"];
                }
                // 数据id
                if (self.approvalItem.approval_data_id) {
                    
                    [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
                }
                if (str) {
                    [dict setObject:str forKey:@"ccTo"];
                }
                if (self.approvalItem.module_bean) {
                    [dict setObject:self.approvalItem.module_bean forKey:@"beanName"];
                }
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestApprovalCopyWithDict:dict];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
            //            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
            //            select.type = 1;
            //            select.isSingle = NO;
            ////            select.peoples = peoples;
            //            select.actionParameter = ^(NSArray *parameter) {
            //
            //                NSString *str = @"";
            //                for (HQEmployModel *em in parameter) {
            //
            //                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%lld,",[em.id longLongValue]]];
            //                }
            //                if (str.length) {
            //                    str = [str substringToIndex:str.length-1];
            //                }
            //
            //                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //
            //                if (self.approvalItem.process_definition_id) {
            //                    [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
            //                }
            //                if (self.approvalItem.task_key) {
            //                    [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
            //                }
            //                if (str) {
            //                    [dict setObject:str forKey:@"ccTo"];
            //                }
            //
            //                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //                [self.customBL requestApprovalCopyWithDict:dict];
            //
            //
            //            };
            //
            //            [self.navigationController pushViewController:select animated:YES];
            
            
        }
        
    }else{
        
        if (buttonIndex == 0) {// 编辑
            
            TFAddCustomController *add = [[TFAddCustomController alloc] init];
            add.type = 7;
            add.tableViewHeight = SCREEN_HEIGHT - NaviHeight;
            add.bean = self.approvalItem.module_bean;
            add.dataId = @([self.approvalItem.approval_data_id integerValue]);
            add.taskKey = self.approvalItem.task_key;
            add.processFieldV = self.approvalItem.process_field_v;
            add.refreshAction = ^{
                
                [self refreshDataWithHide:YES];
            };
            [self.navigationController pushViewController:add animated:YES];
            
        }
        
        if (buttonIndex == 1) {// 删除
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除后不可恢复。你确认要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x222;
            [alertView show];
        }
    }
    
    
    
}


-(void)setTableViewHeight:(CGFloat)tableViewHeight{
    _tableViewHeight = tableViewHeight;
    self.tableView.height = tableViewHeight;
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 2 + self.model.attachments_name.count;
    }else if (section == 1){
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFEmailsDetailHeadCell *cell = [TFEmailsDetailHeadCell emailsDetailHeadCellWithTableView:tableView];
            
            cell.delegate = self;
            
            [cell refreshEmailHeadViewWithModel:self.model];
            
            return cell;
        }
        else if (indexPath.row == 1) {
            
            TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:1];
            
            cell.delegate = self;
            cell.type = @1;
//            [cell refreshEmailsDetailWebViewCellWithData:self.model];
            cell.mailContent = self.model.mail_content;
            
            return cell;
        }
        else {
            
            TFFileModel *attModel = self.model.attachments_name[indexPath.row-2];
            
            HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
            
            cell.type = TwoLineCellTypeTwo;
            cell.titleImageWidth = 40.0;
            
            [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:attModel.file_url] forState:UIControlStateNormal];
            cell.topLabel.text = attModel.file_name;
            cell.bottomLabel.text = [HQHelper fileSizeForKB:[attModel.file_size integerValue]];
            
            return cell;
        }
    }else if (indexPath.section == 1){
        
        TFApprovalFlowProgramCell *cell = [TFApprovalFlowProgramCell approvalFlowProgramCellWithTableView:tableView];
        
        [cell refreshApprovalFlowProgramCellWithModels:self.approvals];
        return cell;
        
    }else{
        
        TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
        cell.titleLabel.text = @"抄送人";
        cell.fieldControl = @"1";
        
        
        [cell refreshSelectPeopleCellWithPeoples:nil structure:@"1" chooseType:@"0" showAdd:NO clear:NO];
        
        return cell;

        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 2) { //附件预览
            
            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return [TFEmailsDetailHeadCell refreshEmailsDetailHeadHeightWithModel:self.model];
        }
        else if (indexPath.row == 1) {
            
            return self.webViewHeight;
        }
        else {
            
            return 55;
        }
    }else if (indexPath.section == 1){
        
        return [TFApprovalFlowProgramCell refreshApprovalFlowProgramCellHeightWithModels:self.approvals];
    }else{
        return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"1"];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1 || section == 2) {
        return 10;
    }
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

#pragma mark TFEmailsDetailWebViewCellDelegate
- (void)getWebViewHeight:(CGFloat)height {
    
    self.webViewHeight = height;
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark TFEmailsDetailHeadCellDelegate
- (void)hideEmailDetailHeadInfo {
    
    
    if ([self.model.isHide isEqualToNumber:@1]) {
        
        self.model.isHide = @0;
    }
    else {
        
        self.model.isHide = @1;
    }
    
    //一个cell刷新
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];  //你需要更新的组数中的cell
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customSave) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.refreshAction){
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if (resp.cmdId == HQCMD_customDetail) {
        
        self.detailDict = resp.body;
        
        NSDictionary *dic = [resp.body valueForKey:@"mailDetail"];
        
        NSArray *arr = [resp.body valueForKey:@"ccTo"];
        
        self.model = [[TFEmailReceiveListModel alloc] initWithDictionary:dic error:nil];
        
        // 底部按钮
        [self setupBottomView];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customEdit) {
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
    if (resp.cmdId == HQCMD_customApprovalWholeFlow) {
        
        self.approvals = resp.body;
        
        // 审批中的人是自己显示四个按钮否则只为评论按钮
        NSString *currentApprovaler = nil;
        TFApprovalFlowModel *flow = nil;
        for (TFApprovalFlowModel *model in self.approvals) {
            
            if ([model.task_status_id isEqualToString:@"1"]) {
                flow = model;
                currentApprovaler = model.approval_employee_id;
                self.currentTaskKey = model.task_key;
                break;
            }
        }
        // 判断自己
        if ([flow.task_approval_type isEqualToString:@"2"] || [flow.task_approval_type isEqualToString:@"1"]) {// 会签
            self.isSelf = YES;
        }else{
            
            if ([currentApprovaler isEqualToString:[UM.userLoginInfo.employee.id description]]) {
                self.isSelf = YES;
            }else{
                self.isSelf = NO;
            }
        }
        
        
        for (NSInteger i = 1; i < self.approvals.count; i++) {
            TFApprovalFlowModel *flow = self.approvals[i-1];
            
            TFApprovalFlowModel *nextflow = self.approvals[i];
            
            nextflow.previousColor = flow.selfColor;
            
            if ([nextflow.process_type isEqualToNumber:@0]) {// 固定流程
                
                if ([flow.task_key isEqualToString:nextflow.task_key]) {
                    
                    if ([nextflow.task_status_id isEqualToString:@"4"] || [nextflow.task_status_id isEqualToString:@"5"]) {
                        
                        nextflow.dot = @0;
                    }else{
                        nextflow.dot = @1;
                    }
                }else{
                    nextflow.dot = @0;
                }
                if ([flow.task_key isEqualToString:@"firstTask"]) {
                    flow.dot = @0;
                }
                
            }else{// 自由流程
                flow.dot = @0;
                nextflow.dot = @0;
                
            }
            
        }
        
        // 底部按钮
        [self setupBottomView];
        
        [self.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    
    }
    
    if (resp.cmdId == HQCMD_customApprovalRevoke) {
        
        [self changeComment];
        
        [self refreshDataWithHide:NO];
        
    }
    
    if (resp.cmdId == HQCMD_customApprovalCopy) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.customBL requsetCustomDetailWithBean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id taskKey:self.approvalItem.task_key processFieldV:self.approvalItem.process_field_v];
        
    }
    
    if (resp.cmdId == HQCMD_customEdit) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    if (resp.cmdId == HQCMD_customRemoveProcessApproval) {
        
        [MBProgressHUD showMessage:@"删除成功" view:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}


- (void)refreshDataWithHide:(BOOL)hide{
    
    if (hide) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self.customBL requsetApprovalWholeFlowWithProcessDefinitionId:self.approvalItem.process_definition_id bean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id];
    
    [self.customBL requsetCustomDetailWithBean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id taskKey:self.approvalItem.task_key processFieldV:self.approvalItem.process_field_v];
}


-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



/** 判断有没有操作权限 1：撤销 2：转交 3：发起人抄送 4：审批人抄送 5：抄送人抄送 */
- (BOOL)haveAuthWithId:(NSInteger)authId{
    
    NSArray *auths = [self.detailDict valueForKey:@"btnAuth"];
    
    BOOL have = NO;
    
    if (auths.count == 0) {
        return have;
    }
    
    for (NSDictionary *dict in auths) {
        
        if ([[dict valueForKey:@"id"] integerValue] == authId) {
            
            have = YES;
            break;
        }
    }
    
    return have;
}


- (void)setupBottomView{
    
    if (![self.detailDict valueForKey:@"process_status"]) return;
    //    if (!self.approvals.count) return;
    //    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57, 0);
    
    // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交 6待提交
    NSInteger processStatus = [[self.detailDict valueForKey:@"process_status"] integerValue];
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    
    if (self.listType == 0) {// 我发起的
        
        if (processStatus == 0) {
            
            if ([self haveAuthWithId:1]) {// 有没有撤销权限
                
                for (NSInteger i = 0; i < 3; i ++) {
                    
                    TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                    model.font = FONT(18);
                    
                    if (0 == i){
                        model.title = @"催办";
                        model.color = GreenColor;
                    }else if (1 == i){
                        model.title = @"撤销";
                        model.color = PriorityUrgent;
                    }else if (2 == i){
                        model.title = @"评论";
                        model.color = LightBlackTextColor;
                    }
                    
                    [arr addObject:model];
                }
                
            }else{
                
                for (NSInteger i = 0; i < 2; i ++) {
                    
                    TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                    model.font = FONT(18);
                    
                    if (0 == i){
                        model.title = @"催办";
                        model.color = GreenColor;
                    }else if (2 == i){
                        model.title = @"评论";
                        model.color = LightBlackTextColor;
                    }
                    
                    [arr addObject:model];
                }
                
            }
            
            
            
        }else if (processStatus == 1){
            
            for (NSInteger i = 0; i < 2; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"催办";
                    model.color = GreenColor;
                }else if (1 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
            
        }else if (processStatus == 2){
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
            
        }else if (processStatus == 3){
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
        }else if (processStatus == 4){
            
            //            for (NSInteger i = 0; i < 1; i ++) {
            //
            //                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            //                model.font = FONT(18);
            //
            //                if (0 == i){
            //                    model.title = @"评论";
            //                    model.color = LightBlackTextColor;
            //                }
            //
            //                [arr addObject:model];
            //            }
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            
        }else{
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
        }
        
    }else if (self.listType == 1){// 待我审批
        
        // -1已提交 0待审批 1审批中 2审批通过 3审批驳回 4已撤销 5已转交
        if (processStatus == 1 || processStatus == 0) {
            
            // 审批中的人是自己显示四个按钮否则只为评论按钮
            // 判断自己
            if (self.isSelf && [self.currentTaskKey isEqualToString:self.approvalItem.task_key]) {
                
                if ([self haveAuthWithId:2]) {
                    
                    for (NSInteger i = 0; i < 4; i ++) {
                        
                        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                        model.font = FONT(18);
                        
                        if (0 == i){
                            model.title = @"通过";
                            model.color = GreenColor;
                        }else if (1 == i){
                            model.title = @"驳回";
                            model.color = RedColor;
                        }else if (2 == i){
                            model.title = @"转交";
                            model.color = PriorityUrgent;
                        }else if (3 == i){
                            model.title = @"评论";
                            model.color = LightBlackTextColor;
                        }
                        
                        [arr addObject:model];
                    }
                }else{
                    
                    for (NSInteger i = 0; i < 3; i ++) {
                        
                        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                        model.font = FONT(18);
                        
                        if (0 == i){
                            model.title = @"通过";
                            model.color = GreenColor;
                        }else if (1 == i){
                            model.title = @"驳回";
                            model.color = RedColor;
                        }else if (2 == i){
                            model.title = @"评论";
                            model.color = LightBlackTextColor;
                        }
                        
                        [arr addObject:model];
                    }
                    
                }
                
            }else{
                for (NSInteger i = 0; i < 1; i ++) {
                    
                    TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                    model.font = FONT(18);
                    
                    if (0 == i){
                        model.title = @"评论";
                        model.color = LightBlackTextColor;
                    }
                    
                    [arr addObject:model];
                }
            }
            
            
        }else if (processStatus == 2){
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
            
        }else if (processStatus == 3){
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
        }else if (processStatus == 4){
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
        }else{
            
            for (NSInteger i = 0; i < 1; i ++) {
                
                TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
                model.font = FONT(18);
                
                if (0 == i){
                    model.title = @"评论";
                    model.color = LightBlackTextColor;
                }
                
                [arr addObject:model];
            }
        }
        
    }else if (self.listType == 2){// 我已审批
        
        for (NSInteger i = 0; i < 1; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            model.font = FONT(18);
            
            if (0 == i){
                model.title = @"评论";
                model.color = LightBlackTextColor;
            }
            
            [arr addObject:model];
        }
        
        
    }else{// 抄送到我
        
        for (NSInteger i = 0; i < 1; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            model.font = FONT(18);
            
            if (0 == i){
                model.title = @"评论";
                model.color = LightBlackTextColor;
            }
            
            [arr addObject:model];
        }
        
    }
    
    [self.bottomView removeFromSuperview];
    
    if (processStatus != 4) {
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57, 0);
        TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight} withTitles:arr];
        self.bottomView = bottomView;
        bottomView.delegate = self;
        [self.view addSubview:bottomView];
    }
}

/** 通过、驳回、转交返回之后变为评论 */
- (void)changeComment{
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    for (NSInteger i = 0; i < 1; i ++) {
        
        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
        model.font = FONT(18);
        
        if (0 == i){
            model.title = @"评论";
            model.color = LightBlackTextColor;
        }
        
        [arr addObject:model];
    }
    
    [self.bottomView removeFromSuperview];
    
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight} withTitles:arr];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view insertSubview:bottomView aboveSubview:self.tableView];
    
}


- (void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectModel:(TFTwoBtnsModel *)model{
    
    if ([model.title isEqualToString:@"通过"]) {
        TFApprovalPassController *pass = [[TFApprovalPassController alloc] init];
        pass.type = 0;
        pass.approvalItem = self.approvalItem;
        pass.refreshAction = ^{
            
            self.currentTaskKey = nil;
            if (self.deleteAction) {
                self.deleteAction();
            }
            
            [self changeComment];
            
            [self refreshDataWithHide:YES];
            
        };
        [self.navigationController pushViewController:pass animated:YES];
        
    }else if ([model.title isEqualToString:@"驳回"]) {
        
        TFApprovalRejectController *reject = [[TFApprovalRejectController alloc] init];
        
        reject.approvalItem = self.approvalItem;
        reject.type = 1;
        reject.refreshAction = ^{
            
            self.currentTaskKey = nil;
            if (self.deleteAction) {
                self.deleteAction();
            }
            
            [self changeComment];
            [self refreshDataWithHide:YES];
        };
        [self.navigationController pushViewController:reject animated:YES];
        
    }else if ([model.title isEqualToString:@"撤销"]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"撤销后，该审批将从审批人与抄送人处撤回，审批流程将会直接终止。你确认要撤销吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = 0x111;
        [alertView show];
        
    }else if ([model.title isEqualToString:@"转交"]) {
        
        TFApprovalPassController *pass = [[TFApprovalPassController alloc] init];
        pass.type = 3;
        pass.approvalItem = self.approvalItem;
        pass.refreshAction = ^{
            
            self.currentTaskKey = nil;
            if (self.deleteAction) {
                self.deleteAction();
            }
            
            [self changeComment];
            
            [self refreshDataWithHide:YES];
        };
        [self.navigationController pushViewController:pass animated:YES];
        
    }else if ([model.title isEqualToString:@"评论"]) {
        
        TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
        //        comment.bean = self.approvalItem.module_bean;
        comment.bean = @"approval";
        comment.id = @([self.approvalItem.approval_data_id integerValue]);
        [self.navigationController pushViewController:comment animated:YES];
        
    }else if ([model.title isEqualToString:@"催办"]) {
        
        TFApprovalPassController *pass = [[TFApprovalPassController alloc] init];
        pass.type = 4;
        pass.approvalItem = self.approvalItem;
        pass.refreshAction = ^{
            
        };
        [self.navigationController pushViewController:pass animated:YES];
    }
    
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x111) {// 撤销
        
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        // 数据bean
        if (self.approvalItem.module_bean) {
            
            [dict setObject:self.approvalItem.module_bean forKey:@"moduleBean"];
        }
        
        // 数据bean
        if (self.approvalItem.approval_data_id) {
            
            [dict setObject:self.approvalItem.approval_data_id forKey:@"dataId"];
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
        // 获取任务id
        if (self.approvalItem.task_id) {
            
            [dict setObject:self.approvalItem.task_id forKey:@"currentTaskId"];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestApprovalCancelWithDict:dict];
        
    }
    
    if (alertView.tag == 0x222) {// 删除
        
        
        if (buttonIndex == 1) {
            
            [self.customBL requestApprovalDeleteWithBean:self.approvalItem.module_bean dataId:self.approvalItem.approval_data_id];
        }
        
    }
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
