//
//  TFMyBusinessCardController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/27.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMyBusinessCardController.h"
#import "TFBusinessCardController.h"
#import "TFBusinessCardView.h"
#import "TFPersonInfoModel.h"
#import "HQRootButton.h"
#import "TFCustomCardView.h"
#import "TFBusinessCard.h"
#import "TFLoginBL.h"
#import "TFStyleModel.h"
#import "TFCardModel.h"
#import "JSHAREService.h"
@interface TFMyBusinessCardController ()<UITableViewDelegate,UITableViewDataSource,TFCustomCardViewDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFPersonInfoModel *personInfoModel;

/** cardVeiw */
//@property (nonatomic, weak) TFBusinessCardView *cardVeiw;
/** TFBusinessCard */
@property (nonatomic, weak) TFBusinessCard *cardVeiw;
/** customCardView */
@property (nonatomic, strong) TFCustomCardView *customCardView;

/** footer */
@property (nonatomic, weak) UIView *footer;

/** TFLoginBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** TFCardModel */
@property (nonatomic, strong) TFCardModel *cardModel;

/** cancelCardModel */
@property (nonatomic, strong) TFCardModel *cancelCardModel;

/** scanerView */
@property (nonatomic, strong) UIImageView *scanerView;


@end

@implementation TFMyBusinessCardController

-(TFCardModel *)cardModel{
    if (!_cardModel) {
        _cardModel = [[TFCardModel alloc] init];
    }
    return _cardModel;
}

-(TFCustomCardView *)customCardView{
    if (!_customCardView) {
        _customCardView = [[TFCustomCardView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT,SCREEN_WIDTH,280}];
        _customCardView.delegate = self;
        [_customCardView refreshCustomViewWithStyles:@[] choice:0 hides:@[]];
    }
    return _customCardView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    [self.cardVeiw refreshBusinessCardVeiwWithModel:_personInfoModel];
    [self.cardVeiw refreshViewWithStyle:0 hiddens:@[]];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    [self.loginBL requestGetCardStyleWithEmployeeId:UM.userLoginInfo.employee.id];
    
    [self initData];
    [self setupNavi];
    [self setupTableView];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getCardStyle) {
        
        self.cardModel = [[TFCardModel alloc] initWithDictionary:resp.body error:nil];
        
        NSArray *arr = [HQHelper dictionaryWithJsonString:self.cardModel.card_template];
        NSMutableArray *sts = [NSMutableArray array];
        for (NSDictionary *di in arr) {
            TFStyleModel *model = [[TFStyleModel alloc] initWithDictionary:di error:nil];
            if (model) {
                [sts addObject:model];
            }
        }
        if (sts.count == 0) {
            TFStyleModel *model = [[TFStyleModel alloc] init];
            model.id = @0;
            model.styleId = @0;
            [sts addObject:model];
            TFStyleModel *model1 = [[TFStyleModel alloc] init];
            model1.id = @1;
            model1.styleId = @1;
            [sts addObject:model1];
        }
        if (self.cardModel.card_template == nil) {
            self.cardModel.card_template = [HQHelper dictionaryToJson:arr];
        }
        if (self.cardModel.hide_set == nil) {
            self.cardModel.hide_set = @"";
        }
        if (self.cardModel.choice_template == nil) {
            self.cardModel.choice_template = @"0";
        }
        self.cancelCardModel = [self.cardModel copy];
        [self.customCardView refreshCustomViewWithStyles:sts choice:[self.cardModel.choice_template integerValue] hides:[self.cardModel.hide_set componentsSeparatedByString:@","]];
        [self.cardVeiw refreshViewWithStyle:[self.cardModel.choice_template integerValue] hiddens:[self.cardModel.hide_set componentsSeparatedByString:@","]];
        
    }
    
    if (resp.cmdId == HQCMD_saveCardStyle) {
        
        self.cancelCardModel = [self.cardModel copy];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}


- (void)initData {
    
    _personInfoModel = [[TFPersonInfoModel alloc] init];
    _personInfoModel.employeeName = UM.userLoginInfo.employee.employee_name;
    _personInfoModel.photograph = UM.userLoginInfo.employee.picture;
    _personInfoModel.telephone = UM.userLoginInfo.employee.phone;
    _personInfoModel.position = UM.userLoginInfo.employee.post_name;
    _personInfoModel.birthday = UM.userLoginInfo.employee.birth;
    _personInfoModel.mobilePhoto = UM.userLoginInfo.employee.mobile_phone;
    _personInfoModel.email = UM.userLoginInfo.employee.email;
    _personInfoModel.companyName = UM.userLoginInfo.company.company_name;
    if (UM.userLoginInfo.employee.sex) {
        _personInfoModel.gender = @([UM.userLoginInfo.employee.sex integerValue]);
    }
    _personInfoModel.region = UM.userLoginInfo.employee.region;
    
    NSString *str = @"";
    for (TFDepartmentCModel *model in UM.userLoginInfo.departments) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.department_name]];
    }
    _personInfoModel.departmentName = [str substringToIndex:str.length-1];
    
}

