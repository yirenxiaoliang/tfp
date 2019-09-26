//
//  TFCreateProjectController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateProjectController.h"
#import "HQCreatScheduleTitleCell.h"
#import "TFManyLableCell.h"
#import "HQSelectTimeCell.h"
#import "TFTwoBtnsView.h"
#import "TFCreateProjectModel.h"
#import "TFProjectResponsibleCell.h"
#import "TFProjectModelMainController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFSelectDateView.h"
#import "TFProjectTaskBL.h"
#import "HQTFInputCell.h"
#import "TFSelectCalendarView.h"

@interface TFCreateProjectController () <UITableViewDelegate,UITableViewDataSource,TFTwoBtnsViewDelegate,UITextViewDelegate,UIActionSheetDelegate,HQBLDelegate,UIAlertViewDelegate,HQTFInputCellDelegate,UITextFieldDelegate,HQSelectTimeCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** bottomView */
@property (nonatomic, weak) TFTwoBtnsView *bottomView;
/** createProjectModel */
@property (nonatomic, strong) TFCreateProjectModel *createPrjectModel;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** changeStatus */
@property (nonatomic, assign) NSInteger changeStatus;

/** 能否编辑 */
@property (nonatomic, assign) BOOL isEdit;
/** 能否编辑进度 */
@property (nonatomic, assign) BOOL isProgress;
/** 能否编辑状态 */
@property (nonatomic, assign) BOOL isStatus;

/** TFProjectModel *model */
@property (nonatomic, strong) TFProjectModel *detailModel;

/** 权限 */
@property (nonatomic, copy) NSString *privilege;

@end

@implementation TFCreateProjectController

-(BOOL)isStatus{
    
    return [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"9"];
}

-(BOOL)isProgress{
    BOOL progress = NO;
    
    // 状态考虑
    /** 项目状态 （0进行中（启用） 1归档 2暂停 3删除 ）*/
    if (self.createPrjectModel.projectType == 0) {
        // 后期的权限考虑
        progress = [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"13"];
    }else{// 非进行中的
        progress = NO;
    }
    return progress;
}

-(BOOL)isEdit{
    
    BOOL edit = NO;
    
    if (self.type == 0) {
        edit = YES;
    }else{
        
        // 状态考虑
        /** 项目状态 （0进行中（启用） 1归档 2暂停 3删除 ）*/
        if (self.createPrjectModel.projectType == 0) {
            // 后期的权限考虑
            edit = [HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"];
        }else{// 非进行中的
            edit = NO;
        }
    }
    return edit;
}

-(TFCreateProjectModel *)createPrjectModel{
    if (!_createPrjectModel) {
        _createPrjectModel = [[TFCreateProjectModel alloc] init];
        
        if (self.type == 0) {
            
            HQEmployModel *model = [[HQEmployModel alloc] init];
            model.id = UM.userLoginInfo.employee.id;
            model.employeeName = UM.userLoginInfo.employee.employee_name;
            model.employee_name = UM.userLoginInfo.employee.employee_name;
            model.picture = UM.userLoginInfo.employee.picture;
            _createPrjectModel.responsible = model;
        }
        _createPrjectModel.projectId = self.projectId;
    }
    return _createPrjectModel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.type == 0) {
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:GrayTextColor];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestGetProjectRoleAndAuthWithProjectId:self.projectId employeeId:UM.userLoginInfo.employee.id];
    
    if (self.type == 0) {
        
        [self setupTableView];
    }
    [self setupNavigation];
    if (self.type == 1) {
        // 请求详情
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestGetProjectDetailWithProjectId:self.projectId];
    }
}


