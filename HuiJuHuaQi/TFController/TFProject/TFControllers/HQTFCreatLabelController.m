//
//  HQTFCreatLabelController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatLabelController.h"
#import "HQTFLabelManageCell.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQSwitchCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFSelectColorController.h"
#import "TFProjLabelModel.h"
#import "TFProjectBL.h"

@interface HQTFCreatLabelController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,HQSwitchCellDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** labels */
//@property (nonatomic, strong) NSMutableArray *labels;


/** TFProjectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;


@end

@implementation HQTFCreatLabelController

//-(NSMutableArray *)labels{
//    if (!_labels) {
//        
//        NSArray *arr = @[HexColor(0x62b031, 1),HexColor(0x00bf8f, 1),HexColor(0x2ca9e1, 1),HexColor(0x4d5aaf, 1),HexColor(0xbb4898, 1),HexColor(0x674598, 1),HexColor(0xd3381c, 1),HexColor(0x00a3af, 1),HexColor(0x2a83a2, 1),HexColor(0xc97586, 1)];
//        
//        _labels = [NSMutableArray arrayWithArray:arr];
//    }
//    return _labels;
//}

-(TFProjLabelModel *)labelModel{
    if (!_labelModel) {
        _labelModel = [[TFProjLabelModel alloc] init];
        _labelModel.projectId = self.projectId;
        _labelModel.labelStatus = @0;
        _labelModel.labelColor = @"#51D0B1";
    }
    return _labelModel;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
}
#pragma mark - navi
- (void)setupNavigation{

    if (self.type == 0) {
        self.navigationItem.title = @"新建标签";
    }else{
        self.navigationItem.title = @"修改标签";
    }
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,70}];
    UIButton *button = [HQHelper buttonWithFrame:(CGRect){25,10,SCREEN_WIDTH-50,50} target:self action:@selector(sureClicked)];
    [view addSubview:button];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[HQHelper createImageWithColor:GreenColor] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    tableView.tableFooterView = view;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)sureClicked{
    
    if (!self.labelModel.labelName || [self.labelModel.labelName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入标签名" toView:KeyWindow];
        return;
    }
    if (self.labelModel.labelName.length > 5) {
        
        [MBProgressHUD showError:@"5个字以内" toView:KeyWindow];
        return;
    }
    
    if (!self.labelModel.labelColor || [self.labelModel.labelColor isEqualToString:@""]) {
        [MBProgressHUD showError:@"请选择标签颜色" toView:KeyWindow];
        return;
    }
    
    if (self.type == 0) {
        [self.projectBL requestAddProjLabelWithModel:self.labelModel];
    }else{
        [self.projectBL requestModProjLabelWithModel:self.labelModel];
    }
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"5个字以内";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(16);
        cell.textVeiw.text = self.labelModel.labelName;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = NO;
        cell.headMargin = 0;
        cell.textVeiw.userInteractionEnabled = YES;
        cell.bottomLine.hidden = YES;
        return cell;

        
    }else{
        
        if (indexPath.row == 0) {
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"选择颜色";
            cell.time.hidden = YES;
            UIView *view = [cell.contentView viewWithTag:0x1234];
            [view removeFromSuperview];
            
            UIButton *colorImage = [UIButton buttonWithType:UIButtonTypeCustom];
            [cell.contentView addSubview:colorImage];
            colorImage.tag = 0x1234;
            colorImage.frame = CGRectMake(101, 0, 30, 30);
            colorImage.centerY = 55/2;
            colorImage.userInteractionEnabled = NO;
            colorImage.layer.cornerRadius = 3;
            colorImage.layer.masksToBounds = YES;
            [colorImage setBackgroundImage:[HQHelper createImageWithColor:[HQHelper colorWithHexString:self.labelModel.labelColor]] forState:UIControlStateNormal];
            [colorImage setImage:[UIImage imageNamed:@"完成白色"] forState:UIControlStateNormal];
            
            return cell;
            
        }else{
            HQSwitchCell *cell = [HQSwitchCell switchCellWithTableView:tableView];
            cell.title.text = @"设置为本项目常用标签";
            cell.bottomLine.hidden = YES;
            cell.delegate = self;
            cell.switchBtn.on = [self.labelModel.labelStatus integerValue]==0?NO:YES;
            return cell;
            
        }
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            HQTFSelectColorController *selectColor = [[HQTFSelectColorController alloc] init];
            selectColor.color = self.labelModel.labelColor?self.labelModel.labelColor:@"#51D0B1";
            selectColor.colorAction = ^(TFProjLabelModel *model){
                
                self.labelModel.labelColor = model.labelColor;
                
                [tableView reloadData];
                
            };
            [self.navigationController pushViewController:selectColor animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    if (indexPath.row == 3) {
//        return [HQTFLabelManageCell refreshCellHeightWithItems:self.labels];
//    }else if (indexPath.row == 2){
//        return 40;
//    }else if (indexPath.row == 0){
//        return 8;
//    }
    
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return 0.5;
    }
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        return 64;
    }
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    if (section == 0) {
        view.backgroundColor = WhiteColor;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){26,12,SCREEN_WIDTH-52,40}];
        label.numberOfLines = 0;
        label.textColor = LightGrayTextColor;
        label.font = FONT(14);
        label.text = @"提示：协作标签对项目所有成员均可见，请谨慎添加、编辑和删除标签";
        [view addSubview:label];

        return view;
    }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    
    if (textView.tag == 0x12345) {
        
        if (textView.text.length > 5) {
            self.labelModel.labelName = [textView.text substringToIndex:5];
            textView.text = self.labelModel.labelName;
            return;
        }else{
            self.labelModel.labelName = textView.text;
        }
    }
    
}

#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    switchButton.on = !switchButton.on;
    self.labelModel.labelStatus = @(switchButton.on?2:0);
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_addProjLabel) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if (resp.cmdId == HQCMD_projectModLabel) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (self.refreshAction) {
        self.refreshAction();
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    
    if (resp.cmdId == HQCMD_addProjLabel) {
        
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
