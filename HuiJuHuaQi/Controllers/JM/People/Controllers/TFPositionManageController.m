//
//  TFPositionManageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPositionManageController.h"
#import "TFPositionManageCell.h"
#import "TFCreatePositionController.h"
#import "TFPositionModel.h"
#import "AlertView.h"
#import "TFPeopleBL.h"
#import "HQTFNoContentView.h"

@interface TFPositionManageController ()<UITableViewDataSource,UITableViewDelegate,TFPositionManageCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak)  UITableView *tableView;

/** positions */
@property (nonatomic, strong) NSMutableArray *positions;

/** TFPositionModel  */
@property (nonatomic, strong) TFPositionModel *selectModel;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** noContent */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

@end

@implementation TFPositionManageController

-(NSMutableArray *)positions{
    if (!_positions) {
        _positions = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 10; i ++) {
//            TFPositionModel *model = [[TFPositionModel alloc] init];
//            model.position = [NSString stringWithFormat:@"职务%ld",i];
//            model.select = @0;
//            
//            [_positions addObject:model];
//        }
    }
    return _positions;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    [self setupNoContentView];
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
//    [self.peopleBL requestPositionListWithPageNo:1 pageSize:1000];
//    [self.peopleBL requestGetPositionList];
}

#pragma mark - 无内容View
- (void)setupNoContentView{
    HQTFNoContentView *noContent = [HQTFNoContentView noContentView];
    noContent.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.tableView.height);
    
    CGRect rect = (CGRect){(SCREEN_WIDTH-Long(150))/2,(self.tableView.height - Long(150))/2 - 60,Long(150),Long(150)};
    
    [noContent setupImageViewRect:rect imgImage:@"图123" withTipWord:@"请添加职务"];
    
    self.noContentView = noContent;
}
- (void)setupNavi{
    
    if (self.type == 0) {
        self.navigationItem.title = @"选择职务";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }else{
        self.navigationItem.title = @"职务管理";
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(positionCreate) image:@"加号" highlightImage:@"加号"];
    }
}

- (void)sure{
    
    if (self.actionParameter) {
        self.actionParameter(self.selectModel);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)positionCreate{
    TFCreatePositionController *creat = [[TFCreatePositionController alloc] init];
    [self.navigationController pushViewController:creat animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.positions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TFPositionManageCell *cell = [TFPositionManageCell positionManageCellWithTableView:tableView withType:self.type];
    TFPositionModel *model = self.positions[indexPath.row];
    [cell refreshPositionManageCellWithPositionModel:model];
    cell.delegate = self;
    if (self.type == 0) {
        
        cell.select = ([model.select isEqualToNumber:@0] || model.select == nil)?NO:YES;
    }
    
    if (self.positions.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {
        
        self.selectModel.select = @0;
        
        TFPositionModel *model = self.positions[indexPath.row];
        model.select = @1;
        
        self.selectModel = model;
        
        [tableView reloadData];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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
#pragma mark - TFPositionManageCellDelegate
-(void)positionManageCellDidEditBtnWithPositionModel:(TFPositionModel *)model{
    
    
    TFCreatePositionController *creat = [[TFCreatePositionController alloc] init];
    creat.positionModel = model;
    [self.navigationController pushViewController:creat animated:YES];
    
}

-(void)positionManageCellDidDeleteBtnWithPositionModel:(TFPositionModel *)model{
    [AlertView showAlertView:@"删除职务" msg:@"你确定要删除此职务吗？" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
        
    } onRightTouched:^{
        [self.positions removeObject:model];
//        [self.peopleBL requestPositionDeleteWithPositionId:model.id];
        
        
    }];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    if (resp.cmdId == HQCMD_positionList) {
//        
//        [self.positions removeAllObjects];
//        [self.positions addObjectsFromArray:resp.body];
//        
//        if (self.positions.count == 0) {
//            self.tableView.backgroundView = self.noContentView;
//        }else{
//            self.tableView.backgroundView = [UIView new];
//        }
//        [self.tableView reloadData];
//    }
//    if (resp.cmdId == HQCMD_positionDelete) {
//        [MBProgressHUD showError:@"删除成功" toView:KeyWindow];
//        
//        if (self.positions.count == 0) {
//            self.tableView.backgroundView = self.noContentView;
//        }else{
//            self.tableView.backgroundView = [UIView new];
//        }
//        [self.tableView reloadData];
//    }
    
//    if (resp.cmdId == HQCMD_getPositionList) {
//        
//        [self.positions removeAllObjects];
//        [self.positions addObjectsFromArray:resp.body];
//        
//        if (self.positions.count == 0) {
//            self.tableView.backgroundView = self.noContentView;
//        }else{
//            self.tableView.backgroundView = [UIView new];
//        }
//        [self.tableView reloadData];
//    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
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
