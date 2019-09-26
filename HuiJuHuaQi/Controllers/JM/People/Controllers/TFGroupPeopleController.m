//
//  TFGroupPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/18.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFGroupPeopleController.h"
#import "HQTFTwoLineCell.h"
#import "HQEmployModel.h"
#import "TFChatPeopleInfoController.h"
#import "TFPersonalMaterialController.h"
#import "ChineseString.h"
#import "TFGroupEmployeeModel.h"
#import "TFGroupInfoModel.h"
#import "HQTFSearchHeader.h"
#import "TFChatBL.h"
#import "TFContactorInfoController.h"
#import "TFSocketManager.h"

@interface TFGroupPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQBLDelegate,UIAlertViewDelegate,HQTFSearchHeaderDelegate,UITextFieldDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** selectPeoples */
@property (nonatomic, strong) NSMutableArray *selectPeoples;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFGroupInfoModel *infoModel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

@property (nonatomic, copy) NSString *word;

@property (nonatomic, strong) NSMutableArray *totalDatas;
/** 搜索的sectionTitle数据 */
@property (nonatomic, strong) NSMutableArray * searchSections ;
/** 搜索的row */
@property (nonatomic, strong) NSMutableArray * searchTitles;

@end

@implementation TFGroupPeopleController


-(NSMutableArray *)totalDatas{
    if (!_totalDatas) {
        _totalDatas = [NSMutableArray array];
    }
    return _totalDatas;
}

