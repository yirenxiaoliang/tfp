//
//  TFUrlInputRecordView.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/27.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFUrlInputRecordView.h"

@interface TFUrlInputRecordView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation TFUrlInputRecordView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupTableView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupTableView];
    }
    return self;
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [userDefault valueForKey:SaveUrlRecordKey];
    self.datas = arr;
    
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 8;
    self.layer.shadowColor = LightGrayTextColor.CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowOffset = CGSizeZero;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    tableView.layer.cornerRadius = 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    NSString *str = self.datas[indexPath.row];
    cell.textLabel.text = str;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 44, 44);
    [btn setImage:IMG(@"清除clear") forState:UIControlStateNormal];
    btn.tag = indexPath.row;
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = btn;
    return cell;
}

-(void)btnClicked:(UIButton *)btn{
    
    NSInteger tag = btn.tag;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:[userDefault valueForKey:SaveUrlRecordKey]];
    [arr removeObjectAtIndex:tag];
    
    self.datas = arr;
    
    [userDefault setValue:arr forKey:SaveUrlRecordKey];
    [userDefault synchronize];
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if ([self.delegate respondsToSelector:@selector(urlInputRecordViewSelectUrl:)]) {
        [self.delegate urlInputRecordViewSelectUrl:self.datas[indexPath.row]];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
