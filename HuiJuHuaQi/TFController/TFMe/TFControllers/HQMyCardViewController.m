//
//  HQMyCardViewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/4/14.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQMyCardViewController.h"
#import "UILabel+Extension.h"
#import "TFEmployModel.h"

#define BarCodeWidth (SCREEN_WIDTH - 36 - 100)

@interface HQMyCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSMutableArray *contentData;


@end

@implementation HQMyCardViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        
        [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:[UIColor clearColor] size:(CGSize){SCREEN_WIDTH,0.5}]];
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(didBack:) image:@"返回白色" highlightImage:@"返回白色"];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(20)}];
        
    }
}


-(UIStatusBarStyle)preferredStatusBarStyle {

    [self setNeedsStatusBarAppearanceUpdate];
    return UIStatusBarStyleLightContent;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigation];
    [self createTableview];
    [self createBottomLab];
    
    
    _dataSource = @[@"",@"公司",@"部门",@"职务",@""];
    
}
- (void)setupNavigation {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationItem.title = @"我的名片";
    
    
    UIBarButtonItem *editBtn = [self itemWithTarget:self action:@selector(editClicked) image:@"编辑-3" highlightImage:@"编辑-3"];
    UIBarButtonItem *shareBtn = [self itemWithTarget:self action:@selector(shareClicked) image:@"共享" highlightImage:@"共享"];
    NSArray *rightBtns=[NSArray arrayWithObjects:editBtn,shareBtn,nil];
    self.navigationItem.rightBarButtonItems = rightBtns;
    

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"二维码背景"]];
    
}

- (void)createBottomLab {

    UILabel *bottomLab = [UILabel initCustom:CGRectMake(70, SCREEN_HEIGHT-20-22, SCREEN_WIDTH-70-57, 22) title:@"Teamface—让工作连接一切!" titleColor:HexAColor(0xFFFFFF, 1) titleFont:16 bgColor:[UIColor clearColor]];
    [self.view addSubview:bottomLab];
}

- (void)createTableview {

    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(18,15+64, SCREEN_WIDTH-36, SCREEN_HEIGHT-64-15-62) style:UITableViewStylePlain];
    [_tableview setBackgroundColor:WhiteColor];
    _tableview.dataSource=self;
    _tableview.delegate=self;
