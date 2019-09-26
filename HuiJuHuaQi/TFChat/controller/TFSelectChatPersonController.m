//
//  TFSelectChatPersonController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2017/12/4.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectChatPersonController.h"
#import "HQEmployModel.h"
#import "ChineseString.h"
#import "HQTFSearchHeader.h"
#import "HQTFTwoLineCell.h"
#import "TFCreateGroupController.h"
#import "TFPeopleBL.h"
#import "HQConversationController.h"
#import "TFEmployModel.h"
#import "AlertView.h"
#import "TFChangeHelper.h"
#import "TFChatViewController.h"
#import "TFChatBL.h"
#import "TFChatInfoListModel.h"
#import "HQSelectTimeCell.h"
#import "TFChatGroupListController.h"
#import "TFSocketManager.h"
#import "TFSelectChatPeopleController.h"

#import "TFSocketManager.h"

@interface TFSelectChatPersonController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** headerView */
@property (nonatomic, strong) UIView *headerView;
/** headerView */
@property (nonatomic, strong) UIView *groupView;

/** 分组数据 */
@property (nonatomic, strong)NSMutableArray * searchSectionArray ;

/** 分组标题 */
@property (nonatomic, strong)NSMutableArray * searchTitleArray;
/** 分组标题 */
@property (nonatomic, strong)NSMutableArray * searchEmoloyArray;
/** 所有职员信息，加过select state的 */
@property (nonatomic, strong)NSMutableArray * allEmployMutArr;

/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** selectEmployees */
@property (nonatomic, strong) NSMutableArray *selectEmployees;

/** isPermission */
@property (nonatomic, assign) BOOL isPermission;

@property (nonatomic, strong) TFChatBL *chatBL;

@property (nonatomic, strong) TFSocketManager *socket;

@property (nonatomic, assign) BOOL isDid;

@end

@implementation TFSelectChatPersonController

-(NSMutableArray *)selectEmployees{
    if (!_selectEmployees) {
        _selectEmployees = [NSMutableArray array];
    }
    return _selectEmployees;
}

-(NSMutableArray *)allEmployMutArr{
    
    if (!_allEmployMutArr) {
        _allEmployMutArr = [NSMutableArray array];
        

    }
    return _allEmployMutArr;
}

-(NSMutableArray *)searchTitleArray{
    
    if (!_searchTitleArray) {
        _searchTitleArray = [NSMutableArray array];
    }
    return _searchTitleArray;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(cancel) image:@"关闭" highlightImage:@"关闭"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
    [self searchHeaderCancelClicked];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerSearch.textField.text = @"";
    [self textFieldContentChange:nil];
    [self setupTableView];
    [self setupHeaderSearch];
    [self textFieldContentChange:self.headerSearch.textField];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.socket = [TFSocketManager sharedInstance];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    
    self.chatBL = [TFChatBL build];
    self.chatBL.delegate = self;
    
    
    [self.peopleBL requestEmployeeListWithDismiss:nil];
    
    kWEAKSELF
    self.action = ^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
}

- (void)sure{
    
    if (!self.selectEmployees.count) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    
    
    if (self.isTwoSure) {
        
        if (self.actionParameter) {
            self.actionParameter(self.selectEmployees);
        }
        
    }else{
        
        if (self.actionParameter) {
            self.actionParameter(self.selectEmployees);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - navi
- (void)setupNavigation{
    
    if (self.type == 1) {
        self.navigationItem.title = @"选择人员";
    }else{
        self.navigationItem.title = @"发起聊天";
    }
    
    if (self.type == 1) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
    }
}

- (void)cancel{
    
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    self.header = header;
    header.delegate = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44 + 70}];
    
    if (!self.isPermission) {
        headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    }
    
    [headerView addSubview:header];
    headerView.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
    
    if (self.type != 1) {
        
        if (self.isPermission) {
            
            UIView *group = [[UIView alloc] initWithFrame:(CGRect){0,44,SCREEN_WIDTH,70}];
            group.backgroundColor = WhiteColor;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,12,46,46}];
            [group addSubview:imageView];
            imageView.image = [UIImage imageNamed:@"建群45"];
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(imageView.frame)+ 10,12,150,30}];
            label.text = @"创建群组";
            label.centerY = 70/2;
            [group addSubview:label];
            self.groupView = group;
            [headerView addSubview:group];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGroup)];
            [group addGestureRecognizer:tap];
        }
        
    }else{
        
        self.headerView.frame = (CGRect){0,0,SCREEN_WIDTH,44};
    }
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

