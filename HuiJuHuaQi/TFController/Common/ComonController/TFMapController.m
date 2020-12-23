//
//  TFMapController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/27.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFMapController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "TFApprovalSearchView.h"
#import "HQTFRelateCell.h"
#import "HQTFNoContentView.h"
#import "POIAnnotation.h"
#import "HQTFTwoLineCell.h"

@interface TFMapController ()<MAMapViewDelegate,AMapSearchDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,TFApprovalSearchViewDelegate>

/** MAMapView */
@property (nonatomic, strong) MAMapView *mapView;
/** AMapSearchAPI */
@property (nonatomic, strong) AMapSearchAPI *search;

/** 是否开启定位 */
@property (nonatomic, assign) BOOL isStartLocation;
/** 第一次 */
@property (nonatomic, assign) BOOL isFirstTime;

/** locationBtn */
@property (nonatomic, strong) UIButton *locationBtn;

/** searchView */
@property (nonatomic, strong) TFApprovalSearchView *searchView;

/** selectLocation */
@property (nonatomic, strong) TFLocationModel *selectLocation;

/** searchLocation */
@property (nonatomic, strong) TFLocationModel *searchLocation;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** locations */
@property (nonatomic, strong) NSMutableArray *locations;

/** locationBtn */
@property (nonatomic, strong) UIButton *searchButton;

/** bgView */
@property (nonatomic, strong) UIButton *bgView;

/** bgView */
@property (nonatomic, strong) UITableView *searchTableView;

/** searchLocations */
@property (nonatomic, strong) NSMutableArray *searchLocations;

/** isSearch */
@property (nonatomic, assign) BOOL isSearch;


@end

@implementation TFMapController

-(UITableView *)searchTableView{
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchTableView.dataSource = self;
        _searchTableView.delegate = self;
        _searchTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _searchTableView.backgroundColor = WhiteColor;
        _searchTableView.tag = 0x123;
    }
    return _searchTableView;
}