//    _tableview.scrollEnabled = NO;
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;//    自动滚动调整
    [self.view addSubview:_tableview];
    _tableview.layer.masksToBounds = YES;
    _tableview.layer.cornerRadius = 4;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identify=@"MycardCell";
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

    
    
    if (indexPath.row == 0) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(20, 20, 40, 40);
        imgView.backgroundColor = [UIColor redColor];
        NSURL *url = [HQHelper URLWithString:UM.userLoginInfo.employee.picture];
        [imgView sd_setImageWithURL:url placeholderImage:PlaceholderHeadImage];
        [cell addSubview:imgView];
        
        CGSize nameSize = [HQHelper calculateStringWithAndHeight:UM.userLoginInfo.employee.employee_name cgsize:CGSizeMake(MAXFLOAT, 22) wordFont:FONT(16)];
        
        UILabel *nameLab = [UILabel initCustom:CGRectMake(70, 20, ceilf(nameSize.width), 22) title:UM.userLoginInfo.employee.employee_name titleColor:HexAColor(0x4A4A4A, 1) titleFont:16 bgColor:HexAColor(0xFFFFFF, 1)];
        [cell addSubview:nameLab];
        
        UILabel *numberLab = [UILabel initCustom:CGRectMake(70, 44, 150, 20) title:UM.userLoginInfo.employee.phone titleColor:HexAColor(0xA0A0AE, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        numberLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:numberLab];
        
        UIImageView *sexView = [[UIImageView alloc] init];
        sexView.frame = CGRectZero;
        if ([UM.userLoginInfo.employee.sex isEqualToString:@"0"]) {
            
            sexView.hidden = NO;
            sexView.image = IMG(@"男");
        }
        else if ([UM.userLoginInfo.employee.sex isEqualToString:@"1"]) {
            
            sexView.hidden = NO;
            sexView.image = IMG(@"女");
        }else{
        
            sexView.hidden = YES;
        }
        [cell addSubview:sexView];
        
        [sexView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(nameLab.mas_right).offset(5);
            make.top.mas_equalTo(cell).offset(27);
            make.width.height.mas_equalTo(10);
        }];
    }
    else if (indexPath.row == 4) {
    
        UIImageView *scanerView = [[UIImageView alloc] init];
        scanerView.frame = CGRectMake((SCREEN_WIDTH-36-BarCodeWidth)/2, 20,BarCodeWidth, BarCodeWidth);
//        TFEmployModel *model = [[TFEmployModel alloc] init];
//        model.employee_name = UM.userLoginInfo.employee.employee_name;
//        model.id = [UM.userLoginInfo.employee.id description];
//        model.post_name = UM.userLoginInfo.employee.post_name;
//        model.phone = UM.userLoginInfo.employee.phone;
//
//        NSString *str = @"";
//        for (TFDepartmentCModel *model in UM.userLoginInfo.departments) {
//            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.department_name]];
//        }
//        model.departmentName = [str substringToIndex:str.length-1];
//
//        NSString *personInfo = [model toJSONString];
        // 1-->2  可知名字range
        // 2-->3  可知公司range
        // 3-->4  可知职位range
        // 4-->5  可知备注range
        // 5-->6  可知电话号码range
        // 6-->7  可知公司地址range
        // 8-->9  可知公司网址range
        // 9-->10  可知Emailrange
        //@"BEGIN:VCARD\nVERSION:3.0\nN:%@\nORG:%@\nTITLE:%@\nNOTE:%@\nTEL:%@\nADR;TYPE=WORK:%@\nADR;TYPE=HOME:%@\nTEL;TYPE=WORK,VOICE:%@\nURL:%@\nEMAIL:%@\nEND:VCARD"
        NSString *code = [NSString stringWithFormat:@"BEGIN:VCARD\nVERSION:3.0\nN:%@\nORG:%@\nTITLE:%@\nNOTE:%@\nTEL:%@\nADR;TYPE=WORK:%@\nADR;TYPE=HOME:%@\nTEL;TYPE=WORK,VOICE:%@\nURL:%@\nEMAIL:%@\nEND:VCARD",TEXT(UM.userLoginInfo.employee.employee_name),TEXT(UM.userLoginInfo.company.company_name),TEXT(UM.userLoginInfo.employee.post_name),@"",TEXT(UM.userLoginInfo.employee.phone),TEXT(UM.userLoginInfo.company.address),@"",@"",TEXT(UM.userLoginInfo.company.website),TEXT(UM.userLoginInfo.employee.email)];
        
        scanerView.image = [HQHelper creatBarcodeWithString:code withImgWidth:BarCodeWidth];
        [cell addSubview:scanerView];
        
        UILabel *nameLab = [UILabel initCustom:CGRectMake(0, CGRectGetMaxY(scanerView.frame)+ 20, SCREEN_WIDTH-30, 20) title:@"微信扫描二维码保存联系人" titleColor:HexAColor(0xBBBBC3, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        [cell addSubview:nameLab];
        
        
        
    }
    else {
    
        UILabel *titleLab = [UILabel initCustom:CGRectMake(40, 16, 30, 17) title:_dataSource[indexPath.row] titleColor:HexAColor(0x69696C, 1) titleFont:12 bgColor:HexAColor(0xFFFFFF, 1)];
        titleLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:titleLab];
        
        NSString *contentStr;
        
        if (indexPath.row==1) {
            
            contentStr = UM.userLoginInfo.company.company_name;
        }
        else if (indexPath.row==2) {
            NSString *str = @"";
            for (TFDepartmentCModel *model in UM.userLoginInfo.departments) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",model.department_name]];
            }
            
            contentStr = [str substringToIndex:str.length-1];
        }
        else if (indexPath.row==3) {
            
            contentStr = UM.userLoginInfo.employee.post_name;
        }
        
        UILabel *contentLab = [UILabel initCustom:CGRectMake(79, 14, 200, 20) title:contentStr titleColor:HexAColor(0x4A4A4A, 1) titleFont:14 bgColor:HexAColor(0xFFFFFF, 1)];
        contentLab.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:contentLab];
    }
    
    
    //线
    CGFloat rowGeight;
    if (indexPath.row==0) {
        
        rowGeight = 76;
    } else {
    
        rowGeight = 45;
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
    
    if (indexPath.row == 0) {
        
        return 76;
    } else if (indexPath.row == 7) {
    
        return 176;
    } else if (indexPath.row == 4) {
        
        return BarCodeWidth + 40 + 40;
    } else {
    
        return 45;
    }

    return 1;
}

- (void)editClicked {

    
}

- (void)shareClicked {
    
    
}
@end