- (void)setupNavi{
    
    self.navigationItem.title = @"我的名片";
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"模版" textColor:LightBlackTextColor];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(didBack:) image:@"返回灰色" highlightImage:@"返回灰色"];
}

- (void)didBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightClicked{
    
    TFBusinessCardController *card = [[TFBusinessCardController alloc] init];
    [self.navigationController pushViewController:card animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    
//    TFBusinessCardView *view = [TFBusinessCardView businessCardView];
//    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, Long(250));
//    tableView.tableHeaderView = view;
//    [view refreshBusinessCardVeiwWithModel:_personInfoModel];
//    self.cardVeiw = view;
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRect){0, 0, SCREEN_WIDTH, Long(250)}];
    tableView.tableHeaderView = header;
    
    TFBusinessCard *view = [TFBusinessCard businessCard];
    view.frame = CGRectMake(15, 15, SCREEN_WIDTH-30, Long(250-30));
    [header addSubview:view];
    [view refreshViewWithStyle:0 hiddens:@[]];
    self.cardVeiw = view;
    
    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,(200 + 36 + 30 + 40)}];
    footer.backgroundColor = WhiteColor;
    self.footer = footer;
    
    UIImageView *scanerView = [[UIImageView alloc] init];
    scanerView.layer.borderWidth = 0.5;
    scanerView.layer.borderColor = HexColor(0xcccccc).CGColor;
    
    scanerView.frame = CGRectMake((SCREEN_WIDTH-200)/2, 30,200, 200);
    NSString *code = [NSString stringWithFormat:@"BEGIN:VCARD\nVERSION:3.0\nN:%@\nORG:%@\nTITLE:%@\nNOTE:%@\nTEL:%@\nADR;TYPE=WORK:%@\nADR;TYPE=HOME:%@\nTEL;TYPE=WORK,VOICE:%@\nURL:%@\nEMAIL:%@\nEND:VCARD",TEXT(UM.userLoginInfo.employee.employee_name),TEXT(UM.userLoginInfo.company.company_name),TEXT(UM.userLoginInfo.employee.post_name),@"",TEXT(UM.userLoginInfo.employee.phone),TEXT(UM.userLoginInfo.company.address),@"",@"",TEXT(UM.userLoginInfo.company.website),TEXT(UM.userLoginInfo.employee.email)];
    
    scanerView.image = [HQHelper creatBarcodeWithString:code withImgWidth:200];
//    scanerView.image = [HQHelper createBarWithString:@"dhh-123456" withImgWidth:200];
    
    [footer addSubview:scanerView];
    self.scanerView = scanerView;
    
    UIButton *head = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanerView addSubview:head];
    head.size = CGSizeMake(30, 30);
    head.center = CGPointMake(scanerView.width/2, scanerView.height/2);
    head.userInteractionEnabled = NO;
    head.layer.borderColor = WhiteColor.CGColor;
    head.layer.borderWidth = 4;
    head.imageView.layer.cornerRadius = 3;
    head.imageView.layer.masksToBounds = YES;
    [head sd_setBackgroundImageWithURL:[HQHelper URLWithString:_personInfoModel.photograph] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image) {
            [head setTitle:@"" forState:UIControlStateNormal];
        }else{
            [head setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [head setTitle:[HQHelper nameWithTotalName:_personInfoModel.employeeName] forState:UIControlStateNormal];
            head.titleLabel.font = FONT(11);
        }
        
    }];
    
    CGFloat width = 100;
    for (NSInteger i = 0; i < 2; i ++) {
        
        HQRootButton *button = [HQRootButton rootButton];
        button.frame = CGRectMake((SCREEN_WIDTH-200)/3 * (i + 1) + i * width, CGRectGetMaxY(scanerView.frame) + 15, width, 100);
        [footer addSubview:button];
        button.tipLable.hidden = YES;
        button.scale = 0.7;
        button.wordScale = 0.3;
        button.tag = i;
        if (0 == i) {
            
            HQRootModel *model = [[HQRootModel alloc] init];
            model.name = @"自定义名片";
            model.image = @"我-自定义";
            button.rootModel = model;
        }else{
            
            HQRootModel *model = [[HQRootModel alloc] init];
            model.name = @"递名片";
            model.image = @"我-名片";
            button.rootModel = model;
        }
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    
//    UILabel *nameLab = [UILabel initCustom:CGRectMake(15, CGRectGetMaxY(scanerView.frame)+ 20, SCREEN_WIDTH-30, 20) title:@"使用微信扫一扫，添加至手机通讯录" titleColor:HexAColor(0x030303, 1) titleFont:14 bgColor:HexAColor(0xffffff, 1)];
//    [footer addSubview:nameLab];

    tableView.tableFooterView = footer;
    
}

