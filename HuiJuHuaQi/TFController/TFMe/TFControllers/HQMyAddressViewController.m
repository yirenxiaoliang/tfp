//
//  HQMyAddressViewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMyAddressViewController.h"
#import "UILabel+Extension.h"
#import "HQAddAddressVC.h"
#import "AlertView.h"
#import "HQChangeAddressVC.h"
#import "TFMyAddressModel.h"

@interface HQMyAddressViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) TFMyAddressModel *myAddressModel;

@end

@implementation HQMyAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];

    [self requestData];
 
    _myAddressModel = [[TFMyAddressModel alloc] init];

}

- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"我的地址";
    
}

- (void)requestData {

    
}

- (void)createTableview {
    
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:BackGroudColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataSource.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"MyAddressCell";
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
    
    
    
    if (indexPath.section < _dataSource.count) {
        
        TFMyAddressModel *model = _dataSource[indexPath.section];
        //姓名
        UILabel *nameLab = [UILabel initCustom:CGRectMake(15, 15, 100, 25) title:model.receiverName titleColor:HexAColor(0x4A4A4A, 1) titleFont:18 bgColor:HexAColor(0xFFFFFF, 1)];
        nameLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:nameLab];
        
        //手机号码
        UILabel *numberLab = [UILabel initCustom:CGRectMake(SCREEN_WIDTH-15-150, 15, 150, 25) title:model.telephone titleColor:HexAColor(0x4A4A4A, 1) titleFont:18 bgColor:HexAColor(0xFFFFFF, 1)];
        numberLab.textAlignment = NSTextAlignmentRight;
        [cell addSubview:numberLab];
        
        //地址
        UILabel *addressLab = [UILabel initCustom:CGRectMake(15, 48, SCREEN_WIDTH-30, 22) title:model.address titleColor:HexAColor(0xA0A0AE, 1) titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        addressLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:addressLab];
        
        //分割线
        UILabel *lineLab = [UILabel initCustom:CGRectMake(15, 86, SCREEN_WIDTH-30, 1) title:@"" titleColor:HexAColor(0xA0A0AE, 1) titleFont:16 bgColor:HexAColor(0xE7E7E7, 1)];
        [cell addSubview:lineLab];
        
        //选择
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(15, 103, 20, 20);
        selectBtn.tag = 0x1234+indexPath.section;
        
        [selectBtn setImage:IMG(@"select") forState:UIControlStateNormal];
        if (indexPath.section == _index) {
            
            if ([_myAddressModel.isDefault isEqualToNumber:@1]) {
                
                [selectBtn setImage:IMG(@"selected") forState:UIControlStateNormal];
            }
            else {
                
                [selectBtn setImage:IMG(@"select") forState:UIControlStateNormal];
            }
        }
        
        
        [selectBtn addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell addSubview:selectBtn];
        
        //默认地址
        UILabel *defaultAddrLab = [UILabel initCustom:CGRectMake(45, 102, 120, 22) title:@"设为默认地址" titleColor:HexAColor(0x4A4A4A, 1) titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        defaultAddrLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:defaultAddrLab];
        
        //编辑按钮
        UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        editBtn.frame = CGRectMake(205, 99, 70, 28);
        [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [editBtn setTitleColor:HexAColor(0xA0A0AE, 1) forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        editBtn.layer.cornerRadius = 2.0;
        editBtn.tag = 100+indexPath.section;
        editBtn.layer.borderColor = [HexAColor(0xBBBBC3, 1) CGColor];
        editBtn.layer.borderWidth = 1.0f;
        [cell addSubview:editBtn];
        
        //删除按钮
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = CGRectMake(SCREEN_WIDTH-70-15, 99, 70, 28);
        [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleteBtn setTitleColor:HexAColor(0xA0A0AE, 1) forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.layer.cornerRadius = 2.0;
        deleteBtn.tag = 0x123 + indexPath.section;
        deleteBtn.layer.borderColor = [HexAColor(0xBBBBC3, 1) CGColor];
        deleteBtn.layer.borderWidth = 1.0f;
        [cell addSubview:deleteBtn];

    }
    
    
    if (indexPath.section == _dataSource.count) {
        
        //新增地址
        UILabel *AddLab = [UILabel initCustom:CGRectMake((SCREEN_WIDTH-100)/2.0, 15, 100, 25) title:@"新增地址" titleColor:HexAColor(0x20BF9A, 1) titleFont:18 bgColor:HexAColor(0xFFFFFF, 1)];
        AddLab.userInteractionEnabled = YES;
        [cell addSubview:AddLab];
        
        UITapGestureRecognizer *addTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addAddressAction:)];
        addTap.numberOfTapsRequired = 1;
        [AddLab addGestureRecognizer:addTap];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=HexAColor(0xFFFFFF, 1);
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == _dataSource.count) {
        
        return 55;
    } else {
    
        return 140;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == _dataSource.count) {
        
        return 20;
    } else {
        
        return 10;
    }
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(void)addAddressAction:(UITapGestureRecognizer *)recognizer {

    HQAddAddressVC *addVC = [[HQAddAddressVC alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)editAction:(UIButton *)button {

    NSInteger index = button.tag-100;
    TFMyAddressModel *model = _dataSource[index];
    HQChangeAddressVC *changeAddressVC = [[HQChangeAddressVC alloc] init];
    changeAddressVC.model = model;
    [self.navigationController pushViewController:changeAddressVC animated:YES];
}

- (void)deleteAction:(UIButton *)button {

    NSInteger index = button.tag-0x123;
    
    TFMyAddressModel *model = _dataSource[index];
    
    [AlertView showAlertView:@"删除地址" msg:@"删除后，该收货地址无法恢复" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
        
    } onRightTouched:^{
        
        NSDictionary *dic = @{
                              @"addressId":model.id
                              };
        
//        [self.setPersonInfoBL requestDelAddressData:dic];
    }];
}

- (void)setDefaultAction:(UIButton *)button {

//    button.selected = !button.selected;
    
    TFMyAddressModel *model = _dataSource[_index];
    
    if (button.tag-0x1234 == _index) {
    
        if ([_myAddressModel.isDefault isEqualToNumber:@1]) {
            
            _myAddressModel.isDefault = @0;
            
        }
        else {
            
            _myAddressModel.isDefault = @1;
        }
        
        

    }
    else {
    
        _myAddressModel.isDefault = @1;
    }
    
    NSDictionary *dic = @{
                          @"addressId":model.id,
                          @"isDefault":_myAddressModel.isDefault
                          };
    
//    [self.setPersonInfoBL requestModDefaultAddressData:dic];
    
    _index = button.tag-0x1234;
    
    [self.tableview reloadData];
    
}

#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    if (resp.cmdId == HQCMD_myAddressList) {
//        
//        _dataSource = resp.body;
//        
//        [self createTableview];
//    }
//    if (resp.cmdId == HQCMD_delAddress) {
//        
//        [MBProgressHUD showError:@"删除成功！" toView:KeyWindow];
//        
//        [self.tableview reloadData];
//    }
//    
//    
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}


@end
