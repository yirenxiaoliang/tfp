//
//  TFSignatureViewController.m
//  HuiJuHuaQi
//
//  Created by daidan on 2019/10/10.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSignatureViewController.h"
#import "HJSignatureView.h"
#import "TFCustomBL.h"

@interface TFSignatureViewController ()<HQBLDelegate>

/** 自定义请求 */
@property (nonatomic, strong) TFCustomBL *customBL;
@property (nonatomic, weak) HJSignatureView *signatureView;
@end

@implementation TFSignatureViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.view.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手写签名";
    self.enablePanGesture = NO;
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self setupSignatureView];
    
}

- (void)setupSignatureView{
    
    HJSignatureView *signatureView = [[HJSignatureView alloc] initWithFrame:(CGRect){0,0,screenW,screenW}];
    [self.view addSubview:signatureView];
    self.signatureView = signatureView;
    signatureView.layer.cornerRadius = 4;
    signatureView.layer.masksToBounds = YES;
    [signatureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.left.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-64);
    }];
    
    CGFloat width = 100;
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(screenW - width - 15, screenW + 15, width, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = WhiteColor;
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.width.equalTo(@(width));
        make.height.equalTo(@(44));
        make.right.equalTo(self.view).offset(-15);
    }];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(CGRectGetMinX(sureBtn.frame) - width - 15, screenW + 15,width, 44);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    clearBtn.layer.cornerRadius = 4;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.backgroundColor = WhiteColor;
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.width.equalTo(@(width));
        make.height.equalTo(@(44));
        make.right.equalTo(sureBtn.mas_left).offset(-15);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(CGRectGetMinX(clearBtn.frame) - width - 15, screenW + 15,width, 44);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.view addSubview:cancelBtn];
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.backgroundColor = WhiteColor;
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.width.equalTo(@(width));
        make.height.equalTo(@(44));
        make.right.equalTo(clearBtn.mas_left).offset(-15);
    }];
    
    
}

- (void)clearClick{
    
    [self.signatureView clear];

}

- (void)sureClick{
    
    UIImage *image = [self.signatureView saveTheSignatureWithError:^(NSString * _Nonnull errorMsg) {
        [MBProgressHUD showError:@"请手写签名" toView:self.view];
    }];
    
    // 上传图片
    if (image) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];

    }
    
}
- (void)cancelClick{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_uploadFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *images = resp.body;
        
        if (self.images) {
            self.images(images);
            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
        
    }
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
