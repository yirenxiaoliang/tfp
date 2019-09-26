//
//  TFPlusController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/8/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFPlusController.h"
#import "HQRootButton.h"
#import "TFModuleModel.h"
#import "TFCustomBL.h"

#define BottomMargin 300
@interface TFPlusController ()<HQBLDelegate>

/** registerBL */
@property (nonatomic ,strong) NSMutableArray *buttons;
@property (nonatomic ,strong) NSMutableArray *positions;
@property (nonatomic ,strong) NSMutableArray *startPositions;
@property (nonatomic ,strong) NSMutableArray *showModules;
/** modules */
@property (nonatomic, strong) NSMutableArray *modules;
/** UIButton *plusBtn */
@property (nonatomic, strong) UIButton *plusBtn;
/** selectModule */
@property (nonatomic, strong) TFModuleModel *selectModule;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** 系统模块 */
@property (nonatomic ,strong) NSMutableArray *systemModels;

@end

@implementation TFPlusController

/** 系统模块 */
-(NSMutableArray *)systemModels{
    
    if (!_systemModels) {
        _systemModels = [NSMutableArray array];
        
//        NSArray *arr = @[@"审批",@"备忘录",@"协作",@"文件库",@"邮件"];
//        NSArray *icon = @[@"审批",@"备忘录",@"协作",@"文件库",@"邮件"];
//        NSArray *beans = @[@"approval",@"memo",@"project",@"library",@"email"];
        NSArray *arr = @[@"审批",@"备忘录"];
        NSArray *icon = @[@"审批",@"备忘录"];
        NSArray *beans = @[@"approval",@"memo"];
        for (NSInteger i = 0; i < arr.count; i ++) {
            TFModuleModel *model = [[TFModuleModel alloc] init];
            model.chinese_name = arr[i];
            model.english_name = beans[i];
            model.icon = icon[i];
            model.icon_type = 0;
            [_systemModels addObject:model];
        }
        
    }
    return _systemModels;
}

- (NSMutableArray *)modules{
    if (!_modules) {
        _modules = [NSMutableArray array];
    }
    return _modules;
}
- (NSMutableArray *)positions{
    if (!_positions) {
        _positions = [NSMutableArray array];
    }
    return _positions;
}

- (NSMutableArray *)showModules{
    if (!_showModules) {
        _showModules = [NSMutableArray array];
    }
    return _showModules;
}
- (NSMutableArray *)startPositions{
    if (!_startPositions) {
        _startPositions = [NSMutableArray array];
    }
    return _startPositions;
}

- (NSMutableArray *)buttons{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)applicationDidBecomeActive{
    
    [self.customBL requestAllApplication];
}

- (void)changeCompanySocketConnect{
    
    [self.customBL requestAllApplication];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGreture];
    [self setupAddBtn];
    [self setupBackground];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestGetSystemStableModule];
    [self.customBL requestQuickAdd];
    
    // app 活跃通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
//    // 登录或切换公司socket连接通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:ChangeCompanySocketConnect object:nil];
//    // SaveOftenModule
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCompanySocketConnect) name:@"SaveOftenModule" object:nil];
    
    
    self.view.backgroundColor = ClearColor;
}
- (void)setupAddBtn{
    
    // 加号按钮
    UIButton *plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusBtn setBackgroundImage:[UIImage imageNamed:@"添加选中"] forState:UIControlStateNormal];
    [plusBtn setImage:[UIImage imageNamed:@"添加选中"] forState:UIControlStateSelected];
    plusBtn.size = plusBtn.currentBackgroundImage.size;
    [plusBtn addTarget:self action:@selector(plusClick:) forControlEvents:UIControlEventTouchUpInside];
    plusBtn.centerX = SCREEN_WIDTH * 0.5;
    plusBtn.centerY = SCREEN_HEIGHT - 49 * 0.5 - BottomM;
    
    self.plusBtn = plusBtn;
}

- (void)plusClick:(UIButton *)button{
    [self cancel];
}


