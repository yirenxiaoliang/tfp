//
//  TFOtherSetController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOtherSetController.h"
#import "TFAddPeoplesCell.h"
#import "HQSelectTimeCell.h"
#import "TFOtherSetItemCell.h"

#import "TFOtherSetModel.h"
#import "HQNotPassSubmitView.h"
#import "TFMutilStyleSelectPeopleController.h"

#import "TFAttendanceBL.h"
#import "TFPCOtherSettingModel.h"
#import "TFPCSettingDetailMocel.h"
#import "HQTwoLableSubmitView.h"
#import "TFLateEarlyCell.h"
#import "TFContactsRoleController.h"

@interface TFOtherSetController ()<UITableViewDelegate,UITableViewDataSource,TFAddPeoplesCellDelegate,TFOtherSetItemCellDelegate,UIActionSheetDelegate,HQBLDelegate,TFLateEarlyCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

//组头标题
@property (nonatomic, strong) NSArray *titlesArr;
//打卡提醒
@property (nonatomic, strong) NSArray *remindArr;
//榜单设置数组
@property (nonatomic, strong) NSArray *listArr;
//人性化班次
@property (nonatomic, strong) NSArray *classArr;
//晚走晚到
@property (nonatomic, strong) NSArray *lateArr;
//晚走晚到Datas
@property (nonatomic, strong) NSMutableArray *lateDatas;
//旷工规则
@property (nonatomic, strong) NSArray *noworkArr;

@property (nonatomic, strong) TFOtherSetModel *setModel;
@property (nonatomic, strong) NSMutableArray *datasources;

@property (nonatomic, strong) NSMutableArray *atdManagers;
@property (nonatomic, strong) TFPCOtherSettingModel *otherSettingModel;
@property (nonatomic, strong) TFPCSettingDetailMocel *detailModel;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

//打卡提醒时间
@property (nonatomic, strong) NSArray *remindTimes;
//榜单排名
@property (nonatomic, strong) NSArray *listMembers;
//榜单统计方式
@property (nonatomic, strong) NSArray *statisticsWays;
//榜单排序规则
@property (nonatomic, strong) NSArray *sequenceRules;

@property (nonatomic, copy) NSString *adminIds;

/** 存放选择的角色数据 */
@property (nonatomic, strong) NSMutableArray *fourSelects;

@end

@implementation TFOtherSetController


-(NSMutableArray *)fourSelects{
    if (!_fourSelects) {
        _fourSelects = [NSMutableArray array];
        
        [_fourSelects addObject:@{@"type":@0}];
        [_fourSelects addObject:@{@"type":@1}];
        [_fourSelects addObject:@{@"type":@2,@"peoples":self.atdManagers}];
        [_fourSelects addObject:@{@"type":@3}];
    }
    return _fourSelects;
}

- (TFPCSettingDetailMocel *)detailModel {
    
    if (!_detailModel) {
        
        _detailModel = [[TFPCSettingDetailMocel alloc] init];
    }
    return _detailModel;
}
- (TFPCOtherSettingModel *)otherSettingModel {
    
    if (!_otherSettingModel) {
        
        _otherSettingModel = [[TFPCOtherSettingModel alloc] init];
    }
    return _otherSettingModel;
}
- (NSMutableArray *)atdManagers {

    if (!_atdManagers) {

        _atdManagers = [NSMutableArray array];

    }
    return _atdManagers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"其他设置";
    
    [self initWithData];
    [self setupTableView];
    [self requestDetailData];
}

-(NSMutableArray *)lateDatas{
    if (!_lateDatas) {
        _lateDatas = [NSMutableArray array];
    }
    return _lateDatas;
}

