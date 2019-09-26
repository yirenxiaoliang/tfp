//
//  TFProjectAddShareController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectAddShareController.h"
#import "HQCreatScheduleTitleCell.h"
#import "TFAddPeoplesCell.h"
#import "TFShareRelatedCell.h"
#import "FDActionSheet.h"
#import "TFProjectMenberManageController.h"
#import "TFCustomerCommentController.h"
#import "TFCustomerDynamicController.h"

#import "TFProjectShareSendModel.h"
#import "TFProjectShareInfoModel.h"

#import "HQTFHeartCell.h"
#import "TFTwoBtnsView.h"
#import "TFChangeHelper.h"

#import "TFProjectTaskBL.h"
#import "AlertView.h"

#import "TFModelEnterController.h"
#import "TFProjectRowFrameModel.h"
#import "TFRelatedModuleDataCell.h"
#import "TFEmailsDetailWebViewCell.h"
#import "TFProjectShareRelatedModel.h"
#import "TFImgDoubleLalImgCell.h"
#import "TFProjectShareMemberController.h"
#import "TFProjectPeopleModel.h"
#import "TFCreateNoteController.h"
#import "TFProjectTaskDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFApprovalDetailController.h"
#import "HQSwitchCell.h"
#import "TFAttributeTextController.h"

@interface TFProjectAddShareController ()<UITableViewDelegate,UITableViewDataSource,TFAddPeoplesCellDelegate,UITextViewDelegate,HQBLDelegate,FDActionSheetDelegate,HQTFHeartCellDelegate,TFTwoBtnsViewDelegate,TFShareRelatedCellDelegate,TFEmailsDetailWebViewCellDelegate,TFRelatedModuleDataCellDelegate,UIAlertViewDelegate,TFImgDoubleLalImgCellDelegate,UIActionSheetDelegate,HQSwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** 分享人 */
@property (nonatomic, strong) NSArray *shares;

/** 点赞人 */
@property (nonatomic, strong) NSMutableArray *praises;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) TFProjectShareSendModel *sendModel;
@property (nonatomic, strong) TFProjectShareInfoModel *infoModel;

@property (nonatomic, strong) TFTwoBtnsView *bottomView;

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSMutableArray *frames;

@property (nonatomic, assign) NSInteger cancelIndex;

@property (nonatomic, strong) TFProjectShareRelatedModel *relatedModel;

@property (nonatomic, assign) CGFloat webViewHeight;

@end

@implementation TFProjectAddShareController

-(TFProjectShareInfoModel *)infoModel{
    if (!_infoModel) {
        _infoModel = [[TFProjectShareInfoModel alloc] init];
    }
    return _infoModel;
}
- (NSArray *)shares {
    
    if (!_shares) {
        
        _shares = [NSArray array];
    }
    return _shares;
}
- (TFProjectShareSendModel *)sendModel {

    if (!_sendModel) {
        
        _sendModel = [[TFProjectShareSendModel alloc] init];
    }
    return _sendModel;
}

- (TFProjectShareRelatedModel *)relatedModel {
    
    if (!_relatedModel) {
        
        _relatedModel = [[TFProjectShareRelatedModel alloc] init];
    }
    return _relatedModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    self.sendModel.shareIds = @"";
    
    if (self.type == 1) { //分享详情
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestProjectShareControllerQueryByIdWithId:self.shareId];
        
        [self.projectTaskBL requestProjectShareControllerQueryRelationListWithData:self.shareId];
    }
    

}

- (void)setNavi {

    if (self.type == 0) {
        
        self.navigationItem.title = @"添加分享";
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(finishAction) text:@"完成" textColor:kUIColorFromRGB(0x909090)];
    }
    if (self.type == 1) {
        
        self.navigationItem.title = @"分享详情";
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(moreAction) image:@"projectMenu" highlightImage:@"projectMenu"];
    }
    
}

