//
//  TFSendCompanyCircleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/20.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSendCompanyCircleController.h"
#import "HQSendFriendCell.h"
#import "HQBaseNavigationController.h"
#import "ZYQAssetPickerController.h"
#import "MWPhotoBrowser.h"
#import "FDActionSheet.h"
#import "KSPhotoBrowser.h"
#import "HQSelectTimeCell.h"
#import "HQTFMorePeopleCell.h"
#import "TFLocationModel.h"
#import "TFCompanyGroupController.h"
#import "TFCompanyCircleBL.h"
#import "HQEmployModel.h"
#import "TFMapController.h"
#import "TFMutilStyleSelectPeopleController.h"

#define ImageRowCount 4  // 图片排放一行4个
#define ImageMargin 15  // 图片间隙
@interface TFSendCompanyCircleController ()<UITableViewDelegate,UITableViewDataSource,HQSendFriendCellDelegate, HQSendFriendCellDelegate  , UITextViewDelegate  , ZYQAssetPickerControllerDelegate , UINavigationControllerDelegate  , FDActionSheetDelegate , UIImagePickerControllerDelegate,KSPhotoBrowserDelegate,HQBLDelegate>

/** 创建cell的高度 */
@property (nonatomic, assign) CGFloat remarkCellHeight;
/** image宽 */
@property (nonatomic, assign) CGFloat imageWidth;
/** 输入框高度 */
@property (nonatomic, assign) CGFloat contentTextViewHeight;

/**tableView */
@property (nonatomic, weak) UITableView *tableView;
/** 图片 */
@property (nonatomic, strong) NSMutableArray *photoMutArr;
/** 人员 */
@property (nonatomic, strong) NSMutableArray *peoples;

/** 内容 */
@property (nonatomic, copy) NSString *content;
/** 地址 */
@property (nonatomic, copy) NSString *address;
/** 经度 */
@property (nonatomic, strong) NSNumber *longitude;
/** 纬度 */
@property (nonatomic, strong) NSNumber *latitude;

/** TFCompanyCircleBL */
@property (nonatomic, strong) TFCompanyCircleBL *companyCircleBL;


@end

@implementation TFSendCompanyCircleController

