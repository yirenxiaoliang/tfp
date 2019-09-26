//
//  TFAddAprrovalListController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/15.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddAprrovalListController.h"
#import "TFAtdOneTFCell.h"
#import "TFAddPCAprrovalCell.h"
#import "TFApprovalModuleController.h"
#import "TFAttendanceBL.h"
#import "TFAttendenceFieldController.h"
#import "TFAttendenceFieldModel.h"

@interface TFAddAprrovalListController ()<UITableViewDelegate,UITableViewDataSource,TFAtdOneTFCellDelegate,UIActionSheetDelegate,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;
//修正状态
@property (nonatomic, copy) NSString *statusStr;
//计算单位
@property (nonatomic, copy) NSString *unitStr;


@property (nonatomic, strong) NSMutableArray *fields;

@property (nonatomic, strong) TFAttendanceBL *attendaceBL;

@end

@implementation TFAddAprrovalListController
-(NSMutableArray *)fields{
    if (!_fields) {
        _fields = [NSMutableArray array];
    }
    return _fields;
}
-(TFReferenceApprovalModel *)model{
    if (!_model) {
        _model = [[TFReferenceApprovalModel alloc] init];
        _model.duration_unit = @"0";
        _model.relevance_status = @"0";
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.attendaceBL = [TFAttendanceBL build];
    self.attendaceBL.delegate = self;
   
    [self setNavi];
    [self setupTableView];
    if (self.type == 1) {
        [self.attendaceBL requestApprovalFieldWithBean:self.model.relevance_bean];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceReferenceApprovalCreate) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"创建成功" toView:KeyWindow];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    if (resp.cmdId == HQCMD_attendanceReferenceApprovalUpdate) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"修改成功" toView:KeyWindow];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    if (resp.cmdId == HQCMD_attendanceApprovalModuleField) {
        
        self.fields = resp.body;
        if (self.type == 1) {
            for (TFAttendenceFieldModel *model in self.fields) {
                if ([self.model.start_time_field isEqualToString:model.field_name]) {
                    self.model.start_time_name = model.field_label;
                }
                if ([self.model.end_time_field isEqualToString:model.field_name]) {
                    self.model.end_time_name = model.field_label;
                }
                if ([self.model.duration_field isEqualToString:model.field_name]) {
                    self.model.duration_name = model.field_label;
                }
            }
        }else{
            self.model.end_time_field = @"";
            self.model.start_time_field = @"";
            self.model.duration_field = @"";
        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

- (void)setNavi {
    
    if (self.type == 0) {
        self.navigationItem.title = @"添加审批单";
    }else{
        self.navigationItem.title = @"修改审批单";
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(saveAction) text:@"保存" textColor:GreenColor];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
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
    if ([self.model.relevance_status integerValue] == 0) {
        return 3;
    }
    if ([self.model.relevance_status integerValue] == 1) {
        return 4;
    }
    return 6;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        TFAtdOneTFCell *cell = [TFAtdOneTFCell atdOneTFCellWithTableView:tableView];
        
        cell.requireLab.hidden = NO;
        cell.titleLab.text = @"关联审批单";
        cell.contentTF.placeholder = @"请选择";
        [cell.enterBtn setTitle:@"设置" forState:UIControlStateNormal];
        cell.delegate = self;
        cell.tag = 1001;
        cell.contentTF.text = self.model.relevance_title;
        cell.topLine.hidden = YES;
        return cell;
    }
    else if (indexPath.row == 1) {
        
        TFAtdOneTFCell *cell = [TFAtdOneTFCell atdOneTFCellWithTableView:tableView];
        
        cell.requireLab.hidden = NO;
        cell.titleLab.text = @"修正状态";
        cell.contentTF.placeholder = @"请选择";
        [cell.enterBtn setTitle:@"设置" forState:UIControlStateNormal];
        cell.delegate = self;
        cell.tag = 1002;
        NSString *str = @"缺卡";
        if ([self.model.relevance_status integerValue] == 1) {
            str = @"请假";
        }else if ([self.model.relevance_status integerValue] == 2){
            str = @"加班";
        }else if ([self.model.relevance_status integerValue] == 3){
            str = @"出差";
        }else if ([self.model.relevance_status integerValue] == 4){
            str = @"销假";
        }else if ([self.model.relevance_status integerValue] == 5){
            str = @"外出";
        }
        cell.contentTF.text = str;
        cell.topLine.hidden = NO;
        return cell;

    }
    else if (indexPath.row == 2) {
        
        TFAddPCAprrovalCell *cell = [TFAddPCAprrovalCell addPCAprrovalCellWithTableView:tableView];
        cell.requrieLAb.hidden = NO;
        cell.titleLab.text = [self.model.relevance_status isEqualToString:@"0"] ? @"补卡时间对应字段" : @"开始时间对应字段";
        cell.topLine.hidden = NO;
        cell.textField.text = self.model.start_time_name;
        cell.tag = 333;
        [[[cell.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self enterBtnClicked:333];
        }];
        return cell;
    }
    else if (indexPath.row == 3) {
        
        TFAddPCAprrovalCell *cell = [TFAddPCAprrovalCell addPCAprrovalCellWithTableView:tableView];
        
        cell.requrieLAb.hidden = YES;
        cell.titleLab.text = @"结束时间对应字段";
        cell.topLine.hidden = NO;
        cell.textField.text = self.model.end_time_name;
        cell.tag = 444;
        [[[cell.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self enterBtnClicked:444];
        }];
        return cell;
    }
    else if (indexPath.row == 4) {
        
        TFAddPCAprrovalCell *cell = [TFAddPCAprrovalCell addPCAprrovalCellWithTableView:tableView];
        
        cell.requrieLAb.hidden = YES;
        cell.titleLab.text = @"时长对应字段";
        cell.topLine.hidden = NO;
        cell.textField.text = self.model.duration_name;
        cell.tag = 555;
        [[[cell.setBtn rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self enterBtnClicked:555];
        }];
        return cell;
    }
    else if (indexPath.row == 5) {
        
        TFAtdOneTFCell *cell = [TFAtdOneTFCell atdOneTFCellWithTableView:tableView];
        
        cell.requireLab.hidden = NO;
        cell.titleLab.text = @"时长计算单位";
        cell.contentTF.placeholder = @"请选择";
        [cell.enterBtn setTitle:@"设置" forState:UIControlStateNormal];
        cell.delegate = self;
        cell.tag = 1003;
        cell.contentTF.text = [self.model.duration_unit isEqualToString:@"0"]?@"按天":@"按小时";
        cell.topLine.hidden = NO;
        return cell;

    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4) {
        
        return 89;
    }
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 60;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    
    UILabel *lab = [UILabel initCustom:CGRectMake(15, 10, SCREEN_WIDTH-30, 40) title:@"审批通过后，该时间段内的考勤“缺卡”状态将会被自动修正为“正常”" titleColor:kUIColorFromRGB(0xFF0000) titleFont:12 bgColor:ClearColor];
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:lab];
    view.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    return view;
}