#pragma mark - 底部View
- (void)setupBottomView{
    
    [self.bottomView removeFromSuperview];
    
    NSMutableArray<TFTwoBtnsModel> *arr = [NSMutableArray<TFTwoBtnsModel> array];
    
    if (self.createPrjectModel.projectType == 0) {
        
        for (NSInteger i = 0; i < 3; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            model.font = FONT(18);
            model.color = HexColor(0x666666);
            
            if (0 == i){
                model.title = @"归档";
                model.image = @"projectArchive";
            }
            
            if (1 == i){
                model.title = @"暂停";
                model.image = @"projectPause";
            }
            if (2 == i){
                model.title = @"删除";
                model.image = @"projectDelete";
            }
            [arr addObject:model];
        }
    }else{
        
        for (NSInteger i = 0; i < 1; i ++) {
            
            TFTwoBtnsModel *model = [[TFTwoBtnsModel alloc] init];
            model.font = FONT(18);
            model.color = HexColor(0x666666);
            
            if (0 == i){
                model.title = @"启用";
                model.image = @"projectStart";
            }
            
            [arr addObject:model];
        }
        
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    TFTwoBtnsView *bottomView = [[TFTwoBtnsView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomHeight,SCREEN_WIDTH,TabBarHeight} withModels:arr];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];

}
#pragma mark - TFTwoBtnsViewDelegate
-(void)twoBtnsView:(TFTwoBtnsView *)twoBtnsView didSelectIndex:(NSInteger)index{
    
    
    if (!self.isStatus) {
        
        [MBProgressHUD showError:@"无权限修改项目状态" toView:self.view];
        return;
    }
    if (self.createPrjectModel.projectType == 0) {
        
        if (index == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要归档该项目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x111+index;
            [alert show];
        }else if (index == 1){
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要暂停该项目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 0x111+index;
            alert.delegate = self;
            [alert show];
        }else{
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要删除该项目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.delegate = self;
            alert.tag = 0x111+index;
            [alert show];
        }
        
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定要启用该项目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 0x444;
        [alert show];
    }
}

#pragma mark - 导航
- (void)setupNavigation{
    
    if (self.type == 0) {
        self.navigationItem.title = @"新建项目";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GrayTextColor];
    }
    
    if (self.type == 1) {
        
        self.navigationItem.title = @"项目设置";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GrayTextColor];
        
    }
}


- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    [self.view endEditing:YES];
    
    // 必填
    if (!self.createPrjectModel.title || [self.createPrjectModel.title isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入项目名称" toView:self.view];
        return;
    }
    if (self.createPrjectModel.endTime <= 0) {
        [MBProgressHUD showError:@"请选择截止时间" toView:self.view];
        return;
    }
    
    if ([self.createPrjectModel.endTime longLongValue] < [HQHelper getNowTimeSp]) {
        
        UIAlertView *alert = nil;
        if (self.type == 0) {
           alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"截止时间小于当前时间，请确认是否创建?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"创建", nil];
        }else{
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"截止时间小于当前时间，请确认是否保存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        }
        alert.delegate = self;
        alert.tag = 0x999;
        [alert show];
        
    }else{
        
        [self saveData];
        
    }
    
}

- (void)saveData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {// 新建
        [self.projectTaskBL requestCreateProjectWithDict:self.createPrjectModel.dict];
    }else{
        
        [self.projectTaskBL requestUpdateProjectDetailWithDict:self.createPrjectModel.dict];
        
    }
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x999) {
        
        if (buttonIndex == 1) {
            
            [self saveData];
        }
    }else{
        
        if (buttonIndex == 1) {
            
            if (self.createPrjectModel.projectType == 0) {
                NSInteger index = alertView.tag - 0x111;
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.projectTaskBL requestChangeProjectStatusWithProjectId:self.projectId status:@(index + 1)];
                self.changeStatus = index + 1;
            }else{
                
                [self.projectTaskBL requestChangeProjectStatusWithProjectId:self.projectId status:@0];
                self.changeStatus = 0;
            }
        }
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_getProjectRoleAndAuth) {
        
        NSDictionary *dict = [resp.body valueForKey:@"priviledge"];
        self.privilege = [dict valueForKey:@"priviledge_ids"];
        
        if (!self.isEdit && !self.isProgress) {
            self.navigationItem.rightBarButtonItem = nil;
        }
        if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
            self.bottomView.hidden = YES;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }else{
            self.bottomView.hidden = NO;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57, 0);
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_createProject) {
        
        if (self.refreshAction) {
            [self.navigationController popViewControllerAnimated:NO];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:resp.body[kData]];
            if (self.createPrjectModel.projectModel.templateId) {
                [dict setObject:self.createPrjectModel.projectModel.templateId forKey:@"temp_id"];
            }
            self.refreshAction(dict);
        }
    }
    
    if (resp.cmdId == HQCMD_updateProject) {
        if (self.refreshAction) {
            self.refreshAction(self.createPrjectModel.title);
        }
        if (self.progressAction) {
            NSMutableDictionary *dd = [NSMutableDictionary dictionary];
            if (self.createPrjectModel.project_progress_status) {
                [dd setObject:self.createPrjectModel.project_progress_status forKey:@"project_progress_status"];
            }
            if (self.createPrjectModel.project_progress_number) {
                [dd setObject:self.createPrjectModel.project_progress_number forKey:@"project_progress_number"];
            }
            if (self.createPrjectModel.project_progress_content) {
                [dd setObject:self.createPrjectModel.project_progress_content forKey:@"project_progress_content"];
            }
            self.progressAction(dd);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_getProjecDetail) {
        
        TFProjectModel *model = resp.body;
        self.detailModel = resp.body;
        
        self.createPrjectModel.title = model.name;
        self.createPrjectModel.visible = [model.visual_range_status integerValue];
        self.createPrjectModel.projectType = [model.project_status integerValue];
        HQEmployModel *ee = [[HQEmployModel alloc] init];
        ee.id = model.leader;
        ee.employee_name = model.leader_name;
        ee.picture = model.leader_pic;
        self.createPrjectModel.responsible = ee;
        self.createPrjectModel.startTime = model.start_time;
        self.createPrjectModel.endTime = model.end_time;
        self.createPrjectModel.descript = model.note;
        self.createPrjectModel.project_progress_status = model.project_progress_status;
        self.createPrjectModel.project_progress_content = IsStrEmpty(model.project_progress_content)?@0:model.project_progress_content;
        self.createPrjectModel.task_count = model.task_count;
        self.createPrjectModel.task_complete_count = model.task_complete_count;
        self.createPrjectModel.project_progress_number = model.project_progress_number;
        
        [self setupTableView];
        [self setupBottomView];
        if (self.privilege) {
            
            if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                self.bottomView.hidden = YES;
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }else{
                self.bottomView.hidden = NO;
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57, 0);
            }
        }
    }
    
    if (resp.cmdId == HQCMD_changeProjectStatus) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"修改成功" toView:self.view];
        
        self.createPrjectModel.projectType = self.changeStatus;
        self.projectModel.project_status = [NSString stringWithFormat:@"%ld",self.changeStatus];
        [self setupBottomView];
        [self.tableView reloadData];
        if (self.privilege) {
            if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                self.bottomView.hidden = YES;
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            }else{
                self.bottomView.hidden = NO;
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 57, 0);
            }
        }
        
        if (self.changeStatus == 3) {// 删除
            if (self.deleteAction) {
                [self.navigationController popViewControllerAnimated:NO];
                self.deleteAction();
            }
        }
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 5;
    }else if (section == 2){
        return 4;
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"项目名称25个字以内（必填）";
        cell.textVeiw.text = self.createPrjectModel.title;
        cell.textVeiw.delegate = self;
        cell.textVeiw.userInteractionEnabled = self.isEdit;
        return cell;
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"可见范围";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            cell.time.text = self.createPrjectModel.visible == 0 ? @"不公开" : @"公开";
            cell.arrowShowState = self.isEdit;
            cell.topLine.hidden = YES;
            cell.arrowType = NO;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"状态";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            if (self.createPrjectModel.projectType == 0) {
                cell.time.text = @"进行中";
            }else if (self.createPrjectModel.projectType == 1){
                cell.time.text = @"已归档";
            }else if (self.createPrjectModel.projectType == 2){
                cell.time.text = @"已暂停";
            }else {
                cell.time.text = @"已删除";
            }
            cell.arrowShowState = NO;
            cell.topLine.hidden = NO;
            cell.arrowType = NO;
            return cell;
            
        }else if (indexPath.row == 2){
            
            TFProjectResponsibleCell *cell = [TFProjectResponsibleCell projectResponsibleCellWithTableView:tableView];
            cell.titleLabel.text = @"负责人";
//            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.createPrjectModel.responsible.picture] placeholderImage:PlaceholderHeadImage];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:self.createPrjectModel.responsible.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image == nil) {
                    [cell.headImage setTitle:[HQHelper nameWithTotalName:self.createPrjectModel.responsible.employee_name] forState:UIControlStateNormal];
                    cell.headImage.backgroundColor = HeadBackground;
                }else{
                    [cell.headImage setTitle:@"" forState:UIControlStateNormal];
                    cell.headImage.backgroundColor = WhiteColor;
                    
                }
            }];
            cell.enterImage.hidden = !self.isEdit;
            cell.topLine.hidden = NO;
            return cell;
        }else if (indexPath.row == 3){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"项目进度";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            if ([self.createPrjectModel.project_progress_status isEqualToString:@"1"]) {
                cell.time.text = @"手动输入项目进度";
            }else{
                cell.time.text = @"根据任务完成进度自动计算";
            }
            cell.arrowShowState = self.isEdit;
            cell.topLine.hidden = NO;
            return cell;
            
        }else{
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"";
            cell.textField.textAlignment = NSTextAlignmentRight;
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textFieldTrailW.constant = 24;
            [cell.enterBtn setImage:nil forState:UIControlStateNormal];
            cell.delegate = self;
            cell.textField.delegate = self;
            cell.textField.tag = 0x999;
            if ([self.createPrjectModel.project_progress_status isEqualToString:@"1"]) {
                cell.textField.placeholder = @"请输入项目进度";
                cell.textField.text = [NSString stringWithFormat:@"%@",self.createPrjectModel.project_progress_content];
                cell.textField.userInteractionEnabled = self.isProgress;
            }else{
                cell.textField.placeholder = @"";
                cell.textField.userInteractionEnabled = NO;
                cell.textField.text = [NSString stringWithFormat:@"%@",self.createPrjectModel.project_progress_number];
            }
            [cell.enterBtn setTitle:@"%" forState:UIControlStateNormal];
            [cell.enterBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
            cell.topLine.hidden = YES;
            return cell;
        }
    }
    
    if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"开始时间";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            cell.time.text = [HQHelper nsdateToTime:[self.createPrjectModel.startTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
            cell.arrowShowState = self.isEdit;
            cell.topLine.hidden = YES;
            cell.arrowType = NO;
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = self.isEdit;
            if (self.type != 1) {
                
                if (self.createPrjectModel.endTime <= 0) {
                    
                    cell.time.text = @"必填";
                    cell.time.textColor = PlacehoderColor;
                }else{
                    
                    cell.time.textColor = BlackTextColor;
                    cell.time.text = [HQHelper nsdateToTime:[self.createPrjectModel.endTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
                }
                
            }else{
                
                cell.time.text = [HQHelper nsdateToTime:[self.createPrjectModel.endTime longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
            }
            cell.topLine.hidden = NO;
            cell.arrowType = NO;
            return cell;
        }else if (indexPath.row == 2){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"项目模板";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = self.isEdit;
            cell.time.text = self.createPrjectModel.projectModel.templateName;
            cell.topLine.hidden = NO;
            if (self.isEdit) {
                
                if (!self.createPrjectModel.projectModel.templateId || [self.createPrjectModel.projectModel.templateId isEqualToNumber:@0]) {
                    cell.arrowType = NO;
                }else{
                    cell.arrowType = YES;
                }
            }
            cell.delegate = self;
            cell.arrow.tag = 0x4444;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"可见范围";
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrowShowState = YES;
            cell.time.text = self.createPrjectModel.visible == 0 ? @"不公开" : @"公开";
            cell.arrowShowState = self.isEdit;
            cell.topLine.hidden = NO;
            cell.arrowType = NO;
            return cell;
        }
    }
    
    if (indexPath.section == 3) {
        TFManyLableCell *cell = [TFManyLableCell creatManyLableCellWithTableView:tableView];
        cell.titleBgView.backgroundColor = BackGroudColor;
        cell.structure = @"0";
        cell.requireLabel.hidden = YES;
        cell.titleLab.text = @"项目描述";
        cell.textVeiw.placeholder = @"请输入500字以内项目描述（选填）";
        cell.textVeiw.text = self.createPrjectModel.descript;
        cell.textVeiw.delegate = self;
        cell.textVeiw.tag = 0x123;
        cell.textVeiw.userInteractionEnabled = self.isEdit;
        return cell;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type != 0) {
        
        if (self.createPrjectModel.projectType == 1) {
            [MBProgressHUD showError:@"归档项目无法修改" toView:self.view];
            return;
        }else if (self.createPrjectModel.projectType == 2){
            [MBProgressHUD showError:@"暂停项目无法修改" toView:self.view];
            return;
        }else if (self.createPrjectModel.projectType == 3){
            [MBProgressHUD showError:@"删除项目无法修改" toView:self.view];
            return;
        }
    }
    if (indexPath.section == 0) {
        if (self.type != 0) {
            
            if (self.createPrjectModel.projectType == 0) {
                // 后期的权限考虑
                if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                    [MBProgressHUD showError:@"无权限修改项目信息" toView:self.view];
                    return;
                }
            }
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.type != 0) {
                
                if (self.createPrjectModel.projectType == 0 ) {
                    // 后期的权限考虑
                    if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                        [MBProgressHUD showError:@"无权限修改项目信息" toView:self.view];
                        return;
                    }
                }
            }
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不公开",@"公开", nil];
            sheet.tag = 0x333;
            [sheet showInView:self.view];
        }
        if (indexPath.row == 2) {
            
            if (self.type != 0) {
                
                if (self.createPrjectModel.projectType == 0) {
                    // 后期的权限考虑
                    if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                        [MBProgressHUD showError:@"无权限修改项目信息" toView:self.view];
                        return;
                    }
                }
            }
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = YES;
            scheduleVC.defaultPoeples = @[self.createPrjectModel.responsible];
            scheduleVC.actionParameter = ^(NSArray *parameter) {
                
                if (parameter.count) {
                    self.createPrjectModel.responsible = parameter[0];
                }
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
        }
        if (indexPath.row == 3) {// 项目进度
            
            if (self.type != 0) {
                if (self.createPrjectModel.projectType == 0) {
                    // 后期的权限考虑
                    if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"13"]) {// 修改进度
                        [MBProgressHUD showError:@"无权限修改项目进度" toView:self.view];
                        return;
                    }
                }
            }
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"根据任务完成进度自动计算",@"手动输入项目进度", nil];
            sheet.tag = 0x444;
            [sheet showInView:self.view];
            
        }
        if (indexPath.row == 4) {
            
            if (self.type != 0) {
                if (self.createPrjectModel.projectType == 0) {
                    // 后期的权限考虑
                    if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"13"]) {// 修改进度
                        [MBProgressHUD showError:@"无权限修改项目进度" toView:self.view];
                        return;
                    }
                }
            }
            
        }
    }
    
    
    if (indexPath.section == 2) {
        
        if (self.type != 0) {
            if (self.createPrjectModel.projectType == 0) {
                // 后期的权限考虑
                if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                    [MBProgressHUD showError:@"无权限修改项目信息" toView:self.view];
                    return;
                }
            }
        }
        if (indexPath.row == 0) {
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:[self.createPrjectModel.startTime longLongValue]<=0?[HQHelper getNowTimeSp]:[self.createPrjectModel.startTime longLongValue] onRightTouched:^(NSString *time) {

                self.createPrjectModel.startTime = @([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]);

                [self.tableView reloadData];
            }];
            
            
