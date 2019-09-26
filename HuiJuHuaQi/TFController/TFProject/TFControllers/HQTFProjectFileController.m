//
//  HQTFProjectFileController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectFileController.h"
#import "HQTFTwoLineCell.h"
#import "HQTFProjectFileRowController.h"
#import "TFProjectBL.h"
#import "MJRefresh.h"
#import "TFPorjectFolderListModel.h"
#import "TFProjectTaskRowModel.h"

@interface HQTFProjectFileController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** 文件夹 */
@property (nonatomic, strong) NSMutableArray *folders;

/** folderListModel */
@property (nonatomic, strong) TFPorjectFolderListModel *folderListModel;


/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation HQTFProjectFileController


-(NSMutableArray *)folders{
    if (!_folders) {
        _folders = [NSMutableArray array];
    }
    return _folders;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupNavigation];
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL requestGetProjTaskListFoldersWithProjectId:self.project.id];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) image:@"添加人员" highlightImage:@"添加人员"];
    
    self.navigationItem.title = @"项目文库";
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"项目成员共5个" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
//    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        
//        self.pageNum = 1;
//        
//        [self.projectBL requestGetProjTaskListFoldersWithPageNum:self.pageNum pageSize:self.pageSize projectId:self.project.id];
//    }];
//    
//    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        
//        self.pageNum ++;
//        
//        [self.projectBL requestGetProjTaskListFoldersWithPageNum:self.pageNum pageSize:self.pageSize projectId:self.project.id];
//        
//    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.folders.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeOne;
    [cell.titleImage setImage:[UIImage imageNamed:@"文件夹pro"] forState:UIControlStateNormal];
    [cell.titleImage setImage:[UIImage imageNamed:@"文件夹pro"] forState:UIControlStateHighlighted];
    TFProjectTaskRowModel *model = self.folders[indexPath.row];
    
    CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){MAXFLOAT,MAXFLOAT} titleStr:model.listName];
    
    if (size.width > SCREEN_WIDTH - 100) {
        
        NSInteger index = (SCREEN_WIDTH-100)/17;
        if (model.listName.length > index) {
            
            cell.topLabel.text = [NSString stringWithFormat:@"%@...",[model.listName substringToIndex:index]];
        }else{
            
            NSInteger index1 = (SCREEN_WIDTH-100)/18;
            cell.topLabel.text = [NSString stringWithFormat:@"%@...",[model.listName substringToIndex:index1]];
        }
        
    }else{
        cell.topLabel.text = model.listName;
    }
    cell.topLabel.textColor = LightBlackTextColor;
    [cell.enterImage setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateNormal];
    [cell.enterImage setImage:[UIImage imageNamed:@"下一级浅灰"] forState:UIControlStateHighlighted];
    cell.enterImgTrailW.constant = 8;
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    }else{
        cell.topLine.hidden = YES;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    HQTFProjectFileRowController *file = [[HQTFProjectFileRowController alloc] init];
    file.projectTaskRow = self.folders[indexPath.row];
    [self.navigationController pushViewController:file animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *tip = self.project.projectName;
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"项目花"];
    attach.bounds = CGRectMake(0, -1, 13, 13);
    
    [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
    
    [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
    
    label.backgroundColor = WhiteColor;
    label.attributedText = str;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjTaskListFolders) {
        
        self.folders = resp.body;
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