- (void)buttonClicked:(UIButton *)button{
    
    if (button.tag == 0) {
        [self customCardShow];
    }else{
        
        
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[HQHelper imageFromView:self.cardVeiw]];
        imageView.frame = CGRectMake(30, 30, SCREEN_WIDTH-60, Long(250-60));
        [view addSubview:imageView];
        UIImageView *barcode = [[UIImageView alloc] initWithImage:[HQHelper imageFromView:self.scanerView]];
        barcode.frame = CGRectMake((SCREEN_WIDTH-100)/2, CGRectGetMaxY(imageView.frame)+30, 100, 100);
        [view addSubview:barcode];
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(barcode.frame)+30,SCREEN_WIDTH,30}];
        label.text = @"长按识别二维码，添加至手机通讯录";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = FONT(14);
        label.textColor = ExtraLightBlackTextColor;
        [view addSubview:label];
        view.height = CGRectGetMaxY(label.frame) + 30;
        
        JSHAREMessage *message = [JSHAREMessage message];
        NSData *imageData = UIImageJPEGRepresentation([HQHelper imageFromView:view], 1);
        message.mediaType = JSHAREImage;
        message.platform = JSHAREPlatformWechatSession;
        message.image = imageData;
        
        [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
            
            if (!error) {
                HQLog(@"分享图文成功");
            }else{
                HQLog(@"分享图文失败, error : %@", error);
            }
        }];
    }
    
}

- (void)customCardShow{
    
    [self.view addSubview:self.customCardView];
    self.footer.hidden = YES;
    self.tableView.scrollEnabled = NO;
    self.enablePanGesture = NO;
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.customCardView.bottom = SCREEN_HEIGHT-64-TopM-BottomM;
        
    }];
}

- (void)customCardHidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.customCardView.y = SCREEN_HEIGHT;
        
    }completion:^(BOOL finished) {
        [self.customCardView removeFromSuperview];
        
        self.footer.hidden = NO;
        self.tableView.scrollEnabled = YES;
        self.enablePanGesture = YES;
        [self setupNavi];
        
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"ewcfds";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
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

#pragma mark - TFCustomCardViewDelegate
-(void)customCardViewDidClickedAdd{
    
    
}

-(void)customCardViewDidClickedStyleIndex:(NSInteger)index{
    
    self.cardModel.choice_template = [NSString stringWithFormat:@"%ld",index];
    
    [self.cardVeiw refreshViewWithStyle:[self.cardModel.choice_template integerValue] hiddens:[self.cardModel.hide_set componentsSeparatedByString:@","]];
    
}
-(void)customCardViewDidClickedBottomIndex:(NSInteger)index models:(NSArray *)models{
    
    if (index == 0) {
        
        NSArray *arr = [HQHelper dictionaryWithJsonString:self.cancelCardModel.card_template];
        NSMutableArray *sts = [NSMutableArray array];
        for (NSDictionary *di in arr) {
            TFStyleModel *model = [[TFStyleModel alloc] initWithDictionary:di error:nil];
            if (model) {
                [sts addObject:model];
            }
        }
        [self.customCardView refreshCustomViewWithStyles:sts choice:[self.cancelCardModel.choice_template integerValue] hides:[self.cancelCardModel.hide_set componentsSeparatedByString:@","]];
        [self.cardVeiw refreshViewWithStyle:[self.cancelCardModel.choice_template integerValue] hiddens:[self.cancelCardModel.hide_set componentsSeparatedByString:@","]];
    }
    
    if (index == 1) {
        NSMutableArray *arr = [NSMutableArray array];
        for (TFStyleModel *s in models) {
            [arr addObject:[s toDictionary]];
        }
        self.cardModel.card_template = [HQHelper dictionaryToJson:arr];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:TEXT(self.cardModel.choice_template) forKey:@"choice_template"];
        [dict setObject:TEXT(self.cardModel.hide_set) forKey:@"hide_set"];
        [dict setObject:TEXT(self.cardModel.card_template) forKey:@"card_template"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.loginBL requestSaveCardStyleWithDict:dict];
    }
    
    [self customCardHidden];
}
-(void)customCardViewDidClickedHiddenIndex:(NSInteger)index hide:(NSString *)hihe{
    self.cardModel.hide_set = hihe;
    
    [self.cardVeiw refreshViewWithStyle:[self.cardModel.choice_template integerValue] hiddens:[self.cardModel.hide_set componentsSeparatedByString:@","]];
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
