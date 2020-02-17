//
//  HQPersonInfoVC.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQPersonInfoVC.h"
#import "TFSelectDateView.h"
#import "UILabel+Extension.h"
#import "HQReSetPasswordController.h"
#import "HQChangePhoneNumVC.h"
#import "AlertView.h"
#import "HQMyCardViewController.h"
#import "HQMyAddressViewController.h"
#import "FDActionSheet.h"
#import "HQSignViewController.h"
#import "TFPeopleBL.h"
#import "TFLoginBL.h"
#import "TFPersonInfoModel.h"
#import "HQTFProjectDescController.h"
#import "MLImageCrop.h"
#import "ZYQAssetPickerController.h"
#import "HQAddressView.h"
#import "HQAreaManager.h"
#import "TFMyHeadPictureController.h"
#import "HQSelectTimeCell.h"
#import "TFEditMobilAndMailController.h"

@interface HQPersonInfoVC ()<UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,HQBLDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,MLImageCropDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSArray *titleArr1;

@property (nonatomic, strong) NSArray *titleArr2;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) TFPeopleBL *peopleBL;
@property (nonatomic, strong)  TFLoginBL*loginBL;


/** image */
@property (nonatomic, strong) UIImage *image;


/** 头像地址 */
@property (nonatomic, copy) NSString *photograph;

@property (nonatomic, strong) TFPersonInfoModel *personInfoModel;

/** HQAddressView */
@property (nonatomic, strong) HQAddressView *addressView;
/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;

@end

@implementation HQPersonInfoVC

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}

-(HQAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        [self.view addSubview:_addressView];
    }
    
    return _addressView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:WhiteColor] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:HexAColor(0xc8c8c8, 1) size:(CGSize){SCREEN_WIDTH,0.5}]];
    }
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    self.loginBL = [TFLoginBL build];
    self.loginBL.delegate = self;
    
    _titleArr1 = @[@"性别",@"生日",@"地区"];
    _titleArr2 = @[@"手机",@"座机",@"邮箱"];
    
    [self initData];
    [self setupNavigation];
    
    [self createTableView];
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
    _personInfoModel.gender = IsStrEmpty(UM.userLoginInfo.employee.sex)?nil:@([UM.userLoginInfo.employee.sex integerValue]);
    
    _personInfoModel.region = UM.userLoginInfo.employee.region;
    _signContent = UM.userLoginInfo.employee.sign;
    
    NSString *str = @"";
    for (TFDepartmentCModel *model in UM.userLoginInfo.departments) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.department_name]];
    }
    _personInfoModel.departmentName = [str substringToIndex:str.length-1];
    
}


- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"个人信息";
    
}

- (void)createScrollView {

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_scrollView];
}