#pragma mark TFAtdOneTFCellDelegate
- (void)enterBtnClicked:(NSInteger)flag {
    
    UIActionSheet *sheet;
    if (flag == 1001) {
        TFApprovalModuleController *list = [[TFApprovalModuleController alloc] init];
        TFModuleModel *mo = [[TFModuleModel alloc] init];
        mo.chinese_name = self.model.relevance_title;
        mo.english_name = self.model.relevance_bean;
        list.model = mo;
        list.actionField = ^(TFModuleModel *parameter) {
            self.model.relevance_bean = parameter.english_name;
            self.model.relevance_title = parameter.chinese_name;
            [self.tableView reloadData];
            [self.attendaceBL requestApprovalFieldWithBean:parameter.english_name];
        };
        [self.navigationController pushViewController:list animated:YES];
    }
    else if (flag == 1002) {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"缺卡",@"请假",@"加班",@"出差",@"销假",@"外出", nil];
        sheet.tag = flag;
        [sheet showInView:self.view];
    }
    else if (flag == 1003) {
        if ([self.model.relevance_status isEqualToString:@"2"]) {// 加班
            sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按小时", nil];
        }else{
            sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按天",@"按小时", nil];
        }
        sheet.tag = flag;
        [sheet showInView:self.view];
    }else if (flag == 333){
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFAttendenceFieldModel *model in self.fields) {
            if ([model.type isEqualToString:@"datetime"]) {
                [arr addObject:model];
            }
        }
        TFAttendenceFieldController *field = [[TFAttendenceFieldController alloc] init];
        field.datas = arr;
        TFAttendenceFieldModel *model = [[TFAttendenceFieldModel alloc] init];
        model.field_name = self.model.start_time_field;
        field.field = model;
        field.action = ^(TFAttendenceFieldModel *parameter) {
            self.model.start_time_field = parameter.field_name;
            self.model.start_time_name = parameter.field_label;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:field animated:YES];
        
    }else if (flag == 444){
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFAttendenceFieldModel *model in self.fields) {
            if ([model.type isEqualToString:@"datetime"]) {
                [arr addObject:model];
            }
        }
        TFAttendenceFieldController *field = [[TFAttendenceFieldController alloc] init];
        field.datas = arr;
        TFAttendenceFieldModel *model = [[TFAttendenceFieldModel alloc] init];
        model.field_name = self.model.end_time_field;
        field.field = model;
        field.action = ^(TFAttendenceFieldModel *parameter) {
            self.model.end_time_field = parameter.field_name;
            self.model.end_time_name = parameter.field_label;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:field animated:YES];
        
    }else if (flag == 555){
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFAttendenceFieldModel *model in self.fields) {
            if ([model.type isEqualToString:@"number"]) {
                [arr addObject:model];
            }
        }
        TFAttendenceFieldController *field = [[TFAttendenceFieldController alloc] init];
        field.datas = arr;
        TFAttendenceFieldModel *model = [[TFAttendenceFieldModel alloc] init];
        model.field_name = self.model.duration_field;
        field.field = model;
        field.action = ^(TFAttendenceFieldModel *parameter) {
            self.model.duration_field = parameter.field_name;
            self.model.duration_name = parameter.field_label;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:field animated:YES];
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1002) {
        self.model.relevance_status = [NSString stringWithFormat:@"%ld",buttonIndex];
        
        if ([self.model.relevance_status isEqualToString:@"2"]) {// 加班
            self.model.duration_unit = [NSString stringWithFormat:@"1"];
        }
    }
    if (actionSheet.tag == 1003) {
        
        if ([self.model.relevance_status isEqualToString:@"2"]) {// 加班
            self.model.duration_unit = [NSString stringWithFormat:@"1"];
        }else{
            self.model.duration_unit = [NSString stringWithFormat:@"%ld",buttonIndex];
        }
    }
    [self.tableView reloadData];
}

#pragma mark 保存
- (void)saveAction {
    
    if (IsStrEmpty(self.model.relevance_bean)) {
        [MBProgressHUD showError:@"请选择审批单" toView:self.view];
        return;
    }
    
    if (IsStrEmpty(self.model.start_time_field)) {
        [MBProgressHUD showError:@"请选择开始时间字段" toView:self.view];
        return;
    }
    
    if ([self.model.relevance_status integerValue] == 0) {// 缺卡
        self.model.duration_unit = @"";
        self.model.duration_name = @"";
        self.model.end_time_name = @"";
    }
    if ([self.model.relevance_status integerValue] == 1) {// 请假
        self.model.duration_unit = @"";
        self.model.duration_name = @"";
    }
    
    if (self.type == 0) {// 新增
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.attendaceBL requestReferenceApprovalCreateWithDict:[self.model toDictionary]];
        
    }else{// 编辑
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.attendaceBL requestReferenceApprovalUpdateWithDict:[self.model toDictionary]];
    }
}

@end