-(UIButton *)bgView{
    if (!_bgView) {
        _bgView = [[UIButton alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT-NaviHeight}];
        _bgView.backgroundColor = HexAColor(0x000000,0.5);
        [_bgView addTarget:self action:@selector(bgClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgView;
}
- (void)bgClicked{
    [self approvalSearchViewDidClickedStatusBtn];
}

-(NSMutableArray *)searchLocations{
    if (!_searchLocations) {
        _searchLocations = [NSMutableArray array];
    }
    return _searchLocations;
}

-(NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}

-(UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(15, 10, SCREEN_WIDTH-30, 30);
        _searchButton.backgroundColor = WhiteColor;
        [_searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
        [_searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateHighlighted];
        [_searchButton setTitle:@" 搜索" forState:UIControlStateNormal];
        [_searchButton setTitle:@" 搜索" forState:UIControlStateHighlighted];
        [_searchButton setTitleColor:GrayTextColor forState:UIControlStateNormal];
        [_searchButton setTitleColor:GrayTextColor forState:UIControlStateHighlighted];
        [_searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _searchButton.layer.cornerRadius = 4;
        _searchButton.titleLabel.font = FONT(15);
        _searchButton.layer.masksToBounds = YES;
    }
    return _searchButton;
}

- (void)searchButtonClicked:(UIButton *)button{
    
    [self.view addSubview:self.bgView];
    self.searchButton.hidden = YES;
    [self.searchView.textFiled becomeFirstResponder];
    [self.navigationController.navigationBar addSubview:self.searchView];
    self.isSearch = YES;
}

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"无搜索结果"];
    }
    return _noContentView;
}

-(TFApprovalSearchView *)searchView{
    if (!_searchView) {
        
        _searchView = [TFApprovalSearchView approvalSearchView];
        _searchView.frame = (CGRect){0,0,SCREEN_WIDTH,46};
        _searchView.type = 2;
        _searchView.textFiled.returnKeyType = UIReturnKeySearch;
        _searchView.textFiled.delegate = self;
        _searchView.textFiled.placeholder = @"搜索地址";
        [_searchView.statusBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_searchView.statusBtn setTitle:@"取消" forState:UIControlStateHighlighted];
        [_searchView.statusBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        [_searchView.statusBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
        [_searchView.statusBtn setImage:nil forState:UIControlStateNormal];
        [_searchView.statusBtn setImage:nil forState:UIControlStateHighlighted];
        _searchView.delegate = self;
        _searchView.textFiled.backgroundColor = CellSeparatorColor;
        _searchView.backgroundColor = WhiteColor;
    }
    return _searchView;
}

#pragma mark - TFApprovalSearchViewDelegate
-(void)approvalSearchViewDidClickedStatusBtn{
    
    [self.searchTableView removeFromSuperview];
    [self.bgView removeFromSuperview];
    [self.searchView.textFiled resignFirstResponder];
    [self.searchView removeFromSuperview];
    self.searchButton.hidden = NO;
    self.isSearch = NO;
}

-(void)approvalSearchViewTextChange:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        [self.searchTableView removeFromSuperview];
    }
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
    
    if (self.isStartLocation && self.type != LocationTypeLookLocation) {
        // 定位
        [self startLocation];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(instancetype)initWithType:(LocationType)type{
    if (self = [super init]) {
        self.type = type;
        if (type == LocationTypeHideLocation) {
            
            [self setupMap];
            [self setupNavi];
            [self startLocation];
            
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enablePanGesture = NO;
    if (self.type != LocationTypeHideLocation) {
        [self setupMap];
        [self setupNavi];
    }
    self.view.backgroundColor = WhiteColor;
}
#pragma mark - 初始化navi
- (void)setupNavi{
    
    self.navigationItem.title = @"定位";
    
    if (self.type == LocationTypeSelectLocation || self.type == LocationTypeSearchLocation) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(send) text:@"确定" textColor:GreenColor];
    }
}

- (void)send{
    
    if (!self.selectLocation) {
        [MBProgressHUD showError:@"请选择地址" toView:self.view];
        return;
    }
    
    if (self.locationAction) {
        
        self.locationAction(self.selectLocation);
        if (self.type != LocationTypeHideLocation) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark - 初始化tableView

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Long(250), SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-Long(250)) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = ClearColor;
    }
    return _tableView;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 0x123) {
        
        return self.searchLocations.count;
    }else{
        return self.locations.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 0x123) {
        TFLocationModel *model = self.searchLocations[indexPath.row];
        
//        HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
//        [cell refreshCellWithLocation:model withType:0];
//
//        cell.enterImage.hidden = !model.select;
//        return cell;
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        [cell.enterImage setImage:IMG(@"完成") forState:UIControlStateNormal];
        cell.enterImage.hidden = !model.select;
        cell.bottomLine.hidden = NO;
        [cell refreshCellWithLocation:model];
        return cell;
    }else{
        
        TFLocationModel *model = self.locations[indexPath.row];
//        HQTFRelateCell *cell = [HQTFRelateCell relateCellWithTableView:tableView];
//        [cell refreshCellWithLocation:model withType:0];
//        
//        cell.enterImage.hidden = !model.select;
//        return cell;
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        [cell.enterImage setImage:IMG(@"完成") forState:UIControlStateNormal];
        cell.enterImage.hidden = !model.select;
        [cell refreshCellWithLocation:model];
        cell.bottomLine.hidden = NO;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (tableView.tag == 0x123) {
        
        
        [self approvalSearchViewDidClickedStatusBtn];
        
        TFLocationModel *model = self.searchLocations[indexPath.row];
        self.searchLocation = model;
        self.selectLocation.latitude = model.latitude;
        self.selectLocation.longitude = model.longitude;
        [self searchPoiByCenterCoordinateWithKeyword:@""];
    }else{
        
        self.selectLocation.select = NO;
        TFLocationModel *model = self.locations[indexPath.row];
        model.select = YES;
        [tableView reloadData];
        self.selectLocation = model;
        
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){model.latitude,model.longitude} animated:YES];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        AMapPOI *poi = [[AMapPOI alloc] init];
        AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
        point.longitude = model.longitude;
        point.latitude = model.latitude;
        poi.location = point;
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
        
        [self.mapView addAnnotation:annotation];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 0x123) {
        
        return 0;
    }else{
        return 30;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == 0x123) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }else{
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BackGroudColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,30}];
        label.backgroundColor = BackGroudColor;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"附近的地址" attributes:@{NSForegroundColorAttributeName:LightGrayTextColor,NSFontAttributeName:FONT(14)}];
        
        label.attributedText = str;
        
        [view addSubview:label];
        
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    [self.searchView.textFiled resignFirstResponder];
}


