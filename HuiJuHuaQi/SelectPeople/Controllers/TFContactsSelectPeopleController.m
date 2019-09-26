//
//  TFContactsSelectPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFContactsSelectPeopleController.h"
#import "HQEmployModel.h"
#import "ChineseString.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactHeaderView.h"
#import "TFCompanyGroupController.h"
#import "TFChatGroupListController.h"
#import "TFPeopleBL.h"
#import "TFChatPeopleInfoController.h"
#import "TFRobotController.h"
#import "TFAddCompanyPeopleController.h"
#import "TFEmployModel.h"
#import "TFCompanyFrameworkController.h"
#import "HQTFSearchHeader.h"
#import "TFAllSelectView.h"
#import "TFContactsWorkFrameController.h"
#import "TFFilePathView.h"
#import "TFSearchPeopleController.h"


@interface TFContactsSelectPeopleController ()<UITableViewDelegate,UITableViewDataSource,TFContactHeaderViewDelegate,HQBLDelegate,HQTFSearchHeaderDelegate,TFSelectPeopleElementCellDelegate,TFAllSelectViewDelegate>
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


/** 所有数据 */
@property (nonatomic, strong) NSMutableArray * selects;

/** TFAllSelectView *allSelectView */
@property (nonatomic, weak) TFAllSelectView *allSelectView;

@end


@implementation TFContactsSelectPeopleController

-(NSMutableArray *)selects{
    if (!_selects) {
        _selects = [NSMutableArray array];
    }
    return _selects;
}

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
    }
    return _allContacts;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self textFieldChangeOfAddContact:nil];
    [self setupTableView];
    [self setupTableViewHeader];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
//    [self.peopleBL requestEmployeeListWithDismiss:self.dismiss];
    [self.peopleBL requestEmployeeListWithDismiss:nil];
    [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:self.dismiss];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(allSelect:) name:AllSelectPeopleNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:SelectPeopleRefreshNotification object:nil];
    
    if (self.type == 1) {
        [self setupAllSelectView];
        self.tableView.height = SCREEN_HEIGHT-NaviHeight-BottomHeight;
        [self setupNavi];
    }
    
    if (self.isSingleSelect) {
        self.allSelectView.hidden = YES;
    }
    
}

/** 导航栏 */
- (void)setupNavi{
    
    self.navigationItem.title = @"联系人";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.actionParameter) {
        self.actionParameter(self.fourSelects);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setupAllSelectView{
    
    TFAllSelectView *allSelectView = [TFAllSelectView allSelectView];
    allSelectView.frame = CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight);
    [self.view addSubview:allSelectView];
    allSelectView.delegate = self;
    self.allSelectView = allSelectView;
    
}

#pragma mark - TFAllSelectViewDelegate
-(void)allSelectViewDidClickedAllSelectBtn:(UIButton *)selectBtn{
    
    [self allSelectWithSelected:selectBtn.selected];
}


/** 刷新通知 */
- (void)refresh:(NSNotification *)note{
    
    NSDictionary *dict = self.fourSelects[0];
    NSArray *arr = [dict valueForKey:@"peoples"];
    
    
    for (NSArray *secs in self.searchEmoploys) {
        
        for (TFEmployModel *model in secs) {
            
            BOOL have = NO;
            for (TFEmployModel *em in arr) {
                
                if ([model.id isEqualToNumber:em.id]) {
                    
                    have = YES;
                    model.select = @1;
                    break;
                }
                
            }
            if (!have) {
                
                if ([model.select isEqualToNumber:@2]) {
                    
                    continue;
                }else{
                    
                    model.select = @0;
                }
            }
            
        }
    }
    
    [self.tableView reloadData];
}


/** 全选通知 */
- (void)allSelect:(NSNotification *)note{
    
    NSDictionary *dict = note.object;
    
    if (0 == [[dict valueForKey:@"type"] integerValue]) {
        
        [self allSelectWithSelected:[[dict valueForKey:@"selected"] integerValue] == 1 ? YES : NO];
    }else{
        return;
    }
    
}


