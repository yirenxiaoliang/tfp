//
//  HQTFPleaseDelayController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFPleaseDelayController.h"
#import "HQWriteContentCell.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFCreatTaskModel.h"
#import "HQTFPeopleCell.h"
#import "HQSelectTimeCell.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQTFTextImageChangeCell.h"
#import "HQTFEndTimeController.h"
#import "TFProjTaskModel.h"
#import "TFProjectBL.h"
#import "TFTaskDeadlineDelayModel.h"
#import "HQTFChoicePeopleController.h"

@interface HQTFPleaseDelayController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView ;
///** HQTFCreatTaskModel */
//@property (nonatomic, strong) TFProjTaskModel *creatTask;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** TFTaskDeadlineDelayModel */
@property (nonatomic, strong) TFTaskDeadlineDelayModel *delayModel;


@end

@implementation HQTFPleaseDelayController
//-(TFProjTaskModel *)creatTask{
//    
//    if (!_creatTask) {
//        _creatTask = [[TFProjTaskModel alloc] init];
//    }
//    return _creatTask;
//}
-(TFTaskDeadlineDelayModel *)delayModel{
    if (!_delayModel) {
        _delayModel = [[TFTaskDeadlineDelayModel alloc] init];
    }
    return _delayModel;
}
-(void)setTask:(TFProjTaskModel *)task{
    _task = task;
    self.delayModel.content = task.descript;
    self.delayModel.taskId = task.id;
    self.delayModel.deadlineType = task.deadlineType;
    self.delayModel.deadline = task.deadline;
//    self.delayModel.approverId = task.managers[0];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
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
    
    if (self.type == 1) {
        [self setupTwoBtn];
        [self.projectBL requestDelProjParticipantWithDelayRecordId:self.task.delayRecordId];
    }
    
}

#pragma mark - navi
- (void)setupNavigation{
    
    if (self.type == 0) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
        
        self.navigationItem.title = @"延时申请";
    }else{
        
        self.navigationItem.title = @"延时审批";
    }
    
}
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    [self.view endEditing:YES];
    
    if (!self.delayModel.deadline) {
        [MBProgressHUD showError:@"请选择截止时间" toView:KeyWindow];
        return;
    }
    
    self.delayModel.approvalType = @1;

    [self.projectBL requestAddOrUpdateTaskDelayWithModel:self.delayModel];
    
}

- (void)setupTwoBtn{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-64-60,SCREEN_WIDTH,60}];
    [self.view addSubview:view];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/2 * i,0,SCREEN_WIDTH/2,60} target:self action:@selector(twoBtnClicked:)];
        [view addSubview:btn];
        btn.backgroundColor = WhiteColor;
        btn.titleLabel.font = FONT(20);
        btn.tag = 0x123 + i;
        if (i == 0) {
            
            [btn setTitle:@"驳回" forState:UIControlStateNormal];
            [btn setTitle:@"驳回" forState:UIControlStateHighlighted];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [btn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        }else{
            [btn setTitle:@"通过" forState:UIControlStateNormal];
            [btn setTitle:@"通过" forState:UIControlStateHighlighted];
            [btn setTitleColor:GreenColor forState:UIControlStateNormal];
            [btn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        }
    }
    
    
    UIView *sepeview = [[UIView alloc] initWithFrame:(CGRect){SCREEN_WIDTH/2,0,0.5,20}];
    sepeview.backgroundColor = CellSeparatorColor;
    sepeview.centerY = view.height/2;
    [view addSubview:sepeview];
}

- (void)twoBtnClicked:(UIButton *)button{
    
    switch (button.tag-0x123) {
        case 0:// 驳回
        {
            self.delayModel.approvalType = @1;
            self.delayModel.approvalType = @2;
            [self.projectBL requestAddOrUpdateTaskDelayWithModel:self.delayModel];
        }
            break;
            
        case 1:// 通过
        {
            self.delayModel.approvalType = @1;
            self.delayModel.approvalResult = @1;
            [self.projectBL requestAddOrUpdateTaskDelayWithModel:self.delayModel];
        }
            break;
        default:
            break;
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
    if (self.type == 1) {
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    }
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 3;
    }
    return 1;
}

