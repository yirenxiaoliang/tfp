//
//  TFScanCodeController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFScanCodeController.h"
#import "LBXAlertAction.h"
#import "TFLoginBL.h"
#import "TFCustomBL.h"
#import "LBXPermission.h"
#import "LBXPermissionSetting.h"
#import "LBXScanVideoZoomView.h"

@interface TFScanCodeController ()<HQBLDelegate,UIAlertViewDelegate>
/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;
/** TFCustomBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 扫码区域上方提示文字 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark - 底部几个功能：开启闪光灯、相册
/** 底部显示的功能项 */
@property (nonatomic, strong) UIView *bottomItemsView;
/** 相册 */
@property (nonatomic, strong) UIButton *btnPhoto;
/** 闪光灯 */
@property (nonatomic, strong) UIButton *btnFlash;
/** 缩放 */
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;

/** 扫码结果 */
@property (nonatomic, strong) NSString *result;
/** 扫描结果地点 */
@property (nonatomic, strong) NSDictionary *resultDict;



@end

@implementation TFScanCodeController

-(void)viewDidAppear:(BOOL)animated{
    
    [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [super viewDidAppear:animated];
            [self drawBottomItems];
            [self drawTitle];
            [self.view bringSubviewToFront:_topTitle];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _loginBL = [TFLoginBL build];
    _loginBL.delegate = self;
    _customBL = [TFCustomBL build];
    _customBL.delegate = self;
    self.cameraInvokeMsg = @"相机启动中";
    self.navigationItem.leftBarButtonItem = [HQHelper itemWithSize:(CGSize){44,44} title:@"返回" titleColor:BlackTextColor target:self selector:@selector(back)];
    self.navigationItem.title = @"二维码";
    
    
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }
}


- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                   CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(5*CGRectGetWidth(_bottomItemsView.frame)/8, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(3*CGRectGetWidth(_bottomItemsView.frame)/8, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
    
}


- (void)showError:(NSString*)str
{
    [LBXAlertAction showAlertWithTitle:@"提示" msg:str buttonsStatement:@[@"知道了"] chooseBlock:nil];
}


#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        }
        else if (!firstTime )
        {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash
{
    [super openOrCloseFlash];
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode
{
    
}


#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {

        strResult = @"识别失败";
    }

    __weak __typeof(self) weakSelf = self;
    [LBXAlertAction showAlertWithTitle:@"扫码内容" msg:strResult buttonsStatement:@[@"知道了"] chooseBlock:^(NSInteger buttonIdx) {

        [weakSelf reStartDevice];
    }];
}

- (void)showNextVCWithScanResult:(LBXScanResult*)scanResult
{
    self.result = scanResult.strScanned;
    
    // url
    if ([HQHelper checkUrl:scanResult.strScanned]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scanResult.strScanned]];

        [self back];
        
        return;
    }
    // 扫描登录
    if ([scanResult.strScanned containsString:@"ScanLogin"] && [scanResult.strScanned containsString:@"useType"]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认登录PC端?" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *dict = [HQHelper dictionaryWithJsonString:scanResult.strScanned];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [_loginBL requestScanWithUserName:UM.userLoginInfo.employee.phone uniqueCode:[dict valueForKey:@"uniqueId"]];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    // 数据内联
    if ([scanResult.strScanned containsString:@"interiorLink"]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[HQHelper dictionaryWithJsonString:scanResult.strScanned]];
        self.resultDict = dict;
//        [dict setObject:@1 forKey:@"readAuth"];
        NSString *companyId = [[dict valueForKey:@"companyId"] description];
        if ([companyId isEqualToString:[UM.userLoginInfo.company.id description]]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *bean = [[dict valueForKey:@"bean"] description];
            NSNumber *dataId = [dict valueForKey:@"id"];
            [self.customBL requestHaveReadAuthWithModuleBean:bean withDataId:dataId];
            
//            if (self.detailAction) {
//                [self dismissViewControllerAnimated:NO completion:nil];
//                self.detailAction(dict);
//            }
        }else{
            
            // 显示
            UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"非本公司数据,请切换对应公司" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [altert show];
            
        }
        return;
    }
    
    // 扫一扫结果回传
    if (self.scanAction) {
        self.scanAction(scanResult.strScanned);
        [self back];
        return;
    }
    
    // 扫条形码，进入数据详情
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL requestBarcodeDetailWithBarcodeValue:scanResult.strScanned];
    return;
    
    
}

