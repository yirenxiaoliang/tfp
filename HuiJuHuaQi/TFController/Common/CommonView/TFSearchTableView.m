//
//  TFSearchTableView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/11.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSearchTableView.h"
#import "HQTFThreeLabelCell.h"
#import "TFAutoMatchRuleModel.h"


@interface TFSearchTableView ()<UITableViewDataSource,UITableViewDelegate>

/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** items */
@property (nonatomic, strong) NSArray *items;

/** UIView *grayView */
@property (nonatomic, weak) UIView *grayView;

/** type 0:自定义 1:自动匹配 */
@property (nonatomic, assign) NSInteger type;


@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation TFSearchTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChild];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupChild];
    }
    return self;
}

- (void)setupChild{
    
    [self setupTableView];
    
    self.backgroundColor = RGBAColor(111, 111, 111, 0);
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    grayView.backgroundColor = RGBAColor(111, 111, 111, 0);
    self.grayView = grayView;
    [self addSubview:grayView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundClick)];

    [self.grayView addGestureRecognizer:tap];
}

- (void)backgroundClick{
    
    if ([self.delegate respondsToSelector:@selector(searchTableViewDidClickedBackgruod)]) {
        [self.delegate searchTableViewDidClickedBackgruod];
    }
    
}


-(void)showAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.top = 0;
        self.backgroundColor = RGBAColor(111, 111, 111, 0.4);
    }];
    
}

-(void)hideAnimationWithCompletion:(void(^)(BOOL))completion {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tableView.bottom = 0;
        self.backgroundColor = RGBAColor(111, 111, 111, 0);
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion(finished);
        }
    }];
    
}

-(void)refreshSearchTableViewWithItems:(NSArray *)items type:(NSInteger)type{
    
    _items = items;
    _type = type;
    
    self.tableView.height = 46 * items.count;
    
    self.grayView.top = self.tableView.height;
    self.grayView.height = SCREEN_HEIGHT - self.grayView.top;
    
    [self.tableView reloadData];
}

-(void)refreshSearchTableViewWithItems:(NSArray *)items{
    
    _items = items;
    
    if (46 * items.count > self.height) {
        self.tableView.height = self.height;
        self.tableView.scrollEnabled = YES;
    }else{
        self.tableView.height = 46 * items.count;
        self.tableView.scrollEnabled = NO;
    }
    
    
    self.grayView.top = self.tableView.height;
    self.grayView.height = SCREEN_HEIGHT - self.grayView.top;
    
    [self.tableView reloadData];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self addSubview:tableView];
    self.tableView = tableView;
    tableView.scrollEnabled = NO;
    
    tableView.bottom = 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
    cell.leftLabel.textColor = ExtraLightBlackTextColor;
    cell.leftLabel.font = FONT(14);
    cell.bottomLine.hidden = NO;
    if (self.type == 0) {
        
        TFBeanTypeModel *model = self.items[indexPath.row];
        cell.leftLabel.text = model.name;
    }else{
        
        TFAutoMatchRuleModel *model = self.items[indexPath.row];
        cell.leftLabel.text = model.title;
    }
    if (self.selectIndex == indexPath.row) {
        cell.leftLabel.textColor = GreenColor;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    if ([self.delegate respondsToSelector:@selector(searchTableViewDidSelectIndex:withText:)]) {
//        [self.delegate searchTableViewDidSelectIndex:indexPath.row withText:self.items[indexPath.row]];
//    }
    
    if (self.type == 0) {
        
        if ([self.delegate respondsToSelector:@selector(searchTableViewDidSelectModel:)]) {
            [self.delegate searchTableViewDidSelectModel:self.items[indexPath.row]];
        }
    }else{
        
        if ([self.delegate respondsToSelector:@selector(searchTableViewDidSelectAutoModel:)]) {
            [self.delegate searchTableViewDidSelectAutoModel:self.items[indexPath.row]];
        }
    }
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46;
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
