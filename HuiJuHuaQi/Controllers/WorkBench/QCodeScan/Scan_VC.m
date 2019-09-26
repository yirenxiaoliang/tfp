

#import "Scan_VC.h"
#import <AVFoundation/AVFoundation.h>
#import "HQQRcodeBaseModel.h"
#import "HQLoginByQRcodeRequestModel.h"
#import "TFLoginBL.h"
#import "AlertView.h"

static const CGFloat kBorderW = 100;
static const CGFloat kMargin = 30;

@interface Scan_VC ()<UIAlertViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,HQBLDelegate>
{
    
    TFLoginBL *_loginBL;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak)   UIView *maskView;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;

@end

@implementation Scan_VC


-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    [self resumeAnimation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden=NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    //这个属性必须打开否则返回的时候会出现黑边
    self.view.clipsToBounds=YES;
    //1.遮罩
    [self setupMaskView];
    //2.下边栏
    [self setupBottomBar];
    //3.提示文本
    [self setupTipTitleView];
    //4.顶部导航
    [self setupNavView];
    //5.扫描区域
    [self setupScanWindowView];
    //6.开始动画
    [self beginScanning];
    
    _loginBL = [TFLoginBL build];
    _loginBL.delegate = self;
    
    if (IOS7_AND_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];
   
}
-(void)setupTipTitleView{
    
    //1.补充遮罩
    
    UIView*mask=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.top+_maskView.height, self.view.width, kBorderW)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    mask.backgroundColor = [UIColor blackColor];
    [self.view addSubview:mask];
    
    //2.操作提示
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.height*0.9-kBorderW*2, self.view.bounds.size.width, kBorderW)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor greenColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
}
-(void)setupNavView{
    
    //1.返回
    
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    backBtn.contentMode=UIViewContentModeScaleAspectFit;
    [backBtn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    //2.相册
    
    UIButton * albumBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    albumBtn.frame = CGRectMake(0, 0, 35, 49);
    albumBtn.center=CGPointMake(self.view.width/2, 20+49/2.0);
    [albumBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    albumBtn.contentMode=UIViewContentModeScaleAspectFit;
    [albumBtn addTarget:self action:@selector(myAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
    
    //3.闪光灯
    
    UIButton * flashBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(self.view.width-55,20, 35, 49);
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    flashBtn.contentMode=UIViewContentModeScaleAspectFit;
    [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    

}
- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderColor = [UIColor blackColor].CGColor;

    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, self.view.width + kBorderW + kMargin , self.view.width + kBorderW + kMargin);
    mask.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.5);
    mask.top = 0;
    
    [self.view addSubview:mask];
}

- (void)setupBottomBar

{
    //1.下边栏
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height * 0.9, self.view.width, self.view.height * 0.1)];
    bottomBar.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:bottomBar];
    

    
   
}
- (void)setupScanWindowView
{
    CGFloat scanWindowH = self.view.width - kMargin * 2;
    CGFloat scanWindowW = self.view.width - kMargin * 2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW - 4, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];

    _scanNetImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scan_net"]];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.x, bottomLeft.y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
}

- (void)setupScan{
    
}


- (void)beginScanning
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanCrop=[self getScanCrop:_scanWindow.bounds readerViewBounds:self.view.frame];
     output.rectOfInterest = scanCrop;
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}