/** 计算某个时间点与今天相差 */
- (NSString *)caculeteTimeWithCreatTimeSp:(long long)creatTimeSp deadlineTime:(long long)deadlineTime{
    
    //    HQLog(@"今天：%@====self.date:%@",[HQHelper getYearMonthDayHourMiuthWithDate:[NSDate date]],[HQHelper getYearMonthDayHourMiuthWithDate:self.date]);
    // 多少秒
    long long time = (deadlineTime-creatTimeSp)/1000.0;
    
    time = ABS(time);
    
    CGFloat day = time/(24*60*60.0);
    
    NSInteger intDay = (NSInteger)day;
    
    CGFloat hour = (day - intDay)*24.0;
    
    NSInteger intHour = (NSInteger)hour;
    
    CGFloat minute = (hour - intHour)*60.0;
    
    NSInteger intMinute = (NSInteger)minute;
    
    NSString *str = [NSString stringWithFormat:@"%ld天%ld小时%ld分",intDay,intHour,intMinute];
    
    return str;
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
    
    NSString *str = [NSString stringWithFormat:@"%ld天%ld小时%ld分",intDay,intHour,intMinute];
    
    return str;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        
        static NSString *indentifier = @"HQBaseCell";
        HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if (!cell) {
            cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = YES;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = FONT(14);
        cell.textLabel.textColor = ExtraLightBlackTextColor;
        cell.textLabel.text = [NSString stringWithFormat:@"此任务截止时间为%@，已超期%@。",[self caculeteTimeWithCreatTimeSp:[self.task.createDate longLongValue] deadlineTime:[self.task.deadline longLongValue]],[self caculeteTimeWithCreatTimeSp:[self.task.deadline longLongValue] deadlineTime:[HQHelper getNowTimeSp]]];
        return  cell;
//        HQTFTextImageChangeCell *cell = [HQTFTextImageChangeCell textImageChangeCellWithTableView:tableView];
//        if ([self.task.deadlineType isEqualToNumber:@0]) {
//            
//            cell.title = [NSString stringWithFormat:@"此任务截止时间为%@，已超期%@。",[HQHelper nsdateToTime:[self.task.deadline longLongValue] formatStr:@"yyyy-MM-dd"],[self caculeteTimeWithCreatTimeSp:[self.task.deadline longLongValue] deadlineTime:[HQHelper getNowTimeSp]]];
//            
//        }else{
//           
//            cell.title = [NSString stringWithFormat:@"此任务截止时间为%@，已超期%@。",[self caculeteTimeWithCreatTimeSp:[self.task.createDate longLongValue] deadlineTime:[self.task.deadline longLongValue]],[self caculeteTimeWithCreatTimeSp:[self.task.deadline longLongValue] deadlineTime:[HQHelper getNowTimeSp]]];
//        }
//        
//        cell.leftBtn.titleLabel.font = FONT(16);
//        cell.bottomLine.hidden = YES;
//        cell.tag = 0x2468;
//        return cell;
        
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            
            HQWriteContentCell *writeCell = [HQWriteContentCell writeContentCellWithTableView:tableView];
            writeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            writeCell.title.text = @"任务名称";
            writeCell.content.delegate = self;
            writeCell.content.tag = 0x222;
            writeCell.content.placeholder = @"";
            writeCell.content.placeholderColor = PlacehoderColor;
            writeCell.topLine.hidden = YES;
            writeCell.content.editable = NO;
            writeCell.content.scrollEnabled = NO;
            writeCell.content.text = self.task.descript;
            writeCell.content.userInteractionEnabled = NO;
            return writeCell;
            
        }else if (indexPath.row == 1) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.arrowShowState = YES;
            cell.time.textColor = PlacehoderColor;
            cell.contentView.backgroundColor = WhiteColor;
            cell.timeTitle.font = FONT(14);
            cell.bottomLine.hidden = NO;
            
           
            //0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
            if ([self.delayModel.deadline isEqualToNumber:@0]) {
                
                cell.time.text = [HQHelper nsdateToTime:[self.delayModel.deadline longLongValue] formatStr:@"yyyy-MM-dd"];
            }else{
                
                cell.time.text = [self caculeteTimeWithTimeSp:[self.delayModel.deadline longLongValue]];
            }
            cell.time.textColor = LightBlackTextColor;
            
            return  cell;
            
        }else{
            
            if (!self.delayModel.employees || self.delayModel.employees.count == 0) {
                HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
                cell.titleLabel.text = @"审批人";
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
                [cell refreshMorePeopleCellWithPeoples:@[]];
                cell.bottomLine.hidden = YES;
                return cell;
            }else{
                
                HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
                cell.peoples = self.delayModel.employees;// self.creatTask.appoints
                cell.titleLabel.text = @"审批人";
                if (!self.delayModel.employees || self.delayModel.employees.count == 0) {
                    cell.contentLabel.text = @"";
                    cell.contentLabel.textColor = PlacehoderColor;
                }else{
                    cell.contentLabel.text = [NSString stringWithFormat:@"%ld人",self.delayModel.employees.count];
                    cell.contentLabel.textColor = LightBlackTextColor;
                }
                cell.bottomLine.hidden = YES;
                
                if (self.type == 0) {
                    
                    cell.enterImg.hidden = NO;
                }else{
                    
                    cell.enterImg.hidden = YES;
                }
                
                return cell;
            }
            
        }
    }else{
        
        
        if (self.type == 0) {
            
            HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
            cell.textVeiw.placeholder = @"说明申请原因";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.delegate = self;
            cell.textVeiw.font = FONT(16);
            cell.textVeiw.text = self.delayModel.applierMark;
            cell.textVeiw.tag = 0x67890;
            cell.bottomLine.hidden = YES;
            cell.textVeiw.userInteractionEnabled = YES;
            return cell;
        }else{
            
            HQWriteContentCell *writeCell = [HQWriteContentCell writeContentCellWithTableView:tableView];
            writeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            writeCell.title.text = @"申请备注";
            writeCell.content.delegate = self;
            writeCell.content.tag = 0x222;
            writeCell.content.placeholder = @"请输入备注";
            writeCell.content.placeholderColor = PlacehoderColor;
            writeCell.topLine.hidden = YES;
            writeCell.content.editable = NO;
            writeCell.content.scrollEnabled = NO;
            writeCell.content.text = self.delayModel.applierMark;
            writeCell.content.userInteractionEnabled = NO;
            return writeCell;
        }
        
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x67890) {
        
        self.delayModel.applierMark = textView.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {// 申请
        
        if (indexPath.section == 1) {
            if (indexPath.row == 1) {
                
                HQTFEndTimeController *repeat = [[HQTFEndTimeController alloc] init];
                repeat.date = [HQHelper nsdateToTime:[self.delayModel.deadline longLongValue]==0?[HQHelper getNowTimeSp]:[self.delayModel.deadline longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
                repeat.deadlineType = self.delayModel.deadlineType==nil?@0:self.delayModel.deadlineType;
                repeat.timeAction = ^(NSArray *parameter){
                    // 0时间点 1分钟 2小时 3天 4周 5月 6年 7秒
                    
                    self.delayModel.deadlineType = parameter[0];
                    NSString *date = parameter[1];
                    self.delayModel.deadline = [NSNumber numberWithLongLong:[HQHelper changeTimeToTimeSp:date formatStr:@"yyyy-MM-dd HH:mm"]];
                    
                    [self.tableView reloadData];
                };
                
                [self.navigationController pushViewController:repeat animated:YES];
            }
        }
        
        if (indexPath.row == 2) {
            
            
            HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
            choice.employees = self.delayModel.employees;// 执行人
            choice.type = ChoicePeopleTypeCreateTaskExcutor;
            choice.Id = self.task.projectId;
            
            choice.sectionTitle = @"延期审批人";
            choice.rowTitle = @"添加审批人";
            if (!self.delayModel.employees.count) {
                choice.instantPush = YES;
            }
            
            choice.actionParameter = ^(NSArray *people){
                
                
                self.delayModel.employees = [NSMutableArray<HQEmployModel,Optional> arrayWithArray:people];
                
                NSMutableArray *ids = [NSMutableArray array];
                for (HQEmployModel *model in people) {
                    
                    [ids addObject:model.id];
                }
                self.delayModel.approverId = ids[0];
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:choice animated:NO];
            
        }
    }else{// 审批
        
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        return 90;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-101,MAXFLOAT} titleStr:self.task.descript].height + 30;
        }
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        if (self.type == 0) {
            
            return 35;
        }
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.type == 0) {
        
        return 8;
    }else{
        
        if (section == 1) {
            return 0;
        }
        return 8;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == 0) {
        
        if (section == 2) {
            
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-10,35} text:@"    申请备注" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }

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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getTaskDelayApplyDetail) {
        
    }
    
    if (resp.cmdId == HQCMD_addOrUpdateTaskDelay) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