#pragma mark - allSelect
- (void)allSelectWithSelected:(BOOL)selected{
    
    
    for (NSArray *arr in self.searchEmoploys) {
        
        for (TFEmployModel *model in arr) {
            
            
            if (selected) {
                
                if ([model.select isEqualToNumber:@2]) {
                    
                    continue;
                }else{
                    
                    model.select = @1;
                }
                
            }else{
                
                
                if ([model.select isEqualToNumber:@2]) {
                    
                    continue;
                }else{
                    
                    model.select = @0;
                }
            }
        }
    }
    
    [self.tableView reloadData];
    
    
    [self selectPeopleNotification];
    
    
}

- (void)selectPeopleNotification{
    
    [self.selects removeAllObjects];
    NSInteger allCount = 0;
    for (NSArray *arr in self.searchEmoploys) {
        
        allCount += arr.count;
        
        for (TFEmployModel *model in arr) {
            
            
            if ([model.select isEqualToNumber:@1]) {
                [self.selects addObject:model];
            }
            
        }
    }
    
    NSDictionary *dict = @{
                           @"type":@(0),
                           @"peoples":self.selects,
                           @"allCount":@(allCount)
                           };
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectPeopleRefreshNotification object:dict];
}


#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,104}];
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    header.backgroundColor = WhiteColor;
    header.button.backgroundColor = BackGroudColor;
    
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,60}];
    [headerView addSubview:bgView];
    bgView.backgroundColor = WhiteColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frameWorkClicked)];
    [bgView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,20,20,20}];
    [bgView addSubview:imageView];
    imageView.image = IMG(@"selectDepartment");
    imageView.contentMode = UIViewContentModeCenter;
    
    UILabel *label = [HQHelper labelWithFrame:(CGRect){CGRectGetMaxX(imageView.frame)+10,20,SCREEN_WIDTH-100,20} text:@"按组织架构查看" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
    [bgView addSubview:label];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH - 20 - 15,20,20,20}];
    [bgView addSubview:arrow];
    arrow.image = IMG(@"下一级浅灰");
    arrow.contentMode = UIViewContentModeCenter;
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    TFSearchPeopleController *search = [[TFSearchPeopleController alloc] init];
    search.isSee = NO;
    search.isSingleSelect = self.isSingleSelect;
    search.departmentId = nil;
    search.dismiss = self.dismiss;
    search.actionParameter = ^(NSArray *parameter) {
        
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setObject:@0 forKey:@"type"];
        if (self.isSingleSelect) {
            [dict1 setObject:[NSMutableArray arrayWithArray:parameter] forKey:@"peoples"];
        }else{
            NSDictionary *dict = self.fourSelects[0];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict valueForKey:@"peoples"]];
            [arr addObjectsFromArray:parameter];
            [dict1 setObject:arr forKey:@"peoples"];
        }
        self.fourSelects[0] = dict1;
        
        if (self.isSingleSelect) {// 单选
            
            for (NSArray *arr1 in self.searchEmoploys) {
                
                for (TFEmployModel *model in arr1) {
                    model.select = @0;
                }
            }
        }
        
        for (NSArray *arr1 in self.searchEmoploys) {
            
            for (TFEmployModel *model in arr1) {
                
                for (TFEmployModel *ee in parameter) {
                    
                    if ([model.id isEqualToNumber:ee.id]) {
                        
                        model.select = @1;
                    }
                }
                
            }
        }
        [self selectPeopleNotification];
        
        [self.tableView reloadData];
        
        
        
    };
    [self.navigationController pushViewController:search animated:YES];
    
}