/** 添加按钮 */
- (void)addButton{
    
    [self.positions removeAllObjects];
    [self.startPositions removeAllObjects];
    [self.buttons removeAllObjects];
    [self.showModules removeAllObjects];
    
//    [self.showModules addObjectsFromArray:self.modules];
    
    NSInteger i = 0;
    for (TFModuleModel *model in self.modules) {// 最多放12个
        if (i > 11) break;
        [self.showModules addObject:model];
        i++;
    }
    
//    if (self.showModules.count < 8) {
//        TFModuleModel *model = [[TFModuleModel alloc] init];
//        model.chinese_name = @"添加";
//        model.icon = @"加人";
//        model.english_name = @"add";
//        [self.showModules addObject:model];
//    }
    if (self.showModules.count == 0) {// 没有就是系统模块
        [self.showModules addObjectsFromArray:self.systemModels];
    }
    
    NSInteger col = 4;
    CGFloat buttonMargin = 15;
    CGFloat buttonW = ((SCREEN_WIDTH - (col + 1) * buttonMargin) / col);
    CGFloat buttonH = buttonW+20;
    
    for (NSInteger i = 0; i < self.showModules.count; i ++) {
        TFModuleModel *model = self.showModules[i];
        
        HQRootButton *button = [self rootButtonWithModel:model];
        button.backgroundColor = [UIColor clearColor];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:button];
        
        button.size = CGSizeMake(buttonW, buttonH);
        button.alpha = 0;
        button.tag = 0x135 + i;
        [self.buttons addObject:button];
        button.layer.anchorPoint = CGPointMake(0, 0);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 动画停止后的位置
        NSInteger lie = i % col;
        NSInteger row = i / col;
        CGFloat buttonX = lie * (buttonW + buttonMargin)+buttonMargin ;
        
        CGFloat topH = SCREEN_HEIGHT - 50 - ((self.showModules.count+col-1)/col) *(buttonH + 2 * buttonMargin) + row * (buttonH + 2 * buttonMargin);
        
        CGFloat buttonY =  (topH);
        CGRect rect = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [self.positions addObject:[NSValue valueWithCGRect:rect]];
        
        // 初始位置
        button.center = CGPointMake(buttonX, buttonY + BottomMargin);
        
        CGRect startRect = CGRectMake(buttonX, buttonY + BottomMargin, buttonW, buttonH);
        [self.startPositions addObject:[NSValue valueWithCGRect:startRect]];
    }
    
    // 按钮动画出现
    [self buttonsAppearAnimation];
    
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        for (NSInteger i = 0; i < self.buttons.count; i ++) {
            UIButton *button = self.buttons[i];
            button.alpha = 1;
        }
        self.plusBtn.transform = CGAffineTransformMakeRotation(M_PI/4 * 4);
    } completion:^(BOOL finished) {
        self.plusBtn.selected = YES;
        // 改变按钮位置
        self.view.userInteractionEnabled = YES;
        [self buttonSetupPosition];
        
    }];
}

/** 私有化-创建按钮 */
- (HQRootButton *)rootButtonWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    HQRootButton *button = [HQRootButton rootButton];
    button.tipLable.hidden = YES;
    button.userInteractionEnabled = YES;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [button setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    return button;
}


