//
//  HQChangePhoneNumVC.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQChangePhoneNumVC.h"
#import "AlertView.h"
#import "UILabel+Extension.h"
#import "HQChangePhoneNextVC.h"
#import "TFLoginBL.h"
#import "TFVerificationCodeController.h"

@interface HQChangePhoneNumVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, copy) NSString *tipText;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) UITextField *textField;

/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation HQChangePhoneNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    [self setupNavigation];
    
    [self createBottomView];
    [self createTableView];
    
    
}

- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"变更手机号码";
    
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,100}];
    [view addSubview:_nextBtn];
    _tableview.tableFooterView = view;
}

- (void)createBottomView {
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextBtn.frame = CGRectMake(25, 35, SCREEN_WIDTH - 50, 50);
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:GreenColor];
    [_nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    _nextBtn.layer.cornerRadius = 5.0;
//    [self.view addSubview:_nextBtn];
}

- (void)nextAction {

    [self.view endEditing:YES];
    
    if (![HQHelper checkTel:_textField.text]) {
        [MBProgressHUD showError:@"正确输入手机号码" toView:self.view];
        return;
    }
    
    [self.loginBL requestGetVerificationWithUserName:_textField.text type:@3];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"MySetCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        for(UIView *vv in cell.subviews)
        {
            [vv removeFromSuperview];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    if (indexPath.row == 0) {
        
        UILabel *countryLab = [UILabel initCustom:CGRectMake(15, 18, 80, 20) title:@"国家地区" titleColor:BlackTextColor titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        countryLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:countryLab];
        
        UILabel *addressLab = [UILabel initCustom:CGRectMake(101, 17, 200, 22) title:@"中国" titleColor:BlackTextColor titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        addressLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:addressLab];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(SCREEN_WIDTH-15-20, 15, 20, 20);
        imgView.image = [UIImage imageNamed:@"下一级浅灰"];
        imgView.contentMode = UIViewContentModeCenter;
        [cell addSubview:imgView];
    } else {
    
        UILabel *numLab = [UILabel initCustom:CGRectMake(15, 18, 30, 20) title:@"+86" titleColor:BlackTextColor titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        numLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:numLab];
        
        UILabel *lineLab = [UILabel initCustom:CGRectMake(81, 13, 1, 30) title:@"" titleColor:HexAColor(0xFFFFFF, 1) titleFont:14 bgColor:HexAColor(0xE7E7E7, 1)];
        lineLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:lineLab];
        
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(101, 17, SCREEN_WIDTH-120, 22);
        _textField.placeholder = @"请填写手机号码";
        _textField.textColor = HexAColor(0x17171A, 1);
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [cell addSubview:_textField];
    }
    
    //线
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(16, 55, SCREEN_WIDTH-16, 0.5)];
    
    bottomLine.backgroundColor = CellSeparatorColor;
    [cell addSubview:bottomLine];
    
    if (indexPath.row == 0) {
        bottomLine.hidden = NO;
    }else{
        bottomLine.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=HexAColor(0xFFFFFF, 1);
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 110 + 88 + 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,20,SCREEN_WIDTH,110}];
    [view addSubview:imageView];
    imageView.image = IMG(@"telephone");
    imageView.contentMode = UIViewContentModeCenter;
    
    UILabel *label1 = [HQHelper labelWithFrame:(CGRect){26,15 + CGRectGetMaxY(imageView.frame),SCREEN_WIDTH-26-26,20} text:[NSString stringWithFormat:@"当前手机号：%@",UM.userLoginInfo.employee.phone] textColor:BlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(16)];
    label1.numberOfLines = 0;
    label1.backgroundColor = HexAColor(0xf2f2f2, 1);
    [view addSubview:label1];
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){15,  CGRectGetMaxY(label1.frame),SCREEN_WIDTH-30,44} text:[NSString stringWithFormat:@"启用提示：更换手机后，下次登录可使用新手机号登录。"] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(13)];
    label.numberOfLines = 0;
    label.backgroundColor = HexAColor(0xf2f2f2, 1);
    [view addSubview:label];
    
    return view;
}

#pragma mark 网络代理
- (void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp {
    
    if (resp.cmdId == HQCMD_sendVerifyCode) {
        
        [MBProgressHUD showError:@"发送成功！" toView:KeyWindow];
        
//        HQChangePhoneNextVC *changeNextVC = [[HQChangePhoneNextVC alloc] init];
//        changeNextVC.telephone = _textField.text;
//        [self.navigationController pushViewController:changeNextVC animated:YES];
        TFVerificationCodeController *veri = [[TFVerificationCodeController alloc] init];
        veri.telephone = _textField.text;
        veri.type = 2;
        [self.navigationController pushViewController:veri animated:YES];
    }
}

- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp {
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
