//
//  TFAddClassesController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddClassesController.h"
#import "HQTFInputCell.h"
#import "TFWorkMemberCell.h"
#import "HQSelectTimeCell.h"
#import "HQSwitchCell.h"
#import "TFSelectDateView.h"

#import "TFAttendanceBL.h"
#import "TFAtdClassModel.h"

@interface TFAddClassesController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,TFWorkMemberCellDelegate,HQSwitchCellDelegate,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isOpen;

//选择的时间
@property (nonatomic, copy) NSString *selectTime;

//index
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, strong) TFAtdClassModel *classModel;

//工作时长
@property (nonatomic, copy) NSString *toalTime;

@end

@implementation TFAddClassesController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setNavi];
    
    if (self.classType == 0) {
        
        [self defaultOneceTime];
    }
    else {
        
        [self.atdBL requestGetAttendanceClassFindDetailWithId:self.classId];
    }
    
    [self setupTableView];
    
    
}

- (void)initData {
    
    
    _classModel = [[TFAtdClassModel alloc] init];
    
    //    1次的默认值是09：00-18:00
    //    休息开始的默认值是12:00休息结束的默认值是13:00
    //    2次的默认值是09：00-12：00；14:00-18:00
    //    3次的默认值是09:00-11:00；12:00-15:00；16:00-18:00
    
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    
    //默认显示休息时间
    self.isOpen = YES;
    
}

- (void)defaultOneceTime {
    
    //默认次数
    self.classModel.classType = [NSString stringWithFormat:@"%ld",self.type+1];
    
    if ([self.classModel.classType isEqualToString:@"1"]) { //1次的默认值
        
        self.classModel.time1Start = @"09:00";
        self.classModel.time1End = @"18:00";
        
        self.classModel.rest1Start = @"12:00";
        self.classModel.rest1End = @"13:00";
    }
    
}

