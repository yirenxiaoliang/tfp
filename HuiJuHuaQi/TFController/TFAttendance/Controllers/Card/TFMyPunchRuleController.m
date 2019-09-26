//
//  TFMyPunchRuleController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyPunchRuleController.h"
#import "TFPunchCardHeader.h"
#import "TFRuleTimeCell.h"
#import "TFAttendanceBL.h"
#import "TFPCSettingDetailMocel.h"
#import "TFRuleLateCell.h"
#import "TFAttendanceMonthController.h"

@interface TFMyPunchRuleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFRuleTimeCellDelegate>

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;
/** 打卡头部 */
@property (nonatomic, strong) TFPunchCardHeader *punchHeader;

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFPCSettingDetailMocel *detailModel;

@property (nonatomic, assign) BOOL sectionOpen1;
@property (nonatomic, assign) BOOL sectionOpen2;
@property (nonatomic, assign) BOOL sectionOpen3;

@end

@implementation TFMyPunchRuleController

-(TFPunchCardHeader *)punchHeader{
    if (!_punchHeader) {
        _punchHeader = [TFPunchCardHeader punchCardHeader];
        _punchHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
        _punchHeader.dateLabel.hidden = YES;
        _punchHeader.arrow.hidden = YES;
        _punchHeader.positionLabel.text = [NSString stringWithFormat:@"考勤组：%@",self.punchViewModel.cardModel.name];
        _punchHeader.positionLabel.textColor = GrayTextColor;
    }
    return _punchHeader;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionOpen1 = self.sectionOpen2 = self.sectionOpen3 = YES;
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    self.navigationItem.title = @"考勤规则";
    [self setupTableView];
    [self requestDetailData];
}

