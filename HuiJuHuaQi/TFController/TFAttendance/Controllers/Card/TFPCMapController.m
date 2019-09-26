//
//  TFPCMapController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//


#import "TFPCMapController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "TFApprovalSearchView.h"
#import "POIAnnotation.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFPCBottomView.h"
#import "TFMapController.h"
#import "TFChatBL.h"

@interface TFPCMapController ()<MAMapViewDelegate,AMapLocationManagerDelegate,TFPCBottomViewDelegate,AMapSearchDelegate,TFOutPunchViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,HQBLDelegate>

/** MAMapView */
@property (nonatomic, strong) MAMapView *mapView;

/** 是否开启定位 */
@property (nonatomic, assign) BOOL isStartLocation;
/** 第一次 */
@property (nonatomic, assign) BOOL isFirstTime;

/** locationBtn */
@property (nonatomic, strong) UIButton *locationBtn;


@property (nonatomic, strong) AMapLocationManager *locationManager;

/** selectLocation */
@property (nonatomic, strong) TFLocationModel *selectLocation;


@property (nonatomic, strong) TFPCBottomView *bottomView;

@property (nonatomic, strong) TFOutPunchView *punchView;
/** AMapSearchAPI */
@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, strong) TFChatBL *chatBL;

@end

@implementation TFPCMapController

-(TFLocationModel *)selectLocation{
    if (!_selectLocation) {
        _selectLocation = [[TFLocationModel alloc] init];
    }
    return _selectLocation;
}
-(UIButton *)locationBtn{
    if (!_locationBtn) {
        
        _locationBtn = [HQHelper buttonWithFrame:(CGRect){20,Long(300)-20-44,44,44} target:self action:@selector(locationClicked)];
        _locationBtn.backgroundColor = WhiteColor;
        _locationBtn.layer.cornerRadius = 22;
        _locationBtn.layer.masksToBounds = YES;
        [_locationBtn setImage:[UIImage imageNamed:@"mapLocation"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"mapLocation"] forState:UIControlStateHighlighted];
    }
    return _locationBtn;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    [self setupMap];
    [self setupNavi];
    [self startLocation];
    self.view.backgroundColor = WhiteColor;
    [self setPunchView];
    [self currentLocation];
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *arr = resp.body;
    if (arr.count) {
        TFFileModel *model = arr.firstObject;
        self.photo = model.file_url;
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

-(void)currentLocation{
    
    TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeHideLocation];
    locationVc.type = LocationTypeHideLocation;
    locationVc.locationAction = ^(TFLocationModel *parameter){
        
        //        if (parameter.city) {
        //            [model.otherDict setObject:parameter.city forKey:@"city"];
        //        }
        
        //        if (parameter.name) {
        //            [model.otherDict setObject:parameter.name forKey:@"name"];
        //        }
        //        [model.otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
        //        [model.otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
        //        [model.otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
        //
        //
        //        model.fieldValue = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
        self.punchView.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
        
        // 怎么计算两个经纬度点之间的距离
        double distance = 0;
        for (TFAtdWatDataListModel *address in self.punchViewModel.cardModel.attendance_address) {
            if (address.location.count) {// 有地址才可比较
                TFAtdLocationModel *loca = address.location.firstObject;
                double x1 = [loca.lat doubleValue];
                double y1 = [loca.lng doubleValue];
                double x2 = parameter.latitude;
                double y2 = parameter.longitude;
                double range = getDistance(x1, y1, x2, y2);
                if (distance == 0) {
                    distance = range;
                }else{
                    if (range < distance) {
                        distance = range;
                    }
                }
            }
        }
        if (distance == 0) {
            self.punchView.descLabel.text = @"";
        }else{
            self.punchView.descLabel.text = [NSString stringWithFormat:@"(距最近的  考勤范围  %.0f米)",distance];
            NSString *str = @"考勤范围";
            NSMutableAttributedString *attr  = [[NSMutableAttributedString alloc] initWithString:TEXT(self.punchView.descLabel.text) attributes:@{NSForegroundColorAttributeName:ExtraLightBlackTextColor,NSFontAttributeName:FONT(12)}];
            [attr addAttribute:NSForegroundColorAttributeName value:GreenColor range:[TEXT(self.punchView.descLabel.text) rangeOfString:str]];
            self.punchView.descLabel.attributedText = attr;
        }
        
    };
    
    [self addChildViewController:locationVc];
}
#pragma mark - punchView
-(void)setPunchView{
    TFOutPunchView *punchView = [TFOutPunchView outPunchView];
    punchView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomM-300, SCREEN_WIDTH, 300);
    [self.view addSubview:punchView];
    self.punchView = punchView;
    punchView.delegate = self;
    
    self.bottomView = [[TFPCBottomView alloc] initWithFrame:CGRectMake(0, 300 - 150, SCREEN_WIDTH, 170)];
    self.bottomView.delegate = self;
    [punchView insertSubview:self.bottomView atIndex:0];
    [self.bottomView refreshPCTimeWithModel:self.punchViewModel.currentRecord];
    self.bottomView.tipLab.hidden = YES;
    self.bottomView.tipImg.hidden = YES;
    
    self.punchView.markLabel.text = @"选填";
    self.punchView.markLabel.textColor = GrayTextColor;
    if (self.type == 1) {
        self.punchView.hidden = YES;
    }
}

