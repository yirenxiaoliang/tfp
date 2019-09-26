//
//  TFFinishInfoController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/10/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFinishInfoController.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "FDActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "TFLoginBL.h"
#import "MLImageCrop.h"

@interface TFFinishInfoController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,FDActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HQBLDelegate,MLImageCropDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** name */
@property (nonatomic, copy) NSString *companyName;
/** name */
@property (nonatomic, copy) NSString *employeeName;
/** name */
@property (nonatomic, copy) NSString *password;


/** 头像地址 */
@property (nonatomic, strong) UIImage *companyImage;
/** 头像地址 */
@property (nonatomic, copy) NSString *companyPhotograph;
/** 头像地址 */
@property (nonatomic, strong) UIImage *employeeImage;
/** 头像地址 */
@property (nonatomic, copy) NSString *employeePhotograph;

/** index */
@property (nonatomic, assign) NSInteger index;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

/** btn */
@property (nonatomic, weak) UIButton *chatBtn;
/** btn */
@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation TFFinishInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupFooter];
    [self setupNavigation];
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
}

#pragma mark - navigation
- (void)setupNavigation{
    
    if (self.type == FinishInfoType_company) {
        
        self.navigationItem.title = @"完善信息";
    }else{
        
        self.navigationItem.title = @"完善信息";
    }
}

#pragma mark - tableViewFooter
- (void)setupFooter{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,180}];
    
    for (NSInteger i = 0; i<2; i++) {
        
        UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,30 + (50 + 20)*i,SCREEN_WIDTH-50,50} target:self action:@selector(buttonClick:)];
        [view addSubview:button];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        button.titleLabel.font = FONT(20);
        button.tag = 0x2345 + i;
        
        if (i == 0) {
            [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateHighlighted];
            [button setTitle:@"通过" forState:UIControlStateNormal];
            [button setTitle:@"通过" forState:UIControlStateHighlighted];
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
//            [button setImage:[UIImage imageNamed:@"聊天24"] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"聊天24"] forState:UIControlStateHighlighted];
            self.chatBtn = button;
            
        }else{
            
            [button setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xe7e7e7, 1)] forState:UIControlStateNormal];
            [button setBackgroundImage:[HQHelper createImageWithColor:HexAColor(0xe7e7e7, 1)] forState:UIControlStateHighlighted];
            [button setTitle:@"跳过" forState:UIControlStateNormal];
            [button setTitle:@"跳过" forState:UIControlStateHighlighted];
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            [button setTitleColor:WhiteColor forState:UIControlStateHighlighted];
//            [button setImage:[UIImage imageNamed:@"删除24"] forState:UIControlStateNormal];
//            [button setImage:[UIImage imageNamed:@"删除24"] forState:UIControlStateHighlighted];
            self.deleteBtn =  button;
        }
    }
    
    if (self.type == FinishInfoType_company) {
        
        [self refreshFooterWithType:0];
        self.deleteBtn.hidden = YES;
        
    }else{
        
        [self refreshFooterWithType:1];
    }
    
    self.tableView.tableFooterView = view;
    
}


- (void)refreshFooterWithType:(NSInteger)type{
    
    switch (type) {
        case 0:
        {
            self.chatBtn.frame = (CGRect){25,30 + (50 + 20)*0,SCREEN_WIDTH-50,50};
            self.deleteBtn.frame = (CGRect){25,30 + (50 + 20)*1,SCREEN_WIDTH-50,50};
        }
            break;
        case 1:
        {
            
            self.chatBtn.frame = (CGRect){25 + ((SCREEN_WIDTH-75)/2 + 25) * 0,30 + (50 + 20)*0,(SCREEN_WIDTH-75)/2,50};
            self.deleteBtn.frame = (CGRect){25 + ((SCREEN_WIDTH-75)/2 + 25) * 1,30 + (50 + 20)*0,(SCREEN_WIDTH-75)/2,50};
        }
            break;
            
        default:
            break;
    }
    
}



