//
//  TFAuthAssignController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAuthAssignController.h"

#import "HQTFTwoLineCell.h"

#import "TFFileBL.h"

@interface TFAuthAssignController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) TFFileBL *fileBL;

@end

@implementation TFAuthAssignController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.fileBL = [TFFileBL build];
    self.fileBL.delegate = self;
    
}

- (void)setNavi {

    self.navigationItem.title = @"权限分配";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:GreenColor];
}

- (void)initData {

    
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
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    if(indexPath.row == 0){
        
        [cell.titleImage setImage:IMG(@"上传") forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(@"上传") forState:UIControlStateHighlighted];
        cell.topLabel.text = @"上传";
        cell.bottomLabel.text = @"成员可在此文件夹下“上传”文件";
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        cell.type = TwoLineCellTypeTwo;
        [cell.enterImage setImage:IMG(@"完成30") forState:UIControlStateNormal];
        
        if (self.upload == 0) {
            
            cell.enterImage.hidden = YES;
        }
        else {
            
            cell.enterImage.hidden = NO;
        }
    }
    else if (indexPath.row == 1) {
        
        [cell.titleImage setImage:IMG(@"下载") forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(@"下载") forState:UIControlStateHighlighted];
        cell.topLabel.text = @"下载";
        cell.bottomLabel.text = @"成员可在此文件夹下“下载”文件";
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        cell.type = TwoLineCellTypeTwo;
        [cell.enterImage setImage:IMG(@"完成30") forState:UIControlStateNormal];
        
        if (self.download == 0) {
            
            cell.enterImage.hidden = YES;
        }
        else {
        
            cell.enterImage.hidden = NO;
        }
        
    }
    else if (indexPath.row == 2) {
        
        [cell.titleImage setImage:IMG(@"只读") forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(@"只读") forState:UIControlStateHighlighted];
        cell.topLabel.text = @"只读";
        cell.bottomLabel.text = @"成员可在此文件夹下“查看、预览”文件";
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        cell.type = TwoLineCellTypeTwo;
        [cell.enterImage setImage:IMG(@"完成不可操作") forState:UIControlStateNormal];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 0) {
        
        if (self.upload == 0) {
            
            self.upload = 1;
        }
        else {
            
            self.upload = 0;
        }
        
    }
    else if (indexPath.row == 1) {
    
        if (self.download == 0) {
            
            self.download = 1;
        }
        else {
            
            self.download = 0;
        }
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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

#pragma mark 确定
- (void)sureAction {

    NSMutableArray *arr = [NSMutableArray array];
    
    if (self.id) {
        
        NSDictionary *dic = @{
                              @"id":self.id,
                              @"upload":@(_upload),
                              @"download":@(_download),
                              @"preview":@1
                              };
        
        [arr addObject:dic];
        
        [self.fileBL requestUpdateSettingWithData:arr folderId:self.folderId];
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_updateSetting) {
        
        [MBProgressHUD showError:@"设置成功！" toView:self.view];
        
        if (self.refreshAction) {
            
            self.refreshAction();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
