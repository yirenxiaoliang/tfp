//
//  TFCompanyContactsController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCompanyContactsController.h"
#import "HQEmployModel.h"
#import "ChineseString.h"
#import "HQTFTwoLineCell.h"
#import "TFContactHeaderView.h"
#import "TFCompanyGroupController.h"
#import "TFChatGroupListController.h"
#import "TFPeopleBL.h"
#import "TFChatPeopleInfoController.h"
#import "TFRobotController.h"
#import "TFAddCompanyPeopleController.h"
#import "TFEmployModel.h"
#import "TFCompanyFrameworkController.h"
#import "TFContactsWorkFrameController.h"
#import "TFFilePathView.h"
#import "TFAddressBookController.h"
#import "TFPersonalMaterialController.h"

@interface TFCompanyContactsController ()<UITableViewDelegate,UITableViewDataSource,TFContactHeaderViewDelegate,HQBLDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** 搜索的sectionTitle数据 */
@property (nonatomic, strong) NSMutableArray * searchSections ;
/** 搜索的row */
@property (nonatomic, strong) NSMutableArray * searchTitles;
/** 搜索数据(就是当前显示的) */
@property (nonatomic, strong) NSMutableArray * searchEmoploys;
/** 所有数据 */
@property (nonatomic, strong) NSMutableArray * allContacts;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

@end

@implementation TFCompanyContactsController

-(NSMutableArray *)searchEmoploys{
    if (!_searchEmoploys) {
        _searchEmoploys = [NSMutableArray array];
    }
    return _searchEmoploys;
}

-(NSMutableArray *)searchSections{
    if (!_searchSections) {
        _searchSections = [NSMutableArray array];
    }
    return _searchSections;
}
-(NSMutableArray *)searchTitles{
    if (!_searchTitles) {
        _searchTitles = [NSMutableArray array];
    }
    return _searchTitles;
}
-(NSMutableArray *)allContacts{
    if (!_allContacts) {
        _allContacts = [NSMutableArray array];
        
//        NSArray *arr = @[@"阿",@"吧",@"从",@"👌",@"的",@"额",@"否",@"个",@"好",@"就",@"看",@"你",@"吗",@"哦",@"拍",@"去",@"人",@"是",@"他",@"我",@"想",@"有",@"在"];
//        
//        for (NSInteger i = 0; i < 100; i++) {
//            
//            HQEmployModel *model = [[HQEmployModel alloc ] init];
//            NSInteger index = arc4random_uniform((int)arr.count);
//            model.employeeName = [NSString stringWithFormat:@"%@零琳%ld",arr[index],i];
//            model.position = [NSString stringWithFormat:@"%@部门%ld",arr[index],i];
//            [_allContacts addObject:model];
//        }
        
        
    }
    return _allContacts;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:nil isNo:nil];
    [self.peopleBL requestEmployeeListWithDismiss:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
   
}
- (void)keyboardShow:(NSNotification *)noti{
    
    NSDictionary *userInfo = noti.userInfo;
    //    NSValue *beginValue    = [userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect beginFrame      = beginValue.CGRectValue;
    CGRect endFrame        = endValue.CGRectValue;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, endFrame.size.height + 49, 0);
    
}
- (void)keyboardHide:(NSNotification *)noti{
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"通讯录";
    [self textFieldChangeOfAddContact:nil];
    [self setupTableView];
    [self setupTableViewHeader];
//    [self setupNavigation];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
//    [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:nil isNo:nil];
    [self.peopleBL requestEmployeeListWithDismiss:nil];
}

#pragma mark - navi
- (void)setupNavigation {
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(leftClick) image:@"群组" highlightImage:@"群组"];
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClick) image:@"添加人员" highlightImage:@"添加人员"];
    
}

- (void)leftClick{
    
//    TFChatGroupListController *groupList = [[TFChatGroupListController alloc] init];
//    [self.navigationController pushViewController:groupList animated:YES];
    
    TFRobotController *robot = [[TFRobotController alloc] init];
    [self.navigationController pushViewController:robot animated:YES];
}
- (void)rightClick{
    
    TFAddCompanyPeopleController *groupList = [[TFAddCompanyPeopleController alloc] init];
    [self.navigationController pushViewController:groupList animated:YES];
    
}

- (void)setupTableViewHeader{
    TFContactHeaderView *headerView = [[TFContactHeaderView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,46+70*5}];
    self.tableView.tableHeaderView = headerView;
    headerView.delegate = self;
}
#pragma mark - TFContactHeaderViewDelegate
-(void)contactHeaderViewDidClickedSearchWithTextField:(UITextField *)textField{
    
    [self textFieldChangeOfAddContact:textField];
}

-(void)contactHeaderViewDidClickedCompanyPeople{
 
//    TFCompanyFrameworkController *companyGroup = [[TFCompanyFrameworkController alloc] init];
//    companyGroup.type = 0;
//    [self.navigationController pushViewController:companyGroup animated:YES];
    
    self.vcTag = 0x1234;
    TFContactsWorkFrameController *item = [[TFContactsWorkFrameController alloc] init];
    item.isSee = YES;
    TFFilePathModel *model = [[TFFilePathModel alloc] init];
    model.name = @"通讯录";
    if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
        model.className = [TFContactsWorkFrameController class];
        HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
        model.vcTag = vc.vcTag + 1;
    }else{
        
        model.className = [TFContactsWorkFrameController class];
        model.vcTag = self.vcTag + 1;
    }
    
    [item.paths addObject:model];
    [self.navigationController pushViewController:item animated:YES];
}

