
//
//  HQTFProjectModelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectModelController.h"
#import "HQTFProjectModelCell.h"
#import "TFProjectBL.h"
#import "TFProjectCatagoryItemModel.h"
#import "TFProjectCatagoryListModel.h"

@interface HQTFProjectModelController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;

/** categorys */
@property (nonatomic, strong) NSMutableArray *categorys;
/** 请求 */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** catagoryList */
@property (nonatomic, strong) TFProjectCatagoryListModel *catagoryList;

/** TFProjectCatagoryItemModel *model */
@property (nonatomic, strong) TFProjectCatagoryItemModel *selectCatagory;

@end

@implementation HQTFProjectModelController

-(NSMutableArray *)categorys{
    
    if (!_categorys) {
        _categorys = [NSMutableArray array];
        /**类型Id:100=项目协作;200=销售业务;300=生产制造;400=设计研发;500=互联网 */
//        NSArray *name = @[@"项目协作",@"销售业务",@"生产制造",@"设计研发",@"互联网",];
//        for (NSInteger i = 0; i < 5 ; i++) {
//            
//            TFProjectCatagoryItemModel *model = [[TFProjectCatagoryItemModel alloc] init];
//            model.id = [NSNumber numberWithInteger:100 * (i + 1)];
//            model.categoryName = name[i];
//            [_categorys addObject:model];
//            
//            if (0==i) {
//                self.selectCatagory = model;
//                model.isSelect = @1;
//            }
//        }
    }
    return _categorys;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    [self.projectBL requestGetCategoryListWithPageNum:1 pageSize:10];
    
}
#pragma mark - Navigation
- (void)setupNavigation{
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
    
    self.navigationItem.title = @"项目模板";
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)sure{
    
    if (self.projectModel) {
        self.projectModel(self.selectCatagory);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    tableView.rowHeight = 70;
    tableView.backgroundColor = BackGroudColor;
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.categorys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFProjectModelCell *cell = [HQTFProjectModelCell projectModelCellWithTableView:tableView];
    TFProjectCatagoryItemModel *model = self.categorys[indexPath.row];
    [cell refreshProjectModelCellWithModel:model];
    cell.bottomLine.hidden = NO;
    
    if (indexPath.row == self.categorys.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    if ([model.isSelect isEqualToNumber:@1]) {
        cell.isSelected = YES;
    }else{
        cell.isSelected = NO;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    self.selectCatagory.isSelect = @0;
    
    TFProjectCatagoryItemModel *model = self.categorys[indexPath.row];
    model.isSelect = @1;
    self.selectCatagory = model;
    
    [tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getCategoryList) {
        
//        self.catagoryList = resp.body;
//        [self.categorys addObjectsFromArray:self.catagoryList.list];
        
        self.categorys = resp.body;
        
        for (TFProjectCatagoryItemModel *model in self.categorys) {
            
            if ([model.id isEqualToNumber:self.categoryId]) {
                model.isSelect = @1;
                self.selectCatagory = model;
            }else{
                model.isSelect = @0;
            }
        }
        
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getCategoryList) {
        
    }
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