- (void)initWithData {
    
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    
    self.datasources = [NSMutableArray array];
    NSMutableArray *arr = [NSMutableArray array];
    self.titlesArr = @[@"打卡提醒",@"榜单设置",@"晚走晚到",@"人性化班次",@"旷工规则"];
    self.remindArr = @[@"上班提前分钟，提醒员工打上班卡",@"下班推后分钟，提醒员工打下班卡"];
    self.listArr = @[@"榜单统计方式",@"早到榜",@"勤勉榜",@"迟到榜",@"迟到排序规则"];
    self.lateArr = @[@"新增晚走晚到规则"];
    self.classArr = @[@"每人允许迟到次数",@"单次允许迟到分钟数"];
    self.noworkArr = @[@"单次迟到超过分钟数记为旷工",@"单次早退超过分钟数记为旷工"];
    [arr addObject:self.titlesArr];
    [arr addObject:self.remindArr];
    [arr addObject:self.listArr];
    [arr addObject:self.lateArr];
    [arr addObject:self.classArr];
    [arr addObject:self.noworkArr];
    
    
    for (int i=0; i<arr.count; i++) {
        
        TFOtherSetModel *setModel = [[TFOtherSetModel alloc] init];
        setModel.select = @0;
        setModel.datas = arr[i];
        [self.datasources addObject:setModel];
    }
    
    /** 设置选项值 */
    self.remindTimes = @[@5,@10,@15,@20,@25,@30];
    self.listMembers = @[@10,@15,@20];
    self.statisticsWays = @[@1,@0];  //0:分开 1:一起
    self.sequenceRules = @[@0,@1]; //0:次数 1:时长
    
}