// @"BEGIN:VCARD\nVERSION:3.0\nN:%@\nORG:%@\nTITLE:%@\nNOTE:%@\nTEL:%@\nADR;TYPE=WORK:%@\nADR;TYPE=HOME:%@\nTEL;TYPE=WORK,VOICE:%@\nURL:%@\nEMAIL:%@\nEND:VCARD"
- (void)infomationWithString:(NSString *)string{

    BOOL startStr = [string containsString:@"BEGIN:VCARD"];

    if (!startStr) {
        return ;
    }

    if (!string || [string isEqualToString:@""]) {
        return ;
    }

    NSString *str1 = @"VERSION:3.0\nN:";
    NSString *str2 = @"\nORG:";
    NSString *str3 = @"\nTITLE:";
    NSString *str4 = @"\nNOTE:";
    NSString *str5 = @"\nTEL:";
    NSString *str6 = @"\nADR;TYPE=WORK:";
    NSString *str7 = @"\nADR;TYPE=HOME:";
    NSString *str8 = @"\nURL:";
    NSString *str9 = @"\nEMAIL:";
    NSString *str10 = @"\nEND:VCARD";

    // 1-->2  可知名字range
    // 2-->3  可知公司range
    // 3-->4  可知职位range
    // 4-->5  可知备注range
    // 5-->6  可知电话号码range
    // 6-->7  可知公司地址range
    // 8-->9  可知公司网址range
    // 9-->10  可知Emailrange

    NSRange range1 = [string rangeOfString:str1];
    NSRange range2 = [string rangeOfString:str2];
    NSRange range3 = [string rangeOfString:str3];
    NSRange range4 = [string rangeOfString:str4];
    NSRange range5 = [string rangeOfString:str5];
    NSRange range6 = [string rangeOfString:str6];
    NSRange range7 = [string rangeOfString:str7];
    NSRange range8 = [string rangeOfString:str8];
    NSRange range9 = [string rangeOfString:str9];
    NSRange range10 = [string rangeOfString:str10];

    NSString *name = [string substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - (range1.location + range1.length))];

    NSString *company = [string substringWithRange:NSMakeRange(range2.location + range2.length, range3.location - (range2.location + range2.length))];

    NSString *position = [string substringWithRange:NSMakeRange(range3.location + range3.length, range4.location - (range3.location + range3.length))];

    NSString *remark = [string substringWithRange:NSMakeRange(range4.location + range4.length, range5.location - (range4.location + range4.length))];

    NSString *telephone = [string substringWithRange:NSMakeRange(range5.location + range5.length, range6.location - (range5.location + range5.length))];

    NSString *address = [string substringWithRange:NSMakeRange(range6.location + range6.length, range7.location - (range6.location + range6.length))];

    NSString *netWork = [string substringWithRange:NSMakeRange(range8.location + range8.length, range9.location - (range8.location + range8.length))];

    NSString *email = [string substringWithRange:NSMakeRange(range9.location + range9.length, range10.location - (range9.location + range9.length))];

    HQLog(@"****%@---%@---%@---%@---%@---%@---%@---%@****", name, company,position,remark, telephone,address,netWork,email);

}

#pragma mark - 网络回调
- (void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp
{
    if (resp.cmdId == HQCMD_scanCodeSubmit) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    if (resp.cmdId == HQCMD_barcodeDetail) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *parameter = resp.body;
        
        
        if ([[[parameter valueForKey:@"readAuth"] description] isEqualToString:@"0"]) {// 无权查看
            
//            [MBProgressHUD showError:@"无权查看" toView:self.view];
            
//            [self reStartDevice];
            
            // 显示
            UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无权查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [altert show];
            
        }else if ([[[parameter valueForKey:@"readAuth"] description] isEqualToString:@"1"]) {// 有权查看
            
            if (self.detailAction) {
                [self dismissViewControllerAnimated:NO completion:nil];
                self.detailAction(parameter);
            }
            
        }else if ([[[parameter valueForKey:@"readAuth"] description] isEqualToString:@"2"]) {// 数据已删除
            
//            [MBProgressHUD showError:@"数据已删除" toView:self.view];
            
            // 显示
            UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"数据不存在" message:self.result delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [altert show];
            
        }
        
    }
    
    if (resp.cmdId == HQCMD_moduleHaveReadAuth) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        
        if ([[dict valueForKey:@"readAuth"] isEqualToNumber:@0]) {
            
            
//            [MBProgressHUD showError:@"无权查看" toView:self.view];
//
//            [self reStartDevice];
            
            // 显示
            UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无权查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [altert show];
            
        } else if ([[dict valueForKey:@"readAuth"] isEqualToNumber:@2]) {
            
            // 显示
            UIAlertView *altert = [[UIAlertView alloc] initWithTitle:@"数据不存在" message:self.result delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
            [altert show];
            
        }else{
            
            if (self.detailAction) {
                [self dismissViewControllerAnimated:NO completion:nil];
                self.detailAction(self.resultDict);
            }
        }
    }
}


- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
//    [self reStartDevice];
    [self back];
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
