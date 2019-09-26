//
//  TFStatusTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/8/2.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFStatusTableView.h"
#import "HQTFNoContentView.h"
#import "TFSeeStatusCell.h"

@interface TFStatusTableView()<UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** 动态数组 */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFStatusTableView

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
-(void)refreshStatusTableViewWithDatas:(NSArray *)datas{
    
    self.dynamics = [NSMutableArray arrayWithArray:datas];
    
    if (self.dynamics.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = [UIView new];
    }
    
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(statusTableView:didChangeHeight:)]) {
        if (self.dynamics.count == 0) {
            [self.delegate statusTableView:self didChangeHeight:SCREEN_WIDTH];
        }else{
            [self.delegate statusTableView:self didChangeHeight:44*self.dynamics.count < SCREEN_WIDTH ? SCREEN_WIDTH :44*self.dynamics.count];
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
    
    TFSeeStatusCell *cell = [TFSeeStatusCell seeStatusCellWithTableView:tableView];
    [cell refreshSeeStatusCellWithModel:self.dynamics[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
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



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