/** 私有化-创建按钮 */
- (HQRootButton *)rootButtonWithModel:(TFModuleModel *)model{
    
    HQRootButton *button = [HQRootButton rootButton];
    button.tipLable.hidden = YES;
    button.userInteractionEnabled = YES;
    if ([model.icon_type isEqualToString:@"1"]) {// 网络图片
        [button sd_setImageWithURL:[HQHelper URLWithString:model.icon_url] forState:UIControlStateNormal placeholderImage:nil];
        [button sd_setImageWithURL:[HQHelper URLWithString:model.icon_url] forState:UIControlStateHighlighted placeholderImage:nil];
        button.imageView.backgroundColor = [HQHelper colorWithHexString:model.icon_color]?[HQHelper colorWithHexString:model.icon_color]:GreenColor;
    }else{// 本地图片
        if (!IsStrEmpty(model.icon)) {
            [button setImage:IMG(model.icon) forState:UIControlStateNormal];
            [button setImage:IMG(model.icon) forState:UIControlStateHighlighted];
            button.imageView.backgroundColor = WhiteColor;
        }else if (!IsStrEmpty(model.icon_url)){
            [button setImage:IMG(model.icon_url) forState:UIControlStateNormal];
            [button setImage:IMG(model.icon_url) forState:UIControlStateHighlighted];
            button.imageView.backgroundColor = [HQHelper colorWithHexString:model.icon_color]?[HQHelper colorWithHexString:model.icon_color]:GreenColor;
        }else{
            [button setImage:IMG(model.chinese_name) forState:UIControlStateNormal];
            [button setImage:IMG(model.chinese_name) forState:UIControlStateHighlighted];
            button.imageView.backgroundColor = WhiteColor;
        }
    }
    [button setTitle:model.chinese_name forState:UIControlStateNormal];
    [button setTitle:model.chinese_name forState:UIControlStateHighlighted];
    [button setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
    [button setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
    
    return button;
}

- (void)buttonClick:(HQRootButton *)button{
    
    if (self.parameterAction) {
        
        TFModuleModel *model = self.showModules[button.tag - 0x135];
        
//        if ([model.english_name containsString:@"bean"]) {
//
//            self.selectModule = model;
////            [self.customBL requestHaveAuthWithModuleId:model.id];
//
//            self.parameterAction(self.selectModule);
//            [self cancel];
//
//
//        }else{
//
//            self.parameterAction(model);
//            [self cancel];
//        }
        
        self.parameterAction(model);
        [self cancel];
    }
}

#pragma mark - 按钮出现动画
- (void)buttonsAppearAnimation{
    
    NSMutableArray *animations = [NSMutableArray array];
    for (NSInteger i = 0; i < self.buttons.count; i ++ ) {
        [animations removeAllObjects];
        // 创建动画组
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        
        UIButton *button = self.buttons[i];
        // 1.创建动画平移
        CABasicAnimation *animPosition = [CABasicAnimation animation];
        animPosition.keyPath = @"position";
        CGRect rect = [self.positions[i] CGRectValue];
        animPosition.toValue = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x, rect.origin.y - 100)];
        [animations addObject:animPosition];
        
        CABasicAnimation *animPosition1 = [CABasicAnimation animation];
        animPosition1.keyPath = @"position";
        CGRect rect1 = [self.positions[i] CGRectValue];
        animPosition1.toValue = [NSValue valueWithCGPoint:rect1.origin];
        [animations addObject:animPosition1];
        
        // 2.创建动画缩放
//        CABasicAnimation *animScale = [CABasicAnimation animation];
//        animScale.keyPath = @"transform.scale";
//        animScale.fromValue = [NSNumber numberWithInteger:0.0];
//        animScale.toValue = [NSNumber numberWithInteger:1];
//        [animations addObject:animScale];
        
        animGroup.removedOnCompletion = NO;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.duration = 0.25 + i * 0.04;
        animGroup.animations = animations;
        // 添加动画
        [button.layer addAnimation:animGroup forKey:nil];
    }
    
}
#pragma mark - 按钮消失动画
- (void)buttonsDisappearAnimation{
    
    NSMutableArray *animations = [NSMutableArray array];
    for (NSInteger i = 0; i < self.buttons.count; i ++ ) {
        
        [animations removeAllObjects];
        // 创建动画组
        CAAnimationGroup *animGroup = [CAAnimationGroup animation];
        
        UIButton *button = self.buttons[i];
        // 1.创建动画平移
        CABasicAnimation *animPosition = [CABasicAnimation animation];
        animPosition.keyPath = @"position";
        
        NSValue *value = self.startPositions[i];
        CGRect rect = [value CGRectValue];
        NSValue *toValue = [NSValue valueWithCGPoint:rect.origin];
        //        animPosition.toValue = [NSValue valueWithCGPoint:CGPointMake(SCREEN_WIDTH * 0.5 - (SCREEN_WIDTH / 3) * 0.5, SCREEN_HEIGHT - (SCREEN_WIDTH / 3) * 0.5)];
        animPosition.toValue = toValue;
        [animations addObject:animPosition];
        
        
        // 2.创建动画缩放
//        CABasicAnimation *animScale = [CABasicAnimation animation];
//        animScale.keyPath = @"transform.scale";
//        animScale.fromValue = [NSNumber numberWithInteger:1];
//        animScale.toValue = [NSNumber numberWithInteger:0.0];
//        [animations addObject:animScale];
        
        animGroup.removedOnCompletion = NO;
        animGroup.fillMode = kCAFillModeForwards;
        animGroup.duration = 0.15 + self.buttons.count * 0.04 - i * 0.04;
        animGroup.animations = animations;
        // 添加动画
        [button.layer addAnimation:animGroup forKey:nil];
    }
}

