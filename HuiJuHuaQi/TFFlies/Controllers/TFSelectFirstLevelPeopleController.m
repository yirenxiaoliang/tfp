//
//  TFSelectFirstLevelPeopleController.m
//  HuiJuHuaQi
//
//  Created by daidan on 2019/11/15.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectFirstLevelPeopleController.h"
#import "TFManagePersonsModel.h"
#import "TFFileBL.h"
#import "TFProjectMenberCell.h"

@interface TFSelectFirstLevelPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@property (nonatomic, strong) NSMutableArray *peoples;
@end

@implementation TFSelectFirstLevelPeopleController
-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
    [self requestData];
    [self setupTableView];
    self.navigationItem.title = @"选择人员";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
}

- (void)sure{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFSettingItemModel *model in self.peoples) {
        if ([model.selectState isEqualToNumber:@1]) {
            [arr addObject:model];
        }
    }
    
    if (arr.count == 0) {
        [MBProgressHUD showError:@"请选择" toView:self.view];
        return;
    }
    
    NSMutableArray *peoples = [NSMutableArray array];
    
    for (TFSettingItemModel *model in arr) {
        HQEmployModel *em = [[HQEmployModel alloc] init];
        em.employee_id = model.employee_id;
        em.employeeId = model.employee_id;
        em.id = model.employee_id;
        [peoples addObject:em];
    }
    
    if (self.actionParameter) {
        self.actionParameter(peoples);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)requestData {

    [self.fileBL requestQueryFolderInitDetailWithData:@(self.style) folderId:self.lastfolderId];
    
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFProjectMenberCell *cell = [TFProjectMenberCell projectMenberCellWithTableView:tableView];
    TFSettingItemModel *model = self.peoples[indexPath.row];
    cell.powerLabel.hidden = YES;
    [cell.headImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            [cell.headImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [cell.headImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [cell.headImage setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
        }
    } ];
    cell.nameLabel.text = model.employee_name;
    cell.topLine.hidden = NO;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }
    
    if ([model.selectState isEqualToNumber:@1]) {
        cell.enterImg.image = IMG(@"完成");
    }else{
        cell.enterImg.image = nil;
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFSettingItemModel *model = self.peoples[indexPath.row];
    model.selectState = [model.selectState isEqualToNumber:@1]?@0:@1;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
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


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryFolderInitDetail) {
        
        TFManagePersonsModel *model = resp.body;
        
        [self.peoples removeAllObjects];
        [self.peoples addObjectsFromArray:model.setting];
        
        [self.view addSubview:self.tableView];
        
        [self.tableView reloadData];
    }
    
    
    
    if (resp.cmdId == HQCMD_savaManageStaff || resp.cmdId == HQCMD_savaMember || resp.cmdId == HQCMD_delManageStaff || resp.cmdId == HQCMD_delMember) {
        
        [self requestData];
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
