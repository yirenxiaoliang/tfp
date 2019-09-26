//
//  TFNoteRemindController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteRemindController.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "TFSelectDateView.h"

@interface TFNoteRemindController ()<UITableViewDelegate,UITableViewDataSource,HQSwitchCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, copy) NSString *timeStr;

@end

@implementation TFNoteRemindController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.timeStr = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:@"yyyy年MM月dd日 HH:mm"];
    self.timeStr = self.remindTime;
//    self.status = 1;
    if (self.status == nil) {
        
        self.status = @1;
    }
    
    [self setNavi];
    
    [self setupTableView];
    
}

- (void)setNavi {

    self.navigationItem.title = @"提醒";
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancelAction) text:@"取消" textColor:kUIColorFromRGB(0x909090)];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:kUIColorFromRGB(0x909090)];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.requireLabel.hidden = YES;
        cell.timeTitle.text = @"请选择";
        cell.time.text = self.timeStr;
        cell.arrow.image = IMG(@"备忘录下一级");
        
        return cell;
        
    }
    else {
    
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        
        cell.title.text = @"仅提醒自己";
        cell.delegate = self;
        
        if ([self.status isEqualToNumber:@1]) {
            
            cell.switchBtn.on = YES;
        }
        else {
        
            cell.switchBtn.on = NO;
        }
        
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        long long timeSp = [HQHelper changeTimeToTimeSp:self.timeStr formatStr:@"yyyy年MM月dd日 HH:mm"];

        [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDayHourMinute timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {

           
            
            if (![time isEqualToString:@""]) {
                
                
                long long selectSp = [HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd HH:mm"];
                
                long long nowSp = [HQHelper getNowTimeSp];
                
                if (selectSp <= nowSp) {
                    
                    [MBProgressHUD showError:@"提醒时间必须大于当前时间！" toView:self.view];
                    
                    return ;
                }
                else {
                
                     self.timeStr = time;
                }
            }
            else {
            
                self.timeStr = time;
            }
            
            
            
            [self.tableView reloadData];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 58;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 44;
    }
    else {
    
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return 38;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UILabel *lable = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 44) title:@"   提醒时间" titleColor:kUIColorFromRGB(0x909090) titleFont:13 bgColor:ClearColor];
        
        lable.textAlignment = NSTextAlignmentLeft;
        
        return lable;
    }
    else {
    
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UILabel *lable = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 38) title:@"   如果有设置共享人，不会提醒他们" titleColor:kUIColorFromRGB(0x909090) titleFont:13 bgColor:ClearColor];
        
        lable.textAlignment = NSTextAlignmentLeft;
        
        return lable;
    }
    else {
    
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    
}

#pragma mark HQSwitchCellDelegate
- (void)switchCellDidSwitchButton:(UISwitch *)switchButton {

    if ([self.status isEqualToNumber:@1]) {
        
        self.status = @0;
    }
    else {
    
        self.status = @1;
    }
    
    [self.tableView reloadData];
}

#pragma mark ---导航栏点击方法
- (void)cancelAction {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sureAction {

    
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        if (![self.timeStr isEqualToString:@""] && self.timeStr != nil) {
            
            [dic setObject:self.timeStr forKey:@"time"];
        }
        else {
        
            [MBProgressHUD showError:@"请选择提醒时间 " toView:self.view];
            return;
        }
    


        [dic setObject:self.status forKey:@"status"];
        
        if (self.refresh) {
            
            self.refresh(dic);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    

    
}

@end
