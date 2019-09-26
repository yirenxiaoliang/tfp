//
//  TFVersionViewController.m
//  HuiJuHuaQi
//
//  Created by Mac mini on 2019/7/17.
//  Copyright © 2019 com.huijuhuaqi.com. All rights reserved.
//

#import "TFVersionViewController.h"
#import "TFRequest.h"
#import "NSDate+NSString.h"
#import "WYWebController.h"
#import "HQSelectTimeCell.h"

@interface TFVersionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TFVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"关于Teamface";
    [self setupViews];
}

/** 初始化控件 */
- (void)setupViews{
 
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,68,68}];
    imageView.image = IMG(@"logo_60");
    [self.view addSubview:imageView];
    imageView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 60 - 68 - 80);
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 14;
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(imageView.frame) + 5,SCREEN_WIDTH,50}];
    [self.view addSubview:versionLabel];
    versionLabel.font = FONT(14);
    versionLabel.textColor = ExtraLightBlackTextColor;
    versionLabel.numberOfLines = 0;
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    versionLabel.text = [NSString stringWithFormat:@"Teamface\n %@",currentVersion];
    
    NSString *teamface = @"Teamface";
    NSMutableAttributedString *teamStr = [[NSMutableAttributedString alloc] initWithString:versionLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 10;
    [teamStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:(NSRange){0,versionLabel.text.length}];
    [teamStr addAttribute:NSForegroundColorAttributeName value:ExtraLightBlackTextColor range:(NSRange){0,versionLabel.text.length}];
    [teamStr addAttribute:NSFontAttributeName value:FONT(16) range:(NSRange){0,teamface.length}];
    [teamStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[teamface rangeOfString:teamface]];
    versionLabel.attributedText = teamStr;
    versionLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(versionLabel.frame) + 50, SCREEN_WIDTH-105, 120) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    tableView.scrollEnabled = NO;
    self.tableView = tableView;
    
    
    // 服务条款
    UILabel *serviceLabel = [[UILabel alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-NaviHeight-BottomM-100,SCREEN_WIDTH,40}];
    [self.view addSubview:serviceLabel];
    serviceLabel.textAlignment = NSTextAlignmentCenter;
    serviceLabel.userInteractionEnabled = YES;
    NSString *ss = @"《服务条款和隐私政策》";
    NSMutableAttributedString *serStr = [[NSMutableAttributedString alloc] initWithString:ss];
    [serStr addAttribute:NSForegroundColorAttributeName value:BlackTextColor range:(NSRange){0,ss.length}];
    [serStr addAttribute:NSFontAttributeName value:FONT(12) range:(NSRange){0,ss.length}];
    [serStr addAttribute:NSForegroundColorAttributeName value:GreenColor range:[ss rangeOfString:ss]];
    
    serviceLabel.attributedText = serStr;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agreeservice)];
    
    [serviceLabel addGestureRecognizer:tap];
    
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(serviceLabel.frame),SCREEN_WIDTH,20}];
    [self.view addSubview:rightLabel];
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.font = FONT(12);
    rightLabel.textColor = ExtraLightBlackTextColor;
    rightLabel.text = @"版权归 Teamface企典 所有";
    
    UILabel *rightLabel1 = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(rightLabel.frame),SCREEN_WIDTH,20}];
    [self.view addSubview:rightLabel1];
    rightLabel1.textAlignment = NSTextAlignmentCenter;
    rightLabel1.font = FONT(10);
    rightLabel1.textColor = ExtraLightBlackTextColor;
    
    rightLabel1.text = [NSString stringWithFormat:@"Copyright © 2014-%@ Teamface. All rights reserved.",[NSDate date].getyear];
    
    
    
//    // 从网络获取AppStore版本号
//    __block NSError *jsonError;
//    // STOREAPPID是你在AppStore对应自己App的ID 可在AppStore上找到 也可在iTunesConnect上找到
//    NSURLSession *session = [NSURLSession sharedSession];
//    [session dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/lookup?id=%@",STORE_APPID]]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//
//        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
//        if (jsonError) {
//            HQLog(@"UpdateAppError:%@",jsonError);
//            return;
//        }
//
//        NSArray *array = appInfoDic[@"results"];
//        if (array.count < 1) {
//            HQLog(@"此APPID为未上架的APP或者查询不到");
//            return;
//        }
//
//        NSDictionary *dic = array[0];
//        NSString *appStoreVersion = dic[@"version"];
//        //打印版本号
//        HQLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
//
//        // 当前版本号小于商店版本号,就更新
//        if([currentVersion floatValue] < [appStoreVersion floatValue]) {
//            UIAlertController *alercConteoller = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dic[@"version"]] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *actionYes = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //用户去更新，一种实现方式如下
//                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", STORE_APPID]];
//
//                [[UIApplication sharedApplication] openURL:url];
//            }];
//            UIAlertAction *actionNo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alercConteoller addAction:actionYes];
//            [alercConteoller addAction:actionNo];
//            [self presentViewController:alercConteoller animated:YES completion:nil];
//        }else{
//            HQLog(@"版本号比商店大 检测到不需要更新");
//        }
//    }];
    
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", STORE_APPID]];
//
//        [[UIApplication sharedApplication] openURL:url];
//    });
    
//    UIButton *update = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:update];
//    update.frame = CGRectMake(60, CGRectGetMaxY(versionLabel.frame) + 50, SCREEN_WIDTH-120, 40);
//    update.layer.cornerRadius = 4;
//    update.layer.masksToBounds = YES;
//    update.backgroundColor = GreenColor;
//    [update setTitle:@"版本更新" forState:UIControlStateNormal];
//    [update addTarget:self action:@selector(updateClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 初始化tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.font = FONT(16);
        cell.timeTitle.text = @"去评分";
        cell.timeTitle.textColor = BlackTextColor;
        cell.headMargin = 15;
        cell.topLine.hidden = NO;
        cell.bottomLine.hidden = NO;
        cell.trailW.constant = 0;
        return cell;
        
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.font = FONT(16);
        cell.timeTitle.text = @"版本更新";
        cell.timeTitle.textColor = BlackTextColor;
        cell.headMargin = 15;
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = NO;
        cell.trailW.constant = 0;
        return cell;
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [self updateClicked];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
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



- (void)agreeservice {
    
    WYWebController *webVC = [WYWebController new];
    webVC.url = @"https://app.teamface.cn/#/termsService";
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)updateClicked{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", STORE_APPID]];

    [[UIApplication sharedApplication] openURL:url];
    
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
