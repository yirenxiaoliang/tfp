//
//  TFSelectChatContactsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/7/24.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectChatContactsController.h"
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
#import "HQTFTwoLineCell.h"

#import "TFChatBL.h"
#import "TFGroupInfoModel.h"
#import "TFChatInfoListModel.h"
#import "TFChatViewController.h"

@interface TFSelectChatContactsController ()<UITableViewDelegate,UITableViewDataSource,TFContactHeaderViewDelegate,HQBLDelegate,HQTFSearchHeaderDelegate,TFSelectPeopleElementCellDelegate,TFAllSelectViewDelegate>
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
@property (nonatomic, strong) TFChatBL *chatBL;

/** 所有数据 */
@property (nonatomic, strong) NSMutableArray * selects;

/** TFAllSelectView *allSelectView */
@property (nonatomic, weak) TFAllSelectView *allSelectView;

@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *groupEmployeeIds;

@property (nonatomic, assign) BOOL isIn;
@end


@implementation TFSelectChatContactsController


-(NSMutableArray *)fourSelects{
    if (!_fourSelects) {
        _fourSelects = [NSMutableArray array];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        [_fourSelects addObject:@{@"type":@0,@"peoples":arr?:@[]}];
        [_fourSelects addObject:@{@"type":@1}];
        [_fourSelects addObject:@{@"type":@2}];
        [_fourSelects addObject:@{@"type":@3}];
        
    }
    return _fourSelects;
}


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
    [self.peopleBL requestEmployeeListWithDismiss:nil];
    [self.peopleBL requestCompanyFrameworkWithCompanyId:[UM.userLoginInfo.company.id description] dismiss:nil];
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    if (self.type == 1) {
        [self setupAllSelectView];
        self.tableView.height = SCREEN_HEIGHT-NaviHeight-BottomHeight;
        [self setupNavi];
    }
    
    if (self.isSingleSelect) {
        self.allSelectView.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sure) name:@"SelectFinishNotification" object:nil];
}