/** 扫码结果 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        
        HQLog(@"%@----%@", metadataObject.corners, metadataObject.stringValue);
        
        if ([metadataObject.stringValue containsString:@"ScanLogin"] && [metadataObject.stringValue containsString:@"useType"]) {
            
            NSDictionary *dict = [HQHelper dictionaryWithJsonString:metadataObject.stringValue];
        
//            UILabel *label = [HQHelper labelWithFrame:(CGRect){20,100,SCREEN_WIDTH-40,100} text:metadataObject.stringValue textColor:BlackTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//            [self.view addSubview:label];
//            label.numberOfLines = 0;
//            label.backgroundColor = WhiteColor;
            
//            [AlertView showAlertView:@"提示" msg:@"是否确定PC端登录" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
//            } onRightTouched:^{
            
            [_loginBL requestScanWithUserName:UM.userLoginInfo.employee.phone uniqueCode:[dict valueForKey:@"uniqueId"]];
                
//            }];
            
            return;
        }
    
        
        if ([HQHelper checkUrl:metadataObject.stringValue]) {
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLogoutSuccess object:nil];
            [[UIApplication sharedApplication] openURL:[HQHelper URLWithString:metadataObject.stringValue]];
            return;
        }
        
    }
}


//- (void)addContactCtrlCreatContact:(NSArray *)contacts{
//    HQLog(@"*********%@*********", contacts);// 只有一个元素
//    HQUserManager *user = [HQUserManager defaultUserInfoManager];
//    HQUserLoginCModel *login = [user userLoginInfo];
//    // 取得CoreData管理单例
//    HQCoreDataManager *mana = [HQCoreDataManager defaultCoreDataManager];
//    
//    // 存客户联系人时需排除相同的人和电话号码
//    NSArray *allCustomer = [mana queryCustomerWithEmployeeID:login.employee.id];
//    
//    self.saveCustomer = contacts[0];
//    // 记录有冲突的人
//    NSMutableArray *confictPeo = [NSMutableArray array];
//    // 记录有冲突的人
//    NSMutableArray *confictTele = [NSMutableArray array];
//    // 记录合格保存的人
//    NSMutableArray *pass = [NSMutableArray array];
//    
//    // 遍历排除相同的
//    BOOL save = YES;
//    for (HQCustomerCModel *customer in allCustomer) {
//        // 比较名字
//        if ([customer.name isEqualToString:self.saveCustomer.name]) {
//            [confictPeo addObject:self.saveCustomer];
//            save = NO;
//            break;
//        }else{
//            // 比较电话
//            for (NSString *saveTele in self.saveCustomer.telephone) {
//                if (saveTele && ![saveTele isEqualToString:@""]) {
//                    for (HQCustomerStringCModel *tele in [customer.telephone allObjects]) {
//                        if ([tele.desc isEqualToString:saveTele]) {
//                            
//                            [confictTele addObject:self.saveCustomer];
//                            save = NO;
//                            break;
//                        }
//                    }
//                }
//                // 只要有冲突的就结束
//                if (!save) {
//                    break;
//                }
//            }
//        }
//        
//        // 只要有冲突的就结束
//        if (!save) {
//            break;
//        }
//        
//    }
//    
//    // 保存
//    if (save) {
//        [pass addObject:self.saveCustomer];
//    }
//    
//    // 有冲突的给出提示
//    NSMutableArray *peoples = [NSMutableArray array];// 有相似的所有人集合
//    
//    for (HQCustomerCModel *customer in allCustomer) {
//        if ([customer.name isEqualToString:self.saveCustomer.name]) {
//            [peoples addObject:customer];
//        }else{
//            // 比较电话
//            for (NSString *saveTele in self.saveCustomer.telephone) {
//                if (saveTele && ![saveTele isEqualToString:@""]) {
//                    for (HQCustomerStringCModel *tele in [customer.telephone allObjects]) {
//                        if ([tele.desc isEqualToString:saveTele]) {
//                            [peoples addObject:customer];
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    if (peoples.count) {
//        
//        [HQSimilarAlertView showAlertView:@"发现相似的联系人" contact:peoples leftTitle:@"替换" rightTitle:@"新建" onLeftTouched:^(NSArray *array) {// 替换
//            HQLog(@"%@", array);
//            HQCustomerCModel *customer = array[0];
//            // 将array中的数据从数据库中删除
//            [mana removeContactWithEmployeeID:customer.employeeID customerID:customer.customerID];
//            // 然后保存该条新的
//            [self saveHQCreateCustomerContactModel:self.saveCustomer];
//            
//            // 取出所有客户
//            NSArray *all = [mana queryCustomerWithEmployeeID:login.employee.id];
//            HQLog(@"----------------%@--------------", all);
//            
//            // 提示
//            [MBProgressHUD showError:@"替换成功" toView:self.view];
//            
//        } onRightTouched:^{// 新建
//            HQLog(@"%@",self.saveCustomer);
//            // 保存self.saveCustomer
//            
//            [self saveHQCreateCustomerContactModel:self.saveCustomer];
//            
//            // 取出所有客户
//            NSArray *all = [mana queryCustomerWithEmployeeID:login.employee.id];
//            HQLog(@"----------------%@--------------", all);
//            
//            // 提示
//            [MBProgressHUD showError:@"新建成功" toView:self.view];
//        }];
//    }
//    
//    
//    // 合格的保存
//    HQLog(@"%@", pass);
//    for (HQCreateCustomerContactModel *contact in pass) {
//        [self saveHQCreateCustomerContactModel:contact];
//        // 提示
//        [MBProgressHUD showError:@"新建成功" toView:self.view];
//    }
//    
//}



// @"BEGIN:VCARD\nVERSION:3.0\nN:%@\nORG:%@\nTITLE:%@\nNOTE:%@\nTEL:%@\nADR;TYPE=WORK:%@\nADR;TYPE=HOME:%@\nTEL;TYPE=WORK,VOICE:%@\nURL:%@\nEMAIL:%@\nEND:VCARD"
//- (HQCreateCustomerContactModel *)infomationWithString:(NSString *)string{
//    
//    BOOL startStr = [string containsString:@"BEGIN:VCARD"];
//    
//    if (!startStr) {
//        return nil;
//    }
//    
//    if (!string || [string isEqualToString:@""]) {
//        return nil;
//    }
//    
//    NSString *str1 = @"VERSION:3.0\nN:";
//    NSString *str2 = @"\nORG:";
//    NSString *str3 = @"\nTITLE:";
//    NSString *str4 = @"\nNOTE:";
//    NSString *str5 = @"\nTEL:";
//    NSString *str6 = @"\nADR;TYPE=WORK:";
//    NSString *str7 = @"\nADR;TYPE=HOME:";
//    NSString *str8 = @"\nURL:";
//    NSString *str9 = @"\nEMAIL:";
//    NSString *str10 = @"\nEND:VCARD";
//    
//    // 1-->2  可知名字range
//    // 2-->3  可知公司range
//    // 3-->4  可知职位range
//    // 4-->5  可知备注range
//    // 5-->6  可知电话号码range
//    // 6-->7  可知公司地址range
//    // 8-->9  可知公司网址range
//    // 9-->10  可知Emailrange
//    
//    NSRange range1 = [string rangeOfString:str1];
//    NSRange range2 = [string rangeOfString:str2];
//    NSRange range3 = [string rangeOfString:str3];
//    NSRange range4 = [string rangeOfString:str4];
//    NSRange range5 = [string rangeOfString:str5];
//    NSRange range6 = [string rangeOfString:str6];
//    NSRange range7 = [string rangeOfString:str7];
//    NSRange range8 = [string rangeOfString:str8];
//    NSRange range9 = [string rangeOfString:str9];
//    NSRange range10 = [string rangeOfString:str10];
//    
//    NSString *name = [string substringWithRange:NSMakeRange(range1.location + range1.length, range2.location - (range1.location + range1.length))];
//    
//    NSString *company = [string substringWithRange:NSMakeRange(range2.location + range2.length, range3.location - (range2.location + range2.length))];
//    
//    NSString *position = [string substringWithRange:NSMakeRange(range3.location + range3.length, range4.location - (range3.location + range3.length))];
//    
//    NSString *remark = [string substringWithRange:NSMakeRange(range4.location + range4.length, range5.location - (range4.location + range4.length))];
//    
//    NSString *telephone = [string substringWithRange:NSMakeRange(range5.location + range5.length, range6.location - (range5.location + range5.length))];
//    
//    NSString *address = [string substringWithRange:NSMakeRange(range6.location + range6.length, range7.location - (range6.location + range6.length))];
//    
//    NSString *netWork = [string substringWithRange:NSMakeRange(range8.location + range8.length, range9.location - (range8.location + range8.length))];
//    
//    NSString *email = [string substringWithRange:NSMakeRange(range9.location + range9.length, range10.location - (range9.location + range9.length))];
//    
//    HQLog(@"****%@---%@---%@---%@---%@---%@---%@---%@****", name, company,position,remark, telephone,address,netWork,email);
//    
//    HQCreateCustomerContactModel *contact = [[HQCreateCustomerContactModel alloc] init];
//    contact.name = name;
//    contact.customerName = company;
//    contact.position = position;
//    contact.remark = remark;
//    contact.address = address;
//    contact.webAddress = netWork;
//    [contact.telephone insertObject:telephone atIndex:0];
//    [contact.email insertObject:email atIndex:0];
//    
//    return contact;
//}


//- (void)saveHQCreateCustomerContactModel:(HQCreateCustomerContactModel *)contact{
//    
//    HQUserManager *user = [HQUserManager defaultUserInfoManager];
//    HQUserLoginCModel *login = [user userLoginInfo];
//    // 取得CoreData管理单例
//    HQCoreDataManager *mana = [HQCoreDataManager defaultCoreDataManager];
//    // 保存
//    NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
//    dict1[@"employeeID"] = login.employee.id;
//    dict1[@"name"] = contact.name;
//    dict1[@"customerID"] = [NSString stringWithFormat:@"%lld", [HQHelper getNowTimeSp]];
//    dict1[@"customerName"] = contact.customerName;
//    dict1[@"gender"] = @(contact.gender);
//    dict1[@"position"] = contact.position;
//    dict1[@"weChatID"] = contact.weChatID;
//    dict1[@"birthday"] = @(contact.birthday);
//    dict1[@"qqNumbe"] = contact.qqNumbe;
//    dict1[@"remark"] = contact.remark;
//    dict1[@"longitude"] = @(contact.longitude);
//    dict1[@"latitude"] = @(contact.latitude);
//    dict1[@"address"] = contact.address;
//    dict1[@"webAddress"] = contact.webAddress;
//    
//    HQCustomerCModel *customer = [mana saveCustomerWithDic:dict1];
//    
//    for (NSString *tele in contact.telephone) {
//        if (tele.length) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"desc"] = tele;
//            HQCustomerStringCModel *tele = [mana saveCustomerStringWithDic:dict];
//            [customer addTelephoneObject:tele];
//        }
//    }
//    
//    for (NSString *email in contact.email) {
//        if (email.length) {
//            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//            dict[@"desc"] = email;
//            HQCustomerStringCModel *email = [mana saveCustomerStringWithDic:dict];
//            [customer addEMailObject:email];
//        }
//    }
//    
//    [mana.appDelegate saveContext];
//    
//}



#pragma mark - 网络回调
- (void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp
{
    
    
    if (resp.cmdId == HQCMD_scanCodeSubmit) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp
{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
    
}


#pragma mark-> 我的相册
-(void)myAlbum{
    
    HQLog(@"我的相册");
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //2.设置代理
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //4.随便给他一个转场动画
        controller.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
        
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
        
        [AlertView showAlertView:@"提示" msg:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" leftTitle:nil rightTitle:@"确定" onLeftTouched:nil onRightTouched:^{
            
            [_session stopRunning];
        }];
    }
    
}
#pragma mark-> imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            
            
            // 扫描的不行华企员工二维码（eg. URL等等）
            [MBProgressHUD showError:@"不能识别该二维码" toView:self.view];
            [self performSelector:@selector(disMiss) withObject:nil afterDelay:1];

          
        }
        else{
            
            
            [AlertView showAlertView:@"提示" msg:@"该图片没有包含一个二维码！" leftTitle:nil rightTitle:@"确定" onLeftTouched:nil onRightTouched:^{
                
                [_session stopRunning];
            }];
        }
        
  
    }];
    
}


#pragma mark-> 闪光灯
-(void)openFlash:(UIButton*)button{
    
    HQLog(@"闪光灯");
    button.selected = !button.selected;
    if (button.selected) {
        [self turnTorchOn:YES];
    }
    else{
        [self turnTorchOn:NO];
    }
    
}

#pragma mark-> 开关闪光灯
- (void)turnTorchOn:(BOOL)on
{
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}


#pragma mark 恢复动画
- (void)resumeAnimation
{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if(anim){
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
        
    }else{
        
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowH = self.view.width - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.width;
    
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 1.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];
    }
    
    

}
#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}
#pragma mark-> 返回
- (void)disMiss
{
//    self.navigationController.navigationBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO ;
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self disMiss];
    } else if (buttonIndex == 1) {
        [_session startRunning];
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
