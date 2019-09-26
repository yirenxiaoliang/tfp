//
//  TFEditMobilAndMailController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/8/17.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEditMobilAndMailController.h"
#import "TFPeopleBL.h"

@interface TFEditMobilAndMailController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFPeopleBL *peopleBL;
@end

@implementation TFEditMobilAndMailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.type == EditInfoTypeMail) {
        
        self.navigationItem.title = @"设置邮箱";
    }
    else {
        self.navigationItem.title = @"设置座机";
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(finish) text:@"完成" textColor:GreenColor];
    [self setupTableView];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
}

- (void)finish {
    
    TFEmployModel *em = [[TFEmployModel alloc] init];
    
    if (self.type == EditInfoTypeMail) {
        
        //正则校验
        BOOL isEmail = [HQHelper validateEmail:self.titleStr];
        if (isEmail) {
            
            em.email = self.titleStr;
            [self.peopleBL requestUpdateEmployeeWithEmployee:em];
        }
        else {
            [MBProgressHUD showError:@"您输入的邮箱格式有误！" toView:self.view];
            return;
        }
    }
    else {
        
        BOOL isMobil = [HQHelper checkNumber:self.titleStr];
        if (isMobil) {
            
            em.mobile_phone = self.titleStr;
            [self.peopleBL requestUpdateEmployeeWithEmployee:em];
        }
        else {
            [MBProgressHUD showError:@"您输入的座机格式有误！" toView:self.view];
            return;
        }
    }
    
    
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-20, 60)];
    textField.text = self.titleStr;
    textField.delegate = self;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField becomeFirstResponder];
    [cell addSubview:textField];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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

-(void)textFieldDidChange:(UITextField *)textField
{

    self.titleStr = textField.text;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_updateEmployee) {
        
        [MBProgressHUD showError:@"保存成功！" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh(self.titleStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