- (void)createGroup{
    TFCreateGroupController *createGroup = [[TFCreateGroupController alloc] init];
    [self.navigationController pushViewController:createGroup animated:YES];
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
        
        if (self.type != 1) {
            
            if (self.isPermission) {
                
                UIView *group = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,70}];
                group.backgroundColor = WhiteColor;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,12,46,46}];
                [group addSubview:imageView];
                imageView.image = [UIImage imageNamed:@"建群45"];
                UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(imageView.frame)+ 10,12,150,30}];
                label.text = @"创建群组";
                label.centerY = 70/2;
                [group addSubview:label];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGroup)];
                [group addGestureRecognizer:tap];
                self.tableView.tableHeaderView = group;
            }else{
                
                self.tableView.tableHeaderView = nil;
            }
            
        }else{
            
            self.tableView.tableHeaderView = nil;
        }
        
        
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
    
    [self textFieldContentChange:nil];
    
}

- (void)keyboardHide{
    
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldContentChange:textField];
}

#pragma mark - 监听TextFiled输入内容
- (void)textFieldContentChange:(UITextField *)textField
{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (HQEmployModel *employModel in self.allEmployMutArr) {
            
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([employModel.employeeName?:employModel.employee_name rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", employModel.employeeName?:employModel.employee_name, i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:employModel];
                
                i++;
            }
        }
        
        
        
        self.searchSectionArray = [ChineseString IndexArray:nameMutArr];
        
        self.searchTitleArray = [ChineseString LetterSortArray:nameMutArr];
        
        
        
        NSMutableArray *modelMutArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<self.searchTitleArray.count; i++) {
            
            NSArray *arr = self.searchTitleArray[i];
            
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
        
        
        self.searchEmoloyArray = modelMutArr;
        
        
        [self.tableView reloadData];
    }
    
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //索引栏颜色
    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    tableView.sectionIndexColor = ExtraLightBlackTextColor;
}

