//
//  HQTFCreatTaskController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatTaskController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQTFPeopleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFAddLabelCell.h"
#import "TFProjLabelModel.h"
#import "HQTFThreeLabelCell.h"
#import "HQTFAddPeopleController.h"
#import "HQTFChoicePeopleController.h"
#import "HQTFProjectDescController.h"
#import "HQTFLabelManageController.h"
#import "FDActionSheet.h"
#import "HQTFQuantifyController.h"
#import "HQTFEndTimeController.h"
#import "HQTFMorePeopleCell.h"
#import "TFProjTaskModel.h"
#import "TFProjectBL.h"
#import "HQSelectTimeView.h"

@interface HQTFCreatTaskController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQSwitchCellDelegate,FDActionSheetDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFProjTaskModel */
@property (nonatomic, strong) TFProjTaskModel *projectTask;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

@end

@implementation HQTFCreatTaskController

//-(HQTFCreatTaskModel *)creatTask{
//    if (!_creatTask) {
//        _creatTask = [[HQTFCreatTaskModel alloc] init];
//        
//        _creatTask.projTask.priority = @2;
//        
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSInteger i = 0; i < 4; i++) {
//            
//            TFProjLabelModel *model = [[TFProjLabelModel alloc] init];
//            model.labelName = @"我是标标签";
//            model.labelColor = @"#33dd88";
//            [arr addObject:model];
//        }
//        
//        _creatTask.projTask.labels = arr;
//    }
//    return _creatTask;
//}

-(TFProjTaskModel *)projectTask{
    if (!_projectTask) {
        _projectTask = [[TFProjTaskModel alloc] init];
        _projectTask.projectId = self.projectSeeModel.project.id;
        _projectTask.taskListId = self.projectSeeModel.listId;
        _projectTask.isPublic = @1;
    }
    return _projectTask;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupNavigation];
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"新建任务";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    if (!self.projectTask.title || [self.projectTask.title isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入任务名称" toView:KeyWindow];
        return;
    }
    if (!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0]) {
        [MBProgressHUD showError:@"请选择截止时间" toView:KeyWindow];
        return;
    }
    
    if (self.projectEndTime && ![self.projectEndTime isEqualToNumber:@0]) {
        
        if ([self.projectEndTime longLongValue] < [self.projectTask.deadline longLongValue]) {
            [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
            return ;
        }
    }
    

    if (self.projectTask.excutors.count) {
        
        HQEmployModel *model = self.projectTask.excutors[0];
        self.projectTask.executor = model.id?model.id:model.employeeId;
        self.projectTask.executorName = model.employeeName;
        self.projectTask.executorPhotograph = model.photograph;
    }
    
    BOOL contain = NO;
    for (NSNumber *num in self.projectTask.teamUserIds) {
        
        if ([UM.userLoginInfo.employee.employee_id isEqualToNumber:num]) {
            contain = YES;
            break;
        }
        
    }
    
    if (!contain) {// 协作人要加上自己
        [self.projectTask.teamUserIds addObject:UM.userLoginInfo.employee.employee_id];
    }
    
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    [self.projectBL requestAddProjTaskWithModel:self.projectTask];
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
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
        return 2;
    }else if (section == 2){
        return 3;
    }
    //else if (section == 3){
    //   return 1 + self.creatTask.files.count;
    //}
    return 1;
}