- (void)frameWorkClicked{
    
    TFContactsWorkFrameController *frameWork = [[TFContactsWorkFrameController alloc] init];
    frameWork.dismiss = self.dismiss;
    TFFilePathModel *model = [[TFFilePathModel alloc] init];
    model.name = @"联系人";
    if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
        model.className = [TFContactsWorkFrameController class];
        HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
        model.vcTag = vc.vcTag + 1;
    }else{
        
        model.className = [TFContactsWorkFrameController class];
        model.vcTag = self.vcTag + 1;
    }
    
    [frameWork.paths addObject:model];
    
    frameWork.vcTag = self.vcTag + 1;
    frameWork.fourSelects = self.fourSelects;
    frameWork.noSelectPoeples = self.noSelectPoeples;
    frameWork.actionParameter = ^(id parameter) {
      
        if (self.actionParameter) {
            self.actionParameter(self.fourSelects);
        }
        [self.navigationController popViewControllerAnimated:NO];
    };
    frameWork.isSingleSelect = self.isSingleSelect;
    
    [self.navigationController pushViewController:frameWork animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight-49-BottomM) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 8, 0);
    tableView.backgroundColor = BackGroudColor;
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
        
        for (TFEmployModel *contactsModel in self.allContacts) {
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.employee_name) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.employee_name), i];
                
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
    return 60.0;
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
    TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.section * 222 + indexPath.row];
    cell.delegate = self;
    NSArray *sections = self.searchEmoploys[indexPath.section];
    TFEmployModel *model = sections[indexPath.row];
    [cell refreshCellWithEmployeeModel:model isSingle:NO];
    cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
    if (indexPath.row == 0) {
        cell.topLine.hidden = YES;
    }else{
        cell.topLine.hidden = NO;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TFSelectPeopleElementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self selectPeopleElementCellDidClickedSelectBtn:cell.selectBtn];
}


#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger section = selectBtn.tag / 0x999;
    NSInteger row = selectBtn.tag % 0x999;
    
    NSArray *sections = self.searchEmoploys[section];
    TFEmployModel *model = sections[row];
    
    // 单选
    if (self.isSingleSelect) {
        
        if ([model.select isEqualToNumber:@2]) {
            
            return;
        }
        
        // 取消选中
        for (NSArray *arr in self.searchEmoploys) {
            
            for (TFEmployModel *e in arr) {
                
                if ([e.select isEqualToNumber:@2]) {
                    
                    continue;
                }else{
                    
                    e.select = @0;
                }
                
            }
        }
        
        // 选择当前的
        model.select = @1;
        
        
        [self.tableView reloadData];
        
        
        [self selectPeopleNotification];
        
        return;
    }
    
    // 多选操作
    if ([model.select isEqualToNumber:@2]) {
        
        return;
    }else{
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    }
    
    [self.tableView reloadData];
    
    
    [self selectPeopleNotification];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_employeeList) {
        
//        NSMutableArray *employess = [NSMutableArray array];
//        for (TFEmployModel *model in resp.body) {
//            
//            HQEmployModel *emp = [[HQEmployModel alloc] init];
//            emp.email = model.email;
//            emp.telephone = model.phone;
//            emp.employeeId = @([model.id longLongValue]);
//            emp.id = @([model.id longLongValue]);
//            emp.photograph = model.picture;
//            emp.employeeName = model.employee_name;
//            
//            [employess addObject:emp];
//        }
//        
        [self.allContacts removeAllObjects];
        [self.allContacts addObjectsFromArray:resp.body];
        
        NSDictionary *dict = self.fourSelects[0];
        NSArray *arr = [dict valueForKey:@"peoples"];
        
        for (HQEmployModel *dePe in arr) {
            
            for (TFEmployModel *coPo in self.allContacts) {
                
                if ([dePe.id integerValue] == [coPo.id integerValue]) {
                    
                    coPo.select = @1;
                    break;
                }
            }
        }
        
        for (HQEmployModel *dePe in self.noSelectPoeples) {
            
            for (TFEmployModel *coPo in self.allContacts) {
                
                if ([dePe.id integerValue] == [coPo.id integerValue]) {
                    
                    coPo.select = @2;
                    break;
                }
            }
        }
        
        [self textFieldChangeOfAddContact:nil];
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.allContacts.count forKey:CompanyTotalPeople];
        
        [self.tableView reloadData];
        
        [self selectPeopleNotification];
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
