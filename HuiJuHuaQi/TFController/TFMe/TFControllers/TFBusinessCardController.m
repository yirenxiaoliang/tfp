//
//  TFBusinessCardController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFBusinessCardController.h"
#import "TFBusinessCardCell.h"

@interface TFBusinessCardController ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** cards */
@property (nonatomic, strong) NSMutableArray *cards;

/** selectNum */
@property (nonatomic, strong) NSNumber *selectNum;

@end

@implementation TFBusinessCardController

-(NSMutableArray *)cards{
    
    if (!_cards) {
        _cards = [NSMutableArray array];
        
        NSString *str = [[NSUserDefaults standardUserDefaults] valueForKey:@"BusinessCard"];
        
        if (str == nil) {
            str = @"businessCard1";
        }
        
        NSString *sss = [str stringByReplacingOccurrencesOfString:@"businessCard" withString:@""];
        NSInteger num = [sss integerValue];
        
        for (NSInteger i = 0; i < 4; i ++) {
            
            if (num-1 == i) {
                [_cards addObject:[NSNumber numberWithBool:YES]];
            }else{
                [_cards addObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
    return _cards;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"我的名片";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"确定" textColor:LightBlackTextColor];
}

- (void)rightClicked{
    
    BOOL contain = NO;
    for (NSInteger i = 0; i < self.cards.count; i ++) {
        NSNumber *num = self.cards[i];
        if ([num boolValue]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"businessCard%ld",i+1] forKey:@"BusinessCard"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            contain = YES;
            break;
        }
    }
    
    if (contain) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD showError:@"请选择" toView:self.view];
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cards.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFBusinessCardCell *cell = [TFBusinessCardCell businessCardCellWithTableView:tableView];
    [cell refreshBusinessCardCellWithType:indexPath.section + 1];
    NSNumber *select = self.cards[indexPath.section];
    cell.selectBtn.selected = [select boolValue];
    cell.selectBtn.userInteractionEnabled = NO;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [self.cards removeAllObjects];
    for (NSInteger i = 0;i < 4 ; i++) {
        [self.cards addObject:[NSNumber numberWithBool:NO]];
    }
    
    self.cards[indexPath.section] = [NSNumber numberWithBool:YES];
    
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return Long(181);
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
