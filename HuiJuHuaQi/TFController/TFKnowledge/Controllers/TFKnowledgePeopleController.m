//
//  TFKnowledgePeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/12/11.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgePeopleController.h"
#import "HQTFTwoLineCell.h"
#import "TFKnowledgeBL.h"
#import "HQTFNoContentView.h"
#import "TFContactorInfoController.h"

@interface TFKnowledgePeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 请求 */
@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;
/** 人员 */
@property (nonatomic, strong) NSMutableArray *peoples;
/** 无内容视图 */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFKnowledgePeopleController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无数据"];
    }
    return _noContentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    [self setupNavi];
    [self setupTableView];
    
}

- (void)setupNavi{
    if (self.type == 0) {
        self.navigationItem.title = @"阅读";
        [self.knowledgeBL requestSureLearnAndReadPeopleWithKnowledgeId:self.dataId];
    }else if (self.type == 1){
        self.navigationItem.title = @"收藏";
        [self.knowledgeBL requestCollectionPeopleWithKnowledgeId:self.dataId];
    }else if (self.type == 2){
        self.navigationItem.title = @"点赞";
        [self.knowledgeBL requestGoodPeopleWithKnowledgeId:self.dataId];
    }else if (self.type == 3){
        self.navigationItem.title = @"已学习";
        [self.knowledgeBL requestSureLearnAndReadPeopleWithKnowledgeId:self.dataId];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_learnAndReadKnowledgePeople) {
        NSDictionary *dict = resp.body;
        NSArray *reads = [dict valueForKey:@"reads"];
        NSArray *learning = [dict valueForKey:@"learning"];
        if (self.type == 0) {
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dd in reads) {
                TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
                if (em) {
                    [arr addObject:em];
                }
            }
            self.peoples = arr;
        }
        
        if (self.type == 3) {
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dd in learning) {
                TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
                if (em) {
                    [arr addObject:em];
                }
            }
            self.peoples = arr;
        }
        if (self.peoples.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_collectKnowledgePeople) {
        
        if (self.type == 1) {
            
            NSArray *learning = resp.body;
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dd in learning) {
                TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
                if (em) {
                    [arr addObject:em];
                }
            }
            self.peoples = arr;
        }
        if (self.peoples.count == 0) {
            self.tableView.backgroundView = self.noContentView;
        }else{
            self.tableView.backgroundView = [UIView new];
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_goodKnowledgePeople) {
        
        if (self.type == 2) {
            
            NSArray *learning = resp.body;
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *dd in learning) {
                TFEmployModel *em = [[TFEmployModel alloc] initWithDictionary:dd error:nil];
                if (em) {
                    [arr addObject:em];
                }
            }
            self.peoples = arr;
            if (self.peoples.count == 0) {
                self.tableView.backgroundView = self.noContentView;
            }else{
                self.tableView.backgroundView = [UIView new];
            }
        }
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeTwo;
    cell.headMargin = 15;
    cell.titleImage.userInteractionEnabled = NO;
    cell.enterImage.hidden = YES;
    [cell refreshWithTFEmployModel:self.peoples[indexPath.row]];
    if (indexPath.row == self.peoples.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
    TFEmployModel *employee = self.peoples[indexPath.row];
    info.signId = employee.sign_id;
    [self.navigationController pushViewController:info animated:YES];
    
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
