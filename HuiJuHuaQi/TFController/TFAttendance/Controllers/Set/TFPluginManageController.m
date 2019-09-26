//
//  TFPluginManageController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/7/3.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPluginManageController.h"
#import "TFPluginCell.h"
#import "TFPunchViewModel.h"

@interface TFPluginManageController ()<TFPluginCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) TFPunchViewModel *punchViewModel;
@property (nonatomic, strong) NSArray *datas;
@end

@implementation TFPluginManageController

-(TFPunchViewModel *)punchViewModel{
    if (!_punchViewModel) {
        _punchViewModel = [[TFPunchViewModel alloc] init];
    }
    return _punchViewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"插件管理";
    [self setupTableView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    RACSignal *signal = [self.punchViewModel.quickCommand execute:[NSDictionary dictionary]];
    [signal subscribeNext:^(id  _Nullable x) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.datas = x;
        [self.tableView reloadData];
    }];
    [signal subscribeError:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"NSDebugDescription"] toView:self.view];
    }];
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
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFPluginCell *cell = [TFPluginCell pluginCellWithTableView:tableView];
    [cell refreshPluginCellWithModel:self.datas[indexPath.row]];
    cell.delegate = self;
    if (self.datas.count -1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 107;
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

#pragma mark - TFPluginCellDelegate
-(void)pluginCellDidClickedSwitchBtn:(UISwitch *)switchBtn model:(TFPluginModel *)model{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (model.id) {
        [dict setObject:model.id forKey:@"id"];
    }
    if ([model.plugin_status isEqualToNumber:@1]) {
        [dict setObject:@0 forKey:@"pluginStatus"];
    }else{
        [dict setObject:@1 forKey:@"pluginStatus"];
    }
    
    RACSignal *signal = [self.punchViewModel.pluginCommand execute:dict];
    [signal subscribeNext:^(id  _Nullable x) {
        model.plugin_status = [model.plugin_status isEqualToNumber:@1] ? @0 : @1;
        if ([model.plugin_status isEqualToNumber:@1]) {
            [MBProgressHUD showImageSuccess:@"开启成功" toView:self.view];
        }else{
            [MBProgressHUD showImageSuccess:@"关闭成功" toView:self.view];
        }
    }];
    [signal subscribeError:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:[error.userInfo valueForKey:@"NSDebugDescription"] toView:self.view];
        [switchBtn setOn:[model.plugin_status isEqualToNumber:@1] animated:YES];
    }];
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
