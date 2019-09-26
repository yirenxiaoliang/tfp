//
//  TFContactHeaderView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactHeaderView.h"
#import "HQTFTwoLineCell.h"
#import "TFApprovalSearchView.h"

@interface TFContactHeaderView ()<UITableViewDelegate,UITableViewDataSource,TFApprovalSearchViewDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
@end

@implementation TFContactHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildView];
    }
    return self;
}

- (void)setupChildView{
    
//    UIButton *button = [HQHelper buttonWithFrame:(CGRect){15,8,SCREEN_WIDTH-30,30} normalImageStr:@"搜索" highImageStr:@"搜索" target:self action:@selector(buttonClicked)];
//    button.titleLabel.font = FONT(14);
//    [self addSubview:button];
//    [button setTitle:@" 搜索成员" forState:UIControlStateNormal];
//    [button setTitle:@" 搜索成员" forState:UIControlStateHighlighted];
//    [button setTitleColor:LightGrayTextColor forState:UIControlStateNormal];
//    [button setTitleColor:LightGrayTextColor forState:UIControlStateHighlighted];
//    button.backgroundColor = WhiteColor;
//    button.layer.cornerRadius = 4;
//    button.layer.masksToBounds = YES;
//    [self addSubview:button];
    
    [self setupTableView];
    
    
    
    self.backgroundColor = BackGroudColor;
}

- (void)buttonClicked{
    
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 46+70*5) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    [self addSubview:tableView];
    
    TFApprovalSearchView *view = [TFApprovalSearchView approvalSearchView];
    view.frame = (CGRect){0,0,SCREEN_WIDTH,46};
    view.delegate = self;
    view.type = 1;
    tableView.tableHeaderView = view;
}


-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedSearchWithTextField:)]) {
        [self.delegate contactHeaderViewDidClickedSearchWithTextField:textField];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        
        [cell.titleImage setImage:[UIImage imageNamed:@"组织架构"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"组织架构"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"企业成员";
    }else if (indexPath.row == 1){
        
        [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"群组";
    }else if (indexPath.row == 2){
        
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"机器人";
    }else if (indexPath.row == 3){
        
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"常用联系人";
    }else if (indexPath.row == 4){
        
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateHighlighted];
        cell.topLabel.text = @"外部联系人";
    }
    cell.topLabel.textColor = BlackTextColor;
    cell.enterImage.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.type = TwoLineCellTypeOne;
    if (indexPath.row == 4) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) {
        
        if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedCompanyPeople)]) {
            [self.delegate contactHeaderViewDidClickedCompanyPeople];
        }
    }else if (indexPath.row == 1){
        
        if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedChatGroup)]) {
            [self.delegate contactHeaderViewDidClickedChatGroup];
        }
    }else if (indexPath.row == 2){
            
        if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedRobot)]) {
            [self.delegate contactHeaderViewDidClickedRobot];
        }
        
    }else if (indexPath.row == 3){
        
        if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedOftenPeople)]) {
            [self.delegate contactHeaderViewDidClickedOftenPeople];
        }
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(contactHeaderViewDidClickedOutPeople)]) {
            [self.delegate contactHeaderViewDidClickedOutPeople];
        }
        
    }
    
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
