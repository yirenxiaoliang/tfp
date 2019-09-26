//
//  TFEmailsSelectSenderController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsSelectSenderController.h"
#import "HQTFTwoLineCell.h"

#import "TFEmailAccountModel.h"

#import "TFMailBL.h"

@interface TFEmailsSelectSenderController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) NSInteger index;

//后台返回账号数据
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation TFEmailsSelectSenderController

- (NSMutableArray *)datas {

    if (!_datas) {
        
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.mailBL = [TFMailBL build];
    
    self.mailBL.delegate = self;
    
    [self.mailBL getPersonnelMailAccount];
    
}

- (void)setNavi {

    self.navigationItem.title = @"选择发件人";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
    
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
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFEmailAccountModel *model = self.datas[indexPath.row];
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.type = TwoLineCellTypeOne;
    cell.topLabel.text = model.account;;
    cell.bottomLine.hidden = NO;
    
//    [cell.titleImage setImage:IMG(@"没选中") forState:UIControlStateNormal];
//    if (indexPath.row == self.index) {
//
//        if (self.isSelect) {
//            
//            [cell.titleImage setImage:IMG(@"选中了") forState:UIControlStateNormal];
//        }
        if ([model.isSelect isEqualToNumber:@1]) {
            
            [cell.titleImage setImage:IMG(@"选中了") forState:UIControlStateNormal];
        }
        else {
            
            [cell.titleImage setImage:IMG(@"没选中") forState:UIControlStateNormal];
        }
//
//    }
//    else {
//    
//        [cell.titleImage setImage:IMG(@"没选中") forState:UIControlStateNormal];
//    }

    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TFEmailAccountModel *amodel in self.datas) {
        
        amodel.isSelect = @0;
        
        [arr addObject:amodel];
    }
    
    
    TFEmailAccountModel *model = arr[indexPath.row];
    
    if ([model.isSelect isEqualToNumber:@1] && indexPath.row == self.index) {
        
        model.isSelect = @0;
    }
    else {
    
        model.isSelect = @1;
    }
    
    
    
    if ([model.isSelect isEqualToNumber:@1]) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
    }
    else {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
    }
    
    
//    if (self.isSelect && indexPath.row == self.index) {
//        
//        self.isSelect = NO;
//    }
//    else {
//    
//        self.isSelect = YES;
//    }
//    
//    
    self.index = indexPath.row;
//
//    if (self.isSelect) {
//        
//        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:kUIColorFromRGB(0x28C195)];
//    }
//    else {
//    
//        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:kUIColorFromRGB(0x69696C)];
//    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 54;
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

#pragma mark 确定选择按钮
- (void)sureAction {
    
    //    TFEmailAccountModel *model = self.datas[self.index];
    
    BOOL have = NO;
    for (TFEmailAccountModel *model in self.datas) {
        
        if ([model.isSelect isEqualToNumber:@1]) {
            
            if (self.refreshAction) {
                
                self.refreshAction(model);
            }
            
            have = YES;
            
            break;
        }
    }
    
    if (!have) {
        
        [MBProgressHUD showError:@"请选中发件人!" toView:self.view];
    }
    else {
    
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryPersonnelAccount) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.datas = resp.body;
        
        if (self.accountId) {
            
            BOOL have = NO;
            for (TFEmailAccountModel *model in self.datas) {
                
                if ([model.id isEqualToNumber:self.accountId]) {
                    
                    model.isSelect = @1;
                    have = YES;
                    break;
                }
            }
            
            if (!have) {
                
                for (TFEmailAccountModel *model in self.datas) {
                    
                    if ([model.account_default isEqualToString:@"1"]) {
                        
                        model.isSelect = @1;
                    }
                }
            }

        }
        else {
        
            for (TFEmailAccountModel *model in self.datas) {
                
                if ([model.account_default isEqualToString:@"1"]) {
                    
                    model.isSelect = @1;
                }
            }

        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
