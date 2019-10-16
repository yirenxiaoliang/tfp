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
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(15, screenW + 15, (screenW - 45) / 2, 44);
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    clearBtn.layer.cornerRadius = 4;
    clearBtn.layer.masksToBounds = YES;
    clearBtn.backgroundColor = WhiteColor;
    [clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(CGRectGetMaxX(clearBtn.frame) + 15, screenW + 15, (screenW - 45) / 2, 44);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [self.view addSubview:sureBtn];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = WhiteColor;
    [sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
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


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_uploadFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSArray *images = resp.body;
        
        if (self.images) {
            self.images(images);
            [self.navigationController popViewControllerAnimated:YES];
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
