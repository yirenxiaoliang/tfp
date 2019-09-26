//
//  HQTFProjectPeopleManageController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/24.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFProjectPeopleManageController.h"
#import "HQTFSearchHeader.h"
#import "HQTFTwoLineCell.h"
#import "HQTFPeopleInfoController.h"
#import "TFProjectBL.h"
#import "MJRefresh.h"
#import "TFProjectMemberListModel.h"
#import "HQTFAddPeopleController.h"
#import "AlertView.h"

@interface HQTFProjectPeopleManageController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,HQTFTwoLineCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** headerView */
@property (nonatomic, strong) UIView *headerView;

/** projectBL */
@property (nonatomic, strong) TFProjectBL *projectBL;

/** TFProjectMemberListModel */
@property (nonatomic, strong) TFProjectMemberListModel *memberListModel;

/** members */
@property (nonatomic, strong) NSMutableArray *members;


/** pageNum */
@property (nonatomic, assign) NSInteger pageNum;
/** pageSize */
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation HQTFProjectPeopleManageController

-(NSMutableArray *)members{
    if (!_members) {
        _members = [NSMutableArray array];
    }
    return _members;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    [self setupTableView];
    [self setupHeaderSearch];
    [self textFieldChange:nil];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.projectBL = [TFProjectBL build];
    self.projectBL.delegate = self;
    [self.projectBL requestGetProjectMembersWithProjectId:self.Id employeeName:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
    self.navigationItem.title = @"成员管理";
    if (self.type == 1) {
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
}

- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)sure{
    
    if (self.peopleAction) {
        NSMutableArray *arr = [NSMutableArray array];
        for (HQEmployModel *peo in self.members) {
            
            if ([peo.selectState isEqualToNumber:@1]) {
                [arr addObject:peo];
            }
        }
        if (arr.count == 0) {
            [MBProgressHUD showError:@"请选择人员" toView:KeyWindow];
            return;
        }
        
        [self.navigationController popViewControllerAnimated:NO];
        self.peopleAction(arr);
    }
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    headerView.backgroundColor = HexColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

-(void)searchHeaderClicked{
    self.headerSearch.type = SearchHeaderTypeMove;
    [self.headerSearch.textField becomeFirstResponder];
    self.headerSearch.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
    [self.navigationController.navigationBar addSubview:self.headerSearch];
    [UIView animateWithDuration:0.25 animations:^{
        
        self.headerSearch.y = -20;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = nil;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -44);
    }];
    
}


-(void)searchHeaderCancelClicked{
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerSearch.y = 24;
        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        self.tableView.contentOffset = CGPointMake(0, -88);
    }completion:^(BOOL finished) {
        
        self.tableView.tableHeaderView = self.headerView;
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.headerSearch removeFromSuperview];
    }];
    
    [self.projectBL requestGetProjectMembersWithProjectId:self.Id employeeName:nil];
}

- (void)keyboardHide{
    
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldChange:textField];
}



- (void)textFieldChange:(UITextField *)textField
{
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        [self.projectBL requestGetProjectMembersWithProjectId:self.Id employeeName:textField.text];
    }
}



//#pragma mark - 初始化tableView
//- (void)setupTableView
//{
//    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.dataSource = self;
//    tableView.delegate = self;
//    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//    tableView.backgroundColor = BackGroudColor;
//    
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
//    
////    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
////        
////        self.pageNum = 1;
////        
////        [self.projectBL requestGetProjectMembersWithProjectId:self.Id];
////        
////    }];
////    
////    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////        
////        self.pageNum ++;
////        
////        [self.projectBL requestGetProjectMembersWithProjectId:self.Id];
////        
////    }];
//}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"项目成员共5个" textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    view.layer.masksToBounds = YES;
    [view addSubview:self.headerSearch];
    self.tableView.tableHeaderView = view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.members.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    cell.tag = 0x123 + indexPath.row;
    cell.delegate = self;
    cell.topLabel.textColor = BlackTextColor;
    cell.enterImage.hidden = NO;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 0;
    cell.enterImage.userInteractionEnabled = NO;