#pragma mark - UITableViewDelegate - UITableViewDataSource
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    return  self.searchSectionArray;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BackGroudColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = HexAColor(0xf2f2f2, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    NSString *sectionStr=[self.searchSectionArray objectAtIndex:(section-1)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoloyArray.count+1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
    else {
    
        NSArray *arr = self.searchEmoloyArray[section-1];
        
        return  arr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        
        cell.timeTitle.text = @"选择一个群";
        cell.arrowShowState = YES;
        
        return cell;
    }
    else {
    
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        //    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        //    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
        
        NSArray *sections = self.searchEmoloyArray[indexPath.section-1];
        HQEmployModel *model = sections[indexPath.row];
        
        cell.topLabel.text = model.employee_name;
        cell.bottomLabel.text = model.position;
        cell.topLabel.textColor = BlackTextColor;
        cell.enterImage.hidden = NO;
        cell.bottomLine.hidden = NO;
        
        if (model.position && ![model.position isEqualToString:@""]) {
            
            cell.type = TwoLineCellTypeTwo;
        }else{
            
            cell.type = TwoLineCellTypeOne;
        }
        
        if (![model.photograph isEqualToString:@""]&&model.photograph != nil) {
            
            [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal];
            [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
        }
        else {
            
            [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:HeadBackground];
        }
//        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.photograph] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
        
        cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        
        if (self.type == 1) {
            
            if ([model.selectState isEqualToNumber:@0] || model.selectState == nil) {
                [cell.enterImage setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
            }else{
                [cell.enterImage setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateNormal];
            }
        }
        
        if (sections.count - 1 == indexPath.row) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        TFChatGroupListController *groups = [[TFChatGroupListController alloc] init];
        
        groups.dbModel = self.dbModel;
        groups.fileModel = self.fileModel;
        if (self.isSend) {
            
            self.isSendFromFileLib = YES;
        }
        groups.isSendFromFileLib = self.isSendFromFileLib;
        groups.isTransitive = self.isTrans;
        
        [self.navigationController pushViewController:groups animated:YES];
    }
    else {
    
        NSArray *sections = self.searchEmoloyArray[indexPath.section-1];
        HQEmployModel *employee = sections[indexPath.row];
        
        if (self.type != 1) { //聊天

            if (!self.isDid) {
                
                NSArray *conversations = [DataBaseHandle queryAllChatListExceptAssistant];
                
                BOOL exist = NO;
                
                TFFMDBModel *model = [[TFFMDBModel alloc] init];
                for (model in conversations) {
                    
                    //会话已存在
                    if ([model.receiverID isEqualToNumber:employee.sign_id]) {
                        
                        exist = YES;
                        break;
                    }
                }
                
                if (!exist) { //没有该聊天
                    
                    //添加单聊
                    [self.chatBL requestAddSingleChatWithData:employee.sign_id];
                }
                else { //有该聊天
                
                    if (self.isSend) { //从文件库发
                        
                        self.isSendFromFileLib = YES;
                        self.isTrans = NO;
                    }
                    else {
                    
                        self.isSendFromFileLib = NO;
                        self.isTrans = YES;
                    }
                    TFChatViewController *chatVC = [[TFChatViewController alloc] init];
                    
                    chatVC.fileModel = self.fileModel;
                    chatVC.dbModel = self.dbModel;
                    chatVC.isTransitive = self.isTrans;
                    chatVC.isSendFromFileLib = self.isSendFromFileLib;
                    
                    chatVC.chatId = model.chatId;
                    chatVC.naviTitle = model.receiverName;
                    chatVC.cmdType = [model.chatType integerValue];
                    chatVC.receiveId = [model.receiverID integerValue];
                    [self.navigationController pushViewController:chatVC animated:YES];
                    
                }

                
                self.isDid = YES;
            }
            
            
            
        }
        else{ //选人
            if (self.isSingle) {
                
                for (NSArray *arr in self.searchEmoloyArray) {
                    
                    for (HQEmployModel *employ in arr) {
                        
                        employ.selectState = @0;
                        
                    }
                }
                employee.selectState = @1;
                
                [self.selectEmployees removeAllObjects];
                [self.selectEmployees addObject:employee];
                
                [self.tableView reloadData];
                
            }else{
                
                employee.selectState = ([employee.selectState isEqualToNumber:@0] || employee.selectState == nil)?@1:@0;
                
                NSMutableArray *allPeople = [NSMutableArray array];
                
                for (NSArray *arr in self.searchEmoloyArray) {
                    
                    for (HQEmployModel *employ in arr) {
                        
                        [allPeople addObject:employ];
                    }
                }
                
                [self.selectEmployees removeAllObjects];
                for (HQEmployModel *emp in allPeople) {
                    
                    if (emp.selectState != nil && [emp.selectState isEqualToNumber:@1]) {
                        [self.selectEmployees addObject:emp];
                    }
                }
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }

    }
    
}



-(void)createSingleConversationWithEmployee:(HQEmployModel *)employee{
    
    __block HQConversationController *sendMessageCtl =[[HQConversationController alloc] init];//!!
    //    __block JCHATConversationViewController *sendMessageCtl =[[JCHATConversationViewController alloc] init];
    __weak typeof(self)weakSelf = self;
    sendMessageCtl.superViewController = self;
    [JMSGConversation createSingleConversationWithUsername:employee.imUserName appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            JCHATMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            HQLog(@"createSingleConversationWithUsername");
        }
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.haveGroup) {
            
            return 46;
        }
        else{
        
           return 0;
        }
        
    }
    
    return 70;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_employeeList) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableArray *employess = [NSMutableArray array];
        for (TFEmployModel *model in resp.body) {
            
            if (![model.sign_id isEqualToNumber:UM.userLoginInfo.employee.sign_id]) {
                
                [employess addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
            }
            
            
        }
        
        
        [self.allEmployMutArr removeAllObjects];
        [self.allEmployMutArr addObjectsFromArray:employess];
        [self textFieldContentChange:nil];
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_addSingleChat) {
        
        self.isDid = NO;
        TFChatInfoListModel *model = resp.body;
        
        if (self.isTrans) {
            
            TFChatViewController *chatVC = [[TFChatViewController alloc] init];
            chatVC.dbModel = self.dbModel;
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
    
    self.isDid = NO;
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}


@end
