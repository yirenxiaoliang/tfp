//
//  TFFinishPersonDataController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/25.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFFinishPersonDataController.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "FDActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "HQAddressView.h"
#import "HQIndustryView.h"
#import "TFEnterModelController.h"
#import "TFLoginBL.h"
#import "MLImageCrop.h"

@interface TFFinishPersonDataController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,FDActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,HQBLDelegate,MLImageCropDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** addressView */
@property (nonatomic, strong) HQAddressView *addressView;
/** industryView */
@property (nonatomic, strong) HQIndustryView *industryView;

/** name */
@property (nonatomic, copy) NSString *name;
/** gender */
@property (nonatomic, strong) NSNumber *gender;
/** image */
@property (nonatomic, strong) UIImage *image;
/** 头像地址 */
@property (nonatomic, copy) NSString *photograph;

/** name */
@property (nonatomic, copy) NSString *companyName;
/** name */
@property (nonatomic, copy) NSString *telephone;
/** name */
@property (nonatomic, copy) NSString *address;
/** name */
@property (nonatomic, copy) NSString *addressId;
/** name */
@property (nonatomic, copy) NSString *industry;
/** name */
@property (nonatomic, copy) NSString *industryId;

/** HQRegisterBL */
@property (nonatomic, strong) TFLoginBL *loginBL;

@end

@implementation TFFinishPersonDataController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.navigationItem.title = @"完善资料";
    [self setupHeader];
    [self setupFooter];
    [self setupAddressAndIndustry];
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)setupHeader{
    
    UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(180)}];
    
    UILabel *company = [[UILabel alloc] initWithFrame:(CGRect){20,Long(25),SCREEN_WIDTH-40,Long(41)}];
    [header addSubview:company];
    company.textColor = BlackTextColor;
    company.textAlignment = NSTextAlignmentLeft;
    
    UILabel *welcome = [[UILabel alloc] initWithFrame:(CGRect){0,CGRectGetMaxY(company.frame)+ Long(25) ,SCREEN_WIDTH,Long(20)}];
    [header addSubview:welcome];
    welcome.textColor = GreenColor;
    welcome.textAlignment = NSTextAlignmentCenter;
    welcome.font = FONT(20);
    
    if (self.type == FinishDataType_joinCompany) {
        
        company.text = @"深圳汇聚华企科技有限公司";
        welcome.text = @"欢迎您的加入！";
        company.font = FONT(24);
    }else{
        
        company.text = @"TeamFace";
        welcome.text = @"欢迎您的使用！";
        company.font = FONT(40);
    }
    
    
    self.tableView.tableHeaderView = header;
}

- (void)setupFooter{
    
    UIView *footer = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,Long(180)}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,Long(130),SCREEN_WIDTH-50,Long(50)} target:self action:@selector(finished)];
    [footer addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    button.backgroundColor = GreenColor;
    button.titleLabel.font = FONT(20);
    
    if (self.type == FinishDataType_company) {
        button.frame = (CGRect){25,Long(80),SCREEN_WIDTH-50,Long(50)};
    }
    
    if (self.type == FinishDataType_joinCompany) {
        
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateHighlighted];
        
    }else if (self.type == FinishDataType_person){
        
        [button setTitle:@"下一步" forState:UIControlStateNormal];
        [button setTitle:@"下一步" forState:UIControlStateHighlighted];
        
    }else{
        
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitle:@"完成" forState:UIControlStateHighlighted];
    }
    
    self.tableView.tableFooterView = footer;
}

