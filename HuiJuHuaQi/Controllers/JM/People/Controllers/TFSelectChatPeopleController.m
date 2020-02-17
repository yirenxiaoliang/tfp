//
//  TFSelectChatPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/4/17.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSelectChatPeopleController.h"
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

@interface TFSelectChatPeopleController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQBLDelegate,UITextFieldDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView;
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

@property (nonatomic, copy) NSString *keyWord;

@end

@implementation TFSelectChatPeopleController

-(NSMutableArray *)selectEmployees{
    if (!_selectEmployees) {
        _selectEmployees = [NSMutableArray array];
    }
    return _selectEmployees;
}

-(NSMutableArray *)allEmployMutArr{
    
    if (!_allEmployMutArr) {
        _allEmployMutArr = [NSMutableArray array];
        
//        NSArray *names = @[@"啊",@"吧",@"传",@"的",@"额",@"否",@"个",@"好",@"有"];
//        
//        for (NSInteger i = 0; i < 30; i ++) {
//            
//            HQEmployModel *model = [[HQEmployModel alloc] init];
//            model.employeeName = [NSString stringWithFormat:@"%@%ld",names[arc4random_uniform(9)],i];
//            model.position = @"iOS";
//            [_allEmployMutArr addObject:model];
//        }
        
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
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self textFieldContentChange:nil];
    [self setupTableView];
    [self setupHeaderSearch];
    [self textFieldContentChange:self.header.textField];
    [self setupNavigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
//    [self.peopleBL requestGetEmployeeByParamWithPageNo:1 pageSize:10000 departmentId:nil isNo:nil];
//    [self.peopleBL getPermissionWithModuleId:@1121];
    
    if (self.dataPeoples) {
        
        for (HQEmployModel *emp in self.dataPeoples) { //选中的人带进来
            
            if ([emp.selectState isEqualToNumber:@1]) {
                
                [self.selectEmployees addObject:emp];
            }
        }
        
        for (HQEmployModel *model in self.peoples) {
            
            for (HQEmployModel *em in self.dataPeoples) {
                
                if ([em.id isEqualToNumber:model.id]) {
                    
                    em.selectState = @1;
                    break;
                }
            }
            
        }
        
        [self.allEmployMutArr removeAllObjects];
        [self.allEmployMutArr addObjectsFromArray:self.dataPeoples];
        [self textFieldContentChange:nil];
        
    }else{
        
        [self.peopleBL requestEmployeeListWithDismiss:nil];
    }
    
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
    self.header = header;
    header.type = SearchHeaderTypeSearch;
    header.textField.delegate = self;
    header.button.backgroundColor = WhiteColor;
    header.delegate = self;
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    
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
    
}

- (void)createGroup{
    TFCreateGroupController *createGroup = [[TFCreateGroupController alloc] init];
    [self.navigationController pushViewController:createGroup animated:YES];
}
//
//-(void)searchHeaderClicked{
//
//    self.header.type = SearchHeaderTypeSearch;
//    [self.header.textField becomeFirstResponder];
//    self.header.frame = CGRectMake(0, 24, SCREEN_WIDTH, 64);
//    [self.navigationController.navigationBar addSubview:self.header];
//
////    [UIView animateWithDuration:0.25 animations:^{
////
////        self.headerSearch.y = -20;
////        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
////    }completion:^(BOOL finished) {
//
//        if (self.type != 1) {
//
//            if (self.isPermission) {
//
//                UIView *group = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,70}];
//                group.backgroundColor = WhiteColor;
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){15,12,46,46}];
//                [group addSubview:imageView];
//                imageView.image = [UIImage imageNamed:@"建群45"];
//                UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){CGRectGetMaxX(imageView.frame)+ 10,12,150,30}];
//                label.text = @"创建群组";
//                label.centerY = 70/2;
//                [group addSubview:label];
//                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(createGroup)];
//                [group addGestureRecognizer:tap];
//                self.tableView.tableHeaderView = group;
//            }else{
//
//                self.tableView.tableHeaderView = nil;
//            }
//
//        }else{
//
//            self.tableView.tableHeaderView = nil;
//        }
//
//
//        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//        self.tableView.contentOffset = CGPointMake(0, -44);
////    }];
//
//}