- (void)setNavi {
    
    if (self.classType == 0) {
        self.navigationItem.title = @"添加班次";
    }else{
        self.navigationItem.title = @"编辑班次";
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
    
    return 11;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"班次名称";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.placeholder = @"请输入少于10个字名称";
        cell.delegate = self;
        cell.textField.text = self.classModel.name;
        cell.textField.delegate = self;
        cell.titleLabel.textColor = kUIColorFromRGB(0x333333);
        [cell refreshInputCellWithType:0];
        
        return cell;
    }
    else if (indexPath.row == 1) {
        
        TFWorkMemberCell *cell = [TFWorkMemberCell workMemberCellWithTableView:tableView];
        cell.segment.selectedSegmentIndex = self.type;
        cell.delegate = self;
        cell.titleLab.textColor = kUIColorFromRGB(0x333333);
        cell.topLine.hidden = NO;
        return cell;
    }
    else if (indexPath.row == 8) {
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        
        cell.title.text = @"休息时间";
        cell.delegate = self;
        if (self.isOpen) {
            cell.switchBtn.on = YES;
        }
        else{
            cell.switchBtn.on = NO;
        }
        cell.topLine.hidden = NO;
        cell.title.textColor = kUIColorFromRGB(0x333333);
        return cell;
        
    }
    else if (indexPath.row == 9) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"休息开始";
        cell.time.text = self.classModel.rest1Start;
        
        cell.arrow.hidden = NO;
        cell.timeTitle.textColor = kUIColorFromRGB(0x333333);
        cell.time.textColor = kUIColorFromRGB(0x666666);
        return cell;
        
    }
    else if (indexPath.row == 10) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"休息结束";
        cell.time.text = self.classModel.rest1End;
        
        cell.arrow.hidden = NO;
        cell.timeTitle.textColor = kUIColorFromRGB(0x333333);
        cell.time.textColor = kUIColorFromRGB(0x666666);
        return cell;
        
    }
    else {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        if (indexPath.row == 2) {
            
            cell.timeTitle.text = @"上班";
            cell.time.text = self.classModel.time1Start;
        }
        else if (indexPath.row == 3) {
            
            cell.timeTitle.text = @"下班";
            cell.time.text = self.classModel.time1End;
        }
        else if (indexPath.row == 4) {
            
            cell.timeTitle.text = @"上班";
            cell.time.text = self.classModel.time2Start;
        }
        else if (indexPath.row == 5) {
            
            cell.timeTitle.text = @"下班";
            cell.time.text = self.classModel.time2End;
        }
        else if (indexPath.row == 6) {
            
            cell.timeTitle.text = @"上班";
            cell.time.text = self.classModel.time3Start;
        }
        else if (indexPath.row == 7) {
            
            cell.timeTitle.text = @"下班";
            cell.time.text = self.classModel.time3End;
        }

        cell.timeTitle.textColor = kUIColorFromRGB(0x333333);
        cell.time.textColor = kUIColorFromRGB(0x666666);

        cell.arrow.hidden = NO;
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 2 || indexPath.row == 3 ||indexPath.row == 4 ||indexPath.row == 5 ||indexPath.row == 6 ||indexPath.row == 7 || indexPath.row == 9 || indexPath.row == 10) {
        
        [TFSelectDateView selectDateViewWithType:DateViewType_HourMinute timeSp:[HQHelper getNowTimeSp] onRightTouched:^(NSString *time) {
            
            /** 设置考勤时间 */
            if (indexPath.row == 2) {
                
                self.classModel.time1Start = time;
            }
            else if (indexPath.row == 3) {
                
                self.classModel.time1End = time;
            }
            else if (indexPath.row == 4) {
                
                self.classModel.time2Start = time;
            }
            else if (indexPath.row == 5) {
                
                self.classModel.time2End = time;
            }
            else if (indexPath.row == 6) {
                
                self.classModel.time3Start = time;
            }
            else if (indexPath.row == 7) {
                
                self.classModel.time3End = time;
            }
            else if (indexPath.row == 9) {
                
                self.classModel.rest1Start = time;
            }
            else if (indexPath.row == 10) {
                
                self.classModel.rest1End = time;
                
                /** 计算工作时长 */
                
                long long workStartSp = [HQHelper changeTimeToTimeSp:self.classModel.time1Start formatStr:@"HH:mm"]; // 上班时间
                long long workEndSp = [HQHelper changeTimeToTimeSp:self.classModel.time1End formatStr:@"HH:mm"]; // 下班时间
                
                long long workTime; //工作时间     上班时间 - 下班时间
                if (workEndSp > workStartSp) {
                    
                    workTime = workEndSp - workStartSp;
                }
                else { //次日
                    
                    workTime = workEndSp+24*60*60*1000-workStartSp;
                }
                
                
                long long restStartSp = [HQHelper changeTimeToTimeSp:self.classModel.rest1Start formatStr:@"HH:mm"]; //休息开始时间
                long long restEndSp = [HQHelper changeTimeToTimeSp:time formatStr:@"HH:mm"]; //休息结束时间
                
                long long restTime; //休息时间
                
                if (restEndSp > restStartSp) {
                    
                    restTime = restEndSp - restStartSp;
                }
                else {
                    
                    restTime = workEndSp+24*60*60*1000-workStartSp;
                }
                
                //实际工作时间
                long long realTime =  workTime - restTime;
                
                CGFloat hour = floor(realTime / (3600*1000.0));  //向下取整
                CGFloat hour1 = realTime/(3600*1000.0);

                CGFloat mins = (hour1-hour)*60;
                HQLog(@"%f",hour1);
                HQLog(@"%f",mins);
                
                self.classModel.totalWorkingHours = [NSString stringWithFormat:@"%.f小时%.f分钟",hour,mins];
                self.toalTime = [NSString stringWithFormat:@"合计工作时长%.f小时%.f分钟",hour,mins];
                
                self.classModel.attendanceTime = [NSString stringWithFormat:@"%@-%@",self.classModel.time1Start,self.classModel.time1End];
            }
            
            
            
            
            [self.tableView reloadData];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        
        return 97;
    }

    if (self.type == 0) {
        
        if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7) {
            
            return 0;
        }
        else {
            
            if (!self.isOpen) {
                
                if (indexPath.row == 9 || indexPath.row == 10) {
                    
                    return 0;
                }
            }
        }
    }
    else if (self.type == 1) {
        
        if (indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10) {
            
            return 0;
        }
        
    }
    else if (self.type == 2) {
        
        if (indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 ) {
            
            return 0;
        }
        
    }
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    NSString *str = self.toalTime;

    UILabel *lab = [UILabel initCustom:CGRectMake(10, 0, SCREEN_WIDTH-20, 40) title:str titleColor:kUIColorFromRGB(0x666666) titleFont:14 bgColor:ClearColor];
    
    lab.textAlignment = NSTextAlignmentRight;
    
    [view addSubview:lab];
    view.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    return view;

}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.classModel.name = textField.text;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.classModel.name = textField.text;
}

