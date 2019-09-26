//
//  HQSignViewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSignViewController.h"

#import "HQCreatScheduleTitleCell.h"

@interface HQSignViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (nonatomic, weak)  UITableView *tableView;

@end

@implementation HQSignViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self setupTableView];
}

- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
    self.navigationItem.title = @"个性签名";
    
    
}

- (void)sure{
    
    if (self.descAction) {
        self.descAction(self.descString);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
    
    cell.textVeiw.placeholder = @"20字以内";
    
    
    cell.textVeiw.placeholderColor = PlacehoderColor;
    cell.textVeiw.delegate = self;
    cell.textVeiw.font = FONT(18);
    cell.textVeiw.text = self.descString;
    cell.textVeiw.tag = 0x12345;
    cell.bottomLine.hidden = YES;
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [cell.textVeiw becomeFirstResponder];
    //    });
    return cell;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    self.descString = textView.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return SCREEN_HEIGHT - 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 35;
}

@end
