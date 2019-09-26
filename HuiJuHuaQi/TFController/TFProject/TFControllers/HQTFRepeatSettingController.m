//
//  HQTFRepeatSettingController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/30.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFRepeatSettingController.h"
#import "HQTFTextImageChangeCell.h"
#import "HQTFRepeatRowController.h"
#import "HQTFRepeatSelectView.h"

@interface HQTFRepeatSettingController ()<UITableViewDelegate,UITableViewDataSource>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 选择index */
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *everyday;
@property (nonatomic, copy) NSString *defineSelf;

@end

@implementation HQTFRepeatSettingController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.everyday = @"";
    self.defineSelf = @"";
    [self setupTableView];
    [self setupNavigation];
}


#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    
    self.navigationItem.title = @"重复任务设置";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
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
    
    HQTFTextImageChangeCell *cell = [HQTFTextImageChangeCell textImageChangeCellWithTableView:tableView];
    cell.tag = 0x2468;
    
    cell.titleImg = @"未选中";
    if (indexPath.row == 0) {
        
        cell.title = [NSString stringWithFormat:@"  从不重复"];
        cell.bottomLine.hidden = NO;
        
    }else if (indexPath.row == 1){
        
        cell.title = [NSString stringWithFormat:@"  每天"];
        cell.desc = self.everyday;
        cell.bottomLine.hidden = NO;
        
    }else{
        
        cell.title = [NSString stringWithFormat:@"  自定义"];
        cell.desc = self.defineSelf;
        cell.bottomLine.hidden = YES;
    }
    if (indexPath.row == self.index) {
        cell.titleImg = @"选中";
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    if (indexPath.section == 1) {
    
//        [HQTFTimePeriodView selectTimeViewWithStartTimeSp:self.startSp endTimeSp:self.endSp timeSpArray:^(NSArray *array) {
//            
//            HQLog(@"%@",array);
//            
//            self.startSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"1970/01/01 %@",array[0]] formatStr:@"yyyy/MM/dd HH:mm"];
//            
//            self.endSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"1970/01/01 %@",array[1]] formatStr:@"yyyy/MM/dd HH:mm"];
//            
//            self.time = [NSString stringWithFormat:@"%@ - %@", [HQHelper nsdateToTime:self.startSp formatStr:@"HH:mm"],[HQHelper nsdateToTime:self.endSp formatStr:@"HH:mm"]];
//            
//            
//            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            
//        }];
//    }
    
    
    
    if (indexPath.row == 0) {
        self.index = indexPath.row;
        self.everyday = @"";
    }
    
    if (indexPath.row == 1) {
        [HQTFRepeatSelectView selectTimeViewWithStartWithType:1 start:@"1" end:@"1" timeArray:^(NSArray *array) {
            
            self.index = indexPath.row;
            self.everyday = [NSString stringWithFormat:@"每%@天，重复%@次",array[0],array[1]];
            
            [self.tableView reloadData];
        }];
    }
    
    if (indexPath.row == 2) {
        HQTFRepeatRowController *repeatRow= [[HQTFRepeatRowController alloc] init];
        
        repeatRow.action = ^(NSArray *parameter){
            
            NSString *string = @"";
            
            for (NSNumber *num in parameter[0]) {
                
                string = [string stringByAppendingString:[NSString stringWithFormat:@"周%@ ",[self stringWithIndex:[num integerValue]]]];
            }
            
            NSString *total = [NSString stringWithFormat:@"%@ - %@", [HQHelper nsdateToTime:[parameter[2] longLongValue] formatStr:@"HH:mm"],[HQHelper nsdateToTime:[parameter[3] longLongValue] formatStr:@"HH:mm"]];
            
            string = [string stringByAppendingString:total];
            
            string = [string stringByAppendingString:@" "];
            
            string = [string stringByAppendingString:parameter[1]];
            
            self.defineSelf = string;
            
            self.index = indexPath.row;
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:repeatRow animated:YES];
        self.everyday = @"";
    }
    
    [self.tableView reloadData];
}

-(NSString *)stringWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
            return @"一";
            break;
        case 1:
            return @"二";
            break;
        case 2:
            return @"三";
            break;
        case 3:
            return @"四";
            break;
        case 4:
            return @"五";
            break;
        case 5:
            return @"六";
            break;
        case 6:
            return @"日";
            break;
            
        default:
            break;
    }
    return  @"";
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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