- (void)punchCardClicked {// 打卡
    
    [self requestPunchCark];
}

-(void)requestPunchCark{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.punchViewModel.currentRecord.punchcard_key) {
        [dict setObject:self.punchViewModel.currentRecord.punchcard_key forKey:@"punchcardTimeField"];
    }
    [dict setObject:@(self.punchDate) forKey:@"attendanceDate"];
    if (self.punchViewModel.cardModel.id) {
        [dict setObject:self.punchViewModel.cardModel.id forKey:@"groupId"];
    }
    if (self.punchViewModel.currentRecord.punchcard_type) {
        [dict setObject:self.punchViewModel.currentRecord.punchcard_type forKey:@"punchcardType"];
    }
    
    [dict setObject:@(0) forKey:@"punchcardWay"];
    [dict setObject:@0 forKey:@"isOutworker"];
    
    UIDevice *divice = [UIDevice currentDevice];
    [dict setObject:divice.model forKey:@"punchcardEquipment"];
    if (IsStrEmpty(self.punchView.addressLabel.text)) {
        [dict setObject:self.punchView.addressLabel.text forKey:@"punchcardAddress"];
    }
    if (self.remark) {
        [dict setObject:self.remark forKey:@"remark"];
    }
    if (self.photo) {
        [dict setObject:self.photo forKey:@"photo"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    [self.attendanceBL requestPunchAttendanceWithDict:dict];
    RACSignal *signal = [self.punchViewModel.punchCommand execute:dict];
    [signal subscribeNext:^(id  _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [signal subscribeError:^(NSError * _Nullable error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - TFOutPunchViewDelegate
-(void)punchViewClickedMark{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)punchViewClickedPhoto{
    
    [self openCamera];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        self.remark = textField.text;
        self.punchView.markLabel.text = self.remark;
        if (IsStrEmpty(self.remark)) {
            self.punchView.markLabel.text = @"选填";
            self.punchView.markLabel.textColor = GrayTextColor;
        }else{
            self.punchView.markLabel.textColor = BlackTextColor;
        }
    }
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
//    TFFileModel *model = [[TFFileModel alloc] init];
//    model.file_name = @"这是一张自拍图";
//    model.file_type = @"jpg";
//    model.image = image;
    
    [self.punchView.photoBtn setImage:image forState:UIControlStateNormal];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.chatBL chatFileWithImages:@[image] withVioces:nil bean:@"attendence"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 初始化navi
- (void)setupNavi{
    
    self.navigationItem.title = @"定位";
    
}


#pragma mark - 点击定位按钮
- (void)locationClicked{
    [self startLocation];
}


#pragma mark - 初始化地图
- (void)setupMap{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10;
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    
    MAUserLocationRepresentation *r = [[MAUserLocationRepresentation alloc] init];
    r.showsAccuracyRing = NO;///精度圈是否显示，默认YES
    [self.mapView updateUserLocationRepresentation:r];
    
    [self.view addSubview:self.mapView];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    self.isStartLocation = YES;

    [self.view addSubview:self.locationBtn];
    self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-BottomM-260));
    self.locationBtn.frame = CGRectMake(20, (SCREEN_HEIGHT-NaviHeight-BottomM-260)-20-44, 44, 44);
    if (self.type == 1) {
        self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT-BottomM));
        self.locationBtn.frame = CGRectMake(20, (SCREEN_HEIGHT-NaviHeight-BottomM)-20-44, 44, 44);
        [self.mapView setZoomLevel:16 animated:YES];
    }
    
    for (TFLocationModel *model in self.locations) {
        
        MAAnimatedAnnotation *pointAnnotation = [[MAAnimatedAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.latitude, model.longitude);
        pointAnnotation.title = [NSString stringWithFormat:@"办公地点：%@",model.address];
        [self.mapView addAnnotation:pointAnnotation];
        MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(model.latitude, model.longitude) radius:[model.effective_range doubleValue]];
        
        //在地图上添加圆
        [_mapView addOverlay: circle];
        
    }
}
/** 开启定位 */
- (void)startLocation{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

#pragma mark - MAMapViewDelegate
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];
        
        circleRenderer.lineWidth    = 5.f;
//        circleRenderer.strokeColor  = HexAColor(0x3689E9, 0.4);
        circleRenderer.fillColor    = HexAColor(0x3689E9, 0.4);
        return circleRenderer;
    }
    return nil;
}
/** 用户位置发生变化 */
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        HQLog(@"userlocation :%@", userLocation.location);
        if (!self.isFirstTime) {
            self.isFirstTime = YES;
            [mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        }
        self.selectLocation.latitude = userLocation.location.coordinate.latitude;
        self.selectLocation.longitude = userLocation.location.coordinate.longitude;
        for (MAPointAnnotation *no in mapView.annotations) {
            if ([no.title isEqualToString:@"自己的位置"]) {
                [mapView removeAnnotation:no];
                break;
            }
        }
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = userLocation.location.coordinate;
        pointAnnotation.title = @"自己的位置";
        [mapView addAnnotation:pointAnnotation];
    }
}

/** 在地图添加大头针 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{

    if ([annotation.title isEqualToString:@"自己的位置"]) {

        static NSString *pointReuseIndentifier = @"userIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = NO;        //设置标注动画显示，默认为NO
        annotationView.image = [UIImage imageNamed:@"地图个人标志"]; //自定义标注（需将下面气泡注释）
        return annotationView;
        
    }else{
        
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.image = [UIImage imageNamed:@"地图企业标志"];  //自定义标注（需将下面气泡注释）
        return annotationView;
    }
    
}


//- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    MAAnnotationView *view = views.firstObject;
//    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
//    if ([view.annotation isKindOfClass:[MAUserLocation class]])
//    {
//
//        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
//        pre.fillColor = kUIColorFromRGB(0x9BB8D4);
//        pre.strokeColor = kUIColorFromRGB(0x979797);
//        pre.image = IMG(@"地图个人标志");
//        pre.lineWidth = 1;
////        pre.lineDashPattern = @[@6, @3];
//        //隐藏蓝色精度圈
//        pre.showsAccuracyRing=YES;
//        [_mapView updateUserLocationRepresentation:pre];
//
//        view.calloutOffset = CGPointMake(0, 0);
//    }
//}

@end