- (void)requestDetailData {
    
    [self.attendanceBL requestGetAttendanceSettingFindDetail];
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
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 3){
        TFOtherSetModel *model = self.datasources[section];
        if ([model.select isEqualToNumber:@1]) {
            
            return 1+model.datas.count+self.lateDatas.count;
        }
        else {
            
            return 1;
        }
    }
    else {
        
        TFOtherSetModel *model = self.datasources[section];
        if ([model.select isEqualToNumber:@1]) {
            
            return 1+model.datas.count;
        }
        else {
            
            return 1;
        }
        
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFAddPeoplesCell *cell = [TFAddPeoplesCell AddPeoplesCellWithTableView:tableView];
        
        cell.requireLabel.hidden = YES;
        cell.titleLabel.text = @"考勤管理员";
        cell.delegate = self;
        
        [cell refreshAddRolesCellWithPeoples:self.atdManagers structure:0 chooseType:0 showAdd:YES row:indexPath.row];
        
        return cell;
    }
    
    else if (indexPath.section == 3) { //晚走晚到
        
        if (indexPath.row == 0) {
            
            TFOtherSetModel *model = self.datasources[0];
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.requireLabel.hidden = YES;
            cell.timeTitle.text = model.datas[indexPath.section-1];
            cell.timeTitle.font = FONT(16);
            
            TFOtherSetModel *set = self.datasources[indexPath.section];
            if ([set.select isEqualToNumber:@1]) {
                cell.arrow.image = IMG(@"收起更多");
            }
            else {
                cell.arrow.image = IMG(@"展开更多");
            }
            
            return cell;
            
        }else if (indexPath.row == 1){
            
            TFOtherSetModel *model = self.datasources[indexPath.section];
            
            TFOtherSetItemCell *cell = [TFOtherSetItemCell otherSetItemCellWithTableView:tableView];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.titleLab.font = FONT(14);
            cell.titleLab.text = model.datas[indexPath.row-1];
            cell.contentTF.placeholder = @"请选择";
            [cell configOtherSetItemCellWithTableView:1];
            cell.backgroundColor = HexColor(0xF8FBFE);
            return cell;
        }else{
            
            TFLateEarlyCell *cell = [TFLateEarlyCell lateEarlyCellWithTableView:tableView];
            cell.tag = indexPath.row-2;
            [cell refreshLateEarlyCellWithModel:self.lateDatas[indexPath.row-2]];
            cell.delegate = self;
            return cell;
            
        }
        
    }
    else {
        
        
        if (indexPath.row == 0) {
            
            TFOtherSetModel *model = self.datasources[0];
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.requireLabel.hidden = YES;
            cell.timeTitle.text = model.datas[indexPath.section-1];
            cell.timeTitle.font = FONT(16);
            
            TFOtherSetModel *set = self.datasources[indexPath.section];
            if ([set.select isEqualToNumber:@1]) {
                cell.arrow.image = IMG(@"收起更多");
            }
            else {
                cell.arrow.image = IMG(@"展开更多");
            }
            
            return cell;
            
        }
        else {
            
            TFOtherSetModel *model = self.datasources[indexPath.section];
            
            TFOtherSetItemCell *cell = [TFOtherSetItemCell otherSetItemCellWithTableView:tableView];
            cell.indexPath = indexPath;
            cell.delegate = self;
            cell.titleLab.font = FONT(14);
            cell.titleLab.text = model.datas[indexPath.row-1];
            cell.backgroundColor = HexColor(0xF8FBFE);
            NSInteger type;
            if (indexPath.section == 1) { //打卡提醒
                type = 2;
                cell.contentTF.placeholder = @"请设置分钟数";
                if (indexPath.row == 1) {
                    cell.contentTF.text = [NSString stringWithFormat:@"提前%@分钟",self.detailModel.remind_clock_before_work];
                }
                else if (indexPath.row == 2) {
                    cell.contentTF.text = [NSString stringWithFormat:@"延后%@分钟",self.detailModel.remind_clock_after_work];
                }
                
            }
            else if (indexPath.section == 2) { //榜单设置
                type = 2;
                cell.contentTF.placeholder = @"请选择";
                if (indexPath.row == 1) {
                    if ([self.detailModel.list_set_type isEqualToString:@"1"]) {
                        cell.contentTF.text = @"所有考勤组都统计一起";
                    }
                    else if ([self.detailModel.list_set_type isEqualToString:@"0"]) {
                        cell.contentTF.text = @"按考勤组分开统计";
                    }
                }
                else if (indexPath.row == 2) {
                    cell.contentTF.text = [NSString stringWithFormat:@"前%@",self.detailModel.list_set_early_arrival];
                }
                else if (indexPath.row == 3) {
                    cell.contentTF.text = [NSString stringWithFormat:@"前%@",self.detailModel.list_set_diligent];
                }
                else if (indexPath.row == 4) {
                    cell.contentTF.text = [NSString stringWithFormat:@"前%@",self.detailModel.list_set_be_late];
                }
                else if (indexPath.row == 5) {
                    if ([self.detailModel.list_set_sort_type isEqualToString:@"0"]) {
                        cell.contentTF.text = @"按迟到次数排序(次数相同按时长)";
                    }
                    else if ([self.detailModel.list_set_sort_type isEqualToString:@"1"]) {
                        cell.contentTF.text = @"按迟到时长排序(时长相同按次数)";
                    }
                }
            }
            else if (indexPath.section == 4) { //人性化班次
                type = 2;
                cell.contentTF.placeholder = @"请设置大于等于零整数";
                if (indexPath.row == 1) {
                    cell.contentTF.text = [NSString stringWithFormat:@"%@",self.detailModel.humanization_allow_late_times];
                }
                else if (indexPath.row == 2) {
                    cell.contentTF.text = [NSString stringWithFormat:@"%@",self.detailModel.humanization_allow_late_minutes];
                }
                
            }
            else { //旷工规则
                type = 2;
                cell.contentTF.placeholder = @"请设置大于等于零整数";
                if (indexPath.row == 1) {
                    cell.contentTF.text = [NSString stringWithFormat:@"%@",self.detailModel.absenteeism_rule_be_late_minutes];
                }
                else if (indexPath.row == 2) {
                    cell.contentTF.text = [NSString stringWithFormat:@"%@",self.detailModel.absenteeism_rule_leave_early_minutes];
                }
            }
            
            [cell configOtherSetItemCellWithTableView:type];
            return cell;
        }
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section>0) {
        
        TFOtherSetModel *model = self.datasources[indexPath.section];
        
        if ([model.select isEqualToNumber:@1]) {
            
            model.select = @0;
        }
        else {
            
            model.select = @1;
        }
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:indexPath.section];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 80;
    } else if (indexPath.section == 3) {
        if (indexPath.row > 1) {// 晚走晚到
            return [TFLateEarlyCell refreshLateEarlyCellHeightWithModel:self.lateDatas[indexPath.row-2]];
        }
    }
    return 60;
}

