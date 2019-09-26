//
//  TFOutMarkController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/4/1.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFOutMarkController.h"
#import "HQSelectTimeCell.h"
#import "KSPhotoBrowser.h"

@interface TFOutMarkController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;


@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation TFOutMarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"打卡备注";
    [self setupTableView];
    
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = WhiteColor;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *footerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,140}];
    tableView.tableFooterView = footerView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){20,20,100,100}];
    self.imageView = imageView;
    [footerView addSubview:imageView];
    imageView.layer.cornerRadius = 4;
    imageView.layer.masksToBounds = YES;
    [imageView sd_setImageWithURL:[HQHelper URLWithString:self.recordModel.photo] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image == nil) {
            imageView.hidden = YES;
        }else{
            imageView.hidden = NO;
        }
    }];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewImg)];
    [imageView addGestureRecognizer:tap];
    
}
//图片点击
- (void)previewImg{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.imageView thumbImage:self.imageView.image imageUrl:[HQHelper URLWithString:self.recordModel.photo]];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    //    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    //    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleDot;
    browser.showType = KSPhotoBrowserTypeNone;
//    browser.fileTitle = model.fileName;
    //    browser.delegate = self;
    browser.bounces = NO;
    [browser showFromViewController:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        cell.timeTitle.text = @"打卡时间";
        cell.time.text = [HQHelper nsdateToTime:[self.recordModel.real_punchcard_time longLongValue] formatStr:@"HH:mm"];
    }else if (indexPath.row == 1){
        cell.timeTitle.text = @"打卡地点";
        cell.time.text = self.recordModel.punchcard_address;
    }else{
        cell.timeTitle.text = @"打卡备注";
        cell.time.text = self.recordModel.remark;
    }
    cell.arrow.hidden = YES;
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = NO;
    cell.arrowWidth.constant = 0;
    cell.arrow.hidden = YES;
    cell.time.numberOfLines = 0;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 1){
        
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-100-30} titleStr:self.recordModel.punchcard_address];
        
        if (size.height + 30 > 60) {
            return size.height + 30;
        }else{
            return 60;
        }
        
    }else{
        
        CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-100-30} titleStr:self.recordModel.remark];
        
        if (size.height + 30 > 60) {
            return size.height + 30;
        }else{
            return 60;
        }
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