- (void)setupBottomView {

    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
        
    for (NSInteger i = 0; i < 2; i ++) {
        
        TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
        
        if (0 == i){
            
            model.title = @"评论";
            model.font = FONT(16);
            model.color = kUIColorFromRGB(0x666666);
        }
        else{
            
            model.title = @"动态";
            model.font = FONT(16);
            model.color = kUIColorFromRGB(0x666666);
        }
        
        [arr addObject:model];
    }
    
    //    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44) withImages:arr];
//    self.bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-64-44, SCREEN_WIDTH, 44) withModels:arr];
    self.bottomView = [[TFTwoBtnsView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight) withTitles:arr];
    self.bottomView.delegate = self;
    [self.view addSubview:self.bottomView];
    
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    self.tableView = tableView;
    
    if (self.type == 0) {
        
         [self.view addSubview:self.tableView];
    }
   
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 2;
    }
    if (section == 3) {
        
        if (self.type == 2) {
            return 0;
        }
        
        if (self.tasks.count>0) {
            
            return 2;
        }
    }
    if (section == 1) {
        if (self.type != 1) {
            return 2;
        }
        return 1;
    }
    if (section == 2) {
        if (self.type == 2) {
            return 0;
        }
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
            
            cell.textVeiw.tag = indexPath.row+0x123;
            cell.textVeiw.delegate = self;
            cell.textVeiw.placeholder = @"请输入标题";
            cell.bottomLine.hidden = NO;
            
            if (self.type == 1) {
                
                cell.textVeiw.userInteractionEnabled = NO;
                self.sendModel.title = self.infoModel.share_title;
            }
            else {
            
                cell.textVeiw.userInteractionEnabled = YES;
            }
            cell.textVeiw.text = self.sendModel.title;
            
            return cell;
        }
        else {

            if (self.type == 1) {
                
                TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:1];
                cell.type = @1;
                cell.mailContent = self.infoModel.share_content;
                cell.delegate = self;
                
                return cell;
            }
            else {
                
                TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:0];
                cell.type = @0;
                cell.mailContent = self.infoModel.share_content;
                cell.delegate = self;
                
                return cell;
            }
            

        }
    }
    else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            
            TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
            
            cell.requireLabel.hidden = YES;
            cell.titleLabel.text = @"分享人";
            cell.delegate = self;
            
            if (self.type == 1) {
                
                
                NSArray *shareArr = self.infoModel.share_obj;
                NSMutableArray *people = [NSMutableArray array];
                for (NSDictionary *dd in shareArr) {
                    
                    //                TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
                    //                if (em) {
                    //
                    //                    [people addObject:[TFChangeHelper tfEmployeeToHqEmployee:em]];
                    //                }
                    [people addObject:dd];
                }
                
                self.shares = people;
                
            }
            
            if (self.type == 1) {
                
                [cell refreshAddPeoplesCellWithPeoples:self.shares structure:0 chooseType:0 showAdd:NO row:indexPath.row];
            }
            else {
                
                [cell refreshAddPeoplesCellWithPeoples:self.shares structure:0 chooseType:0 showAdd:YES row:indexPath.row];
            }
            
            
            return cell;
            
        }else{
            
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.title.text = @"所有人可见";
            cell.switchBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.delegate = self;
            cell.topLine.hidden = NO;
            if (self.type == 0) {
                
                cell.switchBtn.on = [[self.sendModel.shareStatus description] isEqualToString:@"1"]?YES:NO;
            }else{
                
                cell.switchBtn.on = [[self.infoModel.share_status description] isEqualToString:@"1"]?YES:NO;
            }
            return cell;
            
        }
    }
    else if (indexPath.section == 2) {
    
//        //点赞列表
//        HQTFHeartCell *cell = [HQTFHeartCell heartCellWithTableView:tableView];
//        cell.isShow = YES;
//        cell.delegate = self;
//
        
//
//        [cell refreshHeartCellWithPeoples:self.praises];
//        return cell;
        TFImgDoubleLalImgCell *cell = [TFImgDoubleLalImgCell imgDoubleLalImgCellWithTableView:tableView];
        
        NSArray *praiseArr = self.infoModel.praise_obj;
        NSMutableArray *people = [NSMutableArray array];
        for (NSDictionary *dd in praiseArr) {
            
//            TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
//            if (em) {
//
//                [people addObject:[TFChangeHelper tfEmployeeToHqEmployee:em]];
//            }
            [people addObject:dd];
        }
        
        self.praises = people;
        
        [cell refreshCellWithPeoples:self.praises];
        cell.delegate = self;
        return cell;
        
    }
    else {
    
        if (indexPath.row == 0) {
            
            TFShareRelatedCell *cell = [TFShareRelatedCell shareRelatedCellWithTableView:tableView];
            cell.delegate = self;
            if (self.tasks.count) {
                cell.bottomLine.hidden = NO;
            }else{
                cell.bottomLine.hidden = YES;
            }
            
            if (![self.infoModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //不是本人创建
                cell.relatedBtn.hidden = YES;
            }else{
                cell.relatedBtn.hidden = NO;
            }
            return cell;
        }
        else {
            
            TFRelatedModuleDataCell *cell = [TFRelatedModuleDataCell relatedModuleDataCellWithTableView:tableView];
            
            cell.delegate = self;
            
            if (![self.infoModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //不是本人创建
                [cell refreshCellWithTasks:self.tasks frames:self.frames auth:NO];
            }else{
                [cell refreshCellWithTasks:self.tasks frames:self.frames auth:YES];
            }
            
            return cell;
        }
        
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
            att.fieldLabel = @"内容";
            att.content = self.infoModel.share_content;
            att.contentAction = ^(NSString *parameter) {
                
                self.infoModel.share_content = parameter;
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:att animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (self.type == 1) {
            
            TFProjectShareMemberController *member = [[TFProjectShareMemberController alloc] init];
            member.peoples = self.shares;
            member.naviTitle = @"分享人";
            [self.navigationController pushViewController:member animated:YES];
        }
        
    }
    else if (indexPath.section == 2) {
        
        TFProjectShareMemberController *member = [[TFProjectShareMemberController alloc] init];
        member.peoples = self.praises;
        member.naviTitle = @"点赞人";
        [self.navigationController pushViewController:member animated:YES];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            return self.webViewHeight;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 80;
        }else{
            return 60;
        }
    }
    if (indexPath.section == 2) {
        
        if (self.type == 0) { //新增没有点赞
            return 0;
        }
        else {
            return 45;
        }

    }
    if (indexPath.section == 3) {
        
        if (self.type == 0) {
            
            return 0;
        }
        else {
            
            if (indexPath.row > 0) {
                
                if (![self.infoModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //不是本人创建
                    
                    return [TFRelatedModuleDataCell refreshRelatedModuleHeightWithFrames:self.frames auth:NO];
                }else{
                    return [TFRelatedModuleDataCell refreshRelatedModuleHeightWithFrames:self.frames auth:YES];
                }
            }
        }
        
        
    }
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 12;
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

#pragma mark TFEmailsDetailWebViewCellDelegate
- (void)giveWebViewContentForAddEmail:(NSString *)content {
    
    self.sendModel.content = self.infoModel.share_content;
    if (!self.sendModel.content || [self.sendModel.content isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"内容不能为空" toView:self.view];
        return;
    }
    
    if (self.type == 0) { //新增

        self.sendModel.id = self.proId;
        
        //默认值
//        self.sendModel.shareStatus = @0;
        self.sendModel.submitStatus = @0;
        
        [self.projectTaskBL requestProjectShareControllerSaveWithModel:self.sendModel];
        
    }
    else {
        
        self.sendModel.id = self.infoModel.id;
        self.sendModel.shareStatus = @([self.infoModel.share_status integerValue]);
        self.sendModel.submitStatus = @0;
//        self.sendModel.shareIds = self.infoModel.share_ids;
        
        [self.projectTaskBL requestProjectShareControllerEditWithModel:self.sendModel];
    }

}

- (void)getWebViewHeight:(CGFloat)height{
    
    self.webViewHeight = height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.on) {
        if (self.type == 0) {
            self.sendModel.shareStatus = @1;
        }else{
            self.infoModel.share_status = @"1";
        }
    }else{
        if (self.type == 0) {
            self.sendModel.shareStatus = @0;
        }else{
            self.infoModel.share_status = @"0";
        }
    }
}

#pragma mark TFRelatedModuleDataCellDelegate(长按取消)
- (void)deleteRelatedDataWithIndex:(NSIndexPath *)indexPath {
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    self.cancelIndex = indexPath.row;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认取消该关联吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
    
}
//查看关联详情
- (void)didSelectRelatedWithIndex:(NSIndexPath *)indexPath {

        
    TFProjectRowModel *model = self.tasks[indexPath.row];
    
    // 1备忘录 2任务 3自定义模块数据 4审批数据
    if ([model.dataType isEqualToNumber:@1]) {
        
        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        note.type = 1;
//        note.noteId = model.id;
        note.noteId = model.bean_id;
        [self.navigationController pushViewController:note animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@2]){
        
        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = model.projectId;
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            if (model.task_id) {// 子任务
                detail.taskType = 3;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 2;
            }
        }else{// 项目任务
            if (model.task_id) {// 子任务
                detail.taskType = 1;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 0;
            }
        }
//        detail.dataId = model.quoteTaskId;
        detail.dataId = model.bean_id;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([model.dataType isEqualToNumber:@3]){
        
        //        TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = model.bean_name;
        detail.dataId = model.bean_id;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else{
        TFApprovalListItemModel *approval = [[TFApprovalListItemModel alloc] init];
        approval.id = model.id;
        approval.task_id = [model.task_id description];
        approval.task_key = model.task_key;
        approval.task_name = model.task_name;
//        approval.approval_data_id = model.approval_data_id;
        approval.approval_data_id = [model.bean_id description];
        approval.module_bean = model.module_bean;
        approval.begin_user_name = model.begin_user_name;
        approval.begin_user_id = model.begin_user_id;
        approval.process_definition_id = model.process_definition_id;
        approval.process_key = model.process_key;
        approval.process_name = model.process_name;
        approval.process_status = model.process_status;
        approval.status = model.status;
        approval.process_field_v = model.process_field_v;
        
        TFApprovalDetailController *detail = [[TFApprovalDetailController alloc] init];
        detail.approvalItem = approval;
        detail.listType = 1;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 0x2018) {
        
        if (buttonIndex == 1) {
            
            [self.projectTaskBL requestProjectShareControllerDeleteWithId:self.infoModel.id];
        }
    }else{
        
        if (buttonIndex == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            TFProjectRowModel *row = self.tasks[self.cancelIndex];
//            [self.projectTaskBL requestProjectShareControllerCancleRelationWithId:[NSString stringWithFormat:@"%@",row.taskInfoId]];
            [self.projectTaskBL requestProjectShareControllerCancleRelationWithId:[NSString stringWithFormat:@"%@",row.bean_id]];
        }
    }
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {

    NSInteger index = textView.tag-0x123;
    
    if (index == 0) {
        
        if (textView.text.length > 100) {
            
            textView.text = [textView.text substringToIndex:100];
            [MBProgressHUD showError:@"不能超过100个字！" toView:self.view];
        }
        self.sendModel.title = textView.text;
        
    }
    else if (index == 1) {
    
        self.sendModel.content = textView.text;
    }
}

#pragma mark TFAddPeoplesCellDelegate <选择分享人>
- (void)addPersonel:(NSInteger)index {

//    TFMutilStyleSelectPeopleController *select = [[TFMutilStyleSelectPeopleController alloc] init];
//
//    select.selectType = 1;
//    select.defaultPoeples = self.shares;
//    select.actionParameter = ^(id parameter) {
//
//        self.shares = parameter;
//
//        for (TFEmployModel *model in parameter) {
//
//            self.sendModel.shareIds = [self.sendModel.shareIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
//        }
//
//        self.sendModel.shareIds = [self.sendModel.shareIds substringFromIndex:1];
//
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//
//    };
//
//    [self.navigationController pushViewController:select animated:YES];
    if (self.type == 1) {
        
        TFProjectShareMemberController *member = [[TFProjectShareMemberController alloc] init];
        member.peoples = self.shares;
        member.naviTitle = @"分享人";
        [self.navigationController pushViewController:member animated:YES];
        
        return;
    }
    
    TFProjectMenberManageController *member = [[TFProjectMenberManageController alloc] init];
    member.type = 1;
    member.projectId = self.proId;
    member.isMulti = YES;
    member.selectPeoples = self.shares;
    member.parameterAction = ^(NSArray *parameter) {

//        NSMutableArray *arr = [NSMutableArray array];
//        for (TFProjectPeopleModel *proModel in parameter) {
//
//            HQEmployModel *em = [[HQEmployModel alloc] init];
//            em.employee_id = proModel.employee_id;
//            em.employee_name = proModel.employee_name;
//            em.photograph = proModel.employee_pic;
//            [arr addObject:em];
//        }
      
        self.shares = parameter;
        for (HQEmployModel *model in self.shares) {

            self.sendModel.shareIds = [self.sendModel.shareIds stringByAppendingString:[NSString stringWithFormat:@",%@",model.id]];
        }

        self.sendModel.shareIds = [self.sendModel.shareIds substringFromIndex:1];

        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
    [self.navigationController pushViewController:member animated:YES];
}

#pragma mark  HQTFHeartCellDelegate (点赞)
-(void)heartCellDidClickedHeart:(UIButton *)heartBtn {

    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    if ([self.infoModel.share_praise_status isEqualToNumber:@0]) {
        
        self.infoModel.share_praise_status = @1;
    }
    else {
    
        self.infoModel.share_praise_status = @0;
    }
    
    [self.projectTaskBL requestProjectShareControllerSharePraiseWithId:self.infoModel.id status:self.infoModel.share_praise_status];
    
}

#pragma mark - TFImgDoubleLalImgCellDelegate
-(void)cellDidClickedFirstBtn{
    
    //    [self.projectTaskBL requestTaskHeartPeopleWithTaskId:self.dataId typeStatus:@(self.taskType + 1)];
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    BOOL contain = NO;
    
    for (HQEmployModel *model in self.praises) {
        NSNumber *ID = UM.userLoginInfo.employee.id;
        if ([model.id isEqualToNumber:ID]) {
            contain = YES;
            break;
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.infoModel.share_praise_status isEqualToNumber:@0]) {
        
        self.infoModel.share_praise_status = @1;
    }
    else {
        
        self.infoModel.share_praise_status = @0;
    }
    [self.projectTaskBL requestProjectShareControllerSharePraiseWithId:self.infoModel.id status:self.infoModel.share_praise_status];

}

#pragma mark TFTwoBtnsViewDelegate (评论、动态)
- (void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    if (index == 0) { //评论
        
        TFCustomerCommentController *commentVC = [[TFCustomerCommentController alloc] init];
        
        commentVC.bean = @"dynamic_type_share";
        commentVC.id = self.infoModel.id;
        commentVC.refreshAction = ^(id parameter) {
            

        };
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }
    
    else {
//
        TFCustomerDynamicController *dynamicVC = [[TFCustomerDynamicController alloc] init];
        dynamicVC.bean = @"dynamic_type_share";
        dynamicVC.id = self.infoModel.id;
        [self.navigationController pushViewController:dynamicVC animated:YES];
    }
    
    if (index == 2) {
    
        
        
    }
    
}

#pragma mark ---完成
- (void)finishAction {

    if ([self.sendModel.title isEqualToString:@""] || self.sendModel.title ==nil) {
        
        [MBProgressHUD showError:@"标题不能为空！" toView:self.view];
        return;
    }
    TFEmailsDetailWebViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    [cell getEmailContentFromWebview];
    
}

- (void)moreAction {

//    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"编辑",@"删除", nil];
//
//    [sheet show];
    
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
    
    
    NSString *str = @"置顶";
    if ([self.infoModel.share_top_status isEqualToString:@"1"]) {
        str = @"取消置顶";
    }
    
    if (![self.infoModel.create_by isEqualToNumber:UM.userLoginInfo.employee.id]) { //不是本人创建
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:str,nil];
        sheet.tag = 0x222;
        
        [sheet showInView:self.view];
        
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"编辑",str,@"删除",nil];
    sheet.tag = 0x333;
    
    [sheet showInView:self.view];
    
}

#pragma mark TFShareRelatedCellDelegate(添加关联)
- (void)addRelatedContent {
    
    if (![self.projectModel.project_status isEqualToString:@"0"]) {
        if ([self.projectModel.project_status isEqualToString:@"1"]) {// 归档
            
            [MBProgressHUD showError:@"项目已归档" toView:self.view];
        }
        if ([self.projectModel.project_status isEqualToString:@"2"]) {// 暂停
            
            [MBProgressHUD showError:@"项目已暂停" toView:self.view];
        }
        return;
    }
//    [self.projectTaskBL requestProjectShareControllerQueryRelationListWithData:self.shareId];
    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
    enter.type = 3;
    enter.projectId = self.proId;
    enter.parameterAction = ^(NSDictionary *parameter) {
        
        self.relatedModel.projectId = self.infoModel.project_id;
        self.relatedModel.relation_id = [parameter valueForKey:@"data"];
        self.relatedModel.module_id = [parameter valueForKey:@"moduleId"];
        self.relatedModel.module_name = [parameter valueForKey:@"moduleName"];
        self.relatedModel.bean_name = [parameter valueForKey:@"bean"];
        self.relatedModel.bean_type = [parameter valueForKey:@"beanType"];
        
        self.relatedModel.share_id = self.infoModel.id;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestProjectShareControllerSaveRelationWithModel:self.relatedModel];
    };
    [self.navigationController pushViewController:enter animated:YES];
}

#pragma mark FDActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (actionSheet.tag == 0x222) {
        
        if (buttonIndex == 0) {
            
            [self.projectTaskBL requestProjectShareControllerShareStickWithId:self.infoModel.id status:[self.infoModel.share_top_status isEqualToString:@"1"] ? @0 : @1];
        }
        return;
    }
    switch (buttonIndex) {
        case 0: //编辑
        {
        
            self.type = 2;
            
            self.navigationItem.title = @"编辑分享";
            
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(finishAction) text:@"完成" textColor:kUIColorFromRGB(0x909090)];
            
            [self.tableView reloadData];
            
            self.bottomView.hidden = YES;
            
        }
            break;
        
        case 1://置顶
        {

            [self.projectTaskBL requestProjectShareControllerShareStickWithId:self.infoModel.id status:[self.infoModel.share_top_status isEqualToString:@"1"] ? @0 : @1];
        }
            break;
            
        case 2: //删除
        {
//            [AlertView showAlertView:@"提示" msg:@"确定要删除该分享吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
//
//            } onRightTouched:^{
//                [self.projectTaskBL requestProjectShareControllerDeleteWithId:self.infoModel.id];
//            }];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该分享吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x2018;
            [alert show];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectShareControllerSave) { //新增
        
        [MBProgressHUD showError:@"添加成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProjectShareListNotification" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerEdit) { //编辑
        
        [MBProgressHUD showError:@"编辑成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerQueryById) { //详情
        
        [self setupBottomView];
        self.infoModel = resp.body;
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerShareStick) {
        
        [MBProgressHUD showError:@"设置成功" toView:self.view];
        self.infoModel.share_top_status = [self.infoModel.share_top_status isEqualToString:@"1"] ? @"0" : @"1";
        if (self.refresh) {
            
            self.refresh();
        }
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerDelete) { //删除
        
        [MBProgressHUD showError:@"删除成功" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerSharePraise) { //点赞
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        BOOL contain = NO;
        
        for (HQEmployModel *model in self.praises) {
            if ([model.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                [self.praises removeObject:model];
                contain = YES;
                break;
            }
        }
        
        if (!contain) {
            HQEmployModel *model = [[HQEmployModel alloc] init];
            model.id = UM.userLoginInfo.employee.id;
            model.employeeName = UM.userLoginInfo.employee.employee_name;
            model.employee_name = UM.userLoginInfo.employee.employee_name;
            model.picture = UM.userLoginInfo.employee.picture;
            [self.praises addObject:model];
        }
        
        [self.projectTaskBL requestProjectShareControllerQueryByIdWithId:self.shareId];
//        [self.tableView reloadData];
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
//
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerQueryRelationList) {
        
        [self.view addSubview:self.tableView];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        NSArray *datas = [dict valueForKey:@"dataList"];
        NSMutableArray<TFProjectRowModel> *tasks = [NSMutableArray<TFProjectRowModel> array];
        NSMutableArray *frames = [NSMutableArray array];
        
        
        for (NSDictionary *taskDict in datas) {
            TFProjectRowModel *task = [HQHelper projectRowWithTaskDict:taskDict];
            
            [tasks addObject:task];
            
            TFProjectRowFrameModel *frame = [[TFProjectRowFrameModel alloc] initBorder];
            frame.projectRow = task;
            [frames addObject:frame];
        }
        
        self.tasks = tasks;
        self.frames = frames;
        
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_projectShareControllerCancleRelation) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tasks removeObjectAtIndex:self.cancelIndex];
        [self.frames removeObjectAtIndex:self.cancelIndex];

        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    if (resp.cmdId == HQCMD_projectShareControllerSaveRelation) {
        
        [self.projectTaskBL requestProjectShareControllerQueryRelationListWithData:self.infoModel.id];
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