-(NSMutableArray *)selectPeoples{
    if (!_selectPeoples) {
        _selectPeoples = [NSMutableArray array];
    }
    return _selectPeoples;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) text:@"取消"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.memberArr) {
        [self.totalDatas addObjectsFromArray:self.memberArr];
        [self searchHeaderTextChange:self.headerSearch.textField];
    }
    [self setupTableView];
    [self setupNavi];
    
    self.chatBL = [TFChatBL build];
    
    self.chatBL.delegate = self;
    if (self.isAT == 1) {
        
        [self.chatBL requestGetGroupInfoWithData:self.groupId];
    }
    
}
- (void)setupNavi{
    
    if (self.type == 0) {
        self.navigationItem.title = [NSString stringWithFormat:@"群聊成员(%ld)",self.totalDatas.count];
    }
    else if (self.type == 1) {
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(deletePeople) text:@"移除" textColor:GreenColor];
        self.navigationItem.title = @"移除群成员";
    }
    else if (self.type == 2) {
    
        self.navigationItem.title = @"群成员";
    }
    else if (self.type == 3) {
        
        self.navigationItem.title = @"选择新群主";
    }
}
- (void)deletePeople{
    
    [self.selectPeoples removeAllObjects];
    
    for (TFGroupEmployeeModel *emp in self.totalDatas) {
        if ([emp.selectState isEqualToNumber:@1]) {
            
            if (![emp.id isEqualToNumber:UM.userLoginInfo.employee.id]) {
                
                [self.selectPeoples addObject:emp];
            }
            else {
            
                [MBProgressHUD showError:@"不能移除自己！" toView:self.view];
                return;
            }
            
        }
    }
    
    if (self.selectPeoples.count == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }else{
        
        if (self.actionParameter) {
            self.actionParameter(self.selectPeoples);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)cancel{
    
    for (TFGroupEmployeeModel *emp in self.totalDatas) {
    
        emp.selectState = 0;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化tableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    [view addSubview:headerSearch];
    view.layer.masksToBounds = YES;
    self.headerSearch = headerSearch;
    self.headerSearch.type = SearchHeaderTypeSearch;
    tableView.tableHeaderView = view;
    headerSearch.backgroundColor = WhiteColor;
    headerSearch.textField.backgroundColor = BackGroudColor;
    headerSearch.image.backgroundColor = BackGroudColor;
    
    
    //索引栏颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    tableView.sectionIndexColor = ExtraLightBlackTextColor;
}

#pragma mark - HQTFSearchHeaderDelegate
//-(void)searchHeaderTextChange:(UITextField *)textField{
//
//    UITextRange *range = [textField markedTextRange];
//    //获取高亮部分
//    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
//
//    if (!position) {
//
//        NSMutableArray *arr = [NSMutableArray array];
//        for (TFGroupEmployeeModel *model in self.totalDatas) {
//            if ([model.employeeName containsString:textField.text]) {
//                [arr addObject:model];
//                continue;
//            }
//            if ([model.employee_name containsString:textField.text]) {
//                [arr addObject:model];
//                continue;
//            }
//        }
//        self.memberArr = arr;
//        [self.tableView reloadData];
//        self.word = textField.text;
//    }
//    if (textField.text.length == 0) {
//        [self.memberArr removeAllObjects];
//        [self.memberArr addObjectsFromArray:self.totalDatas];
//
//        [self.tableView reloadData];
//        self.word = textField.text;
//    }
//}
-(void)searchHeaderTextChange:(UITextField *)textField{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (TFGroupEmployeeModel *contactsModel in self.totalDatas) {
            
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
        
        self.memberArr = modelMutArr;
        self.word = textField.text;
        [self.tableView reloadData];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text = self.word;
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = self.word;
}


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



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.memberArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.memberArr[section];
    
    return  arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
    
    cell.bottomLine.hidden = NO;
    cell.enterImage.userInteractionEnabled = NO;
    [cell.enterImage setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateNormal];
    
    NSArray *sections = self.memberArr[indexPath.section];
    TFGroupEmployeeModel *model = sections[indexPath.row];

//    [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
    if (![model.picture isEqualToString:@""]) {
        
        [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:HeadBackground];
    }

    
    cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
    cell.titleImage.layer.masksToBounds = YES;
    
    cell.topLabel.text = model.employee_name;
    
    
    
    if ([model.selectState isEqualToNumber:@1]) {
        
        cell.enterImage.hidden = NO;
    }
    else {
    
        cell.enterImage.hidden = YES;
    }
//    if (model.position && ![model.position isEqualToString:@""]) {
//        cell.type = TwoLineCellTypeTwo;
//    }else{
        cell.type = TwoLineCellTypeOne;
//    }
    
    
    if (sections.count-1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.type == 1) {
        
        NSArray *sections = self.memberArr[indexPath.section];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        if ([model.selectState isEqualToNumber:@1]) {
            model.selectState=@0;
        }else{
            model.selectState=@1;
        }
        [tableView reloadData];
    }
    else if (self.type == 2) { //@人
    
        NSArray *sections = self.memberArr[indexPath.section];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        [self.selectPeoples addObject:model];
        
        if (self.actionParameter) {
            self.actionParameter(self.selectPeoples);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if (self.type == 3) { //
        self.section = indexPath.section;
        self.index = indexPath.row;
        NSArray *sections = self.memberArr[indexPath.section];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定选择 %@ 为群主，你将自动放弃群主身份。",model.employee_name] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [alert show];
//        TFGroupEmployeeModel *model = self.memberArr[indexPath.row];
//        [self.selectPeoples addObject:model];
//
//        if (self.actionParameter) {
//            self.actionParameter(self.selectPeoples);
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
    else{
        
//        TFPersonalMaterialController *personalVC = [[TFPersonalMaterialController alloc] init];
//
//        TFGroupEmployeeModel *employee = self.memberArr[indexPath.row];
//        personalVC.signId = employee.sign_id;
//
//        [self.navigationController pushViewController:personalVC animated:YES];
//
        
        TFContactorInfoController *info = [[TFContactorInfoController alloc] init];
        NSArray *sections = self.memberArr[indexPath.section];
        TFGroupEmployeeModel *model = sections[indexPath.row];
        info.signId = model.sign_id;
        [self.navigationController pushViewController:info animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma  mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
    
        NSArray *sections = self.memberArr[self.section];
        TFGroupEmployeeModel *model = sections[self.index];
        [self.chatBL requestTransferGroupWithData:self.groupId signId:model.sign_id];
    }
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
 
    if (resp.cmdId == HQCMD_getGroupInfo) {
        
        self.infoModel = resp.body;
        
        self.memberArr = [NSMutableArray array];
        
        TFGroupEmployeeModel *em = [[TFGroupEmployeeModel alloc] init];
        em.employee_name = @"所有人  ";
        em.picture = @"";
        em.sign_id = @0;
        [self.memberArr addObject:em];
        
        for (NSInteger i = 0; i < self.infoModel.employeeInfo.count; i ++) {
            
            TFGroupEmployeeModel *employeeModel = self.infoModel.employeeInfo[i];

            employeeModel.selectState = @0;
            
            //过滤自己
            if (![employeeModel.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                [self.memberArr addObject:employeeModel];
            }
            
        }
        [self.totalDatas addObjectsFromArray:self.memberArr];
        [self searchHeaderTextChange:self.headerSearch.textField];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_imChatTransferGroup) {
        
        [MBProgressHUD showError:@"转让成功！" toView:self.view];
        
        NSArray *sections = self.memberArr[self.section];
        TFGroupEmployeeModel *model = sections[self.index];
        NSString *str = [NSString stringWithFormat:@"欢迎%@成为新的群主",model.employeeName?:model.employee_name];
        
        [[TFSocketManager sharedInstance] sendMsgData:1 receiverId:self.groupId chatId:self.groupId text:str msgType:@7 datas:@[] atList:@[] voiceTime:@0];
        
        //返回群详情刷新
        if (self.actionHandler) {
            
            self.actionHandler();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
