//
//  HQChangePhoneNextVC.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQChangePhoneNextVC.h"

#import "AlertView.h"
#import "UILabel+Extension.h"
#import "Masonry.h"
#import "TFLoginBL.h"

@interface HQChangePhoneNextVC ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, copy) NSString *tipText;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong)UIButton *sureBtn;

@property (nonatomic, strong) TFLoginBL *loginBL;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation HQChangePhoneNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    [self setupNavigation];
    
    [self createTableView];
    
    [self createBottomView];
    
    [self receiveLab];
}

- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"变更手机号码";
    
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
}

- (void)createBottomView {
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(25, 278-64, 325, 50);
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setBackgroundColor:GreenColor];
    [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    _sureBtn.layer.cornerRadius = 5.0;
    
    [self.view addSubview:_sureBtn];
}

- (void)receiveLab {

    UILabel *Lab = [UILabel initCustom:CGRectZero title:@"收不到验证码？" titleColor:HexAColor(0x2066C1, 1) titleFont:14 bgColor:BackGroudColor];
    Lab.textAlignment = NSTextAlignmentCenter;
    Lab.userInteractionEnabled = YES;
    [self.view addSubview:Lab];
    
    [Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_sureBtn.mas_bottom).offset(30);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
        make.left.equalTo(self.view).mas_offset((SCREEN_WIDTH-200)/2);
    }];
    
    //添加手势
    UITapGestureRecognizer *labTap = [[UITapGestureRecognizer alloc] init];
    labTap.numberOfTapsRequired = 1;
    [labTap addTarget:self action:@selector(tapEvent:)];
    [Lab addGestureRecognizer:labTap];
}

- (void)tapEvent:(UITapGestureRecognizer *)recognizer {

    
    [AlertView showAlertView:@"重新获取验证码" msg:@"" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
        
    } onRightTouched:^{
        
    }];
}

- (void)sureAction {
    
    if (![HQHelper checkSure:_textField.text]) {
        [MBProgressHUD showError:@"请正确输入验证码" toView:KeyWindow];
        return;
    }
    
    [self.loginBL requestChangeCompanyWithCompanyId:nil];
    
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
        
        UILabel *countryLab = [UILabel initCustom:CGRectMake(15, 18, 65, 20) title:@"手机号码" titleColor:HexAColor(0x69696C, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        countryLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:countryLab];
        
        UILabel *addressLab = [UILabel initCustom:CGRectMake(101, 17, 200, 22) title:self.telephone titleColor:HexAColor(0x4A4A4A, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        addressLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:addressLab];

    } else {
        
        UILabel *numLab = [UILabel initCustom:CGRectMake(15, 18, 65, 20) title:@"验证码" titleColor:HexAColor(0x69696C, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        numLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:numLab];
        
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(101, 17, SCREEN_WIDTH-120, 22);
        _textField.placeholder = @"请输入验证码";
        _textField.textColor = HexAColor(0xCACAD0, 1);
        _textField.font = [UIFont systemFontOfSize:16];
        [cell addSubview:_textField];
    }
    
    //线
    UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(16, 55, SCREEN_WIDTH-16, 0.5)];
    
    bottomLine.backgroundColor = CellSeparatorColor;
    [cell addSubview:bottomLine];
    
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
    
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _label = [HQHelper labelWithFrame:(CGRect){26,15,SCREEN_WIDTH-26-29,44} text:@"短信验证码已发送，请填写验证码" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(16)];

    _label.numberOfLines = 0;
    _label.backgroundColor = HexAColor(0xf2f2f2, 1);
    return _label;
}

//#pragma mark 网络代理
///**
// *  业务成功回调方法
// *
// *  @param blEntiy   业务对象
// *  @param result    业务处理之后的返回数据
// */
//- (void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp {
//
////    if (resp.cmdId == HQCMD_modTelephone) {
////        
////        [MBProgressHUD showError:@"修改成功！" toView:KeyWindow];
////        
////        [self.navigationController popViewControllerAnimated:YES];
////    }
//}
//
///**
// *  业务失败回调方法
// *
// *  @param blEntiy   业务对象
// *  @param result    包括错误信息的对象
// */
//- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp {
//    
//    
//}


@end
