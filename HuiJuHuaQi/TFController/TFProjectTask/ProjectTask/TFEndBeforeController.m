//
//  TFEndBeforeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEndBeforeController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQSelectTimeCell.h"

@interface TFEndBeforeController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;



@end

@implementation TFEndBeforeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    self.navigationItem.title = @"截止前";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (!self.time || [self.time isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入时间" toView:self.view];
        return;
    }
    
    if (self.parameterAction) {
        NSDictionary *dict = @{@"time":self.time,
                               @"unit":@(self.unit)
                               };
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"请输入";
        cell.textVeiw.text = self.time;
        cell.textVeiw.delegate = self;
        cell.textVeiw.keyboardType = UIKeyboardTypeNumberPad;
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.topLine.hidden = YES;
            cell.bottomLine.hidden = NO;
            cell.timeTitle.textColor = BlackTextColor;
            cell.timeTitle.font = FONT(16);
            cell.titltW.constant = SCREEN_WIDTH-30;
            cell.requireLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.timeTitle.text = @"选择时间单位";
            cell.arrow.image = nil;
            cell.time.textColor = BlackTextColor;
            cell.time.textAlignment = NSTextAlignmentRight;
            cell.arrow.hidden = YES;
            return cell;
            
        }else{
            NSString *str = @"";
            if (indexPath.row - 1 == 0) {
                str = @"分钟";
            }else if (indexPath.row - 1 == 1){
                str = @"小时";
            }else{
                str = @"天";
            }
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.topLine.hidden = YES;
            cell.timeTitle.textColor = GrayTextColor;
            cell.timeTitle.font = FONT(16);
            cell.titltW.constant = SCREEN_WIDTH-30;
            cell.requireLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.timeTitle.text = str;
            if (indexPath.row-1 == self.unit) {
                cell.arrow.image = [UIImage imageNamed:@"完成"];
            }else{
                cell.arrow.image = nil;
            }
            cell.arrow.hidden = NO;
            cell.time.textColor = BlackTextColor;
            cell.time.textAlignment = NSTextAlignmentRight;
            return cell;
            
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        
        if (indexPath.row > 0) {
            
            self.unit = indexPath.row - 1;
            [tableView reloadData];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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