//    [cell.enterImage setImage:[UIImage imageNamed:@"关闭30"] forState:UIControlStateNormal];
    
    HQEmployModel *model = self.members[indexPath.row];
    cell.topLabel.text = model.employeeName;
    [cell.enterImage setTitleColor:GreenColor forState:UIControlStateNormal];
    
    if (self.type == 0) {
        
        if ([model.isProjectCreator integerValue] == 1) {
            [cell.enterImage setTitle:@"创建人" forState:UIControlStateNormal];
        }else if ([model.isProjectPrincipal integerValue] == 1){
            [cell.enterImage setTitle:@"负责人" forState:UIControlStateNormal];
        }else{
            [cell.enterImage setTitle:@"" forState:UIControlStateNormal];
        }
    }else{// 选人
        [cell.titleDescImg setTitleColor:GreenColor forState:UIControlStateNormal];
        [cell.titleDescImg setTitleColor:GreenColor forState:UIControlStateHighlighted];
        if ([model.isProjectCreator integerValue] == 1) {
            [cell.titleDescImg setTitle:@"(创建人)" forState:UIControlStateNormal];
        }else if ([model.isProjectPrincipal integerValue] == 1){
            [cell.titleDescImg setTitle:@"(负责人)" forState:UIControlStateNormal];
        }else{
            [cell.titleDescImg setTitle:@"" forState:UIControlStateNormal];
        }
        
        if ([model.selectState isEqualToNumber:@0]) {
            
            [cell.enterImage setImage:nil forState:UIControlStateNormal];
            [cell.enterImage setTitle:@"" forState:UIControlStateNormal];
        }else{
            [cell.enterImage setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateNormal];
            [cell.enterImage setTitle:@"" forState:UIControlStateNormal];
        }
    }
    
    if (!model.position || [model.position isEqualToString:@""]) {
        
        cell.type = TwoLineCellTypeOne;
    }else{
        
        cell.type = TwoLineCellTypeTwo;
    }
    cell.bottomLabel.text = model.position;
    
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    cell.topLabel.text = model.employeeName;
    
    
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
    }else{
        cell.topLine.hidden = YES;
    }
    
    if (indexPath.row == self.members.count-1) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    if ([model.employeeStatus integerValue] != 1) {
        cell.titleDescImg.hidden = NO;
        [cell.titleDescImg setBackgroundImage:[HQHelper createImageWithColor:RedColor size:(CGSize){8,8}] forState:UIControlStateNormal];
        cell.titleDescImg.layer.cornerRadius = 4;
        cell.titleDescImg.layer.masksToBounds = YES;
        
    }else{
        
        cell.titleDescImg.layer.cornerRadius = 0;
        cell.titleDescImg.layer.masksToBounds = NO;
        cell.titleDescImg.hidden = YES;
        [cell.titleDescImg setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
    }
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 0) {
        
        HQTFPeopleInfoController *people = [[HQTFPeopleInfoController alloc] init];
        people.participant = self.members[indexPath.row];
        people.projectItem = self.projectItem;
        people.actionParameter = ^(HQEmployModel *employee){
            
            [self.members removeObject:employee];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:people animated:YES];
    }else{
        
        HQEmployModel *model = self.members[indexPath.row];
        if (self.isMulti) {// 多选
            
            model.selectState = [model.selectState isEqualToNumber:@0]?@1:@0;
            
        }else{// 单选
            
            for (HQEmployModel *peo in self.members) {
                peo.selectState = @0;
            }
            model.selectState = @1;
        }
        
        [self.tableView reloadData];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSString *tip = [NSString stringWithFormat:@" %@",self.projectItem.projectName];
    UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH-15,44} text:tip textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"    "];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"项目花"];
    attach.bounds = CGRectMake(0, -1, 13, 13);
    
    [str appendAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:tip]];
    
    [str addAttribute:NSFontAttributeName value:FONT(14) range:NSMakeRange(5, tip.length)];
    
    label.backgroundColor = WhiteColor;
    label.attributedText = str;
    return label;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - cellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
//    NSInteger index = cell.tag - 0x123;
//    
//    HQEmployModel *model = self.members[index];
//    
//    [AlertView showAlertView:@"删除" msg:@"成员将无法接受或发出项目信息内容" leftTitle:@"取消" rightTitle:@"确定" onLeftTouched:^{
//        
//    } onRightTouched:^{
//        [self.projectBL requestDelProjParticipantWithId:model.id];
//    }];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_getProjectMembers) {
        
//        self.memberListModel = resp.body;
//        
//        if ([self.tableView.mj_footer isRefreshing]) {
//            
//            [self.tableView.mj_footer endRefreshing];
//            
//        }else {
//            
//            [self.tableView.mj_header endRefreshing];
//            
//            [self.members removeAllObjects];
//        }
//        
//        [self.members addObjectsFromArray:self.memberListModel.list];
//        
//        if (self.memberListModel.totalRows == self.members.count) {
//            
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            
//            self.tableView.mj_footer = nil;
//            
//            if (self.members.count < 10) {
//                self.tableView.tableFooterView = [UIView new];
//            }else{
//                self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"项目成员共%ld个",self.members.count] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
//            }
//            
//        }else {
//            
//            [self.tableView.mj_footer resetNoMoreData];
//        }
        
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (HQEmployModel *emp in resp.body) {
            
            emp.selectState = @0;
            [arr addObject:emp];
        }
        
        for (HQEmployModel *peo in self.employees) {
            
            for (HQEmployModel *people in arr) {
                
                if ([people.id?people.id:people.employeeId isEqualToNumber:peo.id?peo.id:peo.employeeId] ) {
                    
                    people.selectState = @1;
                    break;
                }
                
            }
            
        }
        
        self.members = arr;
        
        self.tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"项目成员共%ld个",self.members.count] textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
        [self.tableView reloadData];

    }
    
    if (resp.cmdId == HQCMD_delProjParticipant) {
        
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_header endRefreshing];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
    if (resp.cmdId == HQCMD_getProjectMembers) {
        
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
