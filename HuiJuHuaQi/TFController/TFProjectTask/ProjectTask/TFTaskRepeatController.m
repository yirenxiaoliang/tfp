//
//  TFTaskRepeatController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskRepeatController.h"
#import "HQSelectTimeCell.h"
#import "TFSingleTextCell.h"
#import "TFSelectWeekController.h"
#import "TFSelectDayController.h"
#import "TFSelectTerminalController.h"
#import "TFProjectTaskBL.h"

@implementation TFDateModel


@end

@interface TFTaskRepeatController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQBLDelegate>

/** repeatType */
@property (nonatomic, strong) NSNumber *repeatType;

/** repeats */
@property (nonatomic, strong) NSArray *repeats;

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 频率 */
@property (nonatomic, copy) NSString *frequency;

/** dates */
@property (nonatomic, strong) NSMutableArray *dates;

/** endType */
@property (nonatomic, strong) NSNumber *endType;

/** time */
@property (nonatomic, copy) NSString *time;

/** projectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** repeatId */
@property (nonatomic, strong) NSNumber *repeatId;

@end

@implementation TFTaskRepeatController

-(NSMutableArray *)dates{
    if (!_dates) {
        _dates = [NSMutableArray array];
    }
    return _dates;
}

-(NSArray *)repeats{
    if (!_repeats) {
        _repeats = @[@"按天",@"按周",@"按月",@"从不重复"];
    }
    return _repeats;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.endType = @0;
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    if (self.taskType == 0 || self.taskType == 1) {
        [self.projectTaskBL requsetGetProjectTaskRepeatWithTaskId:self.taskId];
    }else{
        [self.projectTaskBL requsetGetPersonnelTaskRepeatWithTaskId:self.taskId];
    }
    
    [self setupTableView];
    [self setupNavi];
}
#pragma mark - navi
- (void)setupNavi{
    self.navigationItem.title = @"设置重复";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (!self.repeatType) {
        [MBProgressHUD showError:@"请选择重复类型" toView:self.view];
        return;
    }else{
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (self.taskId) {
            [dict setObject:self.taskId forKey:@"task_id"];
        }
        if (self.repeatType) {
            [dict setObject:self.repeatType forKey:@"repeat_type"];
        }
        if ([self.repeatType isEqualToNumber:@0]) {// 天
            if (!self.frequency || [self.frequency isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入频率" toView:self.view];
                return;
            }else{
                [dict setObject:self.frequency forKey:@"repeat_unit"];
            }
            if (self.time) {
                if ([self.endType isEqualToNumber:@1]) {
                    [dict setObject:self.time forKey:@"end_of_times"];
                }
                if ([self.endType isEqualToNumber:@2]) {
                    [dict setObject:self.time forKey:@"end_time"];
                }
            }
            
        }else if ([self.repeatType isEqualToNumber:@1] || [self.repeatType isEqualToNumber:@2]){// 周,月
            if (!self.frequency || [self.frequency isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入频率" toView:self.view];
                return;
            }else{
                [dict setObject:self.frequency forKey:@"repeat_unit"];
            }
            if (self.dates.count == 0) {
                [MBProgressHUD showError:@"请选择重复日期" toView:self.view];
                return;
            }else{
                NSString *str = @"";
                for (TFDateModel *date in self.dates) {
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",date.tag + 1]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length-1];
                }
                [dict setObject:str forKey:@"frequency_unit"];
            }
            
            if (self.time) {
                if ([self.endType isEqualToNumber:@1]) {
                    [dict setObject:self.time forKey:@"end_of_times"];
                }
                if ([self.endType isEqualToNumber:@2]) {
                    [dict setObject:self.time forKey:@"end_time"];
                }
            }
        }else if ([self.repeatType isEqualToNumber:@3]){// 从不
            
        }
        if (self.endType) {
            [dict setObject:self.endType forKey:@"end_way"];
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.taskType == 0 || self.taskType == 1) {
            
            if (self.repeatId) {// 修改
                [dict setObject:self.repeatId forKey:@"id"];
                [self.projectTaskBL requsetUpdateProjectTaskRepeatWithDict:dict];
            }else{// 保存
                [self.projectTaskBL requsetSaveProjectTaskRepeatWithDict:dict];
            }
        }else{
            if (self.repeatId) {// 修改
                
                [dict setObject:self.repeatId forKey:@"id"];
                [self.projectTaskBL requsetUpdatePersonnelTaskRepeatWithDict:dict];
            }else{// 保存
                [self.projectTaskBL requsetSavePersonnelTaskRepeatWithDict:dict];
            }
        }
        
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectTaskRepeat || resp.cmdId == HQCMD_getPersonnelTaskRepeat) {
        
        NSArray *arr = resp.body;
        if (arr.count) {
            NSDictionary *dict = arr[0];
            self.repeatId = [dict valueForKey:@"id"];
            self.repeatType = @([[dict valueForKey:@"repeat_type"] integerValue]);
            
            if ([self.repeatType isEqualToNumber:@0]) {// 天
                
                self.frequency = [[dict valueForKey:@"repeat_unit"] description];
                self.endType = @([[dict valueForKey:@"end_way"] integerValue]);
                
                if ([self.endType isEqualToNumber:@1]) {
                    self.time = [[dict valueForKey:@"end_of_times"] description];
                }
                if ([self.endType isEqualToNumber:@2]) {
                    self.time = [[dict valueForKey:@"end_time"] description];
                }
                
                
            }else if ([self.repeatType isEqualToNumber:@1] || [self.repeatType isEqualToNumber:@2]){// 周,月
                
                self.frequency = [[dict valueForKey:@"repeat_unit"] description];
                NSArray *arr = [[dict valueForKey:@"frequency_unit"] componentsSeparatedByString:@","];
                
                NSMutableArray *dates = [NSMutableArray array];
                for (NSInteger i = 0; i < arr.count; i ++) {
                    TFDateModel *date = [[TFDateModel alloc] init];
                    NSString *da = arr[i];
                    date.name = da;
                    if ([self.repeatType isEqualToNumber:@1]) {
                        if ([da isEqualToString:@"1"]) {
                            date.name = @"星期一";
                        }else if ([da isEqualToString:@"2"]) {
                            date.name = @"星期二";
                        }else if ([da isEqualToString:@"3"]) {
                            date.name = @"星期三";
                        }else if ([da isEqualToString:@"4"]) {
                            date.name = @"星期四";
                        }else if ([da isEqualToString:@"5"]) {
                            date.name = @"星期五";
                        }else if ([da isEqualToString:@"6"]) {
                            date.name = @"星期六";
                        }else if ([da isEqualToString:@"7"]) {
                            date.name = @"星期日";
                        }
                    }
                    date.tag = [arr[i] integerValue];
                    date.select = @1;
                    [dates addObject:date];
                }
                self.dates = dates;
                
                self.endType = @([[dict valueForKey:@"end_way"] integerValue]);
                
                if ([self.endType isEqualToNumber:@1]) {
                    self.time = [[dict valueForKey:@"end_of_times"] description];
                }
                if ([self.endType isEqualToNumber:@2]) {
                    self.time = [[dict valueForKey:@"end_time"] description];
                }
                
            }else if ([self.repeatType isEqualToNumber:@3]){// 从不
                
            }
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_saveProjectTaskRepeat) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_savePersonnelTaskRepeat) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_updateProjectTaskRepeat) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_updatePersonnelTaskRepeat) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
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
        return 4;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timeTitle.text = self.repeats[indexPath.row];
        if (self.repeatType) {
            if (indexPath.row  == [self.repeatType integerValue]) {
                cell.arrow.image = [UIImage imageNamed:@"完成"];
            }else{
                cell.arrow.image = nil;
            }
        }else{
            cell.arrow.image = nil;
        }
        cell.bottomLine.hidden = NO;
        cell.arrow.hidden = NO;
        cell.time.textColor = BlackTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        return cell;
        
    }else if (indexPath.section == 1) {
        
        
        TFSingleTextCell *cell = [TFSingleTextCell singleTextCellWithTableView:tableView];
        cell.titleLabel.text = @"频率";
        cell.textView.placeholder = @"请输入";
        cell.textView.delegate = self;
        cell.textView.text = TEXT(self.frequency);
        cell.textView.textColor = GreenColor;
        cell.structure = @"1";
        cell.fieldControl = @"0";
        cell.textView.userInteractionEnabled = YES;
        cell.isHideBtn = NO;
        NSString *str = @"";
        if (self.repeatType) {
            if ([self.repeatType isEqualToNumber:@0]) {
                str = @"天";
            }else if ([self.repeatType isEqualToNumber:@1]){
                str = @"周";
            }else if ([self.repeatType isEqualToNumber:@2]){
                str = @"月";
            }
        }
        cell.textView.textAlignment = NSTextAlignmentRight;
        [cell.enterBtn setTitle:str forState:UIControlStateNormal];
        [cell.enterBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        cell.titleLabel.textColor = GrayTextColor;
        return cell;
        
    }else if (indexPath.section == 2) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-60;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        cell.arrow.hidden = NO;
        if (self.dates.count) {
            NSString *str = @"";
            for (TFDateModel *model in self.dates) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",model.name]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            cell.timeTitle.text = str;
            cell.timeTitle.textColor = BlackTextColor;
            
        }else{
            cell.timeTitle.text = @"选择";
            cell.timeTitle.textColor = GrayTextColor;
        }
        
        return cell;
        
    }else{
        
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = 101;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        cell.arrow.hidden = NO;
        cell.timeTitle.text = @"结束";
        cell.timeTitle.textColor = GrayTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        cell.time.text = self.time;
        if (self.endType) {
            if (!self.endType || [self.endType isEqualToNumber:@0]) {
                
                cell.time.attributedText = [[NSAttributedString alloc] initWithString:@"永不" attributes:@{NSForegroundColorAttributeName:GreenColor}];
                
            }else if ([self.endType isEqualToNumber:@1]){
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@次以后",self.time] attributes:@{NSForegroundColorAttributeName:BlackTextColor,NSFontAttributeName:FONT(16)}];
                
                NSRange range = [[NSString stringWithFormat:@"%@%@",TEXT(self.time),@"次以后"] rangeOfString:TEXT(self.time)];
                
                [str addAttribute:NSForegroundColorAttributeName value:GreenColor range:range];
                
                cell.time.attributedText = str;
                
            }else{
                
                cell.time.attributedText = [[NSAttributedString alloc] initWithString:TEXT(self.time) attributes:@{NSForegroundColorAttributeName:GreenColor}];
            }
        }else{
            cell.time.attributedText = nil;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        self.repeatType = @(indexPath.row);
        [self.dates removeAllObjects];
        self.time = nil;
        self.endType = nil;
        self.frequency = nil;
        // bug1451
        
        [tableView reloadData];
    }
    
    if (indexPath.section == 2) {
        
        if ([self.repeatType isEqualToNumber:@1]) {// 周
            TFSelectWeekController *week = [[TFSelectWeekController alloc] init];
            week.selects = self.dates;
            week.parameterAction = ^(id parameter) {
              
                self.dates = parameter;
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:week animated:YES];
        }
        
        if ([self.repeatType isEqualToNumber:@2]) {// 月
            TFSelectDayController *day = [[TFSelectDayController alloc] init];
            day.selects = self.dates;
            day.parameterAction = ^(id parameter) {
              
                self.dates = parameter;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:day animated:YES];
        }
    }
    if (indexPath.section == 3) {// 结束
        
        TFSelectTerminalController *terminal = [[TFSelectTerminalController alloc] init];
        terminal.endType = [self.endType integerValue];
        terminal.time = self.time;
        terminal.parameterAction = ^(NSDictionary *parameter) {
          
            self.endType = [parameter valueForKey:@"endType"];
            self.time = [parameter valueForKey:@"time"];
            [tableView reloadData];
        };
        [self.navigationController pushViewController:terminal animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (self.repeatType) {
        
        if ([self.repeatType isEqualToNumber:@3]) {
            if (indexPath.section == 0) {
                return 60;
            }
            return 0;
        }else if ([self.repeatType isEqualToNumber:@0]){
            if (indexPath.section == 2) {
                return 0;
            }
            return 60;
        }else{
            return 60;
        }
        
    }else{
        if (indexPath.section == 0) {
            return 60;
        }else{
            return 0;
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.repeatType isEqualToNumber:@1] || [self.repeatType isEqualToNumber:@2]) {
        
        if (section == 2) {
            return 40;
        }
    }
    if ([self.repeatType isEqualToNumber:@0]) {
        
        if (section == 2) {
            return 0;
        }
    }
    
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        
        if (section == 2) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = BackGroudColor;
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,40}];
            [view addSubview:label];
            label.textColor = LightBlackTextColor;
            label.font = FONT(16);
            if ([self.repeatType isEqualToNumber:@1]) {
                label.text = @"每周重复日期";
            }
            
            if ([self.repeatType isEqualToNumber:@2]) {
                label.text = @"每月重复日期";
            }
            
            return view;
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

#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (text.length) {
        if (![text haveNumber]) {
            
            [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    self.frequency = textView.text;
    
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
