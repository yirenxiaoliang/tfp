
//
//  HQTFCreatProjectController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFCreatProjectController.h"
#import "HQCreatScheduleTitleCell.h"
#import "HQSelectTimeCell.h"
#import "HQTFPeopleCell.h"
#import "HQTFProjectDescController.h"
#import "HQTFAddPeopleController.h"
#import "HQTFChoicePeopleController.h"
#import "HQTFRelateProjectController.h"
#import "HQTFCustomerCompanyController.h"
#import "HQTFProjectCategoryController.h"
#import "HQTFSelectDateView.h"
#import "NSDate+NSString.h"
#import "HQTFMorePeopleCell.h"
#import "FDActionSheet.h"
#import "HQSelectTimeView.h"
#import "HQTFProjectModelController.h"
#import "HQTFProjectStateCell.h"
#import "HQWriteContentCell.h"
#import "AlertView.h"
#import "TFProjectBL.h"
#import "TFProjectCatagoryItemModel.h"
#import "TFProjectDetailModel.h"
#import "HQEmployModel.h"
#import "HQTFProjectMainController.h"

@interface HQTFCreatProjectController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,FDActionSheetDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, strong) UITableView *tableView;
/** one */
@property (nonatomic, weak) UIButton *oneBtn;
/** two */
@property (nonatomic, weak) UIButton *twoBtn;

/** UIView *view */
@property (nonatomic, strong) UIView *twoBtnView;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;
/**  项目详情 */
@property (nonatomic, strong) TFProjectDetailModel *projectDetail;

/** permission 0:无新建公开项目权限 1：新建公开 */
@property (nonatomic, assign) BOOL openPermission;
/** permission 0:无新建bu公开项目权限 1：新建不公开 */
@property (nonatomic, assign) BOOL noOpenPermission;
/** permission 0:无管理公开项目权限 1：不公开 */
@property (nonatomic, assign) BOOL manageOpenPermission;

@end

@implementation HQTFCreatProjectController


-(HQTFCreatProjectModel *)creatProject{
    
    if (!_creatProject) {
        _creatProject = [[HQTFCreatProjectModel alloc] init];
        _creatProject.isPublic = @0;
//        _creatProject.categoryName = @"项目协作";
    }
    return _creatProject;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == CreatProjectControllerTypeCreate) {
        
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavigation];
    [self setupTwoBtn];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    
    if (self.type == CreatProjectControllerTypeEdit) {
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        [self.projectBL requestGetProjectDetailWithProjectId:self.creatProject.id];
    }else{
        
        [self.projectBL requestGetCategoryListWithPageNum:1 pageSize:10];
    }
    
    [self.projectBL getPermissionWithModuleId:@1110];
    
}

