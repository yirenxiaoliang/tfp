//
//  HQTFRepeatRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRepeatRowController.h"
#import "HQTFRepeatRowCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFTimePeriodView.h"
#import "HQTFRepeatSelectView.h"

@interface HQTFRepeatRowController ()<UITableViewDelegate,UITableViewDataSource,HQTFRepeatRowCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 星期列表 */
@property (nonatomic, strong) NSArray *weekdays;

/** 时间 */
@property (nonatomic, copy) NSString *time;
/** 重复次数 */
@property (nonatomic, copy) NSString *repeatNum;
/** 时间戳 */
@property (nonatomic, assign) long long startSp;
/** 时间戳 */
@property (nonatomic, assign) long long endSp;
@end

@implementation HQTFRepeatRowController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.startSp = [HQHelper changeTimeToTimeSp:@"1970/01/01 09:00" formatStr:@"yyyy/MM/dd HH:mm"];
    self.endSp = [HQHelper changeTimeToTimeSp:@"1970/01/01 16:00" formatStr:@"yyyy/MM/dd HH:mm"];
    self.time = [NSString stringWithFormat:@"%@ - %@", [HQHelper nsdateToTime:self.startSp formatStr:@"HH:mm"],[HQHelper nsdateToTime:self.endSp formatStr:@"HH:mm"]];
    
    self.repeatNum = @"从不";
    
    [self setupTableView];
    [self setupNavigation];
}


#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    self.navigationItem.title = @"自定义重复";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    if (!self.weekdays || self.weekdays.count == 0) {
        [MBProgressHUD showError:@"请选择重复时间" toView:KeyWindow];
        return;
    }
    
    if ([self.repeatNum isEqualToString:@"从不"]) {
        
        [MBProgressHUD showError:@"请选择重复次数" toView:KeyWindow];
        return;
    }
    
    if (self.startSp >= self.endSp) {
        
        [MBProgressHUD showError:@"时间段选择有误" toView:KeyWindow];
        return;
    }
    
    if (self.action) {
        
        self.action(@[self.weekdays, self.repeatNum,@(self.startSp),@(self.endSp)]);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        HQTFRepeatRowCell *cell = [HQTFRepeatRowCell repeatRowCellWithTableView:tableView];
        cell.bottomLine.hidden = NO;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 1) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"重复次数";
        cell.arrowShowState = YES;
        cell.time.text = self.repeatNum;
        cell.time.textColor = LightBlackTextColor;
        cell.bottomLine.hidden = NO;
        return  cell;
        
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"时间段    ";
        cell.arrowShowState = YES;
        if (!self.time) {
            cell.time.text = @"-- --";
            cell.time.textColor = PlacehoderColor;
        }else{
            cell.time.text = self.time;
            cell.time.textColor = LightBlackTextColor;
        }
        cell.bottomLine.hidden = YES;
        return  cell;
        
    }
    
}

-(void)repeatRowCellWithIndexs:(NSArray *)indexs{
    
    self.weekdays = indexs;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 1) {
        
        [HQTFRepeatSelectView selectTimeViewWithStartWithType:0 start:self.repeatNum end:@"" timeArray:^(NSArray *array) {
            self.repeatNum = [NSString stringWithFormat:@"%@次",array[0]];
            if ([array[0] isEqualToString:@"从不"]) {
                self.repeatNum = @"从不";
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    
    if (indexPath.row == 2) {
        
        [HQTFTimePeriodView selectTimeViewWithStartTimeSp:self.startSp endTimeSp:self.endSp timeSpArray:^(NSArray *array) {
            
            HQLog(@"%@",array);
            
            self.startSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"1970/01/01 %@",array[0]] formatStr:@"yyyy/MM/dd HH:mm"];
            
            self.endSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"1970/01/01 %@",array[1]] formatStr:@"yyyy/MM/dd HH:mm"];
            
            self.time = [NSString stringWithFormat:@"%@ - %@", [HQHelper nsdateToTime:self.startSp formatStr:@"HH:mm"],[HQHelper nsdateToTime:self.endSp formatStr:@"HH:mm"]];
            
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        if (SCREEN_WIDTH < 375) {
            return 55 * 3;
        }
        return 55 * 2;
    }
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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