- (void)finished{
    
    [self.view endEditing:YES];
    if (self.type == FinishDataType_joinCompany) {
        
        
        
        
    }else if (self.type == FinishDataType_person){
        
        if (!self.name || [self.name isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入姓名" toView:KeyWindow];
            return;
        }
        
//
//        
//        if (self.image) {
//            // 有头像先传头像
//            
//            [self.registerBL uploadFileWithImages:@[self.image] withVioces:nil withModule:6];
//            
//        }else{
//            
//            [self.registerBL initUserDataWithUserId:self.user.id userName:self.name gender:self.gender photograph:self.photograph inviteCompanyId:nil];
//        }
        
        
        NSDictionary *dict = @{
                               @"userId":TEXT(self.userId),
                               @"companyId":TEXT(self.companyId),
                               @"user_name":TEXT(self.name)
                               };
        
        
        [self.loginBL requestSetupEmployeeInfoWithDict:dict];
        
    }else if (self.type == FinishDataType_company){
        
        if (!self.companyName || [self.companyName isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入公司名" toView:KeyWindow];
            return;
        }
        
        if (!self.telephone || [self.telephone isEqualToString:@""]) {
            [MBProgressHUD showError:@"请输入电话" toView:KeyWindow];
            return;
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.registerBL addOrFinishCompanyInfoWithCompanyName:self.companyName companyTel:self.telephone region:self.addressId industryCode:self.industryId isDefault:@1 code:nil passWord:nil];
        
        NSDictionary *dict = @{
                               @"userId":TEXT(self.userId),
                               @"company_name":TEXT(self.companyName),
                               @"address":TEXT(self.addressId),
                               @"industry":TEXT(self.industryId),
                               @"phone":TEXT(self.telephone)
                               };
        
        
        [self.loginBL requestSetupCompanyInfoWithDict:dict];
        
    }else{// 邀请码设置员工信息
//        if (self.image) {
//            // 有头像先传头像
//            
//            [self.registerBL uploadFileWithImages:@[self.image] withVioces:nil withModule:6];
//            
//        }else{
//            
//            [self.registerBL initEmployeeDataWithEmployeeId:self.user.employeeId employeeName:self.name gender:self.gender photograph:self.photograph inviteCompanyId:self.user.inviteCompanyId permssion:@1];
//        }
    }

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.type == FinishDataType_person || self.type == FinishDataType_employee|| self.type == FinishDataType_joinCompany) {
        
        return 3;
    }else{
        
        return 4;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == FinishDataType_joinCompany || self.type == FinishDataType_person || self.type == FinishDataType_employee) {
        if (indexPath.row == 0) {
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"姓名";
            cell.textField.placeholder = @"请输入真实姓名（必填）";
            cell.textField.text = self.name;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
            return cell;
            
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            
            UIView *view = [cell.contentView viewWithTag:0x123];
            [view removeFromSuperview];
            cell.timeTitle.text = @"性别";
            
            if (!self.gender) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                cell.time.textColor = BlackTextColor;
                cell.time.text = [self.gender isEqualToNumber:@0]?@"男":@"女";
            }
            return cell;
            
        }else{
            
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            UIView *view = [cell.contentView viewWithTag:0x123];
            [view removeFromSuperview];
            
            UIImageView *image = [[UIImageView alloc] init];
            [cell.contentView addSubview:image];
            image.tag = 0x123;
            image.frame = CGRectMake(101, 0, 40, 40);
            image.centerY = 55/2;
            if (!self.image) {
                cell.time.text = @"请添加";
            }else{
                cell.time.text = @"";
            }
            image.image = self.image;
            cell.time.textColor = PlacehoderColor;
            cell.timeTitle.text = @"头像";
            return cell;
            
        }

    }else{
        if (indexPath.row == 0) {
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"企业名称";
            cell.textField.placeholder = @"请输入企业名称（必填）";
            cell.textField.text = self.companyName;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
            cell.textField.tag = 0x123;
            return cell;
            
        }else if (indexPath.row == 1){
            
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            cell.titleLabel.text = @"企业电话";
            cell.textField.placeholder = @"请输入企业电话（必填）";
            cell.textField.text = self.companyName;
            [cell refreshInputCellWithType:0];
            cell.bottomLine.hidden = NO;
            cell.delegate = self;
            cell.textField.tag = 0x456;
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            return cell;
            
        }else if (indexPath.row == 2){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"所在地";
            if (!self.address || [self.address isEqualToString:@""]) {
                cell.time.text = @"请选择所在地";
                cell.time.textColor = PlacehoderColor;
            }else{
                cell.time.text = self.address;
                cell.time.textColor = BlackTextColor;
            }
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"所在行业";
            if (!self.industry || [self.industry isEqualToString:@""]) {
                cell.time.text = @"请选择所在行业";
                cell.time.textColor = PlacehoderColor;
            }else{
                cell.time.text = self.industry;
                cell.time.textColor = BlackTextColor;
            }
            return cell;
            
        }

    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == FinishDataType_person || self.type == FinishDataType_joinCompany|| self.type == FinishDataType_employee) {
        
        if (indexPath.row == 1) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"性别" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            [sheet show];
        }
        
        if (indexPath.row == 2) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
            sheet.tag = 0x222;
            [sheet show];
        }
    }else{
        
        if (indexPath.row == 2) {
                [self.industryView cancelView];
                [self.addressView showView];
    
        }
        
        if (indexPath.row == 3) {
            
            [self.addressView cancelView];
            [self.industryView showView];
        }
    }
}

