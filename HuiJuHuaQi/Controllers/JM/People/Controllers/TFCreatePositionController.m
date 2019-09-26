//
//  TFCreatePositionController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreatePositionController.h"
#import "HQTFInputCell.h"
#import "TFPositionManageController.h"
#import "TFPeopleBL.h"

@interface TFCreatePositionController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;


@end

@implementation TFCreatePositionController

-(TFPositionModel *)positionModel{
    if (!_positionModel) {
        _positionModel = [[TFPositionModel alloc] init];
    }
    return _positionModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"新建职务";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(positionManage) text:@"职务管理" textColor:GreenColor];
    
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
}

- (void)positionManage{
    TFPositionManageController *manage = [[TFPositionManageController alloc] init];
    manage.type = 1;
    [self.navigationController pushViewController:manage animated:YES];
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
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,90}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30,SCREEN_WIDTH-50,50} target:self action:@selector(buttonClick)];
    [view addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.titleLabel.font = FONT(20);
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateHighlighted];
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
    tableView.tableFooterView = view;
    
}

- (void)buttonClick{
    
    if (!self.positionModel.name || [self.positionModel.name isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入职务名称" toView:self.view];
        return;
    }
    
//    [self.peopleBL requestPositionAddWithPosition:self.positionModel.name];
//    [self.peopleBL requestAddPositionWithPosition:self.positionModel.name];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
    cell.titleLabel.text = @"职务名称";
    cell.textField.placeholder = @"请输入职务名称";
    cell.textField.text = self.positionModel.name;
    cell.enterBtn.tag = 0x123 + indexPath.row;
    [cell refreshInputCellWithType:0];
    cell.bottomLine.hidden = YES;
    cell.delegate = self;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
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
#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    self.positionModel.name = textField.text;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    if (resp.cmdId == HQCMD_positionAdd) {
//        
//        [MBProgressHUD showError:@"创建成功" toView:KeyWindow];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    
//    if (resp.cmdId == HQCMD_addPosition) {
//        
//        [MBProgressHUD showError:@"创建成功" toView:KeyWindow];
//        [self.navigationController popViewControllerAnimated:YES];
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
