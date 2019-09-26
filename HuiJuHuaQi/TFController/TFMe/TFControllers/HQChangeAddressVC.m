//
//  HQChangeAddressVC.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQChangeAddressVC.h"

#import "UILabel+Extension.h"
#import "TFMyAddressModel.h"
#import "TFLocationModel.h"

@interface HQChangeAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) TFMyAddressModel *myAddressModel;


@property (nonatomic, strong) UITextField *textField;

@end

@implementation HQChangeAddressVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancelAction) text:@"取消" textColor:HexAColor(0x69696C, 1)];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    
    [self createTableview];
    
    _dataSource = @[@"收货人",@"手机号码",@"选择地区",@"详细地址",@"邮政编码"];
    
}

- (void)setupNavigation {
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"修改地址";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sureAction) text:@"确定" textColor:HexAColor(0x20BF9A, 1)];
    
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
    
//    TFMyAddressModel *model = _dataSource[indexPath.row];
    
    //名称
    UILabel *nameLab = [UILabel initCustom:CGRectMake(15, 18, 70, 20) title:_dataSource[indexPath.row] titleColor:HexAColor(0x69696C, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
    nameLab.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:nameLab];

    //填写内容
    _textField = [[UITextField alloc] init];
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
        _textField.frame = CGRectMake(101, 17, SCREEN_WIDTH-120, textFieldSize.height);
    }
    else if (indexPath.row == 4) { //邮编
        
        self.contentStr = self.model.postCode;
    }
    
//    if (indexPath.row != 3) {
    
        _textField.frame = CGRectMake(101, 17, SCREEN_WIDTH-120, 22);
        
        _textField.tag = indexPath.row;
        _textField.textColor = HexAColor(0x4A4A4A, 1);
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.delegate = self;
        _textField.text = self.contentStr;
        [cell addSubview:_textField];
        
//    }

    if (indexPath.row == 2) {
        
        //地图
        UIImageView *mapImgV = [[UIImageView alloc] init];
        mapImgV.frame = CGRectMake(SCREEN_WIDTH-20-24, 16, 24, 24);
        mapImgV.image = IMG(@"灰色地图");
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
        
//         CGSize size = [HQHelper calculateStringWithAndHeight:self.model.address cgsize:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT) wordFont:FONT(16)];
        
//        return size.height;
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

//选择地区事件
- (void)selectAddress:(UITapGestureRecognizer *)recogniz {

    self.index = recogniz.view.tag;
    
//    HQTFSportController *mapVC = [[HQTFSportController alloc] init];
//    mapVC.locationAction = ^(TFLocationModel *locationModel) {
//        
//        self.model.region = locationModel.name;
//        
//        [self.tableview reloadData];
//    };
//    [self.navigationController pushViewController:mapVC animated:YES];
    
}

- (void)sureAction {

    
    TFMyAddressModel *model = [[TFMyAddressModel alloc] init];

    model.id = self.model.id;
    model.receiverName = self.model.receiverName;
    model.telephone = self.model.telephone;
    model.region = self.model.region;
    model.address = self.model.address;
    model.postCode = self.model.postCode;

}

//取消
- (void)cancelAction {

    [self.navigationController popViewControllerAnimated:YES];
    
}

//#pragma mark - 网络请求代理
//-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    if (resp.cmdId == HQCMD_modMyAddress) {
//        
//        [MBProgressHUD showError:@"修改成功！" toView:KeyWindow];
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}
//
//-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
//    
//    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
//}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    //返回BOOL值，指定是否允许文本字段结束编辑，当编辑结束，文本字段会让出first responder
    
//    self.model.address = textField.text;
    if (textField.tag == 0) {
        
        self.model.receiverName = textField.text;
    }
    if (textField.tag == 1) {
        
        self.model.telephone = textField.text;
    }
    if (textField.tag == 2) {
        
        self.model.region = textField.text;
    }
    if (textField.tag == 3) {
        
        self.model.address = textField.text;
    }
    if (textField.tag == 4) {
        
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

@end