/** 导航栏 */
- (void)setupNavi{
    
    self.navigationItem.title = @"选择联系人";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消" textColor:GrayTextColor];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sure{

    NSMutableArray *persons = [NSMutableArray array];
    
    if (self.isIn) {
        
        NSDictionary *dic = self.fourSelects[0];
        NSArray *arr = [dic valueForKey:@"peoples"];
        for (TFEmployModel *model in arr) {

            [persons addObject:model];
            
        }
    }
    else {
        
        for (TFEmployModel *model in self.allContacts) {
            
            if ([model.select isEqualToNumber:@1]) {
                
                [persons addObject:model];
            }
        }
    }
    
    if (persons.count == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    
    if (persons.count == 1) {
        
        NSArray *conversations = [DataBaseHandle queryAllChatListExceptAssistant];
        HQEmployModel *emp = persons[0];
        BOOL exist = NO;
        
        TFFMDBModel *model = [[TFFMDBModel alloc] init];
        for (model in conversations) {
            
            //会话已存在
            if ([model.receiverID isEqualToNumber:emp.sign_id]) {
                
                exist = YES;
                break;
            }
        }
        
        if (!exist) { //没有该聊天
            
            //添加单聊
            [self.chatBL requestAddSingleChatWithData:emp.sign_id];
        }
        else { //有该聊天
            
    //            if (self.isSend) { //从文件库发
    //
    //                self.isSendFromFileLib = YES;
    //                self.isTrans = NO;
    //            }
    //            else {
    //
    //                self.isSendFromFileLib = NO;
    //                self.isTrans = YES;
    //            }
            self.isSendFromFileLib = NO;
            self.isTrans = NO;
            TFChatViewController *chatVC = [[TFChatViewController alloc] init];
            
            chatVC.fileModel = self.fileModel;
//            chatVC.dbModel = self.dbModel;
            chatVC.isTransitive = self.isTrans;
            chatVC.isSendFromFileLib = self.isSendFromFileLib;
            
            chatVC.chatId = model.chatId;
            chatVC.naviTitle = model.receiverName;
            chatVC.cmdType = [model.chatType integerValue];
            chatVC.receiveId = [model.receiverID integerValue];
            [self.navigationController pushViewController:chatVC animated:YES];
            
        }
    }
    else {
        
        self.groupName = @"";
        self.groupEmployeeIds = @"";
        for (HQEmployModel *model in persons) {
            
            self.groupName = [self.groupName stringByAppendingString:[NSString stringWithFormat:@"、%@",model.employee_name]];
            self.groupEmployeeIds = [self.groupEmployeeIds stringByAppendingString:[NSString stringWithFormat:@",%@",[model.sign_id stringValue]]];
        }
        
        if (self.groupName.length) {
            self.groupName = [self.groupName substringFromIndex:1];
        }
        if (self.groupName.length > 12) {
            self.groupName = [self.groupName substringToIndex:12];
        }
        self.groupEmployeeIds = [self.groupEmployeeIds substringFromIndex:1];
        [self.chatBL requestAddGroupChatWithData:self.groupName groupNotice:@"" peoples:self.groupEmployeeIds];
    }

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
    [self.allSelectView.numLabel setText:[NSString stringWithFormat:@"已选择：%ld人",arr.count]];
    
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
    
    
    NSMutableArray *persons = [NSMutableArray array];
    for (TFEmployModel *model in self.allContacts) {
        
        if ([model.select isEqualToNumber:@1]) {
            
            [persons addObject:model];
        }
    }
    
    [self.allSelectView.numLabel setText:[NSString stringWithFormat:@"已选择：%ld人",persons.count]];
    
    [self.tableView reloadData];
    
}

#pragma mark - 头部
- (void)setupTableViewHeader{
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    header.backgroundColor = WhiteColor;
    header.textField.backgroundColor = BackGroudColor;
    header.button.backgroundColor = BackGroudColor;
    
//    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,60}];
//    [headerView addSubview:bgView];
//    bgView.backgroundColor = WhiteColor;
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(frameWorkClicked)];
//    [bgView addGestureRecognizer:tap];
//
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,20,20,20}];
//    [bgView addSubview:imageView];
//    imageView.image = IMG(@"selectDepartment");
//    imageView.contentMode = UIViewContentModeCenter;
//
//    UILabel *label = [HQHelper labelWithFrame:(CGRect){CGRectGetMaxX(imageView.frame)+10,20,SCREEN_WIDTH-100,20} text:@"按组织架构查看" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
//    [bgView addSubview:label];
//
//    UIImageView *arrow = [[UIImageView alloc] initWithFrame:(CGRect){SCREEN_WIDTH - 20 - 15,20,20,20}];
//    [bgView addSubview:arrow];
//    arrow.image = IMG(@"下一级浅灰");
//    arrow.contentMode = UIViewContentModeCenter;
    
    self.tableView.tableHeaderView = headerView;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderClicked{
    
    TFSearchPeopleController *search = [[TFSearchPeopleController alloc] init];
    search.isSee = NO;
    search.isSingleSelect = self.isSingleSelect;
    search.departmentId = nil;
    search.actionParameter = ^(NSArray *parameter) {
        
        NSDictionary *dict = self.fourSelects[0];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict valueForKey:@"peoples"]];
        [arr addObjectsFromArray:parameter];
        
        
        NSMutableDictionary *dict1 = [NSMutableDictionary dictionary];
        [dict1 setObject:@0 forKey:@"type"];
        [dict1 setObject:arr forKey:@"peoples"];
        self.fourSelects[0] = dict1;
        
        
        for (NSArray *arr1 in self.searchEmoploys) {
            
            for (TFEmployModel *model in arr1) {
                
                for (TFEmployModel *ee in parameter) {
                    
                    if ([model.id isEqualToNumber:ee.id]) {
                        
                        model.select = @1;
                    }
                }
                
            }
        }
        
        [self.tableView reloadData];
        
        
        
    };
    [self.navigationController pushViewController:search animated:YES];
    
}


- (void)frameWorkClicked{
    
    TFContactsWorkFrameController *frameWork = [[TFContactsWorkFrameController alloc] init];
    
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
            self.isIn = YES;
        }
        [self.navigationController popViewControllerAnimated:NO];
    };
    frameWork.isSingleSelect = self.isSingleSelect;
    
    [self.navigationController pushViewController:frameWork animated:YES];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
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
    
    if (section == 0) {
        
        return 0;
    }
    else if (section == 1) {
        
        return 10;
    }
    else {
        
        return 30;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section > 1) {
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = BackGroudColor;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
        label.backgroundColor = HexAColor(0xf2f2f2, 1);
        label.font = [UIFont systemFontOfSize:14.0];
        NSString *sectionStr = [self.searchSections objectAtIndex:(section-2)];
        [label setText:sectionStr];
        [contentView addSubview:label];
        return contentView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoploys.count+2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0 || section == 1) {
        
        return 1;
    }
    else {
        
        NSArray *arr = self.searchEmoploys[section-2];
        
        return  arr.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) { //选择一个群
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;
        cell.topLabel.text = @"选择一个群";
        [cell.enterImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(@"选择一个群") forState:UIControlStateNormal];
        cell.bottomLine.hidden = YES;
        return cell;
    }
    else if (indexPath.section == 1) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;
        cell.topLabel.text = @"按组织架构查看";
        [cell.enterImage setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
        [cell.titleImage setImage:IMG(@"selectDepartment") forState:UIControlStateNormal];
        cell.bottomLine.hidden = YES;
        return cell;
    }
    else {
        
        TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.section * 222 + indexPath.row];
        cell.delegate = self;
        NSArray *sections = self.searchEmoploys[indexPath.section-2];
        TFEmployModel *model = sections[indexPath.row];
        [cell refreshCellWithEmployeeModel:model isSingle:NO];
        cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
        if (indexPath.row == sections.count-1) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        if (indexPath.row == 0) {
            cell.topLine.hidden = YES;
        }else{
            cell.topLine.hidden = NO;
        }
        return cell;
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        TFChatGroupListController *groupList = [[TFChatGroupListController alloc] init];

        groupList.isSendFromFileLib = NO;

        [self.navigationController pushViewController:groupList animated:YES];
    }
    else if (indexPath.section == 1) {
        
        [self frameWorkClicked];
    }
    else {
        
        TFSelectPeopleElementCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectPeopleElementCellDidClickedSelectBtn:cell.selectBtn];
    }
    
}


