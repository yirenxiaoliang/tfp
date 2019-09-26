//
//  TFAddPCAddressController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/13.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddPCAddressController.h"
#import "HQTFInputCell.h"
#import "FDActionSheet.h"
#import "TFMapController.h"
#import "TFPCMapController.h"
#import "TFMapController.h"
#import "TFAttendanceBL.h"
#import "TFAddAtdWayModel.h"

@interface TFAddPCAddressController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,HQBLDelegate,UITextFieldDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFAttendanceBL *atdBL;

@property (nonatomic, strong) TFAddAtdWayModel *model;

@end

@implementation TFAddPCAddressController

- (TFAddAtdWayModel *)model {
    
    if (!_model) {
        
        _model = [[TFAddAtdWayModel alloc] init];
    }
    return _model;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    [self setupTableView];
    [self location];
    
    self.atdBL = [TFAttendanceBL build];
    self.atdBL.delegate = self;
    
    if (self.type == 1) {
        
        [self.atdBL requestGetAttendanceWayDetailWithId:self.wayId];
    }
    else {
        
        self.model.effectiveRange = @(100);
    }
}
-(void)location{
    
    TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeHideLocation];
    locationVc.type = LocationTypeHideLocation;
    locationVc.locationAction = ^(TFLocationModel *parameter){
        
        TFAtdLocationModel *lo = [[TFAtdLocationModel alloc] init];
        lo.lat = @(parameter.latitude);
        lo.lng = @(parameter.longitude);
        lo.address = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
        self.model.location = [NSArray<TFAtdLocationModel,Optional> arrayWithObject:lo];
        
        self.model.address = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
        
        [self.tableView reloadData];
    };
    
    [self addChildViewController:locationVc];
}

- (void)setNavi {
    
    if (self.type == 0) {
        self.navigationItem.title = @"添加地址";
    }else{
        self.navigationItem.title = @"编辑地址";
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(saveAction) text:@"保存" textColor:GreenColor];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-44) style:UITableViewStylePlain];
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
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"考勤名称";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.placeholder = @"请输入少于10个字名称";
        cell.delegate = self;
        cell.textField.delegate = self;
        cell.textField.text = self.model.name;
        cell.bottomLine.hidden = NO;
        [cell refreshInputCellWithType:0];
        
        return cell;
    }
    else if (indexPath.row == 1) {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"考勤地址";
        cell.requireLabel.hidden = NO;
        cell.enterBtn.hidden = YES;
        cell.textField.text = self.model.address;
        cell.textField.textColor = kUIColorFromRGB(0x333333);
        cell.textField.userInteractionEnabled = NO;
        cell.delegate = self;
        cell.textField.placeholder = @"";
        cell.bottomLine.hidden = NO;
        [cell refreshInputCellWithType:0];
        
        return cell;
        
    }
    else {
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        
        cell.titleLabel.text = @"有效范围";
        cell.requireLabel.hidden = YES;
        cell.enterBtn.hidden = NO;
        cell.textField.placeholder = @"";
        cell.textField.text = [NSString stringWithFormat:@"%ld米",self.model.effectiveRange.integerValue];
        cell.delegate = self;
        
        [cell refreshInputCellWithType:2];
        
        [cell.enterBtn setImage:nil forState:UIControlStateNormal];
        [cell.enterBtn setTitle:@"设置" forState:UIControlStateNormal];
        [cell.enterBtn setTitleColor:GreenColor forState:UIControlStateNormal];
        cell.enterBtn.titleLabel.font = FONT(12);
        cell.enterBtnW.constant = 40.0;
        cell.bottomLine.hidden = YES;
        return cell;
        
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.row == 1) {
        
//        TFPCMapController *locationVc = [[TFPCMapController alloc] init];
//        locationVc.type = LocationTypeSearchLocation;
//        locationVc.keyword = nil;
//        locationVc.locationAction = ^(TFLocationModel *parameter){
//
//        };
//        [self.navigationController pushViewController:locationVc animated:YES];
        
        TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeSelectLocation];
        locationVc.type = LocationTypeSelectLocation;
        if (self.model.location.count) {
            TFAtdLocationModel *mo = self.model.location.firstObject;
            locationVc.location = CLLocationCoordinate2DMake([mo.lat doubleValue], [mo.lng doubleValue]);
        }
        locationVc.keyword = self.model.address;
        locationVc.locationAction = ^(TFLocationModel *parameter){
            
            TFAtdLocationModel *lo = [[TFAtdLocationModel alloc] init];
            lo.lat = @(parameter.latitude);
            lo.lng = @(parameter.longitude);
            lo.address = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
            self.model.location = [NSArray<TFAtdLocationModel,Optional> arrayWithObject:lo];
            
            self.model.address = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:locationVc animated:YES];
    }
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

#pragma mark 保存
-(void)saveAction {
    
    self.model.wayType = @"0";
    
    if (self.type == 0) {
        [self.atdBL requestAddAttendanceWayWithModel:self.model];
    }else{
        [self.atdBL requestUpdateAttendanceWayWithModel:self.model];
    }
    
}

#pragma mark HQTFInputCellDelegate
- (void)inputCellDidClickedEnterBtn:(UIButton *)button {
    
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"有效范围" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"50米",@"100米",@"150米",@"200米",@"300米",@"500米",@"1000米", nil];
    
    [sheet show];
}

- (void)inputCellWithTextField:(UITextField *)textField {
    
    self.model.name = textField.text;
}

#pragma mark FDActionSheet
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
        {
            self.model.effectiveRange = @(50);
            
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.model.effectiveRange = @(100);
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            self.model.effectiveRange =@(150);
            [self.tableView reloadData];
        }
            break;
        case 3:
        {
            self.model.effectiveRange = @(200);
            [self.tableView reloadData];
        }
            break;
        case 4:
        {
            self.model.effectiveRange = @(300);
            [self.tableView reloadData];
        }
            break;
        case 5:
        {
            self.model.effectiveRange = @(500);
            [self.tableView reloadData];
        }
            break;
        case 6:
        {
            self.model.effectiveRange = @(1000);
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceWaySave) {
        
        [MBProgressHUD showError:@"添加成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAddressSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_attendanceWayUpdate) {
        
        [MBProgressHUD showError:@"修改成功" toView:self.view];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateAddressSuccess" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_attendanceWayFindDetail) {
        self.model = resp.body;
        self.model.effectiveRange = self.model.effective_range;
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
