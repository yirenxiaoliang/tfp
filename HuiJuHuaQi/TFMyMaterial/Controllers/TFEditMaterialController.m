//
//  TFEditMaterialController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEditMaterialController.h"
#import "ZYQAssetPickerController.h"

#import "TFSetPhotoCell.h"
#import "HQSelectTimeCell.h"

#import "FDActionSheet.h"

@interface TFEditMaterialController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TFEditMaterialController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人资料";
    
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
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 4;
    }
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFSetPhotoCell *cell = [TFSetPhotoCell SetPhotoCellWithTableView:tableView];
            
            [cell.photoImg sd_setImageWithURL:[HQHelper URLWithString:@""] placeholderImage:PlaceholderHeadImage];
            
            return cell;
        }
        
        else {
        
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            cell.timeTitle.text = @"生日";
            cell.time.text = @"2018";
            
            return cell;
        }
    }
    else {
    
        NSArray *titleArr = @[@"手机",@"座机",@"邮箱"];
        NSArray *contentArr = @[@"15974267842",@"0755-86698189",@"huijuhuaqi@teamface.cn"];
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.requireLabel.hidden = YES;
        cell.timeTitle.text = titleArr[indexPath.row];
        cell.time.text = contentArr[indexPath.row];
        
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"修改头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"照片",@"拍照", nil];
            
            sheet.tag = 101;
            [sheet show];
        }
        else if (indexPath.row == 1) {
        
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            
            sheet.tag = 102;
            [sheet show];
        }
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section ==0) {
        
        return 15;
    }
    return 8;
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

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (sheet.tag == 101) {
        
        if (buttonIndex == 0) {
            
            [self openAlbum];
        }
        else {
            
            [self openCamera];
        }
    }
    else {
    
        
    }
    
}

#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
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
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        // 选择照片上传
    }
    
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 拍照上传
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
