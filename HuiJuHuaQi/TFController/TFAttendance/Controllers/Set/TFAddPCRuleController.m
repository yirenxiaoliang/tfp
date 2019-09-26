//
//  TFAddPCRuleController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCRuleController.h"
#import "TFAddPCRuleCell.h"
#import "HQSelectTimeCell.h"
#import "HQSwitchCell.h"
#import "TFAddressWayCell.h"
#import "TFOneLableCell.h"
#import "TFSelectDateView.h"
#import "FDActionSheet.h"
#import "TFAttendanceBL.h"
#import "TFAtdClassListModel.h"
#import "TFSelectStatusModel.h"
#import "TFAtdWayListModel.h"
#import "TFPCRuleModel.h"
#import "TFAttendanceBL.h"
#import "TFMustPutchCardCell.h"
#import "TFPCRuleController.h"

@interface TFAddPCRuleController ()<UITableViewDelegate,UITableViewDataSource,TFAddPCRuleCellDelegate,HQSwitchCellDelegate,HQBLDelegate,TFOneLableCellDelegate,TFMustPutchCardCellDelegate>

@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *weekData;

//是否收缩
@property (nonatomic, assign) BOOL isHide;

//组索引
@property (nonatomic, assign) NSInteger sectionIndex;

/** 行索引 */
@property (nonatomic, assign) NSInteger rowIndex;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

/** 班次数据 */
@property (nonatomic, strong) TFAtdClassListModel *classModel;

/** 考勤地点 */
@property (nonatomic, strong) TFAtdWayListModel *wayModel;
/** 考勤wifi */
@property (nonatomic, strong) TFAtdWayListModel *wifiModel;

/** 选择班次 */
@property (nonatomic, assign) BOOL isSelectClass;

@property (nonatomic, strong) TFPCRuleModel *ruleModel;
/** 排班选择班次 */
@property (nonatomic, strong) TFSelectStatusModel *arrangeModel;

@end

@implementation TFAddPCRuleController
-(TFSelectStatusModel *)arrangeModel{
    if (!_arrangeModel) {
        _arrangeModel = [[TFSelectStatusModel alloc] init];
    }
    return _arrangeModel;
}

-(TFAtdClassListModel *)classModel{
    if (!_classModel) {
        _classModel = [[TFAtdClassListModel alloc] init];
        
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSInteger i = 0; i < 3; i++) {
//            TFAtdClassModel *mo = [[TFAtdClassModel alloc] init];
//            mo.name = [NSString stringWithFormat:@"我是名字"];
//            mo.cclassType = @"1";
//            mo.time1Start = @"09:00";
//            mo.time1Start = @"18:30";
//            [arr addObject:mo];
//        }
//        _classModel.dataList = arr;
    }
    return _classModel;
}

