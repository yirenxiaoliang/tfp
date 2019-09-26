//
//  TFHighseaMoveController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/30.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFHighseaMoveController.h"
#import "TFCustomBL.h"
#import "HQSelectTimeCell.h"
#import "TFHighseaModel.h"
#import "HQTFNoContentView.h"

@interface TFHighseaMoveController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, strong) TFHighseaModel *selectModel;

/** highseas */
@property (nonatomic, strong) NSMutableArray *highseas;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;
@end

@implementation TFHighseaMoveController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
}
-(NSMutableArray *)highseas{
    if (!_highseas) {
        _highseas = [NSMutableArray array];
    }
    return _highseas;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.dataSource.count) {
        
        [self.highseas addObjectsFromArray:self.dataSource];
    }else{
        
        [self.customBL requestHighseaListWithBean:self.bean];
        
    }
    [self setupTableView];
    [self setupNavi];
}

- (void)setupNavi{
    
    if (self.type == 0) {
        self.navigationItem.title = @"移动至";
    }else{
        self.navigationItem.title = @"退回至";
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    
}


- (void)sure{
    
    if (!self.selectModel) {
        
        [MBProgressHUD showError:@"请选择公海池" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0) {
        [self.customBL requestHighseaMoveWithDataId:self.dataId bean:self.bean seasPoolId:self.selectModel.id];
    }else{
        
        [self.customBL requestHighseaBackWithDataId:self.dataId bean:self.bean seasPoolId:self.selectModel.id];
    }
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_highseaMove) {
        
        [MBProgressHUD showSuccess:@"移动成功" toView:self.view];
        
//        [self.navigationController popViewControllerAnimated:YES];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
    if (resp.cmdId == HQCMD_highseaBack) {
        
        [MBProgressHUD showSuccess:@"退回成功" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:NO];
        
        if (self.refreshAction) {
            self.refreshAction();
        }
    }
    
    if (resp.cmdId == HQCMD_highseaList) {
        
        if (self.type == 0) {
            
            NSArray *arr = resp.body;
            
            for (TFHighseaModel *model in arr) {
                
                if ([model.id isEqualToNumber:self.seaPoolId]) {
                    continue;
                }
                
                [self.highseas addObject:model];
            }
        }else{
            [self.highseas addObjectsFromArray:resp.body];
        }
        
        if (self.highseas.count) {
            
            self.tableView.backgroundView = nil;
        }else{
            
            self.tableView.backgroundView = self.noContentView;
            
            if (self.type == 0) {// 移动
                
                self.noContentView.tipText = @"~没有可移动的目标";
            }else{
                
                self.noContentView.tipText = @"~没有可退回的目标";
            }
            
        }
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.highseas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFHighseaModel *model = self.highseas[indexPath.row];
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    cell.timeTitle.text = model.title;
    cell.backgroundColor = WhiteColor;
    cell.time.textColor = WhiteColor;
    cell.time.text = @"";
    cell.timeTitle.textColor = ExtraLightBlackTextColor;
    
    
    if (model.open && [model.open isEqualToNumber:@1]) {
        [cell.arrow setImage:[UIImage imageNamed:@"signSelect"]];
    }else{
        [cell.arrow setImage:[UIImage imageNamed:@"sign"]];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    self.selectModel.open = @0;
    
    self.selectModel = self.highseas[indexPath.row];
    self.selectModel.open = @1;
    
    [self.tableView reloadData];
    
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
