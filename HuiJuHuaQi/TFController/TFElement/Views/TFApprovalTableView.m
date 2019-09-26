//
//  TFApprovalTableView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/2/28.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalTableView.h"
#import "HQTFNoContentView.h"
#import "TFApprovalFlowProgramCell.h"

@interface TFApprovalTableView()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFApprovalTableView

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(SCREEN_WIDTH-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        [self setupTableView];
        
        self.tableView.scrollEnabled = NO;
    }
    return self;
}
/** 刷新数据 */
-(void)refreshApprovalTableViewWithDatas:(NSArray *)datas{
    
    [self.dynamics removeAllObjects];
    self.dynamics = [NSMutableArray arrayWithArray:datas];
    
    if (self.dynamics.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(approvalTableView:didChangeHeight:)]) {
        if (self.dynamics.count == 0) {
            [self.delegate approvalTableView:self didChangeHeight:SCREEN_WIDTH];
        }else{
            [self.delegate approvalTableView:self didChangeHeight:(90*self.dynamics.count+16)<SCREEN_WIDTH?SCREEN_WIDTH:(90*self.dynamics.count+16)];
        }
    }
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundView = self.noContentView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dynamics.count == 0 ? 0 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFApprovalFlowProgramCell *cell = [TFApprovalFlowProgramCell approvalFlowProgramCellWithTableView:tableView];
    
    [cell refreshApprovalFlowProgramCellWithModels:self.dynamics haveHead:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFApprovalFlowProgramCell refreshApprovalFlowProgramCellHeightWithModels:self.dynamics haveHead:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