/** 设置按钮位置 */
- (void)buttonSetupPosition{
    for (NSInteger i = 0; i < self.buttons.count; i ++) {
        UIButton *button = self.buttons[i];
        button.frame = [self.positions[i] CGRectValue];
    }
}


#pragma mark - 子控件
- (void)setupChild{
    
    // TeamFace
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plusLogo"]];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.frame = CGRectMake(0, 60, SCREEN_WIDTH, 68);
    [self.view addSubview:imageView];
    
}

#pragma mark - 设置背景
- (void)setupBackground{
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    UIToolbar *blurEffectView = [[UIToolbar alloc] init];
    blurEffectView.barStyle = UIBarStyleDefault;
    
    [self.view insertSubview:blurEffectView atIndex:0];
    
    [blurEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.plusBtn];
}

#pragma mark - 添加手势
- (void)setupGreture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [self.view addGestureRecognizer:tap];
}

- (void)cancel{
    
    [self buttonsDisappearAnimation];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        for (NSInteger i = 0; i < self.buttons.count; i ++) {
            UIButton *button = self.buttons[i];
            button.alpha = 0;
        }
        self.view.alpha = 0;
        self.plusBtn.transform = CGAffineTransformMakeRotation(M_PI/4 * 6);
    } completion:^(BOOL finished) {
        
        self.plusBtn.transform = CGAffineTransformIdentity;
        self.plusBtn.selected = NO;
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self dismissViewControllerAnimated:NO completion:nil];
    });
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (resp.cmdId == HQCMD_quickAdd) {
        
        [self.modules removeAllObjects];
        [self.modules addObjectsFromArray:resp.body];
        
        [self addButton];
    }
    
    if (resp.cmdId == HQCMD_moduleHaveAuth) {
        
        NSNumber *auth = [resp.body valueForKey:@"saveAuth"];
        
        if ([auth isEqualToNumber:@1]) {
            
            if (self.parameterAction) {
                self.parameterAction(self.selectModule);
                [self cancel];
            }
            
        }else{
            
            [MBProgressHUD showError:@"无权新建" toView:KeyWindow];
        }
    }
    
    if (resp.cmdId == HQCMD_getSystemStableModule) {
        
        NSArray *arr = resp.body;
        NSMutableArray *models = [NSMutableArray array];
        // 处理系统模块
        for (NSInteger i = 0; i < arr.count; i ++) {
            NSDictionary *dict = arr[i];
            if ([[[dict valueForKey:@"onoff_status"] description] isEqualToString:@"1"]) {
                
                if (!([[dict valueForKey:@"bean"] isEqualToString:@"approval"] || [[dict valueForKey:@"bean"] isEqualToString:@"workbench"] || [[dict valueForKey:@"bean"] isEqualToString:@"memo"])) {
                    
                    TFModuleModel *mu = [[TFModuleModel alloc] init];
                    mu.chinese_name = [dict valueForKey:@"name"];
                    mu.english_name = [dict valueForKey:@"bean"];
                    mu.icon = [dict valueForKey:@"name"];
                    mu.icon_type = 0;
                    mu.icon_color = @"#FFFFFF";
                    [models addObject:mu];
                }
            }
        }
        [self.systemModels addObjectsFromArray:models];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