- (void)createTableView {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        
        return _titleArr1.count;
    } else if(section == 2) {
        
        return _titleArr2.count;
    } else {
    
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"头像";
        cell.time.text = @"";
        cell.structure = @"1";
        cell.fieldControl = @"0";
        cell.arrowShowState = YES;
        cell.bottomLine.hidden = NO;
        cell.topLine.hidden = YES;
        
        
        UIButton *headImg = [UIButton buttonWithType:UIButtonTypeCustom];
        headImg.userInteractionEnabled = NO;
        headImg.layer.cornerRadius = 30;
        headImg.layer.masksToBounds = YES;
        headImg.frame = CGRectMake(101, 10, 60, 60);
        headImg.contentMode = UIViewContentModeScaleToFill;
        NSURL *url = [HQHelper URLWithString:_personInfoModel.photograph];
        [headImg sd_setBackgroundImageWithURL:url forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (image) {
                [headImg setTitle:@"" forState:UIControlStateNormal];
            }else{
                [headImg setTitle:[HQHelper nameWithTotalName:UM.userLoginInfo.employee.employee_name] forState:UIControlStateNormal];
                [headImg setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
            }
        }];
        [cell.contentView addSubview:headImg];
        headImg.tag = 0x123;
        return cell;
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"性别";
            cell.time.text = _personInfoModel.gender?([_personInfoModel.gender integerValue]==0?@"男":@"女"):@"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"生日";
            cell.time.text = (_personInfoModel.birthday && ![_personInfoModel.birthday isEqualToString:@""]) ? [HQHelper nsdateToTime:[_personInfoModel.birthday longLongValue] formatStr:@"yyyy-MM-dd"] : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"地区";
//            cell.time.text = [self.areaManager regionWithRegionData:TEXT(_personInfoModel.region)];
            cell.time.text = (_personInfoModel.region && ![_personInfoModel.region isEqualToString:@""]) ? [self.areaManager regionWithRegionData:TEXT(_personInfoModel.region)] : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = YES;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }
        
    }else{
        
        if (indexPath.row == 0) {
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"手机";
            cell.time.text = (_personInfoModel.telephone && ![_personInfoModel.telephone isEqualToString:@""]) ? _personInfoModel.telephone : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = GreenColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }else if (indexPath.row == 1){
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"座机";
            cell.time.text = (_personInfoModel.mobilePhoto && ![_personInfoModel.mobilePhoto isEqualToString:@""]) ? _personInfoModel.mobilePhoto : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = GreenColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = NO;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"邮箱";
            cell.time.text = (_personInfoModel.email && ![_personInfoModel.email isEqualToString:@""]) ? _personInfoModel.email : @"未设置";
            if ([cell.time.text isEqualToString:@"未设置"]) {
                cell.time.textColor = GrayTextColor;
            }else{
                cell.time.textColor = BlackTextColor;
            }
            cell.structure = @"1";
            cell.fieldControl = @"0";
            cell.arrowShowState = NO;
            cell.bottomLine.hidden = YES;
            cell.topLine.hidden = YES;
            [[cell.contentView viewWithTag:0x123] removeFromSuperview];
            return cell;
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        TFMyHeadPictureController *head = [[TFMyHeadPictureController alloc] init];
        head.headUrl = _personInfoModel.photograph;
        head.refresh = ^(id parameter) {
            if (self.refresh) {
                self.refresh(nil);
            }
        };
        head.headRefresh = ^(id parameter) {
            _personInfoModel.photograph = parameter;
            [self.tableview reloadData];
        };
        [self.navigationController pushViewController:head animated:YES];
        
//        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"头像" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"相册", nil];
//        sheet.tag = 0x222;
//        [sheet show];
    }
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            
//            if (!_personInfoModel.telephone || [_personInfoModel.telephone isEqualToString:@""]) {
//                return;
//            }
//
//            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",_personInfoModel.telephone];
//
//            UIWebView *callWebview = [[UIWebView alloc]init];
//
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//
//            [self.view addSubview:callWebview];
            
        }else if (indexPath.row == 1){
            
//            if (!_personInfoModel.mobilePhoto || [_personInfoModel.mobilePhoto isEqualToString:@""]) {
//                return;
//            }
//
//            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",_personInfoModel.telephone];
//
//            UIWebView *callWebview = [[UIWebView alloc]init];
//
//            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//
//            [self.view addSubview:callWebview];
            TFEditMobilAndMailController *editInfo = [[TFEditMobilAndMailController alloc] init];
            
            editInfo.type = EditInfoTypeMobil;
            editInfo.titleStr = _personInfoModel.mobilePhoto;
            editInfo.refresh = ^(NSString *time){
                
                _personInfoModel.mobilePhoto = time;
                [self.tableview reloadData];
                [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
            };
            [self.navigationController pushViewController:editInfo animated:YES];
            
        }else{
            
            TFEditMobilAndMailController *editInfo = [[TFEditMobilAndMailController alloc] init];
            
            editInfo.type = EditInfoTypeMail;
            editInfo.titleStr = _personInfoModel.email;
            editInfo.refresh = ^(NSString *time) {
              
                _personInfoModel.email = time;
                [self.tableview reloadData];
                [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
            };
            
            [self.navigationController pushViewController:editInfo animated:YES];
        }
        
    }
    else if (indexPath.section == 1) {
    
        if (indexPath.row == 0) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
            [sheet setButtonTitleColor:nil bgColor:WhiteColor fontSize:FONT(18) atIndex:0];
            
            [sheet show];
        }
        else if (indexPath.row == 2) {
        
            
            __weak HQPersonInfoVC *this = self;
            [self.addressView showView];
            self.addressView.sureAddressBlock = ^(NSDictionary *result) {
                
                TFEmployModel *em = [[TFEmployModel alloc] init];
                // 此处传name，自定义中传的id
                em.region = [result valueForKey:@"data"];
                [this.peopleBL requestUpdateEmployeeWithEmployee:em];
                
                [this.addressView cancelView];
            };
            
        }
        else if (indexPath.row == 1) {
            
//            HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
//            desc.descString = self.signContent;
//            desc.naviTitle = @"个性签名";
//            desc.sectionTitle = @"个性签名";
//            desc.descAction = ^(NSString *str){
//                
//                self.signContent = str;
//                
//                TFEmployModel *em = [[TFEmployModel alloc] init];
//                em.sign = str;
//                [self.peopleBL requestUpdateEmployeeWithEmployee:em];
//                
//            };
//
//            [self.navigationController pushViewController:desc animated:YES];
            
            
            long long timeSp = [_personInfoModel.birthday longLongValue];
            
            [TFSelectDateView selectDateViewWithType:DateViewType_YearMonthDay timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
                
                TFEmployModel *em = [[TFEmployModel alloc] init];
                // 此处传name，自定义中传的id
                em.birth = @([HQHelper changeTimeToTimeSp:time formatStr:@"yyyy-MM-dd"]);
                [self.peopleBL requestUpdateEmployeeWithEmployee:em];

            }];
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
   
        return 80;
    }
    else if (indexPath.section == 1) {
    
        return 50;
    } else {
    
        return 50;
    }
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 0;
    }
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - FDActionSheet delegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

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
        
    }
    
    if (buttonIndex == 0) {
        
        _sex = @"男";
        
        
    } else if (buttonIndex == 1) {
    
        _sex = @"女";
    }
    
    TFEmployModel *em = [[TFEmployModel alloc] init];
    em.sex = @(buttonIndex);
    [self.peopleBL requestUpdateEmployeeWithEmployee:em];
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}