//            [TFSelectCalendarView selectCalendarViewWithType:DateViewType_HourMinute timeSp:self.createPrjectModel.startTime<=0?[HQHelper getNowTimeSp]:self.createPrjectModel.startTime onRightTouched:^(NSString *time) {
//
//                self.createPrjectModel.startTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
//
//                [self.tableView reloadData];
//
//            }];
            
        }
        if (indexPath.row == 1) {
            
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:self.createPrjectModel.endTime<=0?[HQHelper getNowTimeSp]:[self.createPrjectModel.endTime longLongValue] onRightTouched:^(NSString *time) {
                
                self.createPrjectModel.endTime = @([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]);
                
                [self.tableView reloadData];
            }];
            
            
//            [TFSelectCalendarView selectCalendarViewWithType:DateViewType_HourMinute timeSp:self.createPrjectModel.endTime<=0?[HQHelper getNowTimeSp]:self.createPrjectModel.endTime onRightTouched:^(NSString *time) {
//
//                self.createPrjectModel.endTime = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
//                [self.tableView reloadData];
//
//            }];
        }
        if (indexPath.row == 2) {
            TFProjectModelMainController *projectModel = [[TFProjectModelMainController alloc] init];
            projectModel.parameter = ^(id parameter) {
                self.createPrjectModel.projectModel = parameter;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:projectModel animated:YES];
        }
        
        if (indexPath.row == 3) {
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不公开",@"公开", nil];
            sheet.tag = 0x333;
            [sheet showInView:self.view];
        }
    }
    
    if (indexPath.section == 3) {
        
        if (self.type != 0) {
            if (self.createPrjectModel.projectType == 0) {
                // 后期的权限考虑
                if (![HQHelper haveProjectAuthWithPrivilege:self.privilege auth:@"7"]) {// 修改信息
                    [MBProgressHUD showError:@"无权限修改项目信息" toView:self.view];
                    return;
                }
            }
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x333) {
        self.createPrjectModel.visible = buttonIndex;
        [self.tableView reloadData];
    }
    if (actionSheet.tag == 0x444) {
        
//        self.createPrjectModel.project_progress_status = [NSString stringWithFormat:@"%ld",buttonIndex];
        self.createPrjectModel.project_progress_status = @(buttonIndex);
        if (buttonIndex == 0) {
            [self.projectTaskBL requsetUpdateProjectProgressWithProjectId:self.projectId projectProgressStatus:@0 projectProgressContent:@([self.createPrjectModel.project_progress_content integerValue])];
        }else{
//            self.createPrjectModel.project_progress_content = nil;
        }
        [self.tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 80;
    }else if (indexPath.section == 3){
        return 200;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            if (self.type == 1) {
                return 0;
            }
            
        }else if (indexPath.row == 1){
            
            if (self.type == 0) {
                return 0;
            }
        }else if (indexPath.row == 2){
            
        }else{
            
            if (self.type == 0) {
                return 0;
            }
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            if (self.type == 0) {
                return 0;
            }
            
        }else if (indexPath.row == 1){
            
        }else if (indexPath.row == 2){
            if (self.type == 1) {
                return 0;
            }
        }else{
            if (self.type == 0) {
                return 0;
            }
        }
    }
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
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

#pragma mark - HQSelectTimeCellDelegate
-(void)arrowClicked:(NSInteger)index section:(NSInteger)section{
    
    if (index == 0x4444) {
        
        self.createPrjectModel.projectModel.templateId = @0;
        self.createPrjectModel.projectModel.templateName = nil;
        [self.tableView reloadData];
    }
}

#pragma mark - UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分  
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
       
        if (textView.tag == 0x123) {// 描述
            
            if (textView.text.length > 500) {
                
                [MBProgressHUD showError:@"最多500字" toView:KeyWindow];
                textView.text = [textView.text substringToIndex:500];
            }
            
            self.createPrjectModel.descript = textView.text;
            
        }else{
            if (textView.text.length > 25) {
                
                [MBProgressHUD showError:@"最多25字" toView:KeyWindow];
                textView.text = [textView.text substringToIndex:25];
            }
            self.createPrjectModel.title = textView.text;
        }
        
    }
    
}

#pragma mark - HQTFInputCellDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 0x999) {
        
        if (string.length) {
            if (![string haveNumber]) {
                
                [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                return NO;
            }else{
                if ([[textField.text stringByAppendingString:string] integerValue]>100) {
                    [MBProgressHUD showError:@"不可大于100%" toView:self.view];
                    return NO;
                }
            }
        }
    }
    return YES;
}

-(void)inputCellWithTextField:(UITextField *)textField{
    
    self.createPrjectModel.project_progress_content = @([textField.text integerValue]);
    
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
