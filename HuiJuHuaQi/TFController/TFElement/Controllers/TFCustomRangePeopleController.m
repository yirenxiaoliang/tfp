//
//  TFCustomRangePeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomRangePeopleController.h"
#import "HQTFSearchHeader.h"
#import "TFSelectPeopleElementCell.h"
#import "TFCustomBL.h"
#import "TFChangeHelper.h"
#import "TFAllSelectView.h"

@interface TFCustomRangePeopleController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,TFSelectPeopleElementCellDelegate,HQBLDelegate,TFAllSelectViewDelegate>
/**  tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** dataPeoples */
@property (nonatomic, strong) NSMutableArray *dataPeoples;

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** allSelectView */
@property (nonatomic, weak) TFAllSelectView *allSelectView;

@end

@implementation TFCustomRangePeopleController

-(NSMutableArray *)dataPeoples{
    
    if (!_dataPeoples) {
        _dataPeoples = [NSMutableArray array];
    }
    return _dataPeoples;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupTableView];
    [self setupTableViewHeader];
    [self setupAllSelectView];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    NSMutableArray *dicts = [NSMutableArray array];
    for (TFNormalPeopleModel *model in self.rangePeople) {
        NSDictionary *dd = [model toDictionary];
        if (dd) {
            [dicts addObject:dd];
        }
    }
    
    [self.customBL requestCustomRangePeopleWithRangePeople:dicts];
    
    self.navigationItem.title = @"成员";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
}

- (void)sure{
    
    NSMutableArray *pol = [NSMutableArray array];
    for (TFEmployModel *kk in self.dataPeoples) {
        
        if ([kk.select isEqualToNumber:@1]) {
            HQEmployModel *ddjj = [TFChangeHelper tfEmployeeToHqEmployee:kk];
            if (ddjj) {
                [pol addObject:ddjj];
            }
        }
    }
    
    if (pol.count == 0) {
        
        [MBProgressHUD showError:@"请选择成员" toView:self.view];
        return;
    }
    
    if (self.actionParameter) {
        self.actionParameter(pol);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customRangePeople) {
        
        NSArray *arr = resp.body;
        [self.dataPeoples removeAllObjects];
        for (NSDictionary *dict in arr) {
            
            TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
            if (model) {
                [self.dataPeoples addObject:model];
            }
        }
        
    }
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

/** 全选 */
- (void)setupAllSelectView{
    
    TFAllSelectView *allSelectView = [TFAllSelectView allSelectView];
    allSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, 44);
    [self.view addSubview:allSelectView];
    allSelectView.delegate = self;
    self.allSelectView = allSelectView;
    
}

#pragma mark - TFAllSelectViewDelegate
-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn{
   
    if (selectBtn.selected) {
        
        for (TFEmployModel *model in self.dataPeoples) {
            
            if ([model.select isEqualToNumber:@2]) {
                continue;
            }
            model.select = @1;
        }
    }else{
        for (TFEmployModel *model in self.dataPeoples) {
            
            if ([model.select isEqualToNumber:@2]) {
                continue;
            }
            model.select = @0;
        }
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFEmployModel *model in self.dataPeoples) {
        
        if ([model.select isEqualToNumber:@2]) {
            continue;
        }
        [arr addObject:model];
    }
    
    self.allSelectView.numLabel.hidden = !selectBtn.selected;
    
    self.allSelectView.numLabel.text = [NSString stringWithFormat:@"已选择：%ld人",arr.count];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStylePlain];
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
    return self.dataPeoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:1];
    cell.delegate = self;
    TFEmployModel *model = self.dataPeoples[indexPath.row];
    [cell refreshCellWithEmployeeModel:model isSingle:NO];
    cell.selectBtn.tag = indexPath.row;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSInteger row = indexPath.row;
    
    if (self.isSingleSelect) {
        
        TFEmployModel *model = self.dataPeoples[row];
        
        if ([model.select isEqualToNumber:@2]) {
            return;
        }
        
        for (TFEmployModel *ee in self.dataPeoples) {
            if ([ee.select isEqualToNumber:@2]) {
                continue;
            }
            ee.select = @0;
        }
        
        model.select = @1;
        
    }else{
        
        TFEmployModel *model = self.dataPeoples[row];
        
        if ([model.select isEqualToNumber:@2]) {
            return;
        }
        
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    }
    
    
    [self.tableView reloadData];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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
#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger row = selectBtn.tag;
    
    if (self.isSingleSelect) {
        
        TFEmployModel *model = self.dataPeoples[row];
        
        if ([model.select isEqualToNumber:@2]) {
            return;
        }
        
        for (TFEmployModel *ee in self.dataPeoples) {
            if ([ee.select isEqualToNumber:@2]) {
                continue;
            }
            ee.select = @0;
        }
        
        model.select = @1;
        
    }else{
        
        TFEmployModel *model = self.dataPeoples[row];
        
        if ([model.select isEqualToNumber:@2]) {
            return;
        }
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    }
    

    [self.tableView reloadData];
    
    
}


#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    
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
