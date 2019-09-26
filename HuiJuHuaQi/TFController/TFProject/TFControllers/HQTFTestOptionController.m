//
//  HQTFTestOptionController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFTestOptionController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQTFPeopleCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFCreatTaskModel.h"
#import "TFProjectBL.h"
#import "HQTFEndTimeController.h"
#import "HQTFChoicePeopleController.h"
#import "HQSelectTimeView.h"


@interface HQTFTestOptionController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** HQTFCreatTaskModel */
@property (nonatomic, strong) HQTFCreatTaskModel *childTask;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;


@end

@implementation HQTFTestOptionController

-(HQTFCreatTaskModel *)childTask{
    
    if (!_childTask) {
        _childTask = [[HQTFCreatTaskModel alloc] init];
        _childTask.projTask.parentId = self.taskDetail.id;
        _childTask.projTask.projectId = self.taskDetail.projectId;
        
        if (self.isEdit) {
            _childTask.projTask.id = self.subtask.id;
            _childTask.projTask.title = self.subtask.title;
            _childTask.projTask.deadline = self.subtask.deadline;
            _childTask.projTask.deadlineType = self.subtask.deadlineType;
            
            HQEmployModel *model = [[HQEmployModel alloc] init];
            model.id = self.subtask.executor?self.subtask.executor:self.subtask.executorId;
            model.employeeId = self.subtask.executor?self.subtask.executor:self.subtask.executorId;
            model.employeeName = self.subtask.executorName?self.subtask.executorName:self.subtask.executorlName;
            model.photograph = self.subtask.executorPhotograph;
            
            NSMutableArray<Optional,HQEmployModel> *arr = [NSMutableArray<Optional,HQEmployModel> arrayWithObject:model];
            _childTask.projTask.excutors = arr;
        }
        
    }
    return _childTask;
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
    [self setupTableView];
    [self setupNavigation];
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
}