- (void)initWeekData {
    
    NSArray *weekArr = @[@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",@"星期日"];
    _weekData = [NSMutableArray array];
    
    if (self.type == 2) {// 自由工时
        
        for (int i=0; i<weekArr.count; i++ ) {
            
            TFSelectStatusModel *model = [[TFSelectStatusModel alloc] init];
            model.titleStr = weekArr[i];
            model.isFold = @0;
            
            NSMutableArray<TFAtdClassModel,Optional> *datas = [NSMutableArray<TFAtdClassModel,Optional> array];
            
            // 加一组休息班次
            TFAtdClassModel *mm1 = [[TFAtdClassModel alloc] init];
            mm1.id = @1;
            mm1.name = @"上班";
            mm1.classDesc = @"";
            [datas addObject:mm1];
            
            // 加一组休息班次
            TFAtdClassModel *mm = [[TFAtdClassModel alloc] init];
            mm.id = @0;
            mm.name = @"休息";
            mm.classDesc = @"";
            [datas addObject:mm];
            
            model.dataList =  datas;
            
            [_weekData addObject:model];
        }
        
        if (self.vcType == 0) {
            // 新增默认选择休息班次
            for (TFSelectStatusModel *ssModel in _weekData) {
                
                TFAtdClassModel *model = ssModel.dataList.lastObject;
                model.isSelect = @1;
                ssModel.name = [NSString stringWithFormat:@"%@: %@",model.name,TEXT(model.classDesc)];
            }
        }else{
            // 编辑时根据数据选中对应的值
            NSArray *arr = [self.dict valueForKey:@"work_day_list"];
            for (NSInteger i = 0; i < _weekData.count; i++) {
                TFSelectStatusModel *ssModel = _weekData[i];
                if (arr.count > i) {// 考虑到可能数组长度不一样
                    NSNumber *num = arr[i];
                    for (TFAtdClassModel *cc in ssModel.dataList) {
                        if (num.integerValue == cc.id.integerValue) {
                            cc.isSelect = @1;
                            if (!IsStrEmpty(cc.classDesc)) {
                                ssModel.name = [NSString stringWithFormat:@"%@: %@",cc.name,TEXT(cc.classDesc)];
                            }else{
                                ssModel.name = [NSString stringWithFormat:@"%@",cc.name];
                            }
                            break;
                        }
                    }
                }else{// 超出index，就选中休息班次
                    TFAtdClassModel *model = ssModel.dataList.lastObject;
                    model.isSelect = @1;
                    ssModel.name = [NSString stringWithFormat:@"%@",model.name];
                }
            }
            
        }
        
    }
    
    if (self.type == 0 || self.type == 1) {// 固定,排班
        
        for (int i=0; i<weekArr.count; i++ ) {
            
            TFSelectStatusModel *model = [[TFSelectStatusModel alloc] init];
            model.titleStr = weekArr[i];
            model.isFold = @0;
            
            NSMutableArray<TFAtdClassModel,Optional> *datas = [NSMutableArray<TFAtdClassModel,Optional> array];
            for (TFAtdClassModel *mo in self.classModel.dataList) {
                
                TFAtdClassModel *mol = [[TFAtdClassModel alloc] init];
                
                mol.id = mo.id;
                mol.name = mo.name;
                mol.classDesc = mo.classDesc;;
                [datas addObject:mol];
            }
            // 加一组休息班次
            TFAtdClassModel *mm = [[TFAtdClassModel alloc] init];
            mm.id = @0;
            mm.name = @"休息";
            mm.classDesc = @"";
            [datas addObject:mm];
            
            model.dataList =  datas;
            
            [_weekData addObject:model];
        }
        
        if (self.vcType == 0) {
            // 新增默认选择休息班次
            for (TFSelectStatusModel *ssModel in _weekData) {
                
                TFAtdClassModel *model = ssModel.dataList.lastObject;
                model.isSelect = @1;
                ssModel.name = [NSString stringWithFormat:@"%@: %@",model.name,TEXT(model.classDesc)];
            }
        }else{
            // 编辑时根据数据选中对应的值
            NSArray *arr = ([self.dict valueForKey:@"work_day_list"] == nil || [[self.dict valueForKey:@"work_day_list"] isEqual:[NSNull null]]) ? @[] : [self.dict valueForKey:@"work_day_list"];
            for (NSInteger i = 0; i < _weekData.count; i++) {
                TFSelectStatusModel *ssModel = _weekData[i];
                if (arr.count > i) {// 考虑到可能数组长度不一样
                    NSNumber *num = arr[i];
                    for (TFAtdClassModel *cc in ssModel.dataList) {
                        if (num.integerValue == cc.id.integerValue) {
                            cc.isSelect = @1;
                            if (!IsStrEmpty(cc.classDesc)) {
                                ssModel.name = [NSString stringWithFormat:@"%@: %@",cc.name,TEXT(cc.classDesc)];
                            }else{
                                ssModel.name = [NSString stringWithFormat:@"%@",cc.name];
                            }
                            break;
                        }
                    }
                }else{// 超出index，就选中休息班次
                    TFAtdClassModel *model = ssModel.dataList.lastObject;
                    model.isSelect = @1;
                    ssModel.name = [NSString stringWithFormat:@"%@",model.name];
                }
            }
        }
    }
   
}

- (TFPCRuleModel *)ruleModel {
    
    if (!_ruleModel) {
        
        _ruleModel = [[TFPCRuleModel alloc] init];
    }
    return _ruleModel;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.isHide = YES;
    
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    
    //先拿班次数据
    [self.atdBL requestGetAttendanceClassFindListWithPageNum:@1 pageSize:@100];
    
    [self setNavi];
    
    [self initWeekData];
    
    [self setupTableView];
    
}

- (void)setNavi {
    
    self.navigationItem.title = @"规则设置";
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
    return 17;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1 || section == 2 || section == 3 || section == 4 || section == 5 || section == 6 || section == 7) {
        TFSelectStatusModel *ssModel = self.weekData[section-1];
        if ([ssModel.isFold isEqualToNumber:@1]) {
            return 1+ssModel.dataList.count;
        }
        else {
            return 1;
        }
    }
    if (section == 11) {// 排班制的选择班次
        if ([self.arrangeModel.isFold isEqualToNumber:@1]) {
            return 1+self.arrangeModel.dataList.count;
        }
        else {
            return 1;
        }
    }
    if (section == 13) {
        
        if (!self.wayModel.select || [self.wayModel.select isEqualToNumber:@0]) {
            
            return 1;
        }
        else {
            
            return self.wayModel.dataList.count+1;
        }
    }
    if (section == 14) {
        
        if (!self.wifiModel.select || [self.wifiModel.select isEqualToNumber:@0]) {
            
            return 1;
        }else{
            return self.wifiModel.dataList.count+1;
        }
    }
    if (section == 9) {// 必须打卡
        return 1+self.ruleModel.mustPunchcardDate.count;
    }
    if (section == 10) {// 不打卡
        return 1+self.ruleModel.noPunchcardDate.count;
    }
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFAddPCRuleCell *cell = [TFAddPCRuleCell addPCRuleCellWithTableView:tableView];
        
        cell.segment.selectedSegmentIndex = self.type;
        cell.delegate = self;
        [cell configAddPCRuleCellWithTableView:self.type];
        return cell;
    }
    else if (indexPath.section == 8) { //法定节假日自动排休
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        
        cell.title.text = @"法定节假日自动排休";
        cell.switchBtn.tag = indexPath.section;
        cell.delegate = self;
        cell.topLine.hidden = NO;
        cell.switchBtn.on = [self.ruleModel.autoStatus isEqualToString:@"1"] ? YES : NO;
        return cell;

    }
    else if (indexPath.section == 9) { //必须打卡日期
        if (indexPath.row == 0) {
            
            TFOneLableCell *cell = [TFOneLableCell OneLableCellWithTableView:tableView];
            
            cell.titleLable.text = @"必须打卡日期";
            cell.enterH.constant = 26;
            cell.enterW.constant = 44;
            cell.tag = 111;
            cell.enterBtn.layer.cornerRadius = 4.0;
            cell.enterBtn.layer.masksToBounds = YES;
            cell.enterBtn.layer.borderWidth = 0.5;
            cell.enterBtn.layer.borderColor = [GreenColor CGColor];
            cell.enterBtn.titleLabel.font = FONT(12);
            [cell.enterBtn setTitle:@"添加" forState:UIControlStateNormal];
            [cell.enterBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            
            cell.topLine.hidden = NO;
            cell.delegate = self;
            
            return cell;
        }else{
            
            TFMustPutchCardCell *cell = [TFMustPutchCardCell mustPutchCardCellWithTableView:tableView];
            [cell refreshCellWithModel:self.ruleModel.mustPunchcardDate[indexPath.row-1]];
            cell.tag = indexPath.section *1234 + indexPath.row-1;
            cell.delegate = self;
            return cell;
        }
        
    }
    else if (indexPath.section == 10) { //不用打卡日期

        if (indexPath.row == 0) {
            
            TFOneLableCell *cell = [TFOneLableCell OneLableCellWithTableView:tableView];
            
            cell.titleLable.text = @"不用打卡日期";
            cell.enterH.constant = 26;
            cell.enterW.constant = 44;
            cell.tag = 222;
            cell.enterBtn.layer.cornerRadius = 4.0;
            cell.enterBtn.layer.masksToBounds = YES;
            cell.enterBtn.layer.borderWidth = 0.5;
            cell.enterBtn.layer.borderColor = [GreenColor CGColor];
            cell.enterBtn.titleLabel.font = FONT(12);
            [cell.enterBtn setTitle:@"添加" forState:UIControlStateNormal];
            [cell.enterBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            
            cell.topLine.hidden = NO;
            cell.delegate = self;
            
            return cell;
        }else{
            
            TFMustPutchCardCell *cell = [TFMustPutchCardCell mustPutchCardCellWithTableView:tableView];
            [cell refreshCellWithModel:self.ruleModel.noPunchcardDate[indexPath.row-1]];
            cell.tag = indexPath.section *1234 + indexPath.row-1;
            cell.delegate = self;
            return cell;
        }

    }
    else if (indexPath.section == 11) { //(排班制)
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitleWidthLayout.constant = 95;
            cell.timeTitle.text = @"选择班次";
            cell.arrow.image = IMG(@"下一级浅灰");
            cell.arrow.hidden = NO;
            cell.backgroundColor = WhiteColor;
            cell.time.text = self.arrangeModel.name;
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.time.textColor = kUIColorFromRGB(0x999999);
//            if ([self.arrangeModel.isFold isEqualToNumber:@1]) {
//                cell.arrow.transform = CGAffineTransformRotate(cell.arrow.transform, M_PI_2);
//            }else{
//                cell.arrow.transform = CGAffineTransformIdentity;
//            }
            return cell;
        }else{
        
            TFAtdClassModel *model = self.arrangeModel.dataList[indexPath.row-1];
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitle.text = @"";
            cell.time.text = [NSString stringWithFormat:@"%@: %@",model.name,TEXT(model.classDesc)];
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.time.textColor = kUIColorFromRGB(0x999999);
            cell.time.font = FONT(14);
            cell.backgroundColor = HexColor(0xF8FBFE);
            cell.timeTitleWidthLayout.constant = 0;
            if ([model.isSelect isEqualToNumber:@1]) {
                
                cell.arrow.hidden = NO;
                [cell.arrow setImage:IMG(@"考勤选择")];
            }
            else {
                
                cell.arrow.hidden = YES;
                [cell.arrow setImage:IMG(@"")];
            }
            
            return cell;
        }
    }
    else if (indexPath.section == 12) { //(自由工时)
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitleWidthLayout.constant = 95;
        cell.timeTitle.text = @"考勤开始时间";
        cell.arrow.image = IMG(@"下一级浅灰");
        cell.arrow.hidden = NO;
        cell.backgroundColor = WhiteColor;
        cell.time.text = TEXT(self.ruleModel.attendanceStartTime);
        return cell;
    }
    else if (indexPath.section == 13) {
        
        if (indexPath.row == 0) { //选择办公地点
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitleWidthLayout.constant = 95;
            cell.timeTitle.text = @"选择办公地点";
            cell.time.text = @"";
            cell.arrow.image = IMG(@"下一级浅灰");
            cell.arrow.hidden = NO;
            cell.backgroundColor = WhiteColor;
            return cell;
        }
        else {
            
            TFAtdWatDataListModel *model = self.wayModel.dataList[indexPath.row-1];
            TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
            
            cell.cellType = 1;
            [cell configAddressWayCellWithTableView:model];
            
            if ([model.select isEqualToNumber:@1]) {
                [cell.deleteBtn setImage:IMG(@"考勤选择") forState:UIControlStateNormal];
            }
            else {
                [cell.deleteBtn setImage:IMG(@"") forState:UIControlStateNormal];
            }
            
            [cell.deleteBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.deleteBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            
            cell.nameTopCons.constant = -1;
            cell.nameBottomCons.constant = 0;
            cell.addressTopCons.constant = 0;
            cell.deleteBtnTopCons.constant = 28;
            cell.backgroundColor = HexColor(0xF8FBFE);
            if (self.wayModel.dataList.count == indexPath.row) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            return cell;
            
        }
    }
    else if (indexPath.section == 14) { //选择办公WiFi
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitleWidthLayout.constant = 95;
            cell.timeTitle.text = @"选择办公WiFi";
            cell.time.text = @"";
            cell.arrow.image = IMG(@"下一级浅灰");
            cell.arrow.hidden = NO;
            cell.backgroundColor = WhiteColor;
            return cell;
        }
        else {
            
            TFAtdWatDataListModel *model = self.wifiModel.dataList[indexPath.row-1];
            TFAddressWayCell *cell = [TFAddressWayCell addressWayCellWithTableView:tableView];
            
            cell.cellType = 1;
            [cell configWiFiWayCellWithTableView:model];
            if ([model.select isEqualToNumber:@1]) {
                [cell.deleteBtn setImage:IMG(@"考勤选择") forState:UIControlStateNormal];
            }
            else {
                [cell.deleteBtn setImage:IMG(@"") forState:UIControlStateNormal];
            }
            [cell.deleteBtn setTitle:@"" forState:UIControlStateNormal];
            [cell.deleteBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            cell.nameTopCons.constant = -1;
            cell.deleteBtnTopCons.constant = 14;
            cell.backgroundColor = HexColor(0xF8FBFE);
            if (self.wifiModel.dataList.count == indexPath.row) {
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
            }
            return cell;
        }
        
    }
    else if (indexPath.section == 15) {
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        
        cell.title.text = @"允许外勤打卡";
        cell.switchBtn.tag = indexPath.section;
        cell.delegate = self;
        cell.topLine.hidden = NO;
        cell.switchBtn.on = [self.ruleModel.outwokerStatus isEqualToString:@"1"] ? YES : NO;
        return cell;
    }
    else if (indexPath.section == 16) {
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        
        cell.title.text = @"人脸识别打卡";
        cell.switchBtn.tag = indexPath.section;
        cell.delegate = self;
        cell.topLine.hidden = NO;
        cell.switchBtn.on = [self.ruleModel.faceStatus isEqualToString:@"1"] ? YES : NO;
        return cell;
    }
    else {
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            TFSelectStatusModel *weekModel = self.weekData[indexPath.section-1];
            
            cell.timeTitle.text = weekModel.titleStr;
            cell.time.text = weekModel.name;
            cell.timeTitleWidthLayout.constant = 95;
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.time.textColor = kUIColorFromRGB(0x999999);
            cell.time.font = FONT(16);
            cell.backgroundColor = WhiteColor;
            cell.arrow.image = IMG(@"下一级浅灰");
            cell.arrow.hidden = NO;
            return cell;
        }
        else {
            
            TFSelectStatusModel *selectModel = self.weekData[indexPath.section-1];
            TFAtdClassModel *model = selectModel.dataList[indexPath.row-1];
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitle.text = @"";
            if (IsStrEmpty(model.classDesc)) {
                cell.time.text = [NSString stringWithFormat:@"%@",model.name];
            }else{
                cell.time.text = [NSString stringWithFormat:@"%@: %@",model.name,TEXT(model.classDesc)];
            }
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.time.textColor = kUIColorFromRGB(0x999999);
            cell.time.font = FONT(14);
            cell.backgroundColor = HexColor(0xF8FBFE);
            cell.timeTitleWidthLayout.constant = 0;
            if ([model.isSelect isEqualToNumber:@1]) {
                
                cell.arrow.hidden = NO;
                [cell.arrow setImage:IMG(@"考勤选择")];
            }
            else {
                
                cell.arrow.hidden = YES;
                [cell.arrow setImage:IMG(@"")];
            }
            
            return cell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    self.sectionIndex = indexPath.section;
    
    if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7) { //固定班制星期一到星期天
        
        TFSelectStatusModel *ssModel = self.weekData[indexPath.section-1];
        
        if (indexPath.row == 0) { //第一行
            
            if ([ssModel.isFold isEqualToNumber:@1]) { //是否收缩
                
                ssModel.isFold = @0;
            }
            else {
                
                ssModel.isFold = @1;
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            
            for (TFAtdClassModel *model in ssModel.dataList) {
                model.isSelect = @0;
            }
            
            TFAtdClassModel *model = ssModel.dataList[indexPath.row-1];
            model.isSelect = @1;
            if (IsStrEmpty(model.classDesc)) {
                ssModel.name = [NSString stringWithFormat:@"%@",model.name];
            }else{
                ssModel.name = [NSString stringWithFormat:@"%@: %@",model.name,TEXT(model.classDesc)];
            }
            
            self.rowIndex = indexPath.row-1;
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.sectionIndex]; //你需要更新的组数
            
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if (indexPath.section == 11){// 排班制选班次（多选）
        
        TFSelectStatusModel *ssModel = self.arrangeModel;
        
        if (indexPath.row == 0) { //第一行
            
            if ([ssModel.isFold isEqualToNumber:@1]) { //是否收缩
                
                ssModel.isFold = @0;
            }
            else {
                
                ssModel.isFold = @1;
            }
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:indexPath.section];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            
            TFAtdClassModel *model = ssModel.dataList[indexPath.row-1];
            model.isSelect = [model.isSelect isEqualToNumber:@1]?@0:@1;
            
            NSString *str = @"";
            for (TFAtdClassModel *model in ssModel.dataList) {
                if ([model.isSelect isEqualToNumber:@1]) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@: %@,",model.name,TEXT(model.classDesc)]];
                }
            }
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            ssModel.name = str;
            
            self.rowIndex = indexPath.row-1;
            
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.sectionIndex]; //你需要更新的组数
            
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
    else if (indexPath.section == 12) { //选择考勤开始时间
        
        [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time) {
            
            self.ruleModel.attendanceStartTime = time;
            [self.tableView reloadData];
        }];
        
    }
    else if (indexPath.section == 13) { //选择办公地点
        
        if (indexPath.row == 0) { //组头
            
            if (!self.wayModel) {
                [self.atdBL requestGetAttendanceWayListWithType:@0 pageNum:nil pageSize:nil];
            }else{
                self.wayModel.select = [self.wayModel.select isEqualToNumber:@1] ? @0 :@1;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.sectionIndex]; //你需要更新的组数
                
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
        else { //地点
            
            TFAtdWatDataListModel *model = self.wayModel.dataList[indexPath.row-1];
            
            if ([model.select isEqualToNumber:@1]) {
                
                model.select = @0;
            }
            else {
                
                model.select = @1;
            }
            [self.tableView reloadData];
        }
        
    }
    if (indexPath.section == 14) { //选择办公Wi-Fi
        
        if (indexPath.row == 0) { //组头
            
            if (!self.wifiModel) {
                [self.atdBL requestGetAttendanceWayListWithType:@1 pageNum:nil pageSize:nil];
            }else{
                self.wifiModel.select = [self.wifiModel.select isEqualToNumber:@1] ? @0 :@1;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.sectionIndex]; //你需要更新的组数
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            }
            
        }else{
            
            TFAtdWatDataListModel *model = self.wifiModel.dataList[indexPath.row-1];
            
            if ([model.select isEqualToNumber:@1]) {
                
                model.select = @0;
            }
            else {
                
                model.select = @1;
            }
            [self.tableView reloadData];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    if (indexPath.section == 0) {
        
        return 106;
    }
    else {
        
        if (self.type == 0) {
            
            if (indexPath.section == 11 || indexPath.section == 12) {
                
                return 0;
            }
            else {
                
                if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6|| indexPath.section == 7) {
                    
                    if (indexPath.row == 0) {
                        
                        return 60;
                    }
                    else {
                        
                        return 40;
                    }
                }
                
                if (indexPath.section == 13) {
                    
                    if (indexPath.row > 0) {
                        
                        return 100;
                    }
                }
                if (indexPath.section == 14) {
                    
                    if (indexPath.row > 0) {
                        
                        return 70;
                    }
                }
                if (indexPath.section == 9) {// 必须打卡
                    if (indexPath.row == 0) {
                        return 60;
                    }else{
                        return 80;
                    }
                }
                if (indexPath.section == 10) {// 不需打卡
                    
                    if (indexPath.row == 0) {
                        return 60;
                    }else{
                        return 40;
                    }
                    
                }
            }
        }
        if (self.type == 1) {
            
            if ( indexPath.section == 15 || indexPath.section == 16 ) {
                
                return 60;
            }else if (indexPath.section == 11){
                if (indexPath.row == 0) {
                    return 60;
                }else{
                    return 40;
                }
            }else if (indexPath.section == 13) {
                
                if (indexPath.row > 0) {
                    
                    return 100;
                }else{
                    return 60;
                }
            }else if (indexPath.section == 14) {
                
                if (indexPath.row > 0) {
                    
                    return 70;
                }else{
                    return 60;
                }
            }
            else {
                
                return 0;
            }
        }
        if (self.type == 2) {
            
            if (indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6|| indexPath.section == 7) {
                
                if (indexPath.row == 0) {
                    
                    return 60;
                }
                else {
                    
                    return 40;
                }
            }else if (indexPath.section == 8 || indexPath.section == 9 || indexPath.section == 10 || indexPath.section == 11) {
                
                return 0;
            }else if (indexPath.section == 13) {
                
                if (indexPath.row > 0) {
                    
                    return 100;
                }else{
                    return 60;
                }
            }else if (indexPath.section == 14) {
                
                if (indexPath.row > 0) {
                    
                    return 70;
                }else{
                    return 60;
                }
            }
        }
    }
    return 60;
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

#pragma mark TFOneLableCellDelegate (添加必须、不必打卡日期)
- (void)addPCDateClicked:(TFOneLableCell *)cell {
    
    if (cell.tag == 111) {// 添加必须
        
        [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time) {
            
            if (!self.ruleModel.mustPunchcardDate) {
                self.ruleModel.mustPunchcardDate = [NSMutableArray array];
            }
            TFAtdClassModel *model = [[TFAtdClassModel alloc] init];
            model.time = [NSString stringWithFormat:@"%lld",[HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            for (TFAtdClassModel *model1 in self.classModel.dataList) {
                NSString *str = [NSString stringWithFormat:@"%@:%@",model1.name,model1.classDesc];
                
                [alert addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    for (TFAtdClassModel *model2 in self.classModel.dataList) {
                        NSString *str1 = [NSString stringWithFormat:@"%@:%@",model2.name,model2.classDesc];
                        if ([str1 isEqualToString:action.title]) {
                            model.id = model2.id;
                            model.name = model2.name;
                            model.classDesc = model2.classDesc;
                            break;
                        }
                    }
                    [self.ruleModel.mustPunchcardDate addObject:model];
                    [self.tableView reloadData];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }];
    }else{// 不必打卡日期
        
        
        [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time){
            
            if (!self.ruleModel.noPunchcardDate) {
                self.ruleModel.noPunchcardDate = [NSMutableArray array];
            }
            TFAtdClassModel *model = [[TFAtdClassModel alloc] init];
            model.time = [NSString stringWithFormat:@"%lld",[HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]];
            [self.ruleModel.noPunchcardDate addObject:model];
            [self.tableView reloadData];
        }];
    }
    
}
#pragma mark - TFMustPutchCardCellDelegate
-(void)mustPutchCardCellDidDelete:(TFMustPutchCardCell *)cell{
    
    NSInteger section = cell.tag / 1234;
    NSInteger row = cell.tag % 1234;
    if (section == 9) {
        [self.ruleModel.mustPunchcardDate removeObjectAtIndex:row];
    }
    if (section == 10) {
        [self.ruleModel.noPunchcardDate removeObjectAtIndex:row];
    }
    [self.tableView reloadData];
}

#pragma mark HQSwitchCellDelegate
- (void)switchCellDidSwitchButton:(UISwitch *)switchButton {
    
    if (switchButton.tag == 8) { //是否法定休假自动排休
        
        if (switchButton.on) {
            
            self.ruleModel.autoStatus = @"1";
        }
        else {
            
            self.ruleModel.autoStatus = @"0";
        }
        
    }
    else if (switchButton.tag == 15) { //允许外勤打卡
        
        if (switchButton.on) {
            
            self.ruleModel.outwokerStatus = @"1";
        }
        else {
            
            self.ruleModel.outwokerStatus = @"0";
        }
        
    }
    else if (switchButton.tag == 16) { //人脸识别打卡
        
        if (switchButton.on) {
            
            self.ruleModel.faceStatus = @"1";
        }
        else {
            
            self.ruleModel.faceStatus = @"0";
        }
        
    }
    
}

#pragma mark TFAddPCRuleCellDelegate
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    if (self.vcType == 1) {
        sender.selectedSegmentIndex=self.type;
        [MBProgressHUD showError:@"不能修改考勤类型" toView:self.view];
        return;
    }
    NSInteger selecIndex = sender.selectedSegmentIndex;
    switch(selecIndex){
        case 0:
            
            sender.selectedSegmentIndex=0;
            self.type = 0;
            [self initWeekData];
            [self.tableView reloadData];
            break;
            
        case 1:
            
            sender.selectedSegmentIndex = 1;
            self.type = 1;
            [self.tableView reloadData];
            break;
            
        case 2:
            
            sender.selectedSegmentIndex = 2;
            self.type = 2;
            [self initWeekData];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
    
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    // 考勤类型，0:固定班次，1排班制，2：自由打卡
    self.type = [[dict valueForKey:@"attendance_type"] integerValue];
    // 班次设置
    // 在班次请求完设置
    
    // 自由打卡
    if (self.type == 2) {
        self.ruleModel.attendanceStartTime = [dict valueForKey:@"attendance_start_time"];
    }
    // 必须打卡日期
    NSArray *must = [dict valueForKey:@"must_punchcard_date"];
    for (NSDictionary *mustDict in must) {
        TFAtdClassModel *model = [[TFAtdClassModel alloc] init];
        model.time = [[mustDict valueForKey:@"time"] description];
        model.id = [mustDict valueForKey:@"time"];
        model.name = [mustDict valueForKey:@"name"];
        model.classDesc = [mustDict valueForKey:@"class_desc"];
        if (!self.ruleModel.mustPunchcardDate) {
            self.ruleModel.mustPunchcardDate = [NSMutableArray array];
        }
        [self.ruleModel.mustPunchcardDate addObject:model];
    }
    // 不必须打卡
    NSArray *nomust = [dict valueForKey:@"no_punchcard_date"];
    for (NSDictionary *ss in nomust) {
        TFAtdClassModel *model = [[TFAtdClassModel alloc] init];
        model.time = [[ss valueForKey:@"time"] description];
        if (!self.ruleModel.noPunchcardDate) {
            self.ruleModel.noPunchcardDate = [NSMutableArray array];
        }
        [self.ruleModel.noPunchcardDate addObject:model];
    }
    // 自动排休
    self.ruleModel.autoStatus = [[dict valueForKey:@"holiday_auto_status"] description];
    // 考勤地点
    // 请求后进行
    
    // 考勤WiFi
    // 请求后进行
    
    // 外勤打卡
    self.ruleModel.outwokerStatus = [[dict valueForKey:@"outworker_status"] description];
    // 人脸打卡
    self.ruleModel.faceStatus = [[dict valueForKey:@"face_status"] description];
    
}

#pragma mark 保存
- (void)saveAction {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.atdName forKey:@"name"];// 考勤组名字
    // 考勤人员
    NSMutableArray *persons = [NSMutableArray array];
    for (HQEmployModel *emp in self.atdPersons) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (emp.id) {
            [dict setObject:emp.id forKey:@"id"];
        }
        if (emp.picture) {
            [dict setObject:emp.picture forKey:@"picture"];
        }
        
        NSString *name = emp.employeeName?:emp.employee_name;
        if (emp.name?:name) {
            [dict setObject:emp.name?:name forKey:@"name"];
        }
        
        if (emp.sign_id) {
            [dict setObject:emp.sign_id forKey:@"sign_id"];
        }
        if (emp.value) {
            [dict setObject:emp.value forKey:@"value"];
        }
        if (emp.type) {
            [dict setObject:emp.type forKey:@"type"];
        }else{
            [dict setObject:@1 forKey:@"type"];
        }
        [persons addObject:dict];
    }
    [dict setObject:persons forKey:@"attendanceusers"];
    // 不需考勤人员
    NSMutableArray *nopersons = [NSMutableArray array];
    for (HQEmployModel *emp in self.noAtdPersons) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (emp.id) {
            [dict setObject:emp.id forKey:@"id"];
        }
        if (emp.picture) {
            [dict setObject:emp.picture forKey:@"picture"];
        }
        NSString *name = emp.employeeName?:emp.employee_name;
        if (emp.name?:name) {
            [dict setObject:emp.name?:name forKey:@"name"];
        }
        
        if (emp.sign_id) {
            [dict setObject:emp.sign_id forKey:@"sign_id"];
        }
        if (emp.value) {
            [dict setObject:emp.value forKey:@"value"];
        }
        if (emp.type) {
            [dict setObject:emp.type forKey:@"type"];
        }else{
            [dict setObject:@1 forKey:@"type"];
        }
        [nopersons addObject:dict];
    }
    [dict setObject:nopersons forKey:@"excludedusers"];
    // 考勤类型，0:固定班次，1排班制，2：自由打卡
    [dict setObject:[NSString stringWithFormat:@"%ld",self.type] forKey:@"attendanceType"];
    // 考勤班次设置
    if (self.type == 0 || self.type == 2) {
        NSMutableArray *ids = [NSMutableArray array];
        for (TFSelectStatusModel *ssModel in self.weekData) {
            for (TFAtdClassModel *cls in ssModel.dataList) {
                if ([cls.isSelect isEqualToNumber:@1]) {
                    [ids addObject:cls.id];
                    break;
                }
            }
        }
        [dict setObject:ids forKey:@"workdaylist"];
    }
    if (self.type == 2) {// 自由打卡
        [dict setObject:@"0" forKey:@"attendanceStartTime"];
    }else{
        [dict setObject:[NSString stringWithFormat:@"%lld",[HQHelper changeTimeToTimeSp:self.ruleModel.attendanceStartTime formatStr:@"yyyy-MM-dd HH:mm"]] forKey:@"attendanceStartTime"];
    }
    // 必须打卡日期
    NSMutableArray *must = [NSMutableArray array];
    for (TFAtdClassModel *model in self.ruleModel.mustPunchcardDate) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.id) {
            [dd setObject:model.id forKey:@"id"];
        }
        if (model.name) {
            [dd setObject:model.name forKey:@"name"];
        }
        if (model.classDesc) {
            [dd setObject:model.classDesc forKey:@"class_desc"];
        }
        if (model.time) {
            [dd setObject:model.time forKey:@"time"];
        }
        [must addObject:dd];
    }
    [dict setObject:must forKey:@"mustPunchcardDate"];
    // 不需打卡日期
    NSMutableArray *nomust = [NSMutableArray array];
    for (TFAtdClassModel *model in self.ruleModel.noPunchcardDate) {
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.time) {
            [dd setObject:model.time forKey:@"time"];
        }
        [nomust addObject:dd];
    }
    [dict setObject:nomust forKey:@"noPunchcardDate"];
    // 自动排休
    [dict setObject:self.ruleModel.autoStatus forKey:@"holidayAutoStatus"];
    // 考勤地点
    NSMutableArray *adds = [NSMutableArray array];
    for (TFAtdWatDataListModel *mo in self.wayModel.dataList) {
        if ([mo.select isEqualToNumber:@1]) {
            if (mo.id) {
                [adds addObject:mo.id];
            }
        }
    }
    [dict setObject:adds forKey:@"attendanceAddress"];
    if (self.vcType == 1 && !self.wayModel) {
        NSMutableArray *adds = [NSMutableArray array];
        NSArray *arr = [self.dict valueForKey:@"attendance_address"];
        for (NSDictionary *dd in arr) {
            if ([dd valueForKey:@"id"]) {
                [adds addObject:[dd valueForKey:@"id"]];
            }
        }
        [dict setObject:adds forKey:@"attendanceAddress"];
    }
    
    // 考勤WiFi
    NSMutableArray *wifis = [NSMutableArray array];
    for (TFAtdWatDataListModel *mo in self.wifiModel.dataList) {
        if ([mo.select isEqualToNumber:@1]) {
            if (mo.id) {
                [wifis addObject:mo.id];
            }
        }
    }
    [dict setObject:wifis forKey:@"attendanceWIFI"];
    
    if (self.vcType == 1 && !self.wifiModel) {
        NSMutableArray *adds = [NSMutableArray array];
        NSArray *arr = [self.dict valueForKey:@"attendance_wifi"];
        for (NSDictionary *dd in arr) {
            if ([dd valueForKey:@"id"]) {
                [adds addObject:[dd valueForKey:@"id"]];
            }
        }
        [dict setObject:adds forKey:@"attendanceWIFI"];
    }
    
    // 外勤打卡
    if (self.ruleModel.outwokerStatus) {
        [dict setObject:self.ruleModel.outwokerStatus forKey:@"outworkerStatus"];
    }
    // 人脸打卡
    if (self.ruleModel.faceStatus) {
        [dict setObject:self.ruleModel.faceStatus forKey:@"faceStatus"];
    }
    
    if (self.vcType == 0) {// 新增
        
        // 生效
        [dict setObject:@0 forKey:@"effectiveDate"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.atdBL requestAddAttendanceScheduleWithDict:dict];
        
    }else{// 编辑
        
        // id
        [dict setObject:[self.dict valueForKey:@"id"] forKey:@"id"];
        
        // 生效
        __block NSString *effective = @"0";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改后的考勤规则支持立即生效与明日生效两种设置，请选择您所需要的生效方式。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"立即生效" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            effective = @"0";
            [dict setObject:effective forKey:@"effectiveDate"];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.atdBL requestUpdateAttendanceScheduleWithDict:dict];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"明日生效" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            long long sp = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"] + 24 * 60 * 60 * 1000;
            effective = [NSString stringWithFormat:@"%lld",sp];
            
            [dict setObject:effective forKey:@"effectiveDate"];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.atdBL requestUpdateAttendanceScheduleWithDict:dict];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceScheduleUpdate) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"修改成功" toView:KeyWindow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RuleCreateSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_attendanceScheduleSave) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"保存成功" toView:KeyWindow];
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([NSStringFromClass(vc.class) isEqualToString:@"TFAttendanceTabbarController"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RuleCreateSuccess" object:nil];
                [self.navigationController popToViewController:vc animated:YES];
                break;
            }
        }
    }
    
    if (resp.cmdId == HQCMD_attendanceClassFindList) {
        
        self.classModel = resp.body;
        
        [self initWeekData];
        
        NSMutableArray<TFAtdClassModel,Optional> *arr = [NSMutableArray <TFAtdClassModel,Optional>array];
        for (TFAtdClassModel *mo in self.classModel.dataList) {
            TFAtdClassModel *model = [[TFAtdClassModel alloc] init];
            model.id = mo.id;
            model.name = mo.name;
            model.classDesc = mo.classDesc;
            model.time = @"";
            [arr addObject:model];
        }
        // 加一组休息班次
        TFAtdClassModel *mm = [[TFAtdClassModel alloc] init];
        mm.id = @0;
        mm.name = @"休息";
        mm.classDesc = @"";
        mm.isSelect = @1;
        [arr addObject:mm];
        
        self.arrangeModel.dataList = arr;
        
        self.arrangeModel.name = [NSString stringWithFormat:@"%@: %@",mm.name,TEXT(mm.classDesc)];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_attendanceWayFindList) {
        
        if (self.sectionIndex == 13) {
            self.wayModel = resp.body;
            self.wayModel.select = @1;
            if (self.vcType == 1) {// 编辑
                NSArray *arr = [self.dict valueForKey:@"attendance_address"];
                for (NSDictionary *dd in arr) {
                    for (TFAtdWatDataListModel *ww in self.wayModel.dataList) {
                        if ([[dd valueForKey:@"id"] integerValue] == [ww.id integerValue]) {
                            ww.select = @1;
                            break;
                        }
                    }
                }
            }
            
        }else{
            self.wifiModel = resp.body;
            self.wifiModel.select = @1;
            if (self.vcType == 1) {// 编辑
                NSArray *arr = [self.dict valueForKey:@"attendance_wifi"];
                for (NSDictionary *dd in arr) {
                    for (TFAtdWatDataListModel *ww in self.wifiModel.dataList) {
                        if ([[dd valueForKey:@"id"] integerValue] == [ww.id integerValue]) {
                            ww.select = @1;
                            break;
                        }
                    }
                }
            }
            
        }
        
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:self.sectionIndex]; //你需要更新的组数
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
