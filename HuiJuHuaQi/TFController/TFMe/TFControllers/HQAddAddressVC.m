//
//  HQAddAddressVC.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAddAddressVC.h"
#import "UILabel+Extension.h"
#import "TFMyAddressModel.h"
#import "TFLocationModel.h"

@interface HQAddAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;
 
@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *placeholderArr;


@property (nonatomic, strong) TFMyAddressModel *myAddressModel;

@end

@implementation HQAddAddressVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancelAction) text:@"取消" textColor:HexAColor(0x69696C, 1)];
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self createTableview];
    
    _dataSource = @[@"收货人",@"手机号码",@"选择地区",@"详细地址",@"邮政编码"];
    _placeholderArr = @[@"姓名",@"11位手机号",@"地区信息",@"街道门牌信息",@"邮政编码"];
    
    _myAddressModel = [[TFMyAddressModel alloc] init];
    
    self.model = [[TFMyAddressModel alloc] init];
}

- (void)requestData {

//    self.setPersonInfoBL = [TFSetPersonInfoBL build];
//    self.setPersonInfoBL.delegate = self;
    
    _myAddressModel.receiverName = self.model.receiverName;
    _myAddressModel.region = self.model.region;
    _myAddressModel.telephone = self.model.telephone;
    _myAddressModel.address = self.model.address;
    _myAddressModel.postCode = self.model.postCode;
    
//    [self.setPersonInfoBL requestAddMyAddressData:_myAddressModel];
}

- (void)setupNavigation {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"新增地址";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:HexAColor(0x69696C, 1)];
    
}

- (void)createTableview {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"AddressCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    else
    {
        for(UIView *vv in cell.subviews)
        {
            [vv removeFromSuperview];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    
    
        
    //姓名
    UILabel *nameLab = [UILabel initCustom:CGRectMake(15, 18, 70, 20) title:_dataSource[indexPath.row] titleColor:HexAColor(0x69696C, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
    nameLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:nameLab];
    
    self.textField = [[UITextField alloc] init];
    
    CGSize textFieldSize;
    if (indexPath.row == 0) { //收货人
        
        self.contentStr = self.model.receiverName;
    }
    else if (indexPath.row == 1) { //号码
        
        self.contentStr = self.model.telephone;
    }
    else if (indexPath.row == 2) { //地区
        
        if (self.index) {
            
            self.contentStr = self.model.region;
        }
        else {
        
            self.contentStr = self.model.region;
        }
        
    }
    else if (indexPath.row == 3) { //详细地址
        
        self.contentStr = self.model.address;
        
        textFieldSize = [HQHelper calculateStringWithAndHeight:self.contentStr cgsize:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT) wordFont:FONT(16)];
        self.textField.frame = CGRectMake(101, 17, SCREEN_WIDTH-120, textFieldSize.height);
    }
    else if (indexPath.row == 4) { //邮编
        
        self.contentStr = self.model.postCode;
    }
    
    self.textField.frame = CGRectMake(101, 17, 260, 22);
    self.textField.placeholder = _placeholderArr[indexPath.row];
    self.textField.textColor = HexAColor(0x4A4A4A, 1);
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:16];
    self.textField.tag = 0x123+indexPath.row;
    self.textField.text = self.contentStr;
    [cell addSubview:self.textField];
    
    if (indexPath.row == 2) {
        
        //地图
        UIImageView *mapImgV = [[UIImageView alloc] init];
        mapImgV.frame = CGRectMake(SCREEN_WIDTH-20-24, 16, 24, 24);
        mapImgV.image = IMG(@"灰色地图");
        mapImgV.tag = 2;
        mapImgV.contentMode = UIViewContentModeCenter;
        mapImgV.userInteractionEnabled = YES;
        [cell addSubview:mapImgV];
        
        UITapGestureRecognizer *selectMapTap = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(selectAddress:)];
        selectMapTap.numberOfTapsRequired = 1;
        [mapImgV addGestureRecognizer:selectMapTap];
    }
    
    //线
    CGFloat rowGeight;
    if (indexPath.row==3) {
        
        rowGeight = 80;
    } else {
        
        rowGeight = 55;
    }
    
    if (indexPath.row<_dataSource.count-1) {
        
        UILabel *bottomLine = [[UILabel alloc] initWithFrame:CGRectMake(16, rowGeight, SCREEN_WIDTH-16, 0.5)];
        
        bottomLine.backgroundColor = CellSeparatorColor;
        [cell addSubview:bottomLine];
        
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=HexAColor(0xFFFFFF, 1);
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        
        return 80;
    } else {
    
        return 55;
    }
    
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    

    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark 点击事件

- (void)sureAction {

    [self requestData];
    
}

- (void)cancelAction {

    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//选择地区事件
- (void)selectAddress:(UITapGestureRecognizer *)recogniz {
    
    self.index = recogniz.view.tag;
    
//    HQTFSportController *mapVC = [[HQTFSportController alloc] init];
//    mapVC.locationAction = ^(TFLocationModel *locationModel) {
//        
////        self.model.address = locationModel.city;
//        self.model.region = locationModel.name;
//        
//        [self.tableview reloadData];
//    };
//    [self.navigationController pushViewController:mapVC animated:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    
    //    self.model.address = textField.text;
    NSInteger index = textField.tag - 0x123;
    
    if (index == 0) {
        
        self.model.receiverName = textField.text;
    }
    if (index == 1) {
        
        self.model.telephone = textField.text;
    }
    if (index == 2) {
        
        self.model.region = textField.text;
    }
    if (index == 3) {
        
        self.model.address = textField.text;
    }
    if (index == 4) {
        
        self.model.postCode = textField.text;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //当用户使用自动更正功能，把输入的文字修改为推荐的文字时，就会调用这个方法。
    //这对于想要加入撤销选项的应用程序特别有用
    //可以跟踪字段内所做的最后一次修改，也可以对所有编辑做日志记录,用作审计用途。
    //要防止文字被改变可以返回NO
    //这个方法的参数中有一个NSRange对象，指明了被改变文字的位置，建议修改的文本也在其中
    
    
    return YES;
}


//#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
////    if (resp.cmdId == HQCMD_addMyAddress) {
////        
////        [MBProgressHUD showError:@"新增成功!" toView:KeyWindow];
////        
////        [self.navigationController popViewControllerAnimated:YES];
////    }
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}

@end