/** 计算某个时间点与今天相差 */
- (NSString *)caculeteTimeWithTimeSp:(long long)timeSp{
    
    //    HQLog(@"今天：%@====self.date:%@",[HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]],[HQHelper getYearMonthDayHourMiuthWithDate:self.date]);
    // 多少秒
    long long time = (timeSp-[HQHelper getNowTimeSp])/1000.0;
    
    time = ABS(time);
    
    CGFloat day = time/(24*60*60.0);
    
    NSInteger intDay = (NSInteger)day;
    
    CGFloat hour = (day - intDay)*24.0;
    
    NSInteger intHour = (NSInteger)hour;
    
    CGFloat minute = (hour - intHour)*60.0;
    
    NSInteger intMinute = (NSInteger)minute;
    
    NSString *str = [NSString stringWithFormat:@"%ld天  %ld小时  %ld分",intDay,intHour,intMinute];
    
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"任务名称30个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.projectTask.title;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = YES;
        
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.delegate = self;
            [cell.switchBtn setOnImage:[HQHelper createImageWithColor:GreenColor]];
            cell.title.text = @"仅协作人可见";
            
            return cell;
        }else{
            
            if (!self.projectTask.excutors || self.projectTask.excutors.count == 0) {
                HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
                cell.titleLabel.text = @"执行人";
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                [cell refreshMorePeopleCellWithPeoples:@[]];
                cell.bottomLine.hidden = YES;
                return cell;
            }else{
                HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
                cell.titleLabel.text = @"执行人";
                cell.contentLabel.text = @"";
                cell.contentLabel.textColor = LightBlackTextColor;
                cell.bottomLine.hidden = YES;
                cell.peoples = self.projectTask.excutors;
                return cell;
            }
            
        }
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.arrowShowState = YES;
            if (!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0]) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                
                if ([self.projectTask.deadlineType isEqualToNumber:@2]) {
                    
                    cell.time.text = [HQHelper nsdateToTime:[self.projectTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
                }else{
                    
                    cell.time.text = [self caculeteTimeWithTimeSp:[self.projectTask.deadline longLongValue]];
                }

                cell.time.textColor = LightBlackTextColor;
            }
            cell.bottomLine.hidden = NO;
            return  cell;
        }else if (indexPath.row == 1){
            
            if (!self.projectTask.priority) {
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"优先级  ";
                cell.arrowShowState = YES;
                cell.time.text = @"普通";
                cell.time.textColor = PlacehoderColor;
                cell.bottomLine.hidden = NO;
                return  cell;
            }else{
                HQTFAddLabelCell *cell = [HQTFAddLabelCell addLabelCellWithTableView:tableView];
                [cell refreshAddLabelCellWithPriority:self.projectTask.priority];
                cell.titleLabel.text = @"优先级";
                cell.bottomLine.hidden = NO;
                return  cell;
            }
            
        }
        /*else if (indexPath.row == 2){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"定量数值";
            cell.arrowShowState = YES;
            if (!self.creatTask.money) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                cell.time.text = self.creatTask.endTime;
                cell.time.textColor = LightBlackTextColor;
            }
            return  cell;
        }*/
        else{
            if (!self.projectTask.labels || self.projectTask.labels.count == 0) {
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"标签";
                cell.arrowShowState = YES;
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
                cell.bottomLine.hidden = YES;
                return  cell;
            }else{
                HQTFAddLabelCell *cell = [HQTFAddLabelCell addLabelCellWithTableView:tableView];
                cell.titleLabel.text = @"标签";
                [cell refreshAddLabelCellWithLabels:self.projectTask.labels];
                cell.bottomLine.hidden = YES;
                return  cell;
            }
        }
        
    }
    /*else if (indexPath.section == 3){
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        cell.leftLabel.text = @"文件";
        cell.rightLabel.text = @"上传文件";
        return cell;
    }*/
    else{
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"输入内容(500字以内)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(16);
        cell.textVeiw.text = self.projectTask.descript;
        cell.textVeiw.tag = 0x67890;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = NO;
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {// 指派
            
//            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
//            choice.employees = self.projectTask.excutors;// 执行人
//            choice.type = ChoicePeopleTypeCreateTaskExcutor;
//            choice.Id = self.projectSeeModel.project.id;
//            choice.projectItem = self.projectSeeModel.project;
//            
//            choice.sectionTitle = @"任务执行人";
//            choice.rowTitle = @"添加执行人";
//            if (!self.projectTask.excutors.count) {
//                choice.instantPush = YES;
//            }
//            
//            choice.actionParameter = ^(NSArray *people){
//                
//                
//                self.projectTask.excutors = [NSMutableArray<Optional,HQEmployModel> arrayWithArray:people];
//                
////                NSMutableArray *ids = [NSMutableArray array];
////                for (HQEmployModel *model in people) {
////                    
////                    [ids addObject:model.id];
////                }
//                if (people.count) {
//                    HQEmployModel *model = people[0];
//                    self.projectTask.executor = model.id?model.id:model.employeeId;
//                    self.projectTask.executorName = model.employeeName;
//                    self.projectTask.executorPosition = model.position;
//                    self.projectTask.executorPhotograph = model.photograph;
//                }
//                
//                [self.tableView reloadData];
//                
//            };
//            
//            [self.navigationController pushViewController:choice animated:NO];
            
            
            
            HQTFAddPeopleController *addPeople = [[HQTFAddPeopleController alloc] init];
            
            addPeople.employees = self.projectTask.excutors;// 执行人
            addPeople.type = ChoicePeopleTypeCreateTaskExcutor;
            addPeople.Id = self.projectSeeModel.project.id;
            addPeople.projectItem = self.projectSeeModel.project;
            addPeople.actionParameter = ^(NSArray *peoples){
                
                
                self.projectTask.excutors = [NSMutableArray<Optional,HQEmployModel> arrayWithArray:peoples];
                
                if (peoples.count) {
                    HQEmployModel *model = peoples[0];
                    self.projectTask.executor = model.id?model.id:model.employeeId;
                    self.projectTask.executorName = model.employeeName;
                    self.projectTask.executorPosition = model.position;
                    self.projectTask.executorPhotograph = model.photograph;
                }
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:addPeople animated:YES];
            
            
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
//            HQTFEndTimeController *repeat = [[HQTFEndTimeController alloc] init];
//            repeat.date = (!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0])?[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd HH:mm"]:[HQHelper nsdateToTime:[self.projectTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
//            repeat.deadlineType = self.projectTask.deadlineType==nil?@2:self.projectTask.deadlineType;
//            repeat.deadlineUnit = self.projectTask.deadlineUnit==nil?@0:self.projectTask.deadlineUnit;
//            repeat.timeAction = ^(NSArray *parameter){
//                // 0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
//                
//                NSString *date = parameter[1];
//                long long timeSp = [HQHelper changeTimeToTimeSp:date formatStr:@"yyyy-MM-dd HH:mm"];
//                if (self.projectEndTime && ![self.projectEndTime isEqualToNumber:@0]) {
//                    
//                    if ([self.projectEndTime longLongValue] < timeSp) {
//                        [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
//                        return ;
//                    }
//                }
//                
//                self.projectTask.deadlineType = parameter[0];
//                self.projectTask.deadline = [NSNumber numberWithLongLong:timeSp];
//                
//                self.projectTask.deadlineUnit = parameter[2];
////                self.projectTask.deadlineType = self.projectTask.deadlineType;
////                self.projectTask.deadline = self.projectTask.deadline;
//                
//                [self.tableView reloadData];
//            };
//            
//            [self.navigationController pushViewController:repeat animated:YES];
            
            [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDayHourMiuth timeSp:(!self.projectTask.deadline || [self.projectTask.deadline isEqualToNumber:@0])?[HQHelper getNowTimeSp]:[self.projectTask.deadline longLongValue] LeftTouched:^{
                
            } onRightTouched:^(NSString *time) {
                
                HQLog(@"%@",time);
                
                if ([time isEqualToString:@""]) {// 清空
                    
                    self.projectTask.deadline = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
                    [self.tableView reloadData];
                    return ;
                }
                
                long long timeSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%@",time] formatStr:@"yyyy-MM-dd HH:mm"];
                
                
                if (self.projectSeeModel.project.endTime && ![self.projectSeeModel.project.endTime isEqualToNumber:@0]) {
                    
                    if ([self.projectSeeModel.project.endTime longLongValue] < timeSp) {
                        [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
                        return ;
                    }
                }
                
                self.projectTask.deadlineType = @2;
                self.projectTask.deadline = [NSNumber numberWithLongLong:timeSp];
                
                [self.tableView reloadData];
            }];

            
        }
        
        if (indexPath.row == 1) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"优先级" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"普通任务",@"紧急任务",@"非常紧急任务",nil];
            
            UIColor *color = LightBlackTextColor;
            if ([self.projectTask.priority integerValue] == 1) {
                color = PriorityUrgent;
            }else if ([self.projectTask.priority integerValue] == 2){
                color = PriorityVeryUrgent;
            }
            
            [sheet setButtonTitleColor:color bgColor:WhiteColor fontSize:FONT(18) atIndex:[self.projectTask.priority integerValue]];
            
            [sheet show];
        }
        /*if (indexPath.row == 2) {
            HQTFQuantifyController *quantity = [[HQTFQuantifyController alloc] init];
            [self.navigationController pushViewController:quantity animated:YES];
        }*/
        if (indexPath.row == 2) {
            HQTFLabelManageController *label = [[HQTFLabelManageController alloc] init];
            label.type = LabelManageControllerSelect;
            label.projectId = self.projectSeeModel.project.id;
            label.didSelectLabels = [NSMutableArray arrayWithArray:self.projectTask.labels];
            label.labelAction = ^(id parameter){
                
                self.projectTask.labels = parameter;
                
                NSMutableArray *labelIds = [NSMutableArray array];
                for (TFProjLabelModel *label in self.projectTask.labels) {
                    [labelIds addObject:label.id];
                }
                self.projectTask.labelIds = labelIds;
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:label animated:YES];
        }
    }
    /*
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"文件库",@"选择已有照片",@"拍照上传",nil];
            
            sheet.tag = 222;
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:0];
            [sheet setButtonTitleColor:BlackTextColor bgColor:nil fontSize:FONT(16) atIndex:1];
            [sheet setCancelButtonTitleColor:BlackTextColor bgColor:CellClickColor fontSize:FONT(16)];
            [sheet show];
        }
        
    }*/
    
    if (indexPath.section == 3) {
        
        HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
        
        desc.descString = self.projectTask.descript;
        desc.sectionTitle = @"任务描述";
        desc.naviTitle = @"任务描述";
        desc.wordNum = 500;
        desc.placehoder = @"500字以内";
        desc.descAction = ^(NSString *time){
            
            self.projectTask.descript = time;
            [self.tableView reloadData];
        };
        

        [self.navigationController pushViewController:desc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 2) {
        
            return [HQTFAddLabelCell refreshAddLabelCellHeightWithLabels:self.projectTask.labels];
        }else{
            return 55;
        }
    }
    /*else if (indexPath.section == 3){
        return 55;
    }*/
    else{
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-120,MAXFLOAT} titleStr:self.projectTask.descript];
        
        return size.height >= 80 ? size.height + 30 : 80;
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 3){
        return 35;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 3) {
        return 8;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (section == 3) {
        
          return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-10,35} text:@"    任务描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark -  switchCellDelegate

-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    switchButton.on = !switchButton.on;
    
    self.projectTask.isPublic = switchButton.on?@0:@1;
    
}

#pragma mark -  switchCellDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x12345) {
        
        self.projectTask.title = textView.text;
    }
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            self.projectTask.priority = @0;
        }
            break;
        case 1:
        {
            self.projectTask.priority = @1;
        }
            break;
        case 2:
        {
            self.projectTask.priority = @2;
        }
            break;
               default:
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_addProjTask) {
        
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        
        /**  此处没有任务id 返回刷新时若点击该任务 无法进入详情
        TFProjectTaskListModel *listModel = self.projectSeeModel.projTaskLists[self.index];
        TFTaskPageVoModel *pageModel = listModel.taskPageVo;
        
        NSMutableArray <TFProjTaskModel,Optional>*taskList = [NSMutableArray <TFProjTaskModel,Optional>arrayWithArray:pageModel.list];
        
        [taskList insertObject:self.projectTask atIndex:0];
        pageModel.list = taskList;
        */
        if (self.refreshAction) {
            self.refreshAction();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