#pragma mark HQSwitchCellDelegate
- (void)switchCellDidSwitchButton:(UISwitch *)switchButton {
    
    if (switchButton.on) {
        
        self.isOpen = YES;
        
        self.classModel.rest1Start = @"";
        self.classModel.rest1End = @"";
    }
    else {
        
        self.isOpen = NO;
        
    }
    
    [self.tableView reloadData];
}

#pragma mark TFWorkMemberCellDelegate
- (void)indexDidChangeForSegmentedControl:(UISegmentedControl *)sender {
    
    NSInteger selecIndex = sender.selectedSegmentIndex;
    
    self.classModel.classType = [NSString stringWithFormat:@"%ld",selecIndex+1];
    switch(selecIndex){
        case 0:

            sender.selectedSegmentIndex=0;
            self.type = 0;
            [self.tableView reloadData];
            break;
            
        case 1:

            sender.selectedSegmentIndex = 1;
            self.type = 1;
            
            if ([self.classModel.classType isEqualToString:@"2"]) { //2次默认值
                
                self.classModel.time1Start = @"09:00";
                self.classModel.time1End = @"12:00";
                
                self.classModel.time2Start = @"14:00";
                self.classModel.time2End = @"18:00";
            }
            
            
            [self.tableView reloadData];
            break;
            
        case 2:
            
            sender.selectedSegmentIndex = 2;
            self.type = 2;
            
            if ([self.classModel.classType isEqualToString:@"3"]) { //3次默认值
                
                self.classModel.time1Start = @"09:00";
                self.classModel.time1End = @"11:00";
                
                self.classModel.time2Start = @"12:00";
                self.classModel.time2End = @"15:00";
                
                self.classModel.time3Start = @"16:00";
                self.classModel.time3End = @"18:00";
            }
            
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
    
}

#pragma mark 保存
- (void)saveAction {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.classModel.classType = [NSString stringWithFormat:@"%ld",self.type+1];
    if (self.classType == 0) {
        
        [self.atdBL requestAddAttendanceClassWithModel:self.classModel];
    }else{
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"修改后的考勤班次支持立即生效与明日生效两种设置，请选择您所需要的生效方式。" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"立即生效" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           
            self.classModel.effectiveDate = @0;
            [self.atdBL requestUpdateAttendanceClassWithModel:self.classModel];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"明日生效" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            long long sp = [HQHelper changeTimeToTimeSp:[HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy-MM-dd"] formatStr:@"yyyy-MM-dd"] + 24 * 60 * 60 * 1000;
            self.classModel.effectiveDate = @(sp);
            [self.atdBL requestUpdateAttendanceClassWithModel:self.classModel];
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_attendanceClassSave) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"添加成功" toView:KeyWindow];
        
        if (self.refresh) {
            
            self.refresh();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_attendanceClassFindDetail) {
        self.classModel = resp.body;
        self.type = [self.classModel.classType integerValue]-1;
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    if (resp.cmdId == HQCMD_attendanceClassUpdate) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"修改成功" toView:KeyWindow];
        if (self.refresh) {
            self.refresh();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
