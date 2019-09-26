//
//  TFEmailTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/7/26.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailTableView.h"
#import "HQTFNoContentView.h"
#import "TFEmailReceiveListModel.h"
#import "TFEmailsListCell.h"

@interface TFEmailTableView ()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFEmailTableView

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
-(void)refreshEmailTableViewWithDatas:(NSArray *)datas{
    
    [self.dynamics removeAllObjects];
    self.dynamics = [NSMutableArray arrayWithArray:datas];
    
    if (self.dynamics.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(emailTableView:didChangeHeight:)]) {
        if (self.dynamics.count == 0) {
            [self.delegate emailTableView:self didChangeHeight:SCREEN_WIDTH];
        }else{
            [self.delegate emailTableView:self didChangeHeight:(90*self.dynamics.count+16)<SCREEN_WIDTH?SCREEN_WIDTH:(90*self.dynamics.count+16)];
        }
    }
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
    tableView.backgroundColor = BackGroudColor;
    [self addSubview:tableView];
    self.tableView = tableView;
    self.tableView.backgroundView = self.noContentView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmailReceiveListModel *model = self.dynamics[indexPath.row];
    TFEmailsListCell *cell = [TFEmailsListCell EmailsListCellWithTableView:tableView];
    cell.leftStatusBtn.hidden = YES;
    [cell refreshEmailListCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(emailTableViewDidClickedEmailWithModel:)]) {
        [self.delegate emailTableViewDidClickedEmailWithModel:self.dynamics[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
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
