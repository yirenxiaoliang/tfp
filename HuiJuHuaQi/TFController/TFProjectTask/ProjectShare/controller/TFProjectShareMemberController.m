//
//  TFProjectShareMemberController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/4/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectShareMemberController.h"
#import "HQTFTwoLineCell.h"
#import "TFContactorInfoController.h"

@interface TFProjectShareMemberController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TFProjectShareMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.naviTitle;
    
    [self setupTableView];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQEmployModel *model = self.peoples[indexPath.row];
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.titleImageWidth = 45.0;
    
    cell.titleImage.layer.cornerRadius = 45.0/2;
    
    cell.titleImage.layer.masksToBounds = YES;
    
//    [cell.titleImage setImage:PlaceholderHeadImage forState:UIControlStateNormal];
    if (![model.picture isEqualToString:@""]) {
        
        [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:GreenColor];
    }

    
    cell.topLabel.text = model.employee_name;
    
    cell.bottomLabel.text = model.position;
    
    cell.bottomLine.hidden = YES;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
    HQEmployModel *employee = self.peoples[indexPath.row];
    info.signId = employee.sign_id;
    [self.navigationController pushViewController:info animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 12;
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