- (void)refreshBtnsWithType:(ProjectStateCellType)type{
    
    switch (type) {
        case ProjectStateCellOutDate:
        case ProjectStateCellGoOn:
        case ProjectStateCellFinish:
        {
            
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
            [self.twoBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [self.twoBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
            [self.oneBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.oneBtn setTitle:@"删除" forState:UIControlStateHighlighted];
            [self.twoBtn setTitle:@"暂停" forState:UIControlStateNormal];
            [self.twoBtn setTitle:@"暂停" forState:UIControlStateHighlighted];
        }
            break;
            
        case ProjectStateCellPause:
        {
            
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
            [self.twoBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            [self.twoBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
            [self.oneBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.oneBtn setTitle:@"删除" forState:UIControlStateHighlighted];
            [self.twoBtn setTitle:@"启动" forState:UIControlStateNormal];
            [self.twoBtn setTitle:@"启动" forState:UIControlStateHighlighted];
        }
            break;
        case ProjectStateCellDelete:
        {
            
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
            [self.oneBtn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
            [self.twoBtn setTitleColor:GreenColor forState:UIControlStateNormal];
            [self.twoBtn setTitleColor:GreenColor forState:UIControlStateHighlighted];
            [self.oneBtn setTitle:@"彻底删除" forState:UIControlStateNormal];
            [self.oneBtn setTitle:@"彻底删除" forState:UIControlStateHighlighted];
            [self.twoBtn setTitle:@"还原" forState:UIControlStateNormal];
            [self.twoBtn setTitle:@"还原" forState:UIControlStateHighlighted];
        }
            break;
            
            
        default:
            break;
    }
}

- (void)setupTwoBtn{
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,SCREEN_HEIGHT-64-60,SCREEN_WIDTH,60}];
    self.twoBtnView = view;
    view.backgroundColor = WhiteColor;
//    [self.view addSubview:view];
    for (NSInteger i = 0; i < 2; i++) {
        
        UIButton *btn = [HQHelper buttonWithFrame:(CGRect){SCREEN_WIDTH/2*i,0,SCREEN_WIDTH/2,60} target:self action:@selector(btnClicked:)];
        btn.tag = 0x11 + i;
        [view addSubview:btn];
        btn.titleLabel.font = FONT(20);
        [btn setTitleColor:LightBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:LightBlackTextColor forState:UIControlStateHighlighted];
        
        if (i == 0) {
            [btn setTitle:@"删除" forState:UIControlStateNormal];
            [btn setTitle:@"删除" forState:UIControlStateHighlighted];
            self.oneBtn = btn;
        }else{
            [btn setTitle:@"暂停" forState:UIControlStateNormal];
            [btn setTitle:@"暂停" forState:UIControlStateHighlighted];
            self.twoBtn = btn;
        }
    }
    
    UIView *sepe = [[UIView alloc] initWithFrame:(CGRect){0,0,0.5,20}];
    [view addSubview:sepe];
    sepe.backgroundColor = CellSeparatorColor;
    sepe.centerY = view.height/2;
    sepe.centerX = SCREEN_WIDTH/2;
}

- (void)btnClicked:(UIButton *)button{
    
    
    if (self.type == CreatProjectControllerTypeEdit) {
        
        if ([self.creatProject.isPublic isEqualToNumber:@1]) {// 公开
            
            if (self.manageOpenPermission) {
                // 有权限就可以执行后面的代码
            }else{
                
                if ([self.creatProject.permission isEqualToNumber:@0]) {
                    [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                    return;
                }
            }
            
            
        }else{// 不公开
            
            if ([self.creatProject.permission isEqualToNumber:@0]) {
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
        }
    }

    /**项目状态:0=进行中;1=已完成;2=暂停;3=回收站*/
    if ([self.creatProject.projectStatus isEqualToNumber:@0] || [self.creatProject.isOverdue isEqualToNumber:@1] || [self.creatProject.projectStatus isEqualToNumber:@1] ) {// 进行、超期、完成
        
        switch (button.tag-0x11) {
            case 0:
            {
                [AlertView showAlertView:@"删除项目" msg:@"项目所有成员将无法操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    self.creatProject.projectStatus = @3;// 回收站
                    [self.projectBL requestUpdateProjectStatusWithProjectId:self.creatProject.id projectStatus:self.creatProject.projectStatus];
                }];
            }
                break;
            case 1:
            {
                [AlertView showAlertView:@"暂停项目" msg:@"项目所有成员将无法操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    /** 项目状态：0进行中（创建一开始就是进入进行中）、1已完成、2暂停 3回收站 */
                    self.creatProject.projectStatus = @2;// 暂停
                    [self.projectBL requestUpdateProjectStatusWithProjectId:self.creatProject.id projectStatus:self.creatProject.projectStatus];
                }];
            }
                break;
                
            default:
                break;
        }
    }else if ([self.creatProject.projectStatus isEqualToNumber:@2] ){// 暂停
        switch (button.tag-0x11) {
            case 0:
            {
                if ([self.creatProject.projectStatus isEqualToNumber:@2]) {
                    [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
                    return;
                }
                [AlertView showAlertView:@"删除项目" msg:@"项目所有成员将无法操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    self.creatProject.projectStatus = @3;// 回收站
                    [self.projectBL requestUpdateProjectStatusWithProjectId:self.creatProject.id projectStatus:self.creatProject.projectStatus];
                }];
            }
                break;
            case 1:
            {
                [AlertView showAlertView:@"启动项目" msg:@"项目所有成员可进行操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    
                    self.creatProject.projectStatus = @0;// 进行中
                    [self.projectBL requestUpdateProjectStatusWithProjectId:self.creatProject.id projectStatus:self.creatProject.projectStatus];
                }];
            }
                break;
                
            default:
                break;
        }

    }else{// 删除
        switch (button.tag-0x11) {
            case 0:
            {
                [AlertView showAlertView:@"彻底删除项目" msg:@"项目所有成员将无法操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    // 彻底删除
                    [self.projectBL requestDeleteProjectWithProjectId:self.creatProject.id];
                }];
            }
                break;
            case 1:
            {
                [AlertView showAlertView:@"还原项目" msg:@"项目所有成员可进行操作及预览" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
                    
                } onRightTouched:^{
                    
                    // 还原
                    self.creatProject.projectStatus = @0;// 进行中
                    [self.projectBL requestUpdateProjectStatusWithProjectId:self.creatProject.id projectStatus:self.creatProject.projectStatus];
                }];
            }
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark - Navigation
- (void)setupNavigation{
    if (self.type == CreatProjectControllerTypeCreate) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"创建" textColor:GreenColor];
        
        self.navigationItem.title = @"新建项目";
    }else{
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"完成" textColor:GreenColor];
        
        self.navigationItem.title = @"项目设置";
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sure{
    
    if (self.type == CreatProjectControllerTypeEdit) {
        
        if ([self.creatProject.projectStatus isEqualToNumber:@2]) {
            [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
            return;
        }
        if ([self.creatProject.projectStatus isEqualToNumber:@3]) {
            [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
            return;
        }
        
        if ([self.creatProject.isPublic isEqualToNumber:@1]) {// 公开
            
            if (self.manageOpenPermission) {
                // 有权限就可以执行后面的代码
            }else{
                
                if ([self.creatProject.permission isEqualToNumber:@0]) {
                    [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                    return;
                }
            }
            
            
        }else{// 不公开
            
            if ([self.creatProject.permission isEqualToNumber:@0]) {
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
        }
    }
    
    [self.view endEditing:YES];
    
    if (!self.creatProject.projectName || [self.creatProject.projectName isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入项目名称" toView:KeyWindow];
        return;
    }
    if (self.creatProject.endTime && ![self.creatProject.endTime isEqualToNumber:@0]) {
        
        if ([self.creatProject.endTime longLongValue] < [HQHelper getNowTimeSp]) {
            [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:KeyWindow];
            return ;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    if (self.type == CreatProjectControllerTypeCreate) {
        
        [self.projectBL requestCreateProjectWithModel:self.creatProject];
        
    }else{
        
        [self.projectBL requestUpdateProjectWithModel:self.creatProject];
    }
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    self.tableView = tableView;
    
    if (self.type == CreatProjectControllerTypeCreate) {
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self.view addSubview:tableView];
    }else{
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - 70);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }
    else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
        cell.textVeiw.placeholder = @"项目名称20个字以内(必填)";
        cell.textVeiw.placeholderColor = PlacehoderColor;
        cell.textVeiw.delegate = self;
        cell.textVeiw.font = FONT(20);
        cell.textVeiw.text = self.creatProject.projectName;
        cell.textVeiw.tag = 0x12345;
        cell.bottomLine.hidden = YES;
        cell.textVeiw.userInteractionEnabled = YES;

        if (self.type == CreatProjectControllerTypeEdit) {
            cell.textVeiw.userInteractionEnabled = NO;
        }
        return cell;
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            if (self.type == CreatProjectControllerTypeCreate) {
                
                HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
                cell.timeTitle.text = @"可见范围";
                cell.arrowShowState = YES;
                cell.time.textColor = LightBlackTextColor;
                if ([self.creatProject.isPublic isEqualToNumber:@0]) {
                    cell.time.text = @"不公开：只有加入的成员可见此项目";
                }else{
                    cell.time.text = @"公开：企业所有成员都可见此项目";
                }
                cell.bottomLine.hidden = NO;
                return  cell;
            }else{
                HQTFProjectStateCell *cell = [HQTFProjectStateCell projectStateCellWithTableView:tableView];
                
                if (![self.creatProject.projectStatus isEqualToNumber:@0]) {
                    
                    cell.type = (ProjectStateCellType)[self.creatProject.projectStatus integerValue];
                }else{
                    
                    if ([self.creatProject.isOverdue integerValue] == 1) {
                        
                        cell.type = ProjectStateCellOutDate;
                    }else{
                        cell.type = ProjectStateCellGoOn;
                    }
                }
                
                return cell;
            }
            
        }else if (indexPath.row == 1){
            /*HQTFPeopleCell *cell = [HQTFPeopleCell peopleCellWithTableView:tableView];
            cell.peoples = @[@"负责人",@"负责人"];
            cell.titleLabel.text = @"负责人";
            if (!self.creatProject.chargePeople) {
                cell.contentLabel.text = @"请添加负责人";
                cell.contentLabel.textColor = PlacehoderColor;
            }else{
                cell.contentLabel.text = self.creatProject.chargePeople;
                cell.contentLabel.textColor = LightBlackTextColor;
            }
            cell.bottomLine.hidden = NO;*/
            HQTFMorePeopleCell *cell = [HQTFMorePeopleCell morePeopleCellWithTableView:tableView];
            [cell refreshMorePeopleCellWithPeoples:self.creatProject.employees];
            cell.bottomLine.hidden = NO;
            cell.titleLabel.text = @"负责人";
            
            if (!self.creatProject.employeeIds || self.creatProject.employeeIds.count == 0) {
                
                cell.contentLabel.textAlignment = NSTextAlignmentLeft;
                cell.contentLabel.text = @"请添加";
                cell.contentLabel.textColor = PlacehoderColor;
            }else{
                
                cell.contentLabel.textAlignment = NSTextAlignmentRight;
                cell.contentLabel.text = [NSString stringWithFormat:@"%ld人",self.creatProject.employeeIds.count];
                cell.contentLabel.textColor = LightBlackTextColor;
            }
            return cell;
        }else if (indexPath.row == 2){
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"截止时间";
            cell.arrowShowState = YES;
            if (!self.creatProject.endTime || [self.creatProject.endTime isEqualToNumber:@0]) {
                cell.time.text = @"请选择";
                cell.time.textColor = PlacehoderColor;
            }else{
                cell.time.text = [HQHelper nsdateToTime:[self.creatProject.endTime longLongValue] formatStr:@"yyyy-MM-dd"];
                
                if ([self.creatProject.isOverdue integerValue] == 1) {
                    
                    cell.time.textColor = RedColor;
                }else{
                    cell.time.textColor = LightBlackTextColor;
                }
            }
            cell.bottomLine.hidden = NO;
            return  cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = @"项目模板";
            cell.arrowShowState = YES;
            cell.time.text = self.creatProject.categoryName;
            cell.time.textColor = LightBlackTextColor;
            
            cell.bottomLine.hidden = YES;
            if (self.type == CreatProjectControllerTypeEdit) {
                
                cell.bottomLine.hidden = NO;
            }
            return  cell;
        }
        
    }else{
        
        if (self.type == CreatProjectControllerTypeCreate) {
            
            HQCreatScheduleTitleCell *cell = [HQCreatScheduleTitleCell creatScheduleTitleCellWithTableView:tableView];
            cell.textVeiw.placeholder = @"为项目写点描述（500字以内）";
            cell.textVeiw.placeholderColor = PlacehoderColor;
            cell.textVeiw.delegate = self;
            cell.textVeiw.font = FONT(16);
            cell.textVeiw.text = self.creatProject.descript;
            cell.textVeiw.tag = 0x12345;
            cell.bottomLine.hidden = YES;
            //        cell.textVeiw.selectable = NO;
            //        cell.textVeiw.editable = NO;
            cell.textVeiw.textColor = LightBlackTextColor;
            cell.textVeiw.userInteractionEnabled = NO;
            return cell;
        }else{
            
            HQWriteContentCell *writeCell = [HQWriteContentCell writeContentCellWithTableView:tableView];
            writeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            writeCell.title.text = @"项目描述";
            writeCell.content.delegate = self;
            writeCell.content.tag = 0x222;
            writeCell.content.placeholder = @"";
            writeCell.content.placeholderColor = CellSeparatorColor;
            writeCell.topLine.hidden = YES;
            writeCell.content.editable = NO;
            writeCell.content.scrollEnabled = NO;
            writeCell.content.text = self.creatProject.descript;
            writeCell.content.userInteractionEnabled = NO;
            return writeCell;
        }
        
        
    }
     
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == CreatProjectControllerTypeEdit) {
        if ([self.creatProject.projectStatus isEqualToNumber:@2]) {
            [MBProgressHUD showError:@"项目已暂停，不可进行编辑操作" toView:KeyWindow];
            return;
        }
        
        if ([self.creatProject.projectStatus isEqualToNumber:@3]) {
            [MBProgressHUD showError:@"项目已删除，不可进行编辑操作" toView:KeyWindow];
            return;
        }
        
        if ([self.creatProject.isPublic isEqualToNumber:@1]) {// 公开
            
            if (self.manageOpenPermission) {
                // 有权限就可以执行后面的代码
            }else{
                
                if ([self.creatProject.permission isEqualToNumber:@0]) {
                    [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                    return;
                }
            }
            
            
        }else{// 不公开
            
            if ([self.creatProject.permission isEqualToNumber:@0]) {
                [MBProgressHUD showError:@"您无权限" toView:KeyWindow];
                return;
            }
        }

    }
    
    
    if (indexPath.section == 0) {
        
        if (self.type == CreatProjectControllerTypeEdit) {
            
            
            
            HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
            desc.descString = self.creatProject.projectName;
            desc.type = 0;
            desc.descAction = ^(NSString *text){
                
                if (text.length > 20) {
                    self.creatProject.projectName = [text substringToIndex:20];
                    [MBProgressHUD showError:@"20个字以内" toView:self.view];
                }else{
                    
                    self.creatProject.projectName = text;
                }
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:desc animated:YES];
        }
    }
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            if (self.type == CreatProjectControllerTypeCreate) {
                
                if (self.openPermission && !self.noOpenPermission) {
                    
                    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"可见范围" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"公开：企业所有成员都可见此项目", nil];
                    [sheet setButtonTitleColor:GreenColor bgColor:WhiteColor fontSize:FONT(18) atIndex:0];
                    
                    [sheet show];
                }else if (!self.openPermission && self.noOpenPermission){
                    
                    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"可见范围" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不公开：只有加入的成员可见此项目", nil];
                    [sheet setButtonTitleColor:GreenColor bgColor:WhiteColor fontSize:FONT(18) atIndex:0];
                    
                    [sheet show];
                }else if (self.openPermission && self.noOpenPermission){
                    
                    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"可见范围" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"不公开：只有加入的成员可见此项目",@"公开：企业所有成员都可见此项目", nil];
                    [sheet setButtonTitleColor:GreenColor bgColor:WhiteColor fontSize:FONT(18) atIndex:[self.creatProject.isPublic integerValue]];
                    
                    [sheet show];
                }else{
                    
                }
                
            }
            
        }else if (indexPath.row == 1) {
            
            
            if (self.type == CreatProjectControllerTypeCreate) {
            
//                HQTFAddPeopleController *addPeople = [[HQTFAddPeopleController alloc] init];
//                addPeople.isMutual = YES;
//                addPeople.type = ChoicePeopleTypeCreateProjectPrincipal;
////                addPeople.projectItem = self.projectItem;
//                addPeople.actionParameter = ^(NSArray *peoples){
//                    
//                    self.creatProject.employees = [NSMutableArray arrayWithArray:peoples];
//                    
//                    NSMutableArray *ids = [NSMutableArray array];
//                    for (HQEmployModel *model in peoples) {
//                        
//                        [ids addObject:model.id];
//                    }
//                    self.creatProject.employeeIds = ids;
//                    
//                    [self.tableView reloadData];
//                    
//                    
//                };
//                
//                [self.navigationController pushViewController:addPeople animated:YES];
                
                
                HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
                choice.projectItem = self.projectItem;
                choice.isMutual = YES;
                choice.type = ChoicePeopleTypeCreateProjectPrincipal;
                choice.employees = self.creatProject.employees;
                choice.Id = self.creatProject.id;
                
                choice.sectionTitle = @"项目负责人";
                choice.rowTitle = @"添加负责人";
                if (self.creatProject.employees == nil || !self.creatProject.employees.count) {
                    choice.instantPush = YES;
                }
                
                choice.actionParameter = ^(NSArray *employees){
                    
                    self.creatProject.employees = [NSMutableArray arrayWithArray:employees];

                    NSMutableArray *ids = [NSMutableArray array];
                    for (HQEmployModel *model in employees) {

                        [ids addObject:model.id];
                    }
                    self.creatProject.employeeIds = ids;
                    
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:choice animated:YES];
                
            }else{
                if ([self.creatProject.permission isEqualToNumber:@2]) {
                    HQTFChoicePeopleController *choice = [[HQTFChoicePeopleController alloc] init];
                    choice.projectItem = self.projectItem;
                    choice.isMutual = YES;
                    choice.employees = self.creatProject.employees;
                    choice.Id = self.creatProject.id;
                    
                    choice.sectionTitle = @"项目负责人";
                    choice.rowTitle = @"添加负责人";
                    if (self.creatProject.employees == nil || !self.creatProject.employees.count) {
                        choice.instantPush = YES;
                    }
                    
                    choice.actionParameter = ^(NSArray *employees){
                        
                        self.creatProject.employees = [NSMutableArray arrayWithArray:employees];
                        
                        NSMutableArray *ids = [NSMutableArray array];
                        for (HQEmployModel *model in employees) {
                            
                            [ids addObject:model.id?model.id:model.employeeId];
                        }
                        self.creatProject.employeeIds = ids;
                        
                        [self.projectBL requestModifyProjectPrincipalWithProjectId:self.creatProject.id teamEmpIds:ids];
//                        [self.tableView reloadData];
                    };
                    [self.navigationController pushViewController:choice animated:YES];
                }
                
            }
            
        }else if (indexPath.row == 2) {
            
            [HQSelectTimeView selectTimeViewWithType:SelectTimeViewType_YearMonthDay timeSp:[self.creatProject.endTime longLongValue]==0?[HQHelper getNowTimeSp]:[self.creatProject.endTime longLongValue] LeftTouched:^{
                
            } onRightTouched:^(NSString *time) {
                
                HQLog(@"%@",time);
                
                if ([time isEqualToString:@""]) {// 清空
                    
                    self.creatProject.endTime = [NSNumber numberWithLongLong:0];
                    [self.tableView reloadData];
                    return ;
                }
                
                long long timeSp = [HQHelper changeTimeToTimeSp:[NSString stringWithFormat:@"%@ 23:59:59",time] formatStr:@"yyyy-MM-dd HH:mm:ss"];
                
                if (timeSp < [HQHelper getNowTimeSp]) {
                    [MBProgressHUD showError:@"截止时间不可小于当前时间" toView:KeyWindow];
                    return ;
                }
                
                self.creatProject.endTime = [NSNumber numberWithLongLong:timeSp];
                [self.tableView reloadData];
            }];
            
        }else{
            HQTFProjectModelController *model = [[HQTFProjectModelController alloc] init];
            model.categoryId = self.creatProject.categoryId;
            model.projectModel = ^(TFProjectCatagoryItemModel *parameter){
               
                self.creatProject.categoryId = parameter.id;
                self.creatProject.categoryName = parameter.categoryName;
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:model animated:YES];
        }
    }
    
    
    if (indexPath.section == 2) {
        
        HQTFProjectDescController *desc = [[HQTFProjectDescController alloc] init];
        desc.descString = self.creatProject.descript;
        desc.type = 1;
        desc.descAction = ^(NSString *text){
            if (text.length > 500) {
                
                self.creatProject.descript = [text substringToIndex:500];
                [MBProgressHUD showError:@"500个字以内" toView:self.view];
            }else{
                
                self.creatProject.descript = text;
            }
            
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:desc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 2){
        
        if (self.type == CreatProjectControllerTypeCreate) {
            
            CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:self.creatProject.descript];
            
            return size.height >= 80 ? size.height + 30 : 80;
        }else{
            
            CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-120,MAXFLOAT} titleStr:self.creatProject.descript];
            
            return size.height >= 80 ? size.height + 30 : 80;
        }
    }
    return 55;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.type == CreatProjectControllerTypeCreate) {
        
        if (section == 2) {
            return 44;
        }
        return 0;
    }else{
        
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2 || section == 1) {
        return 0;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == CreatProjectControllerTypeCreate) {
        
        if (section == 2) {
            return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-10,35} text:@"    项目描述" textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
        }
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
   
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.tag == 0x12345) {
        
        if (textView.text.length > 20) {
            
            self.creatProject.projectName = [textView.text substringToIndex:20];
            textView.text = self.creatProject.projectName;
            [MBProgressHUD showError:@"20个字以内" toView:self.view];
        }else{
            self.creatProject.projectName = textView.text;
        }
    }
}

- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    if (self.openPermission && !self.noOpenPermission) {
        self.creatProject.isPublic = @1;
    }
    
    if (!self.openPermission && self.noOpenPermission) {
        self.creatProject.isPublic = @0;
    }
    
    if (self.openPermission && self.noOpenPermission) {
        self.creatProject.isPublic = @(buttonIndex);
    }
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    if (resp.cmdId == HQCMD_addProject) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        [self.navigationController popViewControllerAnimated:self];
    }
    if (resp.cmdId == HQCMD_updateProject) {
        
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        if ([self.creatProject.isOverdue isEqualToNumber:@1]) {
            [self refreshBtnsWithType:ProjectStateCellOutDate];
        }else{
            [self refreshBtnsWithType:(ProjectStateCellType)[self.creatProject.projectStatus integerValue]];
        }
        [self.tableView reloadData];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_getProjectDetail) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        [self.view addSubview:self.tableView];
               
        self.projectDetail = resp.body;
        
        self.creatProject = [HQTFCreatProjectModel changeProjectItemToCreatProjectModelWithProjectItem:self.projectDetail.project];
        
        NSMutableArray *employeeIds = [NSMutableArray array];
        NSMutableArray *employees = [NSMutableArray array];
        for (HQEmployModel *model in self.projectDetail.participantEmpIds) {
            [employeeIds addObject:model.id?model.id:model.employeeId];
            
            [employees addObject:model];
        }
        self.creatProject.employees = employees;
        self.creatProject.employeeIds = employeeIds;
        
        if (![self.creatProject.permission isEqualToNumber:@0]) {
            
//            if ([self.creatProject.isOverdue isEqualToNumber:@1]) {
//                [self refreshBtnsWithType:ProjectStateCellOutDate];
//            }else{
//                [self refreshBtnsWithType:(ProjectStateCellType)[self.creatProject.projectStatus integerValue]];
            //            }
            [self.view addSubview:self.twoBtnView];
            self.twoBtnView.hidden = NO;
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
            if (![self.creatProject.projectStatus isEqualToNumber:@0]) {
                
                [self refreshBtnsWithType:(ProjectStateCellType)[self.creatProject.projectStatus integerValue]];
            }else{
                
                if ([self.creatProject.isOverdue integerValue] == 1) {
                    
                    [self refreshBtnsWithType:ProjectStateCellOutDate];
                }else{
                    [self refreshBtnsWithType:ProjectStateCellGoOn];
                }
            }
            
        }else{
            self.navigationItem.rightBarButtonItem = nil;
            [self.view addSubview:self.twoBtnView];
            self.twoBtnView.hidden = YES;
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
        // 详情时
        [self.tableView reloadData];
        
    }
    
    
    if (resp.cmdId == HQCMD_updateProjectStatus) {
        
        /** 项目状态: 0=进行中;1=已完成;2=暂停;3=已删除 */
        
//        if ([self.creatProject.isOverdue isEqualToNumber:@1]) {
//            [self refreshBtnsWithType:ProjectStateCellOutDate];
//        }else{
//            [self refreshBtnsWithType:(ProjectStateCellType)[self.creatProject.projectStatus integerValue]];
//        }
        
        if (![self.creatProject.projectStatus isEqualToNumber:@0]) {
            
            [self refreshBtnsWithType:(ProjectStateCellType)[self.creatProject.projectStatus integerValue]];
        }else{
            
            if ([self.creatProject.isOverdue integerValue] == 1) {
                
                [self refreshBtnsWithType:ProjectStateCellOutDate];
            }else{
                [self refreshBtnsWithType:ProjectStateCellGoOn];
            }
        }
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_projectDelete) {
        
        for (UIViewController *vc  in self.navigationController.childViewControllers) {
            
            if ([vc isKindOfClass:[HQTFProjectMainController class]]) {
                
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
        
    }
    
    if (resp.cmdId == HQCMD_getCategoryList) {
        
        if (self.type == CreatProjectControllerTypeCreate) {
            
            NSArray *arr = resp.body;
            if (arr.count) {
                TFProjectCatagoryItemModel *model = arr[0];
                self.creatProject.categoryName = model.categoryName;
                self.creatProject.categoryId = model.id;
            }
            
            [self.tableView reloadData];
        }
    }
    
    if (resp.cmdId == HQCMD_projectPrincipalAddAndModify) {
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_getPermission) {
        
        for (TFPermissionModel *model in resp.body) {
            
            if ([model.code isEqualToNumber:@111001]) {
                self.openPermission = YES;
                continue;
            }
            
            if ([model.code isEqualToNumber:@111002]) {
                self.noOpenPermission = YES;
                continue;
            }
            if ([model.code isEqualToNumber:@111003]) {
                self.manageOpenPermission = YES;
                continue;
            }
        }
        
        if (self.openPermission && !self.noOpenPermission) {
            self.creatProject.isPublic = @1;
        }
        
        if (!self.openPermission && self.noOpenPermission) {
            self.creatProject.isPublic = @0;
        }
        
        if (self.openPermission && self.noOpenPermission) {
            self.creatProject.isPublic = @0;
        }
        
        [self.tableView reloadData];
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    if (resp.cmdId == HQCMD_addProject) {
        
    }
    if (resp.cmdId == HQCMD_updateProject) {
        
    }
    if (resp.cmdId == HQCMD_getProjectDetail) {
    
    }
    if (resp.cmdId == HQCMD_delProject) {
        
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
