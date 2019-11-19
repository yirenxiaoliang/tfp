//
//  TFMutilFileUploadController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/28.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMutilFileUploadController.h"
#import "HQTFTwoLineCell.h"
#import "ZYQAssetPickerController.h"
#import "TFCustomBL.h"

@interface TFMutilFileUploadController ()<UITableViewDelegate,UITableViewDataSource,HQTFTwoLineCellDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** files */
@property (nonatomic, strong) NSMutableArray *files;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


@end

@implementation TFMutilFileUploadController

-(NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
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
    tableView.scrollEnabled = YES;
    tableView.tableFooterView = [self footerView];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.top.equalTo(@30);
        make.right.equalTo(@0);
        make.bottom.equalTo(@(-1));
        
    }];
    
}

- (UIView *)footerView{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,62}];
    view.backgroundColor = ClearColor;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [view addSubview:button];
    button.frame = CGRectMake(20, 16, 30, 30);
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitle:@"+" forState:UIControlStateHighlighted];
    [button setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[HQHelper createImageWithColor:BackGroudColor] forState:UIControlStateHighlighted];
    button.titleLabel.font = FONT(22);
    [button setTitleColor:GrayTextColor forState:UIControlStateNormal];
    [button setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
    
    button.layer.cornerRadius = 15;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(addClicked:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}

- (void)addClicked:(UIButton *)button{
    
 
    [self openAlbum];
}

#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    
    //图片数量
    picker.maximumNumberOfSelection = 9; // 选择图片最大数量
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        TFFileModel *file = self.files.lastObject;
        
        
        TFFileModel *model = [[TFFileModel alloc] init];
        model.file_name = fileName;
        model.file_type = @"jpg";
        model.image = tempImg;
        model.progress = @0;
        if (file) {
            model.cmdId = @([file.cmdId integerValue] + 1);
        }else{
            model.cmdId = @(MutilFileStart+i);
        }
        [self.files addObject:model];
        
        [self.tableView reloadData];
        
        [self.customBL uploadMutilFileWithImages:@[model] cmdId:[model.cmdId integerValue] bean:@"nulti111"];
    }
    
}

#pragma mark - 网络请求代理

/**
 *  业务进度回调方法
 *
 *  @param blEntiy   业务对象
 *  @param result    返回数据
 */
- (void)progressHandle:(HQBaseBL *)blEntity response:(HQResponseEntity*)resp{
    
    HQLog(@"%ld====%@====%f",(NSInteger)resp.cmdId,resp.progress,resp.progress.fractionCompleted);
    
    for (TFFileModel *model in self.files) {
        
        if ([model.cmdId integerValue] == resp.cmdId) {
            
            model.progress = @(resp.progress.fractionCompleted);
            
            break;
        }
        
    }
    
    [self.tableView reloadData];
}


-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.files.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.type = TwoLineCellTypeOne;
    [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    cell.delegate = self;
    cell.enterImage.tag = 0x333 + indexPath.row;
    [cell refreshCellWithFileModel:self.files[indexPath.row]];
    cell.enterImage.hidden = NO;
    cell.enterImgTrailW.constant = 0;
    
    cell.enterImage.hidden = NO;
   
    if (indexPath.row == self.files.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
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

#pragma mark - HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    NSInteger index = enterBtn.tag - 0x333;
    
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