/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = 800.0f/800.0f;
    imageCrop.image = arr.firstObject;
    [imageCrop showWithAnimation:YES];
}
#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 1;
    sheet.configuration.allowEditImage = NO;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
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
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
   
        
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

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.peopleBL imageFileWithImages:@[self.image] withVioces:nil];
}


#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.image = image;
    
    [self.peopleBL imageFileWithImages:@[self.image] withVioces:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //修改头像
    if (resp.cmdId == HQCMD_ImageFile) {
        
        NSArray *files = resp.body;
        
        if (files.count) {
            
            
            TFFileModel *model = files[0];
            _personInfoModel.photograph = model.file_url;
            TFEmployModel *em = [[TFEmployModel alloc] init];
            em.picture = model.file_url;
            
            [self.peopleBL requestUpdateEmployeeWithEmployee:em];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    if (resp.cmdId == HQCMD_updateEmployee) {
        
        
        [self.loginBL requestGetEmployeeInfoAndCompanyInfo];
        
        [self.tableview reloadData];
    }

    if (resp.cmdId == HQCMD_getEmployeeAndCompanyInfo) {
        
        [self.loginBL requestEmployeeList];
        [self initData];
        
        [self.tableview reloadData];
    }
    
    if (resp.cmdId == HQCMD_employeeList) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
