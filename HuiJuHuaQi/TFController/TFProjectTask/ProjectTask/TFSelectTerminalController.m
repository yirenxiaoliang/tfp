//
//  TFSelectTerminalController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectTerminalController.h"
#import "HQSelectTimeCell.h"
#import "HQCreatScheduleTitleCell.h"
#import "TFSelectDateView.h"

@interface TFSelectTerminalController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;


@end

@implementation TFSelectTerminalController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = @"结束重复";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.endType == 1) {
        
        if (!self.time || [self.time isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入次数" toView:self.view];
            return;
        }
    }
    if (self.endType == 2) {
        
        if (!self.time || [self.time isEqualToString:@""]) {
            [MBProgressHUD showError:@"请选择日期" toView:self.view];
            return;
        }
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(self.endType) forKey:@"endType"];
    if (self.time) {
        [dict setObject:self.time forKey:@"time"];
    }
    
    if (self.parameterAction) {
        self.parameterAction(dict);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
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
        cell.bottomLine.hidden = NO;
        cell.arrow.hidden = NO;
        cell.time.textColor = BlackTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == self.endType) {
            cell.arrow.image = [UIImage imageNamed:@"完成"];
        }else{
            cell.arrow.image = nil;
        }
        if (indexPath.row == 0) {
            cell.timeTitle.text = @"永不";
        }else if (indexPath.row == 1){
            cell.timeTitle.text = @"次数";
        }else{
            cell.timeTitle.text = @"日期";
        }
        return cell;
        
    }else if (indexPath.section == 1){
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"请输入";
        cell.textVeiw.text = self.time;
        cell.textVeiw.delegate = self;
        cell.textVeiw.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
        
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.topLine.hidden = YES;
        cell.timeTitle.font = FONT(16);
        cell.titltW.constant = SCREEN_WIDTH-30;
        cell.requireLabel.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bottomLine.hidden = NO;
        cell.arrow.hidden = NO;
        cell.time.textColor = BlackTextColor;
        cell.time.textAlignment = NSTextAlignmentRight;
        cell.arrow.image = [UIImage imageNamed:@"下一级浅灰"];
        if (self.time && ![self.time isEqualToString:@""]) {
            
            cell.timeTitle.text = self.time;
            cell.timeTitle.textColor = BlackTextColor;
        }else{
            
            cell.timeTitle.text = @"请选择";
            cell.timeTitle.textColor = GrayTextColor;
        }
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        self.endType = indexPath.row;
        self.time = nil;
        [tableView reloadData];
    }
    
    if (indexPath.section == 2) {
        long long timeSp = [HQHelper changeTimeToTimeSp:self.time formatStr:@"yyyy-MM-dd HH:mm"];
        
        [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
            
            self.time = time;
            [self.tableView reloadData];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.endType > 0) {
        if (self.endType == 1) {
            if (indexPath.section == 1) {
                return 50;
            }else if (indexPath.section == 2){
                return 0;
            }
        }
        if (self.endType == 2) {
            if (indexPath.section == 2) {
                return 50;
            }else if (indexPath.section == 1){
                return 0;
            }
        }
    }else{
        if (indexPath.section > 0) {
            return 0;
        }
    }
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.endType == 1) {
        if (section == 1) {
            return 50;
        }else if (section == 2){
            return 0;
        }
    }
    
    if (self.endType == 2) {
        if (section == 2) {
            return 50;
        }else if (section == 1){
            return 0;
        }
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.endType > 0) {
        if (section == 1) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,13,SCREEN_WIDTH-30,40}];
            [view addSubview:label];
            label.textColor = LightBlackTextColor;
            label.font = FONT(16);
            label.text = @"发生次数后";
            
            return view;
        }
        
        if (section == 2) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,13,SCREEN_WIDTH-30,40}];
            [view addSubview:label];
            label.textColor = LightBlackTextColor;
            label.font = FONT(16);
            label.text = @"选择日期";
            
            return view;
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

- (void)textViewDidChange:(UITextView *)textView{
    
    self.time = textView.text;
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