- (NSMutableArray *)photoMutArr{
    if (!_photoMutArr) {
        _photoMutArr = [NSMutableArray array];
    }
    return _photoMutArr;
}
- (NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消" textColor:ExtraLightBlackTextColor];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)cancel{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageWidth = (SCREEN_WIDTH - (ImageRowCount + 1) * ImageMargin) / ImageRowCount;
    self.contentTextViewHeight = 150;
    self.remarkCellHeight = self.contentTextViewHeight + self.imageWidth + 2*ImageMargin;
    [self setupTableView];
    [self setupNavi];
    self.companyCircleBL = [TFCompanyCircleBL build];
    self.companyCircleBL.delegate = self;
    
}
#pragma mark - navi
- (void)setupNavi{
    self.navigationItem.title = @"新建动态";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sendCircle) text:@"发送" textColor:GreenColor];
}
- (void)sendCircle{
    
    [self.view endEditing:YES];
    
    self.content = [self.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    if ((!self.content || [self.content isEqualToString:@""]) && self.photoMutArr.count == 0) {
        [MBProgressHUD showError:@"请输入动态内容" toView:self.view];
        return;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.photoMutArr.count) {
        [self.companyCircleBL chatFileWithImages:self.photoMutArr withVioces:@[] bean:@"circle111"];
    }else{
        
        NSMutableArray *ids = [NSMutableArray array];
        for (HQEmployModel *emp in self.peoples) {
            [ids addObject:emp.sign_id];
        }
        
        [self.companyCircleBL requestCompanyCircleAddWithContent:self.content images:@[] address:self.address longitude:self.longitude latitude:self.latitude peoples:ids];
    }
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQSendFriendCell  *cell = [HQSendFriendCell sendFriendCellWithTableView:tableView Type:NO];
        cell.delegate = self;
        cell.attendanceDescriptionType = HQSenderFriendCricleType_friendCricle;
        cell.contentTextViewHeight = self.contentTextViewHeight;
        cell.maxNum = 9;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"所在位置";
            cell.arrowShowState = YES;
            cell.time.textColor = LightBlackTextColor;
            cell.bottomLine.hidden = NO;
            cell.time.text = self.address;
            return  cell;
        }else{
            HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
            [cell refreshMorePeopleCellWithPeoples:self.peoples];
            cell.bottomLine.hidden = NO;
            cell.titleLabel.text = @"提醒谁看";
            cell.bottomLine.hidden = YES;
            
            if (self.peoples.count == 0) {
            
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                cell.contentLabel.text = @"";
                cell.contentLabel.textColor = PlacehoderColor;
            }else{
                
                cell.contentLabel.textAlignment = NSTextAlignmentRight;
                cell.contentLabel.text = [NSString stringWithFormat:@"%ld人",self.peoples.count];
                cell.contentLabel.textColor = LightBlackTextColor;
            }
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0) {
            
            TFMapController *location = [[TFMapController alloc] init];
            if (self.longitude && self.latitude) {
                
                location.location = CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
            }
            location.keyword = self.address;
            location.locationAction = ^(TFLocationModel *parameter){
                
                HQLog(@"===location===");
                self.address = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
                self.longitude = @(parameter.longitude);
                self.latitude = @(parameter.latitude);
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:location animated:YES];
        }
        
        if (indexPath.row == 1) {
            
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 1;
            scheduleVC.isSingleSelect = NO;
            scheduleVC.defaultPoeples = self.peoples;
            //            scheduleVC.noSelectPoeples = model.selects;
            scheduleVC.actionParameter = ^(NSArray *parameter) {
                
                NSString *str = @"";
                for (HQEmployModel *em in parameter) {
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[em.id description]]];
                }
                if (str.length) {
                    str = [str substringToIndex:str.length - 1];
                }
                
                [self.peoples removeAllObjects];
                [self.peoples addObjectsFromArray:parameter];
                [self.tableView reloadData];
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            

//            TFCompanyGroupController *depart = [[TFCompanyGroupController alloc] init];
//            depart.type = 2;
//            depart.isSingle = NO;
//            depart.actionParameter = ^(NSArray *peoples){
//                
//                [self.peoples removeAllObjects];
//                [self.peoples addObjectsFromArray:peoples];
//                [self.tableView reloadData];
//            };
//            
//            [self.navigationController pushViewController:depart animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        return 55;
    }

    return _remarkCellHeight;;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 8;
    }
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

#pragma mark - goOutOneCell Delegate
- (void)didAddPhotoAction{
    
    HQSendFriendCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.contentTextView resignFirstResponder];
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照上传",@"手机相册", nil];
    [sheet show];
    
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self openCamera];
    }
    if (buttonIndex == 1) {
        [self openAlbum];
    }
}

/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    [self.photoMutArr addObjectsFromArray:arr];
   
   
   if (self.photoMutArr.count > 7) {// 3行
       self.remarkCellHeight = self.contentTextViewHeight +  3 *(self.imageWidth + ImageMargin) + ImageMargin;
   } else if(self.photoMutArr.count > 3){// 2行
       self.remarkCellHeight = self.contentTextViewHeight +  2 *(self.imageWidth + ImageMargin) + ImageMargin;
   }else{// 1行
       self.remarkCellHeight = self.contentTextViewHeight +  1 *(self.imageWidth + ImageMargin) + ImageMargin;
   }
   
   HQSendFriendCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
   
   [cell freshPhotoWithArr:self.photoMutArr urlArr:nil];
   [self.tableView reloadData];
}
#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 9 - self.photoMutArr.count ; // 选择图片最大数量;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 9 - self.photoMutArr.count ; // 选择图片最大数量
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 8;
        } else {
            return YES;
        }
    }];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.photoMutArr addObject:image];
    
    HQSendFriendCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell freshPhotoWithArr:self.photoMutArr urlArr:nil];
    
    if (self.photoMutArr.count > 7) {// 3行
        self.remarkCellHeight = self.contentTextViewHeight +  3 *(self.imageWidth + ImageMargin) + ImageMargin;
    } else if(self.photoMutArr.count > 3){// 2行
        self.remarkCellHeight = self.contentTextViewHeight +  2 *(self.imageWidth + ImageMargin) + ImageMargin;
    }else{// 1行
        self.remarkCellHeight = self.contentTextViewHeight +  1 *(self.imageWidth + ImageMargin) + ImageMargin;
    }
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)didDeletePhotoActionWithIndex:(NSInteger)index{
    HQSendFriendCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_photoMutArr removeObjectAtIndex:index];
    [cell freshPhotoWithArr:_photoMutArr urlArr:nil];
    
    if (self.photoMutArr.count > 7) {// 3行
        self.remarkCellHeight = self.contentTextViewHeight +  3 *(self.imageWidth + ImageMargin) + ImageMargin;
    } else if(self.photoMutArr.count > 3){// 2行
        self.remarkCellHeight = self.contentTextViewHeight +  2 *(self.imageWidth + ImageMargin) + ImageMargin;
    }else{// 1行
        self.remarkCellHeight = self.contentTextViewHeight +  1 *(self.imageWidth + ImageMargin) + ImageMargin;
    }
    [self.tableView reloadData];
}

