//
//  TFSetUrlController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/19.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSetUrlController.h"
#import "TFUrlInputRecordView.h"
#import "HQRequestManager.h"

#define RecordHeight (170)

@interface TFSetUrlController ()<TFUrlInputRecordViewDelegate>

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UIButton *remenber;
@property (nonatomic, weak) UIButton *arrow;

@property (nonatomic, strong) TFUrlInputRecordView *recordView;

@end

@implementation TFSetUrlController

-(TFUrlInputRecordView *)recordView{
    if (!_recordView) {
        _recordView = [[TFUrlInputRecordView alloc] initWithFrame:(CGRect){30,0,SCREEN_WIDTH-60,RecordHeight}];
        [self.view addSubview:_recordView];
        _recordView.delegate = self;
    }
    return _recordView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupChild];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeybord) name:UIKeyboardWillShowNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(resetUrl) text:@"重置" textColor:GreenColor];
    
}

-(void)resetUrl{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:SaveIMAddressKey];
    [userDefault removeObjectForKey:SaveIPAddressKey];
    [userDefault removeObjectForKey:SaveInputUrlRecordKey];
    [userDefault synchronize];
    
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.baseUrl = baseUrl;
    app.serverAddress = serverAddress;
    app.urlEnvironment = environment;
    [HQRequestManager dellocManager];// 销毁单例
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)urlInputRecordViewSelectUrl:(NSString *)url{
    
    self.textField.text = url;
    [self showKeybord];
}

-(void)showKeybord{
    
    self.arrow.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.recordView.height = 0;
        self.recordView.alpha = 0;
    }completion:^(BOOL finished) {
        self.recordView.hidden = YES;
        [self.recordView removeFromSuperview];
        self.recordView = nil;// 销毁
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    self.arrow.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.recordView.height = 0;
        self.recordView.alpha = 0;
    }completion:^(BOOL finished) {
        self.recordView.hidden = YES;
        [self.recordView removeFromSuperview];
        self.recordView = nil;// 销毁
    }];
}

-(void)setupChild{
    
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){30,60,SCREEN_WIDTH-60,40}];
    [self.view addSubview:label];
    label.text = @"私有部署服务器";
    label.font = FONT(18);
    
    UITextField *textField = [[UITextField alloc] initWithFrame:(CGRect){30,CGRectGetMaxY(label.frame)+ 20,SCREEN_WIDTH-60-30-30,40}];
    [self.view addSubview:textField];
    textField.placeholder = @"请输入IP+端口号或者域名";
    textField.font = FONT(17);
    textField.textColor = BlackTextColor;
    textField.keyboardType = UIKeyboardTypeURL;
