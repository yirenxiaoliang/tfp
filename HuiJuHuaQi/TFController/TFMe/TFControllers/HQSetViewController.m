//
//  HQSetViewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSetViewController.h"
#import "UILabel+Extension.h"
#import "HQReSetPasswordController.h"
#import "HQChangePhoneNumVC.h"
#import "AlertView.h"
#import "Masonry.h"
#import "TFLauguageController.h"
#import "TFSocketManager.h"
#import "HQSelectTimeCell.h"
#import "HQSwitchCell.h"
#import "HQTFThreeLabelCell.h"


@interface HQSetViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HQSwitchCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) TFSocketManager *socket;

@end

@implementation HQSetViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self createTableView];
    
//    self.socket = [TFSocketManager sharedInstance];
    
}

- (void)setupNavigation {
    self.navigationItem.title = @"设置";
    
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

//    22121
    if (section == 0) {
        
//        return 3;
        return 2;
    }  else if (section == 1) {
        
        return 0;
    }else if (section == 2||section == 3||section == 4) {
        
        return 1;
    } else {
    
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"修改密码";
            cell.time.text = @"";
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            cell.timeTitle.textColor = BlackTextColor;
            cell.timeTitle.font = FONT(16);
            return cell;
            
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"更换手机号码";
            cell.time.text = TEXT(UM.userLoginInfo.employee.phone);
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.time.textColor = GrayTextColor;
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            cell.timeTitle.textColor = BlackTextColor;
            cell.timeTitle.font = FONT(16);
            cell.titltW.constant = 100;
            return cell;
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"语言";
            cell.time.text = @"";
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            cell.timeTitle.textColor = BlackTextColor;
            cell.timeTitle.font = FONT(16);
            return cell;
            
        }
    }else if (indexPath.section == 1){
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        cell.title.text = @"绑定微信号";
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        cell.switchBtn.tag = 0x111;
        cell.switchBtn.on = NO;
        cell.delegate = self;
        cell.title.textColor = BlackTextColor;
        cell.title.font = FONT(16);
        return cell;
        
    }else if (indexPath.section == 2){
        
        HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
        cell.title.text = @"文件大于10M仅在WiFi连接时上传/下载";
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        cell.delegate = self;
        NSNumber *remain = [[NSUserDefaults standardUserDefaults] valueForKey:DataFlowRemain];
        cell.switchBtn.on = (!remain || [remain isEqualToNumber:@1]) ? YES : NO;// 默认开启
        cell.title.textColor = BlackTextColor;
        cell.title.font = FONT(16);
        return cell;
        
    }else if (indexPath.section == 3){
        
        NSInteger size = [[[SDWebImageManager sharedManager] imageCache] getSize];
        NSString *str = @"清空缓存";
        NSString *str1 = @"";
        if (size > 0) {
            str1 = [NSString stringWithFormat:@"（%@）",[HQHelper fileSizeForKB:size]];
        }
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = str;
        cell.time.text = str1;
        cell.time.textColor = GrayTextColor;
        cell.structure = @"1";
        cell.fieldControl = @"0";
        cell.arrowShowState = YES;
        cell.titltW.constant = SCREEN_WIDTH-60;
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        cell.timeTitle.textColor = BlackTextColor;
        cell.timeTitle.font = FONT(16);
        cell.timeTitleWidthLayout.constant = 70;
        return cell;
        
    }else {
        
        HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
        
        cell.bottomLine.hidden = YES;
        cell.topLine.hidden = YES;
        cell.leftLabel.hidden = YES;
        cell.rightLabel.hidden = YES;
        cell.middleLabel.text = @"退出登录";
        cell.middleLabel.textColor = BlackTextColor;
        cell.middleLabel.font = FONT(16);
        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            HQReSetPasswordController *resetVC = [[HQReSetPasswordController alloc] init];
            [self.navigationController pushViewController:resetVC animated:YES];
        }
        else if (indexPath.row == 1) {
        
            HQChangePhoneNumVC *changeVC = [[HQChangePhoneNumVC alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }else{
            [MBProgressHUD showError:@"敬请期待" toView:self.view];
           
//            TFLauguageController *language = [[TFLauguageController alloc] init];
//            [self.navigationController pushViewController:language animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您确认清空缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 0x123;
            [alertView show];
        }
    }
    
    if (indexPath.section == 4) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        alert.tag = 0x589;
        [alert show];
        
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 4) {
        return 65;
    }
    if (section == 1) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)swicthAction:(UISwitch *)sender {

    NSLog(@"===sender===%ld",sender.tag);
    UISwitch *switchButton = (UISwitch*)sender;
    NSString *typeStr;
    if (sender.tag == 100) {
        
        typeStr = @"微信";
    }
    else if (sender.tag == 101) {
    
        typeStr = @"QQ";
    }
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        NSLog(@"开");
        [AlertView showAlertView:[NSString stringWithFormat:@"“Teamface”想要打开“%@”",typeStr] msg:@"" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
//            @"“TeamFace”想要打开“微信”"
            switchButton.on = NO;
        } onRightTouched:^{
            switchButton.on = YES;
        }];
        
    }else {
        NSLog(@"关");
        [AlertView showAlertView:@"确定要解除绑定吗？" msg:@"" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
            
            switchButton.on = YES;
        } onRightTouched:^{
            switchButton.on = NO;
        }];
    }
}

#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    if (switchButton.tag == 0x111) {
//        switchButton.on = NO;
        [MBProgressHUD showError:@"敬请期待" toView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }else{
        [self wifiSwitchClicked:switchButton];
    }
}

- (void)wifiSwitchClicked:(UISwitch *)wifiSwich{
    
    if (!wifiSwich.on) {
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"提示" message:@"关闭后，非Wi-Fi环境上传/下载大于10M的文件时将不再显示流量提醒。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [view show];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:DataFlowRemain];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableview reloadData];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x589) {
        
        if (buttonIndex == 1) {
            [[TFSocketManager sharedInstance] loginOutSocket];//发退出企信登陆包
            [self.socket socketClose];//关闭连接
            [UM loginOutAction];
        }
    }else if (alertView.tag == 0x123) {
        
        if (buttonIndex == 1) {
            
            // 清理缓存
            [[[SDWebImageManager sharedManager] imageCache] clearDiskOnCompletion:^{
                [self.tableview reloadData];
            }];
            
        }
    }else{
        if (buttonIndex == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:DataFlowRemain];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableview reloadData];
        }else{
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:DataFlowRemain];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self.tableview reloadData];
        }

    }
}


@end