//
//-(void)searchHeaderCancelClicked{
//
//    self.header.type = SearchHeaderTypeNormal;
//    self.headerSearch.type = SearchHeaderTypeNormal;
//    [self.headerSearch.textField resignFirstResponder];
//
//    [UIView animateWithDuration:0.25 animations:^{
//        self.headerSearch.y = 24;
//        self.tableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
//        self.tableView.contentOffset = CGPointMake(0, -88);
//    }completion:^(BOOL finished) {
//
//        self.tableView.tableHeaderView = self.headerView;
//        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
//        [self.headerSearch removeFromSuperview];
//    }];
//
//}

- (void)keyboardHide{
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    self.keyWord = textField.text;
    
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
//    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
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
    return 30;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = BackGroudColor;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 30)];
    label.backgroundColor = HexAColor(0xf2f2f2, 1);
    label.font = [UIFont systemFontOfSize:14.0];
    NSString *sectionStr=[self.searchSectionArray objectAtIndex:(section)];
    [label setText:sectionStr];
    [contentView addSubview:label];
    return contentView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoloyArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.searchEmoloyArray[section];
    
    return  arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
//    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
//    [cell.titleImage setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateHighlighted];
    
    NSArray *sections = self.searchEmoloyArray[indexPath.section];
    HQEmployModel *model = sections[indexPath.row];
    
    cell.topLabel.text = model.employeeName?:model.employee_name;
    cell.bottomLabel.text = model.position;
    cell.topLabel.textColor = BlackTextColor;
    cell.enterImage.hidden = NO;
    cell.bottomLine.hidden = NO;
    
    if (model.position && ![model.position isEqualToString:@""]) {
        
        cell.type = TwoLineCellTypeTwo;
    }else{
        
        cell.type = TwoLineCellTypeOne;
    }
    
    if (![model.picture isEqualToString:@""]&&model.picture != nil) {
        
        [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
        [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        
        [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
        [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
        [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
        [cell.titleImage setBackgroundColor:GreenColor];
    }

    
//    [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
//    [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateHighlighted placeholderImage:PlaceholderHeadImage];
    
    cell.titleImage.layer.cornerRadius = cell.titleImage.width/2.0;
    cell.titleImage.layer.masksToBounds = YES;
    
    if (self.type == 1) {
        
        if ([model.selectState isEqualToNumber:@0] || model.selectState == nil) {
            [cell.enterImage setImage:[HQHelper createImageWithColor:ClearColor] forState:UIControlStateNormal];
        }else{
            [cell.enterImage setImage:[UIImage imageNamed:@"完成30"] forState:UIControlStateNormal];
        }
    }
    cell.enterImage.userInteractionEnabled = NO;
    if (sections.count - 1 == indexPath.row) {
        cell.bottomLine.hidden = YES;
    }else{
        cell.bottomLine.hidden = NO;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    NSArray *sections = self.searchEmoloyArray[indexPath.section];
    HQEmployModel *employee = sections[indexPath.row];
    
    if (self.type != 1) { //聊天
//        [self createSingleConversationWithEmployee:employee];
        
        
    }else{ //选人
        if (self.isSingle) {
            
            if ([employee.selectState isEqualToNumber:@1]) {
                
                employee.selectState = @0;
                [self.selectEmployees removeAllObjects];
                
            }else{
                
                for (NSArray *arr in self.searchEmoloyArray) {
                    
                    for (HQEmployModel *employ in arr) {
                        
                        employ.selectState = @0;
                        
                    }
                }
                employee.selectState = @1;
                [self.selectEmployees removeAllObjects];
                [self.selectEmployees addObject:employee];
            }
            
            [self.tableView reloadData];
            
        }
        else{
            
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
        
        
        NSMutableArray *employess = [NSMutableArray array];
        for (TFEmployModel *model in resp.body) {
            
            [employess addObject:[TFChangeHelper tfEmployeeToHqEmployee:model]];
        }
        
        for (HQEmployModel *model in self.peoples) {
            
            for (HQEmployModel *em in employess) {
                
                if ([[em.id description] isEqualToString:[model.id description]]) {
                    
                    em.selectState = @1;
                    break;
                }
            }
            
        }
        
        [self.allEmployMutArr removeAllObjects];
        [self.allEmployMutArr addObjectsFromArray:employess];
        [self textFieldContentChange:nil];
        
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