//    textField.clearButtonMode = UITextFieldViewModeAlways;
    self.textField = textField;
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    textField.text = [userDefault valueForKey:SaveInputUrlRecordKey];
//    NSMutableArray *arr = [userDefault valueForKey:SaveUrlRecordKey];
//    if (arr.count) {
//        textField.text = arr.firstObject;
//        if (![[AppDelegate shareAppDelegate].baseUrl isEqualToString:textField.text] && ![[AppDelegate shareAppDelegate].baseUrl isEqualToString:baseUrl]) {
//            textField.text = [AppDelegate shareAppDelegate].baseUrl;
//        }
//    }
    
    UIButton *clear = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:clear];
    clear.frame = CGRectMake(CGRectGetMaxX(textField.frame), CGRectGetMinY(textField.frame), 30, 40);
    [clear setImage:IMG(@"清除clear") forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *arrow = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:arrow];
    arrow.frame = CGRectMake(CGRectGetMaxX(clear.frame), CGRectGetMinY(textField.frame), 30, 40);
    [arrow setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
    arrow.transform = CGAffineTransformRotate(arrow.transform, M_PI_2);
    [arrow addTarget:self action:@selector(arrowClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.arrow = arrow;
    
    UIView *line = [[UIView alloc] initWithFrame:(CGRect){30,CGRectGetMaxY(textField.frame)+ 4,SCREEN_WIDTH-60,0.5}];
    line.backgroundColor = GrayTextColor;
    [self.view addSubview:line];
    
    UIButton *remenber = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:remenber];
    remenber.frame = CGRectMake(30, CGRectGetMaxY(line.frame)+ 8, 96, 44);
    remenber.titleLabel.font = FONT(14);
    [remenber setTitle:@"  记住地址" forState:UIControlStateNormal];
    [remenber setTitle:@"  记住地址" forState:UIControlStateSelected];
    [remenber setImage:IMG(@"未选中") forState:UIControlStateNormal];
    [remenber setImage:IMG(@"选中g") forState:UIControlStateSelected];
    remenber.selected = YES;
    [remenber setTitleColor:BlackTextColor forState:UIControlStateNormal];
    [remenber setTitleColor:BlackTextColor forState:UIControlStateSelected];
    self.remenber = remenber;
    [remenber addTarget:self action:@selector(remenberClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *tip = [[UILabel alloc] initWithFrame:(CGRect){30,CGRectGetMaxY(remenber.frame)+ 8,SCREEN_WIDTH-60,20}];
    [self.view addSubview:tip];
    tip.text = @"例如 http://192.168.1.183:8081";
    tip.textColor = LightGrayTextColor;
    tip.font = FONT(14);
    
    UIButton *finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(30, CGRectGetMaxY(tip.frame) + 40, SCREEN_WIDTH - 60, 50);
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitle:@"完成" forState:UIControlStateHighlighted];
    [finishBtn setTitle:@"完成" forState:UIControlStateSelected];
    
    [finishBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [finishBtn setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
    [finishBtn setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0x3689E9, 0.7)] forState:UIControlStateDisabled];
    
    [finishBtn addTarget:self action:@selector(finishClicked:) forControlEvents:UIControlEventTouchUpInside];
    finishBtn.titleLabel.font = FONT(20);
    finishBtn.layer.cornerRadius = finishBtn.height/2;
    finishBtn.layer.masksToBounds = YES;
    [self.view addSubview:finishBtn];
}

-(void)clearClicked:(UIButton *)button{
    self.textField.text = @"";
}

-(void)remenberClicked:(UIButton *)button{
    button.selected = !button.selected;
}

-(void)arrowClicked:(UIButton *)button{
    
    button.selected = !button.selected;
    
    [self.view endEditing:YES];
    if (button.selected) {
        self.recordView.hidden = NO;
        self.recordView.y = CGRectGetMaxY(button.frame) + 16;
        self.recordView.height = 0;
        self.recordView.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.recordView.height = RecordHeight;
            self.recordView.alpha = 1;
        }];
    }else{
        
        [UIView animateWithDuration:0.25 animations:^{
            self.recordView.height = 0;
            self.recordView.alpha = 0;
        }completion:^(BOOL finished) {
            self.recordView.hidden = YES;
            [self.recordView removeFromSuperview];
            self.recordView = nil;// 销毁
        }];
    }
    
}

-(void)finishClicked:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    if (self.textField.text.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否访问Teamface服务器？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"访问" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            AppDelegate *app = [AppDelegate shareAppDelegate];
            app.baseUrl = baseUrl;
            app.serverAddress = serverAddress;
            app.urlEnvironment = environment;
            [HQRequestManager dellocManager];// 销毁单例
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (![HQHelper checkUrl:self.textField.text]) {
        [MBProgressHUD showError:@"格式不正确" toView:self.view];
        return;
    }
    
    AppDelegate *app = [AppDelegate shareAppDelegate];
    app.baseUrl = self.textField.text;
    app.serverAddress = serverAddress;
    app.urlEnvironment = environmentInput;
    [HQRequestManager dellocManager];// 销毁单例
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setValue:self.textField.text forKey:SaveInputUrlRecordKey];
        
    NSMutableArray *arr = [userDefault valueForKey:SaveUrlRecordKey];
    NSMutableArray *total = [NSMutableArray array];
    
    for (NSString *obj in arr) {
        if (![obj isEqualToString:app.baseUrl]) {
            [total addObject:obj];
        }
    }
    if (self.remenber.selected) {
        [total insertObject:app.baseUrl atIndex:0];
    }
    [userDefault setValue:total forKey:SaveUrlRecordKey];
        
    [userDefault synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
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