#pragma mark - TFSelectPeopleElementCellDelegate
-(void)selectPeopleElementCellDidClickedSelectBtn:(UIButton *)selectBtn{
    
    NSInteger section = selectBtn.tag / 0x999;
    NSInteger row = selectBtn.tag % 0x999;
    
    NSArray *sections = self.searchEmoploys[section-2];
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
        
        
        return;
    }
    
    // 多选操作
    if ([model.select isEqualToNumber:@2]) {
        
        return;
    }else{
        
        model.select = [model.select isEqualToNumber:@1] ? @0 : @1;
    }
    
    NSMutableArray *persons = [NSMutableArray array];
    for (TFEmployModel *model in self.allContacts) {
        
        if ([model.select isEqualToNumber:@1]) {
            
            [persons addObject:model];
        }
    }
    
    [self.allSelectView.numLabel setText:[NSString stringWithFormat:@"已选择：%ld人",persons.count]];
    
    [self.tableView reloadData];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    
    if (resp.cmdId == HQCMD_employeeList) {
        
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
        
    }
    
    if (resp.cmdId == HQCMD_addGroupChat) {
        
        TFGroupInfoModel *groupModel = resp.body;
        
        TFChatInfoListModel *model = groupModel.groupInfo;
        
        TFChatViewController *chat = [[TFChatViewController alloc] init];
        
        //群成员字符串分割成数组
        chat.naviTitle = self.groupName;
        chat.cmdType = 1;
        chat.chatId = model.id;
        chat.receiveId = [model.id integerValue];
        chat.picture = model.picture;
        
        chat.isCreateGroup = 1;
        NSString *tipContent = @"";
        for (TFGroupEmployeeModel *empModel in groupModel.employeeInfo) {
            
            if (![empModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                tipContent = [tipContent stringByAppendingFormat:@"、%@", empModel.employee_name];
            }
            
        }
        if (tipContent.length>0) {
            
            tipContent = [tipContent substringFromIndex:1];
        }
        
        chat.tipContent = [NSString stringWithFormat:@"欢迎%@加入群聊",tipContent];
//        [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:[model chatListModel]];
        
        [self.navigationController pushViewController:chat animated:YES];
    }
    
    if (resp.cmdId == HQCMD_addSingleChat) {
        
        TFChatInfoListModel *model = resp.body;
        
        if (self.isTrans) {
            
            TFChatViewController *chatVC = [[TFChatViewController alloc] init];
//            chatVC.dbModel = self.dbModel;
            chatVC.isTransitive = self.isTrans;
            chatVC.chatId = model.id;
            chatVC.naviTitle = model.name?:model.employee_name;
            chatVC.cmdType = [model.chat_type integerValue];
            chatVC.receiveId = [model.receiver_id integerValue];
            [self.navigationController pushViewController:chatVC animated:YES];
            
        }
        else {
            
            TFChatViewController *send = [[TFChatViewController alloc] init];
            
            if (self.isSend) {
                
                send.isSendFromFileLib = YES;
                
                
                send.fileModel = self.fileModel;
                
            }
            
            
            send.cmdType = [model.chat_type integerValue];
            send.chatId = model.id;
            send.receiveId = [model.receiver_id integerValue];
            
            send.naviTitle = model.employee_name;
            send.picture = model.picture;
            
            TFFMDBModel *dd = [model chatListModel];
            dd.mark = @3;
            [[NSNotificationCenter defaultCenter] postNotificationName:ConversationListRefreshWithNotification object:dd];
            
            [self.navigationController pushViewController:send animated:YES];
        }
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