- (void)setupAddressAndIndustry{
    __weak TFFinishPersonDataController *this = self;
    self.addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.addressView.sureAddressBlock = ^(id result) {
        [this setAddressWithDic:result];
    };
    [self.view addSubview:self.addressView];
    
    
    self.industryView = [[HQIndustryView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    self.industryView.sureIndustryBlock = ^(id result) {
        NSDictionary *dic = (NSDictionary *)result;
        [this setIndustryWithDic:dic];
    };
    [self.view addSubview:self.industryView];
}
- (void)setAddressWithDic:(id)addressDic
{
    self.address = addressDic[@"name"];
    self.addressId  = addressDic[@"id"];
    [self.addressView cancelView];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}


- (void)setIndustryWithDic:(NSDictionary *)industyDic
{
    self.industry = industyDic[@"value"];
    self.industryId = industyDic[@"id"];
    [self.industryView cancelView];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - sheet
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    if (sheet.tag == 0x222) {
        
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
        
    }else{
        self.gender = @(buttonIndex);
        
        [self.tableView reloadData];
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
    
    if (self.type == FinishDataType_joinCompany || self.type == FinishDataType_person || self.type == FinishDataType_employee) {
        
        self.name = textField.text;
    }else{
        
        if (textField.tag == 0x123) {
            
            self.companyName = textField.text;
        }
        if (textField.tag == 0x456) {
            
            self.telephone = textField.text;
        }
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
    self.image = cropImage;
    
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
    
    self.image = image;
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_initData) {// 完善个人信息
        
        TFFinishPersonDataController *finish = [[TFFinishPersonDataController alloc] init];
        finish.type = FinishDataType_company;
        finish.user = self.user;
        [self.navigationController pushViewController:finish animated:YES];
    }
    
    if (resp.cmdId == HQCMD_companyAdd) {// 完善公司信息
        
        TFEnterModelController *enterModel = [[TFEnterModelController alloc] init];
        [self.navigationController pushViewController:enterModel animated:YES];
    }
    
    if (resp.cmdId == HQCMD_uploadFile) {
        
//        self.photograph = resp.body;
//        
//        if (self.type == FinishDataType_employee) {
//            
//            [self.registerBL initEmployeeDataWithEmployeeId:self.user.employeeId employeeName:self.name gender:self.gender photograph:self.photograph inviteCompanyId:self.user.inviteCompanyId permssion:@1];
//        }
//        if (self.type == FinishDataType_person) {
//            
//            [self.registerBL initUserDataWithUserId:self.user.id userName:self.name gender:self.gender photograph:self.photograph inviteCompanyId:self.user.inviteCompanyId];
//        }
        
    }
    
    
    if (resp.cmdId == HQCMD_getCompanyAndEmploee) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
    }
    
    if (resp.cmdId == HQCMD_setupCompanyInfo) {
        
        NSDictionary *dict = resp.body;
        
        TFFinishPersonDataController *finish = [[TFFinishPersonDataController alloc] init];
        finish.type = FinishDataType_person;
        //        finish.user = resp.body;
        finish.userId = self.userId;
        finish.companyId = [dict valueForKey:@"companyId"];
        
        [self.navigationController pushViewController:finish animated:YES];
    }
    
    if (resp.cmdId == HQCMD_setupEmployeeInfo) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationLoginSuccess object:nil];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
