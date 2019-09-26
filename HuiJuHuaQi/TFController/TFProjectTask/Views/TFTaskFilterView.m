//
//  TFTaskFilterView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/12.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskFilterView.h"
#import "HQTFThreeLabelCell.h"

@interface TFTaskFilterView () <UITableViewDelegate,UITableViewDataSource>

/** tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** oneSections */
@property (nonatomic, strong) NSMutableArray *oneSections;
/** twoSections */
@property (nonatomic, strong) NSMutableArray *twoSections;


@end

@implementation TFTaskFilterView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = HexAColor(0x000000, 0.5);
        
        self.oneSections = [NSMutableArray arrayWithObjects:@"我负责",@"我创建",@"我参与", nil];
        self.twoSections = [NSMutableArray arrayWithObjects:@"超期未完成",@"今日任务",@"明日任务",@"计划任务",@"已完成", nil];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(49, 0, self.width-49, self.height)];
        bgView.backgroundColor = WhiteColor;
        [self addSubview:bgView];
        
        UILabel *titleView = [[UILabel alloc] initWithFrame:(CGRect){0,20,self.width-49,44}];
        [bgView addSubview:titleView];
        titleView.font = BFONT(20);
        titleView.textAlignment = NSTextAlignmentCenter;
        titleView.text = @"筛选";
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NaviHeight, self.width-49, self.height-BottomHeight-NaviHeight) style:UITableViewStylePlain];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.backgroundColor = WhiteColor;
        [bgView addSubview:tableView];
        self.tableView = tableView;
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,self.height-BottomHeight,self.width-49,49}];
        [bgView addSubview:footerView];
        
        UIButton *sortBtn = [[UIButton alloc] initWithFrame:(CGRect){0,0,130,49}];
        [footerView addSubview:sortBtn];
        sortBtn.titleLabel.font = FONT(16);
        [sortBtn setTitle:@" 自定义排序" forState:UIControlStateNormal];
        [sortBtn setTitle:@" 自定义排序" forState:UIControlStateHighlighted];
        [sortBtn setTitleColor:HexColor(0x323232) forState:UIControlStateNormal];
        [sortBtn setTitleColor:HexColor(0x323232) forState:UIControlStateHighlighted];
        [sortBtn setImage:[UIImage imageNamed:@"projectSort"] forState:UIControlStateNormal];
        [sortBtn setImage:[UIImage imageNamed:@"projectSort"] forState:UIControlStateHighlighted];
        [sortBtn addTarget:self action:@selector(sortClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *handleBtn = [[UIButton alloc] initWithFrame:(CGRect){bgView.width-130,0,130,49}];
        [footerView addSubview:handleBtn];
        handleBtn.titleLabel.font = FONT(16);
        [handleBtn setTitle:@" 执行选项" forState:UIControlStateNormal];
        [handleBtn setTitle:@" 执行选项" forState:UIControlStateHighlighted];
        [handleBtn setTitleColor:HexColor(0x323232) forState:UIControlStateNormal];
        [handleBtn setTitleColor:HexColor(0x323232) forState:UIControlStateHighlighted];
        [handleBtn setImage:[UIImage imageNamed:@"projectSetting"] forState:UIControlStateNormal];
        [handleBtn setImage:[UIImage imageNamed:@"projectSetting"] forState:UIControlStateHighlighted];
        [handleBtn addTarget:self action:@selector(handleClicked) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *tapView = [[UIView alloc] initWithFrame:(CGRect){0,0,49,self.height}];
        [self addSubview:tapView];
        tapView.backgroundColor = ClearColor;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [tapView addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)sortClicked{
    
    [self hideAnimation];
    if ([self.delegate respondsToSelector:@selector(taskFilterViewClickedSortBtn)]) {
        [self.delegate taskFilterViewClickedSortBtn];
    }
}

- (void)handleClicked{
    
    [self hideAnimation];
    if ([self.delegate respondsToSelector:@selector(taskFilterViewClickedHandleBtn)]) {
        [self.delegate taskFilterViewClickedHandleBtn];
    }
}


- (void)tapClick{
    
    [self hideAnimation];
}


+ (instancetype)taskFilterView{
    
    TFTaskFilterView *view = [[TFTaskFilterView alloc] initWithFrame:(CGRect){SCREEN_WIDTH,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    
    return view;
}

- (void)showAnimation{
    
    [KeyWindow addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.x = 0;
    }];
}

- (void)hideAnimation{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.x = SCREEN_WIDTH;
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.oneSections.count;
    }else{
        return self.twoSections.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFThreeLabelCell *cell = [HQTFThreeLabelCell threeLabelCellWithTableView:tableView];
    
    if (indexPath.section == 0) {
        
        cell.middleLabel.text = self.oneSections[indexPath.row];
    }else{
        
        cell.middleLabel.text = self.twoSections[indexPath.row];
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [self hideAnimation];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return 0.5;
    }
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