#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    [self searchKeywordCoordinateWithKeyword:textField.text];
    
    return YES;
}

#pragma mark - 点击定位按钮
- (void)locationClicked{
    [self startLocation];
}

#pragma mark - 初始化地图
- (void)setupMap{
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    [self.view addSubview:self.mapView];
    
    /**
     LocationTypeSelectLocation,// 选择位置
     LocationTypeLookLocation,  // 查看位置
     LocationTypeSearchLocation // 搜索位置 */
    
    if (self.type == LocationTypeLookLocation){
        
        self.isStartLocation = YES;
        [self.mapView setCenterCoordinate:self.location];
        
//        [self.view addSubview:self.locationBtn];
//        self.locationBtn.frame = CGRectMake(SCREEN_WIDTH - 44 - 20, SCREEN_HEIGHT-NaviHeight-20-44, 44, 44);
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){15,SCREEN_HEIGHT-NaviHeight-BottomM-15 - 50, SCREEN_WIDTH-30,50}];
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){8,0, SCREEN_WIDTH-46,50}];
        [self.view addSubview:view];
        [view addSubview:label];
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        view.backgroundColor = HexAColor(0x000000, 0.7);
        label.textColor = WhiteColor;
        label.font = FONT(16);
        label.text = self.address;
        label.numberOfLines = 0;
        
        AMapPOI *poi = [[AMapPOI alloc] init];
        AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
        point.longitude = self.location.longitude;
        point.latitude = self.location.latitude;
        poi.location = point;
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
        
        [self.mapView addAnnotation:annotation];
        
    }else{
        self.isStartLocation = YES;
        
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        [self.view addSubview:self.searchButton];
//        [self.view addSubview:self.searchView];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.locationBtn];
        self.mapView.frame = CGRectMake(0, 0, SCREEN_WIDTH, Long(300));
        self.tableView.frame = CGRectMake(0, Long(300)-NaviHeight, SCREEN_WIDTH, SCREEN_HEIGHT-Long(300));
        self.locationBtn.frame = CGRectMake(20, Long(300)-NaviHeight-20-44, 44, 44);
    }
    
    
}
/** 开启定位 */
- (void)startLocation{
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
}

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinateWithKeyword:(NSString *)keyword
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.selectLocation.latitude longitude:self.selectLocation.longitude];
    request.keywords            = @"大厦|楼|建筑|地名地址信息";
//    request.types = @"大厦|楼|建筑|地名地址信息";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.requireExtension    = YES;
    
    [self.search AMapPOIAroundSearch:request];
}
/* 根据关键字搜索POI. */
- (void)searchKeywordCoordinateWithKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.selectLocation.latitude longitude:self.selectLocation.longitude];
    request.keywords            = keyword;
//    request.types = @"大厦|楼|建筑|地名地址信息";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.offset = 50;
    request.requireExtension    = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
}

/* 根据逆地理搜索. */
- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:regeo];
}
#pragma mark - MAMapViewDelegate

- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
    if (self.type == LocationTypeSearchLocation || self.type == LocationTypeSelectLocation) {
        
        // 定位点逆地理查询位置
        self.selectLocation.latitude = coordinate.latitude;
        self.selectLocation.longitude = coordinate.longitude;
        [self searchPoiByCenterCoordinateWithKeyword:@""];

    }
    
    if (self.type == LocationTypeLookLocation) {
        [self.mapView setCenterCoordinate:self.location];
    }
    
}
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (updatingLocation)
    {
        HQLog(@"userlocation :%@", userLocation.location);
        
        if (!self.isFirstTime) {
            self.isFirstTime = YES;
        
            if (self.keyword && ![self.keyword isEqualToString:@""]) {
                
                self.selectLocation = [[TFLocationModel alloc] init];
                self.selectLocation.latitude = self.location.latitude;
                self.selectLocation.longitude = self.location.longitude;
                
                [self searchPoiByCenterCoordinateWithKeyword:self.keyword];
               
                
            }else{
                
                self.selectLocation = [[TFLocationModel alloc] init];
                self.selectLocation.latitude = userLocation.location.coordinate.latitude;
                self.selectLocation.longitude = userLocation.location.coordinate.longitude;
                
                [self searchPoiByCenterCoordinateWithKeyword:@""];
            }
        }
    }
    if (self.type == LocationTypeLookLocation) {
        [self.mapView setCenterCoordinate:self.location];
    }
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    HQLog(@"Error: %@", error);
}


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if (self.isSearch) {
        
        [self.view addSubview:self.searchTableView];
        [self.searchLocations removeAllObjects];
        
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            
            TFLocationModel *model = [[TFLocationModel alloc] init];
            model.latitude = obj.location.latitude;
            model.longitude = obj.location.longitude;
            model.address = obj.address;
            model.name = obj.name;
            model.city = obj.city;
            model.province = obj.province;
            model.district = obj.district;
            
            [self.searchLocations addObject:model];
        }];
        
        if (self.searchLocations.count) {
            self.searchTableView.backgroundView = nil;
        }else{
            self.searchTableView.backgroundView = self.noContentView;
        }
        [self.searchTableView reloadData];
        
    }else{
        
        [self.locations removeAllObjects];
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        if (self.searchLocation) {
            [self.locations addObject:self.searchLocation];
        }
        [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
            
            TFLocationModel *model = [[TFLocationModel alloc] init];
            model.latitude = obj.location.latitude;
            model.longitude = obj.location.longitude;
            model.address = obj.address;
            model.name = obj.name;
            model.city = obj.city;
            model.province = obj.province;
            model.district = obj.district;
            
            [self.locations addObject:model];
        }];
        
        if (self.locations.count) {
            self.tableView.backgroundView = nil;
        }else{
            self.tableView.backgroundView = self.noContentView;
        }
        if (self.locations.count) {
            TFLocationModel *model = self.locations[0];
            model.select = YES;
            self.selectLocation = model;
            
            if (self.type == LocationTypeHideLocation) {// 发送
                [self send];
            }
            
            [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){model.latitude,model.longitude} animated:YES];
            
            AMapPOI *poi = [[AMapPOI alloc] init];
            AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
            point.longitude = model.longitude;
            point.latitude = model.latitude;
            poi.location = point;
            POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
            
            [self.mapView addAnnotation:annotation];
            
            [self.tableView reloadData];
        }

    }
    
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    [self.locations removeAllObjects];
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    [response.regeocode.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        TFLocationModel *model = [[TFLocationModel alloc] init];
        model.latitude = obj.location.latitude;
        model.longitude = obj.location.longitude;
        model.address = obj.address;
        model.name = obj.name;
        model.city = obj.city;
        model.province = obj.province;
        model.district = obj.district;
        
        [self.locations addObject:model];
    }];
    
    if (self.locations.count) {
        self.tableView.backgroundView = nil;
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
    
    if (self.locations.count) {
        TFLocationModel *model = self.locations[0];
        model.select = YES;
        self.selectLocation = model;
        
        [self.mapView setCenterCoordinate:(CLLocationCoordinate2D){model.latitude,model.longitude} animated:YES];
       
        
        AMapPOI *poi = [[AMapPOI alloc] init];
        AMapGeoPoint *point = [[AMapGeoPoint alloc] init];
        point.longitude = model.longitude;
        point.latitude = model.latitude;
        poi.location = point;
        POIAnnotation *annotation = [[POIAnnotation alloc] initWithPOI:poi];
        
        [self.mapView addAnnotation:annotation];
    
        [self.tableView reloadData];
    }
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