-(void)contactHeaderViewDidClickedChatGroup{
    TFChatGroupListController *group = [[TFChatGroupListController alloc] init];
    
    group.isSendFromFileLib = NO;
    
    [self.navigationController pushViewController:group animated:YES];
}


-(void)contactHeaderViewDidClickedRobot{
//    TFRobotController *robot = [[TFRobotController alloc] init];
//    [self.navigationController pushViewController:robot animated:YES];
}

-(void)contactHeaderViewDidClickedOftenPeople{
//    TFRobotController *robot = [[TFRobotController alloc] init];
//    [self.navigationController pushViewController:robot animated:YES];
    
    TFAddressBookController *address = [[TFAddressBookController alloc] init];
    [self.navigationController pushViewController:address animated:YES];
}

-(void)contactHeaderViewDidClickedOutPeople{
//    TFRobotController *robot = [[TFRobotController alloc] init];
//    [self.navigationController pushViewController:robot animated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0,49, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //索引栏颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    tableView.sectionIndexColor = ExtraLightBlackTextColor;
}


- (void)textFieldChangeOfAddContact:(UITextField *)textField
{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (HQEmployModel *contactsModel in self.allContacts) {
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.employeeName) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.employeeName), i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:contactsModel];
                
                i++;
            }
        }
        
        self.searchSections = [ChineseString IndexArray:nameMutArr];
        self.searchTitles = [ChineseString LetterSortArray:nameMutArr];
        
        if (self.searchSections.count) {
            
            if ([self.searchSections[0] isEqualToString:@"#"]) {// 将#放到最后
                
                id obj1 = self.searchSections[0];
                id obj2 = self.searchTitles[0];
                
                [self.searchSections removeObjectAtIndex:0];
                [self.searchTitles removeObjectAtIndex:0];
                [self.searchSections insertObject:obj1 atIndex:self.searchSections.count];
                [self.searchTitles insertObject:obj2 atIndex:self.searchTitles.count];
            }
        }
        
        NSMutableArray *modelMutArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.searchTitles.count; i++) {
            
            NSArray *arr = self.searchTitles[i];
            
            NSMutableArray *subLevelArr = [[NSMutableArray alloc] init];
            
            for (int i=0; i<arr.count; i++) {
                
                //
                NSString *contentStr = arr[i];
                
                NSArray  *contentArr = [contentStr componentsSeparatedByString:@"HJHQID"];
                
                NSInteger subscriptNum = [[contentArr lastObject] integerValue];
                
                //根据名字的排序，再根据下标，得到MODEL排序
                [subLevelArr addObject:beginEmployArr[subscriptNum]];
            }
            
            [modelMutArr addObject:subLevelArr];
            
        }
        
        self.searchEmoploys = modelMutArr;
        
        [self.tableView reloadData];
    }
}



#pragma mark - UITableViewDelegate - UITableViewDataSource
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return  self.searchSections;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BackGroudColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = HexAColor(0xf2f2f2, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    NSString *sectionStr = [self.searchSections objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoploys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.searchEmoploys[section];
    
    return  arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    NSArray *sections = self.searchEmoploys[indexPath.section];
    HQEmployModel *model = sections[indexPath.row];
    
    cell.topLabel.text = model.employeeName;
    cell.bottomLabel.text = model.position;
    cell.topLabel.textColor = BlackTextColor;
    cell.enterImage.hidden = NO;
    cell.bottomLine.hidden = NO;
    if (model.position && ![model.position isEqualToString:@""]) {
        
        cell.type = TwoLineCellTypeTwo;
    }else{
        cell.type = TwoLineCellTypeOne;
    }
//    [cell.enterImage setImage:[UIImage imageNamed:@"关闭30"] forState:UIControlStateNormal];
    
//    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
    
    [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    if (sections.count - 1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *sections = self.searchEmoploys[indexPath.section];
    HQEmployModel *model = sections[indexPath.row];
//    TFChatPeopleInfoController *peopleInfo = [[TFChatPeopleInfoController alloc] init];
//    peopleInfo.employee = model;
//    [self.navigationController pushViewController:peopleInfo animated:YES];
    
    
    TFPersonalMaterialController *personMaterial = [[TFPersonalMaterialController alloc] init];
    
    personMaterial.signId = model.sign_id;
    
    [self.navigationController pushViewController:personMaterial animated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_employeeList) {
        
        
        NSMutableArray *employess = [NSMutableArray array];
        for (TFEmployModel *model in resp.body) {
            
            HQEmployModel *emp = [[HQEmployModel alloc] init];
            emp.email = model.email;
            emp.telephone = model.phone;
            emp.employeeId = @([model.id longLongValue]);
            emp.id = @([model.id longLongValue]);
            emp.photograph = model.picture;
            emp.employeeName = model.employee_name;
            emp.sign_id = model.sign_id;
            [employess addObject:emp];
        }
        
        
        [self.allContacts removeAllObjects];
        [self.allContacts addObjectsFromArray:employess];
        [self textFieldChangeOfAddContact:nil];
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.allContacts.count forKey:CompanyTotalPeople];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