#pragma mark - TFLateEarlyCellDelegate
-(void)lateEarlyCellDidSetting:(TFLateNigthWalk *)model{
    
    [HQTwoLableSubmitView submitPlaceholderStr:@"请输入小时数" secondPlaceholder:@"请输入小时数" title:@"第一天下班晚走" secondTitle:@"第二天下班晚到" maxCharNum:10 LeftTouched:^{
        
    } onRightTouched:^(NSDictionary *dict) {
        
        model.nigthwalkmin = [dict valueForKey:@"text1"];
        model.lateMin = [dict valueForKey:@"text2"];
        [self.tableView reloadData];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFLateNigthWalk *model in self.lateDatas) {
            NSDictionary *dit  = [model toDictionary];
            if (dit) {
                [arr addObject:dit];
            }
        }
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:arr forKey:@"lislateNigthWalkArr"];
        
        [self.attendanceBL requestSaveLateWorkWithDict:dd];
    }];
    
}
-(void)lateEarlyCellDidDeleteBtn:(TFLateEarlyCell *)cell{
    
    [self.lateDatas removeObjectAtIndex:cell.tag];
    [self.tableView reloadData];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFLateNigthWalk *model in self.lateDatas) {
        NSDictionary *dit  = [model toDictionary];
        if (dit) {
            [arr addObject:dit];
        }
    }
    NSMutableDictionary *dd = [NSMutableDictionary dictionary];
    [dd setObject:arr forKey:@"lislateNigthWalkArr"];
    
    [self.attendanceBL requestSaveLateWorkWithDict:dd];
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

#pragma mark TFAddPeoplesCellDelegate
- (void)addPersonel:(NSInteger)index {
    
    
//    NSNumber *roleType = [[NSUserDefaults standardUserDefaults] valueForKey:@"RoleType"];
//    if (!([roleType isEqualToNumber:@2] || [roleType isEqualToNumber:@3])) {
//        [MBProgressHUD showError:@"系统管理员和企业所有者才能修改考勤管理员" toView:self.view];
//        return;
//    }

//    TFMutilStyleSelectPeopleController *selectPeople = [[TFMutilStyleSelectPeopleController alloc] init];
//
//    selectPeople.selectType = 1;
//    selectPeople.isSingleSelect = NO;
//    selectPeople.defaultPoeples = self.atdManagers;
//    selectPeople.actionParameter = ^(id parameter) {
//
//        self.adminIds = @"";
//        [self.atdManagers removeAllObjects];
//        for (HQEmployModel *em in parameter) {
//
//            self.adminIds = [self.adminIds stringByAppendingFormat:@",%@",em.id];
//            [self.atdManagers addObject:em];
//        }
//        if (self.adminIds.length) {
//            self.adminIds = [self.adminIds substringFromIndex:1];
//        }
//
//        [self.attendanceBL requestAddAttendanceSettingSaveAdminWithModel:self.adminIds];
//
//    };
//
//    [self.navigationController pushViewController:selectPeople animated:YES];
    
    TFContactsRoleController *controller3 = [[TFContactsRoleController alloc] init];
    controller3.mainType =  1;
    controller3.yp_tabItemTitle = @"角色";
    controller3.type = 1;
    controller3.fourSelects = self.fourSelects;
    controller3.vcTag = 0x3333;
    controller3.isSingleSelect = NO;
    controller3.isSingleUse = YES;
    controller3.tableViewHeight = SCREEN_HEIGHT-NaviHeight;
    controller3.actionParameter = ^(NSArray *parameter) {
        self.adminIds = @"";
        [self.atdManagers removeAllObjects];
        NSDictionary *dict = parameter[2];
        NSArray *arr = [dict valueForKey:@"peoples"];
        for (TFRoleModel *em in arr) {

            self.adminIds = [self.adminIds stringByAppendingFormat:@",%@",em.id];
            [self.atdManagers addObject:em];
        }
        if (self.adminIds.length) {
            self.adminIds = [self.adminIds substringFromIndex:1];
        }

        [self.attendanceBL requestAddAttendanceSettingSaveAdminWithModel:self.adminIds];
        
    };
    [self.navigationController pushViewController:controller3 animated:YES];
}

