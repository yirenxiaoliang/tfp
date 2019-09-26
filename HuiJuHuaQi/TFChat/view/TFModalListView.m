//
//  TFModalListView.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFModalListView.h"
#import "TFAssistantSiftModel.h"

@interface TFModalListView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation TFModalListView

- (instancetype)initWithFrame:(CGRect)frame items:(NSMutableArray *)items {
    
    if (self = [super initWithFrame:frame]) {
        
        self.items = items;
        [self setupTableView];
        
        [self setupTableViewHeaderView];
    }
    return self;
}

- (void)setupTableViewHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,self.width,65}];
    headerView.backgroundColor = WhiteColor;
    
    UILabel *lab1 = [UILabel initCustom:CGRectZero title:@"全部" titleColor:BlackTextColor titleFont:17 bgColor:ClearColor];
    lab1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lab1];
    
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@16);
        make.top.equalTo(@10);
        make.height.equalTo(@22);
        make.width.equalTo(@(self.width-32));
    }];

    UILabel *lab2 = [UILabel initCustom:CGRectZero title:@"选择需要筛选的模块" titleColor:BlackTextColor titleFont:13 bgColor:ClearColor];
    lab2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lab2];
    
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(@16);
        make.top.equalTo(lab1.mas_bottom).offset(1);
        make.width.equalTo(@(self.width-32));
        make.height.equalTo(@18);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.showsVerticalScrollIndicator = NO;
    tableView.backgroundColor = BackGroudColor;
    
    [self addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = self.items[indexPath.row];
    cell.textLabel.textColor = GreenColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
//    UILabel *line = [UILabel initCustom:CGRectMake(0, 44, self.width, 0.5) title:@"" titleColor:nil titleFont:12 bgColor:kUIColorFromRGB(0x999999)];
//
//    [cell addSubview:line];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(siftModuleListWithData:)]) {
        
        [self.delegate siftModuleListWithData:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
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

@end