-(void)textChangeWithStr:(NSString *)textStr{
    
    self.content = textStr;
}
- (void)didLookAtPhotoActionWithIndex:(NSInteger)index imageViews:(NSArray *)imageViews{
    NSMutableArray *items = @[].mutableCopy;
    for (int i = 0; i < imageViews.count; i++) {
        UIImageView *imageView = imageViews[i];
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        [items addObject:item];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:index];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];

}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    HQLog(@"selected index: %ld", index);
}


//- (void)didLookAtPhotoActionWithIndex:(NSInteger)index imageViews:(NSArray *)imageViews{
//    
//    // 浏览图片
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = NO; // 分享按钮,默认是
//    browser.alwaysShowControls = NO ; // 控制条件控件 是否显示,默认否
//    browser.zoomPhotosToFill = YES; // 是否全屏,默认是
//    browser.enableSwipeToDismiss = NO;
//    [browser showNextPhotoAnimated:NO];
//    [browser showPreviousPhotoAnimated:NO];
//    [browser setCurrentPhotoIndex:index];
//    browser.displayNavArrows = NO;
//    browser.displaySelectionButtons = NO;
//    browser.enableGrid = NO;
//    browser.startOnGrid = NO;
//    browser.autoPlayOnAppear = NO;
//    [self.navigationController pushViewController:browser animated:YES] ;
//}
//#pragma mark - 图片浏览器
//
///**
// * 标题
// */
//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
//    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.photoMutArr.count] ;
//}
//
///**
// * 图片总数量
// */
//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
//    return self.photoMutArr.count;
//}
//
///**
// * 图片设置
// */
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
//    
//    MWPhoto *mwPhoto = [MWPhoto photoWithImage:self.photoMutArr[index]];
//    
//    return mwPhoto;
//    
//}


#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        [self.photoMutArr addObject:tempImg];
    }
    
    if (self.photoMutArr.count > 7) {// 3行
        self.remarkCellHeight = self.contentTextViewHeight +  3 *(self.imageWidth + ImageMargin) + ImageMargin;
    } else if(self.photoMutArr.count > 3){// 2行
        self.remarkCellHeight = self.contentTextViewHeight +  2 *(self.imageWidth + ImageMargin) + ImageMargin;
    }else{// 1行
        self.remarkCellHeight = self.contentTextViewHeight +  1 *(self.imageWidth + ImageMargin) + ImageMargin;
    }
    
    HQSendFriendCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell freshPhotoWithArr:self.photoMutArr urlArr:nil];
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_ChatFile) {
        
        NSArray *files = resp.body;
        
        NSMutableArray *dicts = [NSMutableArray array];
        for (TFFileModel *model in files) {
            
            [dicts addObject:[model toDictionary]];
        }
        NSMutableArray *ids = [NSMutableArray array];
        for (HQEmployModel *emp in self.peoples) {
            [ids addObject:emp.sign_id];
        }
        
        [self.companyCircleBL requestCompanyCircleAddWithContent:TEXT(self.content) images:dicts address:self.address longitude:self.longitude latitude:self.latitude peoples:ids];
    }
    if (resp.cmdId == HQCMD_companyCircleAdd) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
    self.navigationItem.rightBarButtonItem.enabled = YES;
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