- (void)buttonClick:(UIButton *)button{
    
    [self.view endEditing:YES];
    
    if (self.type == FinishInfoType_company) {// 公司信息
        
        if (!self.companyName || [self.companyName isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入企业名称" toView:self.view];
            return;
        }
        
        if (!self.employeeName || [self.employeeName isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入真实姓名" toView:self.view];
            return;
        }
        
        
        NSDictionary *dict = @{
                               @"user_name":TEXT(self.employeeName),
                               @"company_name":TEXT(self.companyName),
                               @"logo":TEXT(self.companyPhotograph),
                               @"picture":TEXT(self.employeePhotograph)
                               };
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.loginBL requestSetupCompanyInfoWithDict:dict];
        
    }else{
        
        if (button.tag == 0x2345) {// 通过
            
            if (!self.password || [self.password isEqualToString:@""]) {
                [MBProgressHUD showError:@"请输入新密码" toView:self.view];
                return;
            }
            
            NSDictionary *dict = @{
                                   @"login_pwd":TEXT([HQHelper stringForMD5WithString:self.password]),
                                   @"picture":TEXT(self.employeePhotograph)
                                   };
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.loginBL requestSetupEmployeeInfoWithDict:dict];
            
        }else{// 跳过
            
            NSDictionary *dict = @{
                                   @"login_pwd":@"",
                                   @"picture":@""
                                   };
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.loginBL requestSetupEmployeeInfoWithDict:dict];
            
        }
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.type == FinishInfoType_company) {
        return 4;
    }else{
        return 2;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == FinishInfoType_company) {
        if (indexPath.row == 0) {
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"企业名称";
            cell.textField.placeholder = @"请输入企业名称";
            cell.textField.text = self.companyName;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
//            cell.requireLabel.hidden = NO;
            cell.textField.tag = 0x111;
            return cell;
            
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            UIView *view = [cell.contentView viewWithTag:0x123];
            [view removeFromSuperview];
            
            UIImageView *image = [[UIImageView alloc] init];
            [cell.contentView addSubview:image];
            image.tag = 0x123;
            image.frame = CGRectMake(101, 0, 40, 40);
            image.centerY = 55/2;
            if (!self.companyImage) {
                cell.time.text = @"请添加";
            }else{
                cell.time.text = @"";
            }
            image.image = self.companyImage;
            cell.time.textColor = PlacehoderColor;
            cell.timeTitle.text = @"公司logo";
            cell.bottomLine.hidden = NO;
            return cell;
            
            
        }else if (indexPath.row == 2) {
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"姓名";
            cell.textField.placeholder = @"请输入真实姓名";
            cell.textField.text = self.employeeName;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
            cell.requireLabel.hidden = NO;
            cell.textField.tag = 0x222;
            return cell;
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            UIView *view = [cell.contentView viewWithTag:0x456];
            [view removeFromSuperview];
            
            UIImageView *image = [[UIImageView alloc] init];
            [cell.contentView addSubview:image];
            image.tag = 0x456;
            image.frame = CGRectMake(101, 0, 40, 40);
            image.centerY = 55/2;
            if (!self.employeeImage) {
                cell.time.text = @"请添加";
            }else{
                cell.time.text = @"";
            }
            image.image = self.employeeImage;
            cell.time.textColor = PlacehoderColor;
            cell.timeTitle.text = @"头像";
            return cell;
            
        }

    }else{
        if (indexPath.row == 0) {
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"新密码";
            cell.textField.placeholder = @"请修改随机密码";
            cell.textField.text = self.password;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
            cell.requireLabel.hidden = NO;
            cell.textField.tag = 0x333;
            return cell;
            
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            UIView *view = [cell.contentView viewWithTag:0x789];
            [view removeFromSuperview];
            
            UIImageView *image = [[UIImageView alloc] init];
            [cell.contentView addSubview:image];
            image.tag = 0x789;
            image.frame = CGRectMake(101, 0, 40, 40);
            image.centerY = 55/2;
            if (!self.employeeImage) {
                cell.time.text = @"请添加";
            }else{
                cell.time.text = @"";
            }
            image.image = self.employeeImage;
            cell.time.textColor = PlacehoderColor;
            cell.timeTitle.text = @"头像";
            return cell;
            
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == FinishInfoType_company) {
        
        if (indexPath.row == 1) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"公司logo" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
            sheet.tag = 0x111;
            self.index = 0x111;
            [sheet show];
        }
        if (indexPath.row == 3) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
            sheet.tag = 0x222;
            self.index = 0x222;
            [sheet show];
        }
        
    }else{
        
        if (indexPath.row == 1) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
            sheet.tag = 0x222;
            self.index = 0x222;
            [sheet show];
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 55;
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

#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    if (textField.tag == 0x111) {
        
        self.companyName = textField.text;
    }
    if (textField.tag == 0x222) {
        
        self.employeeName = textField.text;
    }
    if (textField.tag == 0x333) {
        
        self.password = textField.text;
    }
}


#pragma mark - sheet
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openAlbum];
        }
            break;
            
        default:
            break;
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
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        //        self.image = tempImg;
        
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        imageCrop.ratioOfWidthAndHeight = 800.0f/800.0f;
        imageCrop.image = tempImg;
        [imageCrop showWithAnimation:YES];
        
    }
    
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    if (self.index == 0x111) {
        self.companyImage = cropImage;
    }
    if (self.index == 0x222) {
        self.employeeImage = cropImage;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginBL imageFileWithImages:@[cropImage] withVioces:@[]];
    [self.tableView reloadData];
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (self.index == 0x111) {
        self.companyImage = image;
    }
    if (self.index == 0x222) {
        self.employeeImage = image;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.loginBL imageFileWithImages:@[image] withVioces:@[]];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_ImageFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSArray *arr = resp.body;
        
        if (arr.count) {
            
            TFFileModel *model = arr[0];
            
            if (self.index == 0x111) {
                
                self.companyPhotograph = model.file_url;
                
            }
            
            if (self.index == 0x222) {
                
                self.employeePhotograph = model.file_url;
            }
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_setupCompanyInfo) {
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        
    }
    
    if (resp.cmdId == HQCMD_setupEmployeeInfo) {
        
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
        
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
    }
    
    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:@1];
        
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
