//
//  TFWorkBenchChangePeopleController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWorkBenchChangePeopleController.h"
#import "HQTFTwoLineCell.h"
#import "TFProjectTaskBL.h"
#import "HQTFNoContentView.h"
#import "HQTFSearchHeader.h"

@interface TFWorkBenchChangePeopleController ()<UITableViewDelegate,UITableViewDataSource,HQTFTwoLineCellDelegate,HQBLDelegate,HQTFSearchHeaderDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *peoples;
@property (nonatomic, strong) NSMutableArray *totalPeoples;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFWorkBenchChangePeopleController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:[NSString stringWithFormat:@"无数据"]];
    }
    return _noContentView;
}
-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}
-(NSMutableArray *)totalPeoples{
    if (!_totalPeoples) {
        _totalPeoples = [NSMutableArray array];
    }
    return _totalPeoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    [self.projectTaskBL requestChangePeopleList];
    [self setupNavi];
    [self setupTableView];
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_workBenchChangePeopleList) {
        
        [self.peoples removeAllObjects];
        [self.peoples addObjectsFromArray:resp.body];
        [self.totalPeoples addObjectsFromArray:resp.body];
        
        for (HQEmployModel *model in self.defaultPoeples) {
            for (HQEmployModel *model1 in self.peoples) {
                if ([model.id isEqualToNumber:model1.id]) {
                    model1.selectState = @1;
                }
            }
        }
        if (self.peoples.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
        }
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"选择人员";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (HQEmployModel *model in self.peoples) {
        if ([model.selectState isEqualToNumber:@1]) {
            [arr addObject:model];
        }
    }
    
//    if (arr.count == 0) {
//        [MBProgressHUD showError:@"请选择人员" toView:self.view];
//        return ;
//    }
    
    if (self.actionParameter) {
        self.actionParameter(arr);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    headerView.backgroundColor = WhiteColor;
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.type = SearchHeaderTypeSearch;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    header.textField.backgroundColor = BackGroudColor;
    header.image.backgroundColor = BackGroudColor;
    tableView.tableHeaderView = headerView;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        if (textField.text.length == 0) {
            [self.peoples removeAllObjects];
            [self.peoples addObjectsFromArray:self.totalPeoples];
            [self.tableView reloadData];
            return;
        }
        
        NSMutableArray *arr = [NSMutableArray array];
        for (HQEmployModel *model in self.totalPeoples) {
            
            if ([model.employee_name containsString:textField.text]) {
                [arr addObject:model];
            }
        }
        self.peoples = arr;
        if (self.peoples.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = nil;
        }
        [self.tableView reloadData];
    }
    
}


#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peoples.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeTwo;
    cell.delegate = self;
    cell.enterImage.userInteractionEnabled = NO;
    cell.enterImgTrailW.constant = 0;
    HQEmployModel *model = self.peoples[indexPath.row];
    [cell refreshCellWithEmployeeModel:model];
    cell.enterImage.hidden = NO;
    if ([model.selectState isEqualToNumber:@1]) {
        [cell.enterImage setImage:IMG(@"选中") forState:UIControlStateNormal];
        [cell.enterImage setImage:IMG(@"选中") forState:UIControlStateHighlighted];
    }else{
        [cell.enterImage setImage:IMG(@"没选中") forState:UIControlStateNormal];
        [cell.enterImage setImage:IMG(@"没选中") forState:UIControlStateHighlighted];
    }
    cell.bottomLine.hidden = NO;
    if (self.peoples.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HQEmployModel *model = self.peoples[indexPath.row];
    model.selectState = [model.selectState isEqualToNumber:@1]?@0:@1;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