#pragma mark TFOtherSetItemCellDelegate
- (void)setButtonClicked:(NSIndexPath *)indexPath {
    
    /** 打卡提醒 */
    if (indexPath.section == 1) {
        
        UIActionSheet *sheet;
        if (indexPath.row == 1) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"上班提前提醒分钟" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"提前5分钟",@"提前10分钟",@"提前15分钟",@"提前20分钟",@"提前25分钟",@"提前30分钟", nil];
            sheet.tag = 1001;
        }
        else if (indexPath.row == 2) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"下班延后提醒分钟" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"延后5分钟",@"延后10分钟",@"延后15分钟",@"延后20分钟",@"延后25分钟",@"延后30分钟", nil];
            sheet.tag = 1002;
        }
        
        [sheet showInView:self.view];
    }
    /** 榜单设置 */
    else if (indexPath.section == 2) {
        
        UIActionSheet *sheet;
        if (indexPath.row == 1) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"榜单统计方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"所有考勤组都统计在一起",@"按考勤组分开统计", nil];
            sheet.tag = 1003;
        }
        else if (indexPath.row == 5) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"迟到排序方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"按迟到次数排序(次数相同按时长)",@"按迟到时长排序(时长相同按次数)", nil];
            sheet.tag = 1007;
        }
        else {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"排名数字选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"前10",@"前15",@"前20", nil];
            
            if (indexPath.row == 2) {
                
                sheet.tag = 1004;
            }
            if (indexPath.row == 3) {
                
                sheet.tag = 1005;
            }
            if (indexPath.row == 4) {
                
                sheet.tag = 1006;
            }
            
        }
        
        [sheet showInView:self.view];
    }
    /** 晚走晚到 */
    else if (indexPath.section == 3) {
        // 新增
        TFLateNigthWalk *model = [[TFLateNigthWalk alloc] init];
        model.nigthwalkmin = @"";
        model.lateMin = @"";
        [self.lateDatas addObject:model];
        [self.tableView reloadData];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (TFLateNigthWalk *model in self.lateDatas) {
            NSDictionary *dit  = [model toDictionary];
            if (dit) {
                [arr addObject:dit];
            }
        }
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:arr forKey:@"lislateNigthWalkArr"];
        
        [self.attendanceBL requestSaveLateWorkWithDict:dd];
    }
    /** 人性化班次 */
    else if (indexPath.section == 4) {
        
        if (indexPath.row == 1) {
            
            [HQNotPassSubmitView submitPlaceholderStr:@"请设置大于等于零整数" title:@"每人允许迟到次数" maxCharNum:10 LeftTouched:^{
                
            } onRightTouched:^(NSDictionary *dict) {
                NSString *str = dict[@"text"];
                self.otherSettingModel.humanizationAllowLateTimes = str;
                [self.attendanceBL requestAttendanceSettingSaveHommizationWithModel:self.otherSettingModel];
                HQLog(@"===str===%@",str);
                
            }];
        }
        else if (indexPath.row == 2) {
            
            [HQNotPassSubmitView submitPlaceholderStr:@"请设置大于等于零整数" title:@"单次允许迟到分钟数" maxCharNum:10 LeftTouched:^{
                
            } onRightTouched:^(NSDictionary *dict) {
                NSString *str = dict[@"text"];
                HQLog(@"===str===%@",str);
                self.otherSettingModel.humanizationAllowLateMinutes = str;
                [self.attendanceBL requestAttendanceSettingSaveHommizationWithModel:self.otherSettingModel];
            }];
            
        }
    }
    /** 旷工规则 */
    else if (indexPath.section == 5) {
        
        if (indexPath.row == 1) {
            
            [HQNotPassSubmitView submitPlaceholderStr:@"请设置大于等于零整数" title:@"单次迟到超过分钟数记为旷工" maxCharNum:10 LeftTouched:^{
                
            } onRightTouched:^(NSDictionary *dict) {
                NSString *str = dict[@"text"];
                HQLog(@"===str===%@",str);
                self.otherSettingModel.absenteeismRuleBeLateMinutes = str;
                [self.attendanceBL requestAttendanceSettingSaveAbsenteeismWithModel:self.otherSettingModel];
                
            }];
        }
        else if (indexPath.row == 2) {
            
            [HQNotPassSubmitView submitPlaceholderStr:@"请设置大于等于零整数" title:@"单次早退超过分钟数记为旷工" maxCharNum:10 LeftTouched:^{
                
            } onRightTouched:^(NSDictionary *dict) {
                NSString *str = dict[@"text"];
                HQLog(@"===str===%@",str);
                self.otherSettingModel.absenteeismRuleLeaveEarlyMinutes = str;
                [self.attendanceBL requestAttendanceSettingSaveAbsenteeismWithModel:self.otherSettingModel];
            }];
            
        }
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 1001) {
        
        if (buttonIndex != self.remindTimes.count) {
            
            self.otherSettingModel.remindCockBeforeWork = self.remindTimes[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveRemindWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1002) {
        
        if (buttonIndex != self.remindTimes.count) {
            self.otherSettingModel.remindClockAfterWork = self.remindTimes[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveRemindWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1003) {
        
        if (buttonIndex != self.statisticsWays.count) {
            self.otherSettingModel.listSetType = self.statisticsWays[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveCountWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1004) {
        
        if (buttonIndex != self.listMembers.count) {
            self.otherSettingModel.listSetEarlyArrival = self.listMembers[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveCountWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1005) {
        
        if (buttonIndex != self.listMembers.count) {
            self.otherSettingModel.listSetDiligent = self.listMembers[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveCountWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1006) {
        
        if (buttonIndex != self.listMembers.count) {
            self.otherSettingModel.listSetBeLate = self.listMembers[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveCountWithModel:self.otherSettingModel];
        }
        
    }
    else if (actionSheet.tag == 1007) {
        
        if (buttonIndex != self.sequenceRules.count) {
            self.otherSettingModel.listSetSortType = self.sequenceRules[buttonIndex];
            [self.attendanceBL requestAttendanceSettingSaveCountWithModel:self.otherSettingModel];
        }
        
    }
    
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceSettingFindDetail) {
        
        self.detailModel = resp.body;
        [self.atdManagers removeAllObjects];
        [self.atdManagers addObjectsFromArray:self.detailModel.admin_arr];
        
        self.otherSettingModel.remindClockAfterWork = [self.detailModel.remind_clock_after_work description];
        self.otherSettingModel.remindCockBeforeWork = [self.detailModel.remind_clock_before_work description];
        self.otherSettingModel.listSetType = self.detailModel.list_set_type;
        self.otherSettingModel.listSetEarlyArrival = self.detailModel.list_set_early_arrival;
        self.otherSettingModel.listSetDiligent = self.detailModel.list_set_diligent;
        self.otherSettingModel.listSetBeLate = self.detailModel.list_set_be_late;
        self.otherSettingModel.listSetSortType = self.detailModel.list_set_sort_type;
        self.otherSettingModel.humanizationAllowLateMinutes = self.detailModel.humanization_allow_late_minutes;
        self.otherSettingModel.humanizationAllowLateTimes = self.detailModel.humanization_allow_late_times;
        self.otherSettingModel.absenteeismRuleBeLateMinutes = self.detailModel.absenteeism_rule_be_late_minutes;
        self.otherSettingModel.absenteeismRuleLeaveEarlyMinutes = self.detailModel.absenteeism_rule_leave_early_minutes;
        
        [self.lateDatas removeAllObjects];
        [self.lateDatas addObjectsFromArray:self.detailModel.late_nigth_walk_arr];
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_attendanceSettingSaveAdmin) {
        
        [MBProgressHUD showError:@"添加成功" toView:self.view];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_attendanceSettingSaveRemind) {
        
        [self requestDetailData];
    }
    if (resp.cmdId == HQCMD_attendanceSettingSaveCount) {
        
        [self requestDetailData];
    }
    if (resp.cmdId == HQCMD_attendanceSettingSaveHommization) {
        
        [self requestDetailData];
    }
    if (resp.cmdId == HQCMD_attendanceSettingSaveAbsenteeism) {
        
        [self requestDetailData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
