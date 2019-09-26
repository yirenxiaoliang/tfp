//
//  TFWebLinkListController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/11/29.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFWebLinkListController.h"
#import "TFWebLinkCell.h"
#import "TFCustomBL.h"
#import "TFWebLinkModel.h"
#import "JSHAREService.h"
#import "TFBarcodeShareView.h"

@interface TFWebLinkListController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,TFWebLinkCellDelegate,TFBarcodeShareViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, strong) NSMutableArray *links;

/** index */
@property (nonatomic, assign) NSInteger index;


@end

@implementation TFWebLinkListController

-(NSMutableArray *)links{
    if (!_links) {
        _links = [NSMutableArray array];
    }
    return _links;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    [self.customBL requestWebLinkListWithModuleBean:self.moduleBean source:self.source seasPoolId:self.seasPoolId relevanceModule:self.relevanceModule relevanceField:self.relevanceField relevanceValue:self.relevanceValue];
    
    [self setupTableView];
    self.navigationItem.title = @"Web表单链接";
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getWebLinkList) {
        
        for (NSDictionary *dict in resp.body) {
            TFWebLinkModel *model = [[TFWebLinkModel alloc] initWithDictionary:dict error:nil];
            if (model) {
                [self.links addObject:model];
            }
        }
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.links.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TFWebLinkCell *cell = [TFWebLinkCell webLinkCelllWithTableView:tableView];
    cell.delegate = self;
    cell.tag = indexPath.row;
    [cell refreshWebLinkCellWithModel:self.links[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [TFWebLinkCell refreshWebLinkCellHeightWithModel:self.links[indexPath.row]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
    
}

#pragma mark - delegate
-(void)webLinkCell:(TFWebLinkCell *)cell didClickedBarcode:(NSString *)barcode signInBarcode:(NSString *)signInBarcode{
    
    self.index = cell.tag;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
    view.backgroundColor = WhiteColor;
    view.tag = 0x2222;
    [KeyWindow addSubview:view];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){30,0,SCREEN_WIDTH-60,SCREEN_HEIGHT}];
//    [view addSubview:imageView];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.backgroundColor = WhiteColor;
//
//    imageView.image = [HQHelper creatBarcodeWithString:barcode withImgWidth:SCREEN_WIDTH-100];
//
//    imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
//    [imageView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
    [view addGestureRecognizer:tap1];

    view.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        view.alpha = 1;
    }];
//
//    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
//    share.frame = CGRectMake(0, 0, 200, 100);
//    share.centerX = SCREEN_WIDTH/2;
//    share.bottom = SCREEN_HEIGHT - BottomM;
//    [share setImage:IMG(@"分享") forState:UIControlStateNormal];
//    [share setImage:IMG(@"分享") forState:UIControlStateHighlighted];
//    [share setTitle:@" 分享至微信" forState:UIControlStateNormal];
//    [share setTitle:@" 分享至微信" forState:UIControlStateHighlighted];
//    [share setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
//    [share setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
//    [share addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:share];
    CGFloat height = SCREEN_HEIGHT;
    if (!IsStrEmpty(signInBarcode)) {
        height = SCREEN_HEIGHT/2;
    }
    TFBarcodeShareView *barcodeView = [[TFBarcodeShareView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
    [view addSubview:barcodeView];
    barcodeView.title = @"表单二维码";
    barcodeView.barcode = barcode;
    barcodeView.delegate = self;
    
    if (!IsStrEmpty(signInBarcode)) {
        
        TFBarcodeShareView *signInView = [[TFBarcodeShareView alloc] initWithFrame:CGRectMake(0, height, SCREEN_WIDTH, height)];
        [view addSubview:signInView];
        signInView.title = @"签到二维码";
        signInView.barcode = signInBarcode;
        signInView.delegate = self;
        
        UIView *line = [[UIView alloc] initWithFrame:(CGRect){60,signInView.top,SCREEN_WIDTH-120,0.5}];
        line.backgroundColor = CellSeparatorColor;
        [view addSubview:line];
    }
    
}

-(void)webLinkCellChangeHeight{
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)barcodeClicked:(UIGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.25 animations:^{
        [KeyWindow viewWithTag:0x2222].alpha = 0;
    } completion:^(BOOL finished) {
        [[KeyWindow viewWithTag:0x2222] removeFromSuperview];
    }];
}
#pragma mark - TFBarcodeShareViewDelegate
-(void)barcodeShareViewShareWithBarcode:(NSString *)barcode{
    [self shareWithBarcode:barcode];
}

- (void)shareWithBarcode:(NSString *)barcode{
    
    TFWebLinkModel *model = self.links[self.index];
    JSHAREMessage *message = [JSHAREMessage message];
    NSData *imageData = UIImageJPEGRepresentation(IMG(@"applogo"), 1);
    message.mediaType = JSHARELink;
    message.platform = JSHAREPlatformWechatSession;
    message.image = imageData;
    message.title = model.shareTitle;
    message.text = model.shareDescription;
    message.url = barcode;
    
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        
        if (!error) {
            HQLog(@"分享图文成功");
        }else{
            HQLog(@"分享图文失败, error : %@", error);
        }
    }];
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