#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"指派任务";
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    if (!self.childTask.projTask.title || [self.childTask.projTask.title isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入指派任务名称" toView:KeyWindow];
        return;
    }
    
    if (self.childTask.projTask.title.length > 30) {
        [MBProgressHUD showError:@"30字以内" toView:KeyWindow];
        return;
    }
    
    if (!self.childTask.projTask.deadline || [self.childTask.projTask.deadline isEqualToNumber:@0]) {
        [MBProgressHUD showError:@"请选择截止时间" toView:KeyWindow];
        return;
    }
    
    if (self.isEdit) {
        [self.projectBL requestUpdateProjTaskWithModel:self.childTask.projTask];
        
    }else{
        
        
        [self.projectBL requestAddProjChildTaskWithModel:self.childTask.projTask];
    }
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"指派任务名称30个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.childTask.projTask.title;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = YES;
        
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            
            if (!self.childTask.projTask.excutors || self.childTask.projTask.excutors.count == 0) {
                HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
                cell.titleLabel.text = @"执行人";
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                [cell refreshMorePeopleCellWithPeoples:@[]];
                return cell;
            }
            else{
                
                HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
                
                cell.peoples = self.childTask.projTask.excutors;
                cell.titleLabel.text = @"执行人";
                if (!self.childTask.projTask.excutors.count) {
                    cell.contentLabel.text = @"请添加";
                    cell.contentLabel.textColor = PlacehoderColor;
                }else{
                    cell.contentLabel.text = @"3人";
                    cell.contentLabel.textColor = LightBlackTextColor;
                }
                cell.bottomLine.hidden = NO;
                return cell;
            }
            
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.arrowShowState = YES;
            cell.time.textColor = PlacehoderColor;
            cell.contentView.backgroundColor = WhiteColor;
            cell.timeTitle.font = FONT(14);
            cell.bottomLine.hidden = NO;
            
            if (!self.childTask.projTask.deadline || [self.childTask.projTask.deadline isEqualToNumber:@0]) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                //0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
                if ([self.childTask.projTask.deadlineType isEqualToNumber:@2]) {
                    
                    cell.time.text = [HQHelper nsdateToTime:[self.childTask.projTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
                }else{
                    
                    cell.time.text = [self caculeteTimeWithTimeSp:[self.childTask.projTask.deadline longLongValue]];
                }
                cell.time.textColor = LightBlackTextColor;
            }
            return  cell;

        }
        
    }
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
            choice.employees = self.childTask.projTask.excutors;// 执行人
            choice.type = ChoicePeopleTypeCreateTaskExcutor;
            choice.Id = self.taskDetail.projectId;
            choice.projectItem = self.projectItem;
            if (!self.childTask.projTask.excutors) {
                choice.instantPush = YES;
            }
            choice.sectionTitle = @"指派任务执行人";
            choice.rowTitle = @"添加执行人";
            choice.actionParameter = ^(NSMutableArray<Optional,HQEmployModel> *people){
                
                
                self.childTask.projTask.excutors = people;
                NSMutableArray *ids = [NSMutableArray array];
                for (HQEmployModel *employ in people) {
                    [ids addObject:employ.id?employ.id:employ.employeeId];
                }
                if (ids.count) {
                    HQEmployModel *em = people[0];
                    self.childTask.projTask.executorId = em.id?em.id:em.employeeId;
                    self.childTask.projTask.executor = em.id?em.id:em.employeeId;
                    self.childTask.projTask.executorName = em.employeeName;
                    self.childTask.projTask.executorPhotograph = em.photograph;
                    self.childTask.projTask.executorPosition = em.position;
                    
                }
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:choice animated:NO];
        }
        if (indexPath.row == 1) {
//            HQTFEndTimeController *repeat = [[HQTFEndTimeController alloc] init];
//            repeat.date = [HQHelper nsdateToTime:[self.childTask.projTask.deadline longLongValue]==0?[HQHelper getNowTimeSp]:[self.childTask.projTask.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
//            repeat.deadlineType = self.childTask.projTask.deadlineType==nil?@2:self.childTask.projTask.deadlineType;
//            repeat.deadlineUnit = self.childTask.projTask.deadlineUnit==nil?@0:self.childTask.projTask.deadlineUnit;
//            repeat.timeAction = ^(NSArray *parameter){
//                // 0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
//                NSString *date = parameter[1];
//                long long timeSp = [HQHelper changeTimeToTimeSp:date formatStr:@"yyyy-MM-dd HH:mm"];
//                
//                if (self.projectItem.endTime && ![self.projectItem.endTime isEqualToNumber:@0]) {
//                    
//                    if ([self.projectItem.endTime longLongValue] < timeSp) {
//                        [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
//                        return ;
//                    }
//                }
//                
//                self.childTask.projTask.deadlineType = parameter[0];
//                self.childTask.projTask.deadline = [NSNumber numberWithLongLong:[HQHelper changeTimeToTimeSp:date formatStr:@"yyyy-MM-dd HH:mm"]];
//                
//                [self.tableView reloadData];
//            };
//            
//            [self.navigationController pushViewController:repeat animated:YES];
            
            
            [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDayHourMiuth timeSp:[self.childTask.projTask.deadline longLongValue]==0?[HQHelper getNowTimeSp]:[self.childTask.projTask.deadline longLongValue] LeftTouched:^{
                
            } onRightTouched:^(NSString *time) {
                
                HQLog(@"%@",time);
                
                if ([time isEqualToString:@""]) {// 清空
                    
                    self.childTask.projTask.deadlineType = @2;
                    self.childTask.projTask.deadline = [NSNumber numberWithLongLong:[HQHelper getNowTimeSp]];
                    [self.tableView reloadData];
                    return ;
                }
                
                long long timeSp = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                
                if (self.projectItem.endTime && ![self.projectItem.endTime isEqualToNumber:@0]) {
                    
                    if ([self.projectItem.endTime longLongValue] < timeSp) {
                        [MBProgressHUD showError:@"任务截止时间不能超过项目截止时间" toView:KeyWindow];
                        return ;
                    }
                }
                
                self.childTask.projTask.deadlineType = @2;
                self.childTask.projTask.deadline = [NSNumber numberWithLongLong:timeSp];
                
                [self.tableView reloadData];
            }];

            
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 90;
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        return 35;
//    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
//    if (section == 0) {
//        
//        return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-10,35} text:@"    检测项名称" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
//    }
//    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x12345) {
        
        if (textView.text.length > 30) {
            self.childTask.projTask.title = [textView.text substringToIndex:30];
            textView.text = self.childTask.projTask.title;
            [MBProgressHUD showError:@"30个字以内" toView:self.view];
        }else{
            
            self.childTask.projTask.title = textView.text;
        }
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_addProjTask || resp.cmdId == HQCMD_updateProjTask) {
        
        if (self.successAction) {
            self.successAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
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
