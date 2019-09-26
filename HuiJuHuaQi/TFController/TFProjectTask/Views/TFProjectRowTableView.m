//
//  TFProjectRowTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectRowTableView.h"
#import "TFProjectSectionModel.h"
#import "HQSelectTimeCell.h"


@interface TFProjectRowTableView ()<UITableViewDelegate,UITableViewDataSource>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** rows */
@property (nonatomic, strong) NSArray *rows;

/** UIButton *button */
@property (nonatomic, weak) UIButton *button ;
@end

@implementation TFProjectRowTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
        self.backgroundColor = HexAColor(0x000000,0);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        self.button = button;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tap) name:ProjectRowTableViewHideNotification object:nil];
        
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ProjectRowTableViewHideNotification object:nil];
}

- (void)tap{
    if ([self.delegate respondsToSelector:@selector(projectRowTableViewDidEmpty)]) {
        [self.delegate projectRowTableViewDidEmpty];
    }
    [self hiddenAnimation];
}

-(void)refreshProjectRowTableViewWithRows:(NSArray *)rows{
    
    self.rows = rows;
    
    [self.tableView reloadData];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.bounces = NO;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rows.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    TFProjectSectionModel *row = self.rows[indexPath.row];
    cell.timeTitle.text = row.name;
    cell.titltW.constant = SCREEN_WIDTH - 60;
    if ([row.select isEqualToNumber:@1]) {
        cell.arrow.image = IMG(@"完成");
        cell.timeTitle.textColor = GreenColor;
    }else{
        cell.arrow.image = nil;
        cell.timeTitle.textColor = CellTitleNameColor;
    }
    if (indexPath.row == 0) {
        cell.headMargin = 0;
//        cell.topLine.layer.shadowColor = GrayTextColor.CGColor;
//        cell.topLine.layer.shadowRadius = 2;
//        cell.topLine.layer.shadowOffset = CGSizeMake(0, 4);
//        cell.topLine.layer.shadowOpacity = 0.5;
    }else{
        cell.headMargin = 15;
//        cell.topLine.layer.shadowOffset = CGSizeMake(0, 0);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
    for (TFProjectSectionModel *row in self.rows) {
        row.select = @0;
    }
    TFProjectSectionModel *row = self.rows[indexPath.row];
    row.select = @1;
    
    [tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(projectRowTableViewDidRowIndex:)]) {
        [self.delegate projectRowTableViewDidRowIndex:indexPath.row];
    }
    
    [self hiddenAnimation];
    
    
}

- (void)hiddenAnimation{
    
    [UIView animateWithDuration:0.3 animations:^{
       
        self.tableView.height = 0;
        self.backgroundColor = HexAColor(0x000000, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
        
    }];
    
}

- (void)showAnimation{
    
    [KeyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.height = self.rows.count * 40 > SCREEN_HEIGHT - 64 - 80 ? SCREEN_HEIGHT - 64 - 80 : self.rows.count * 40;
        self.backgroundColor = HexAColor(0x000000, 0.3);
    }completion:^(BOOL finished) {
        
        self.button.frame = CGRectMake(0, self.tableView.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 80 - self.tableView.height);
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
