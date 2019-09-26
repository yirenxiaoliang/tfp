//
//  TFCustomerDynamicController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/9/9.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomerDynamicController.h"
#import "TFCRMDynamicCell.h"
#import "TFDynamicSectionView.h"
#import "TFCRMSearchView.h"
#import "TFCustomerDynamicModel.h"
#import "TFCustomerCommentModel.h"
#import "TFCustomBL.h"
#import "HQTFNoContentView.h"

@interface TFCustomerDynamicController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, strong) UITableView *tableView;

/** 线的高度 */
@property (nonatomic, assign) CGFloat lineH;

/** dynamics */
@property (nonatomic, strong) NSMutableArray *dynamics;

/** searchView */
@property (nonatomic, weak) TFCRMSearchView *searchView;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFCustomerDynamicController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}


-(NSMutableArray *)dynamics{
    if (!_dynamics) {
        _dynamics = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 4; i ++) {
//            TFCustomerDynamicModel *model = [[TFCustomerDynamicModel alloc] init];
//            model.timeDate = [NSString stringWithFormat:@"%lld",[HQHelper getNowTimeSp]];
//            
//            NSMutableArray *arr = [NSMutableArray array];
//            for (NSInteger j = 0; j < 4; j ++) {
//                TFCustomerCommentModel *model1 = [[TFCustomerCommentModel alloc] init];
//                
//                model1.employee_name = @"伊人小亮";
//                model1.content = @"我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵我是一个兵";
//                model1.type = @(j) ;
//                model1.datetime_time = @([HQHelper getNowTimeSp]);
//                model1.voiceTime = @23;
//                model1.fileUrl = @"";
//                model1.fileSize = @3378;
//                if (j == 1) {
//                    model1.fileType = @"mp3";
//                }else if (j == 2){
//                    model1.fileType = @"jpg";
//                }else if (j == 3){
//                    model1.fileType = @"doc";
//                }
//                model1.fileName = @"我是一个文件.doc";
//                [arr addObject:model1];
//            }
//            model.timeList = arr;
//            [_dynamics addObject:model];
//        }
    }
    return _dynamics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestCustomModuleDynamicListWithBean:self.bean dataId:self.id];
    
    [self setupTableView];
    [self setupNavi];
    [self setupCRMSearchView];
}
#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = @"动态";
}

#pragma mark - 初始化筛选View
- (void)setupCRMSearchView{
    TFCRMSearchView *view = [TFCRMSearchView CRMSearchView];
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.view addSubview:view];
    view.filterBtn.hidden = YES;
    view.arrowImage.hidden = YES;
    [view refreshSearchViewWithTitle:[NSString stringWithFormat:@"全部%@",@"动态"] number:0];
    self.searchView = view;
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dynamics.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    TFCustomerDynamicModel *model = self.dynamics[section];
    return model.timeList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCRMDynamicCell *cell = [TFCRMDynamicCell CRMDynamicCellWithTableView:tableView];
    cell.bottomLine.hidden = YES;
    cell.topLine.hidden = YES;
    TFCustomerDynamicModel *model = self.dynamics[indexPath.section];
    [cell refreshCellWithModel:model.timeList[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerDynamicModel *model = self.dynamics[indexPath.section];
    TFCustomerCommentModel *comm = model.timeList[indexPath.row];
    CGFloat height = [TFCRMDynamicCell refreshDynamicHeightWithModel:comm.content];
    
//    self.lineH = height;
    
    
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    //    UIView *view = [[UIView alloc] init];
    //    view.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    TFCustomerDynamicModel *model = self.dynamics[section];
    TFDynamicSectionView *sectionView = [[TFDynamicSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41) date:[model.timeDate longLongValue]];
    
    return sectionView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customDynamicList) {
        
        self.dynamics = resp.body;
        
        NSInteger num = 0;
        for (TFCustomerDynamicModel *model in self.dynamics) {
            num += model.timeList.count;
        }
        
        if (num == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        
        [self.searchView refreshSearchViewWithTitle:@"全部动态" number:num];
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
//    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
