//
//  TFEmainlsTestController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmainlsTestController.h"
#import "TFEmailsAddHeadView.h"

@interface TFEmainlsTestController ()<UITableViewDelegate,UITableViewDataSource,TFEmailsAddHeadViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic,strong) TFEmailsAddHeadView *addHeadView;

@end

@implementation TFEmainlsTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    
    [self createHeadView];
}

- (void)createHeadView {

    self.addHeadView = [[TFEmailsAddHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.addHeadView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    self.addHeadView.delegate = self;
//    [self.view addSubview:self.addHeadView];
    self.tableView.tableHeaderView = self.addHeadView;
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
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"ewcfds";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
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

- (void)headViewHeight:(float)height {

    self.addHeadView.height = 50+height;
    
    CGRect newFrame = self.addHeadView.frame;
    newFrame.size.height = newFrame.size.height;
    self.addHeadView.frame = newFrame;
//    [self.tableView setTableHeaderView:self.addHeadView];
    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.addHeadView];
    [self.tableView endUpdates];
    
}

@end
