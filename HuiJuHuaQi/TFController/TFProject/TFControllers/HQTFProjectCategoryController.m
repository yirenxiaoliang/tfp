//
//  HQTFProjectCategoryController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/22.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectCategoryController.h"
#import "HQTFRelateCell.h"
#import "HQTFProjectDescController.h"

@interface HQTFProjectCategoryController ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** categorys */
@property (nonatomic, strong) NSMutableArray *categorys;

@end

@implementation HQTFProjectCategoryController

-(NSMutableArray *)categorys{
    
    if (!_categorys) {
        _categorys = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i ++) {
            
            NSString *str = [NSString stringWithFormat:@"我是分类名称%ld",i];
            HQCustomerModel *model = [[HQCustomerModel alloc] init];
            
            model.customerTitle = str;
            [_categorys addObject:model];
        }
        
    }
    return _categorys;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    
    self.navigationItem.title = @"项目分类";
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 1;
    }
    return self.categorys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
        HQCustomerModel *model = self.categorys[indexPath.row];
        [cell refreshCellWithModel:model withType:1];
        
        if (indexPath.row == self.categorys.count - 1) {
            cell.headMargin = 0;
        }else{
            cell.headMargin = 15;
        }
        return cell;
    }
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *button = [HQHelper buttonWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55) target:nil action:nil];
        button.userInteractionEnabled = NO;
        button.titleLabel.font = FONT(18);
        [button setTitle:@"新建分类" forState:UIControlStateNormal];
        [button setTitle:@"新建分类" forState:UIControlStateHighlighted];
        [button setTitleColor:GreenColor forState:UIControlStateNormal];
        [button setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [cell.contentView addSubview:button];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    if (indexPath.section == 1) {
        HQTFProjectDescController *cate = [[HQTFProjectDescController alloc] init];
        cate.type = 2;
        [self.navigationController pushViewController:cate animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 55;
    }
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 8;
    }
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        NSString *tip = @" 管理分类请到电脑客户端操作";
        UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"关于"];
        attach.bounds = CGRectMake(0, -1, 6, 13);
        
        [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
        
        [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
        
        label.backgroundColor = WhiteColor;
        label.attributedText = str;
        return label;

    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