- (void)requestDetailData {
    
    [self.attendanceBL requestGetAttendanceSettingFindDetail];
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
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    tableView.tableHeaderView = self.punchHeader;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.sectionOpen1) {
            return 1;
        }else{
            return 0;
        }
    }else if (section == 1){
        if (self.sectionOpen2) {
            return 4;
        }else{
            return 0;
        }
    }else{
        if (self.sectionOpen3) {
            return 2;
        }else{
            return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        TFRuleTimeCell *cell = [TFRuleTimeCell ruleTimeCellWithTableView:tableView];
        cell.nameLabel.text = @"上下班时间";
        cell.descLabel.textColor = HexColor(0x4B5F8D);
        cell.descLabel.text = nil;
        cell.delegate = self;
        cell.descLabel.attributedText = [HQHelper stringAttributeWithUnderLine:@"查看我的排班表"];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@:%@",self.punchViewModel.cardModel.name,self.punchViewModel.cardModel.class_info.classDesc];
        return cell;
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            
            TFRuleTimeCell *cell = [TFRuleTimeCell ruleTimeCellWithTableView:tableView];
            cell.nameLabel.text = @"打卡提醒";
            cell.descLabel.textColor = GrayTextColor;
            cell.descLabel.attributedText = nil;
            cell.descLabel.text = [NSString stringWithFormat:@"上班提前%@分钟，提醒员工打上班卡",TEXT(self.detailModel.remind_clock_before_work)];
            cell.timeLabel.text = [NSString stringWithFormat:@"下班推迟%@分钟，提醒员工打下班卡",TEXT(self.detailModel.remind_clock_after_work)];
            return cell;
            
        }else if (indexPath.row == 1){
            
            
//            TFRuleTimeCell *cell = [TFRuleTimeCell ruleTimeCellWithTableView:tableView];
//            cell.nameLabel.text = @"晚到晚走";
//            cell.descLabel.text = @"第一天下班晚走30分钟，";
//            cell.timeLabel.text = @"第二天可以晚到30分钟";
//            return cell;
            TFRuleLateCell *cell = [TFRuleLateCell ruleLateCellWithTableView:tableView];
            cell.type = 0;
            [cell refreshRuleLateCellWithRows:self.detailModel.late_nigth_walk_arr];
            cell.titleLabel.text = @"晚走晚到";
            return cell;
            
        }else if (indexPath.row == 2){
            
            TFRuleTimeCell *cell = [TFRuleTimeCell ruleTimeCellWithTableView:tableView];
            cell.nameLabel.text = @"人性化班次";
            cell.descLabel.textColor = GrayTextColor;
            cell.descLabel.attributedText = nil;
            cell.descLabel.text = [NSString stringWithFormat:@"每人允许迟到次数%@次，",self.detailModel.humanization_allow_late_times];
            cell.timeLabel.text = [NSString stringWithFormat:@"但是允许迟到%@分钟",self.detailModel.humanization_allow_late_minutes];
            return cell;
        }else{
            
            TFRuleTimeCell *cell = [TFRuleTimeCell ruleTimeCellWithTableView:tableView];
            cell.nameLabel.text = @"旷工规则";
            cell.descLabel.textColor = GrayTextColor;
            cell.descLabel.attributedText = nil;
            cell.descLabel.text = [NSString stringWithFormat:@"单次迟到超过%@分钟数记为旷工，",self.detailModel.absenteeism_rule_be_late_minutes];
            cell.timeLabel.text = [NSString stringWithFormat:@"单次早退超过%@分钟数记为旷工",self.detailModel.absenteeism_rule_leave_early_minutes];
            return cell;
        }
    }else{
        
        if (indexPath.row == 0) {
            TFRuleLateCell *cell = [TFRuleLateCell ruleLateCellWithTableView:tableView];
            cell.type = 1;
            [cell refreshRuleLateCellWithRows:self.punchViewModel.cardModel.attendance_address];
            cell.titleLabel.text = @"办公地点";
            return cell;
        }else{
            TFRuleLateCell *cell = [TFRuleLateCell ruleLateCellWithTableView:tableView];
            cell.type = 2;
            [cell refreshRuleLateCellWithRows:self.punchViewModel.cardModel.attendance_wifi];
            cell.titleLabel.text = @"办公WiFi";
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
           return [TFRuleLateCell refreshRuleLateCellHeightWithRows:self.detailModel.late_nigth_walk_arr];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return [TFRuleLateCell refreshRuleLateCellHeightWithRows:self.punchViewModel.cardModel.attendance_address] ;
        }else{
            return [TFRuleLateCell refreshRuleLateCellHeightWithRows:self.punchViewModel.cardModel.attendance_wifi] ;
        }
    }
    return 85;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,100,44}];
    [view addSubview:label];
    label.font = FONT(16);
    label.textColor = GreenColor;
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH-44,0,44,44}];
    [view addSubview:image];
    image.contentMode = UIViewContentModeCenter;
    image.image = IMG(@"enterDown");
    if (section == 0) {
        if (self.sectionOpen1) {
            image.transform = CGAffineTransformRotate(image.transform, M_PI);
        }else{
            image.transform = CGAffineTransformIdentity;
        }
    }else if (section == 1){
        if (self.sectionOpen2) {
            image.transform = CGAffineTransformRotate(image.transform, M_PI);
        }else{
            image.transform = CGAffineTransformIdentity;
        }
    }else{
        if (self.sectionOpen3) {
            image.transform = CGAffineTransformRotate(image.transform, M_PI);
        }else{
            image.transform = CGAffineTransformIdentity;
        }
    }
    
    UIView *view1 = [[UIView alloc] initWithFrame:(CGRect){0,43.5,SCREEN_WIDTH,.5}];
    view1.backgroundColor = CellSeparatorColor;
    [view addSubview:view1];
    
    if (section == 0) {
        label.text = @"考勤时间";
    }else if (section == 1){
        label.text = @"人性化规则";
    }else{
        label.text = @"考勤范围";
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [view addGestureRecognizer:tap];
    view.tag = section;
    
    return view;
}

-(void)tapClicked:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (view.tag == 0) {
        self.sectionOpen1 = !self.sectionOpen1;
    }else if (view.tag == 1){
        self.sectionOpen2 = !self.sectionOpen2;
    }else{
        self.sectionOpen3 = !self.sectionOpen3;
    }
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFRuleTimeCellDelegate
-(void)ruleTimeCellDidClickedDesc{
    
    TFAttendanceMonthController *calendar = [[TFAttendanceMonthController alloc] init];
    //        calendar.punchDate = self.punchDate;
    [self.navigationController pushViewController:calendar animated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceSettingFindDetail) {
        
        self.detailModel = resp.body;
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
