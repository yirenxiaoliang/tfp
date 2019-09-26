//
//  TFAddressBookController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/1/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddressBookController.h"
#import "HQTFSearchHeader.h"
#import "TFPersonalMaterialController.h"
#import "TFChatGroupListController.h"
#import "TFContactsWorkFrameController.h"
#import "HQTFTwoLineCell.h"
#import "TFFilePathView.h"
#import "TFSearchPeopleController.h"
#import "TFContactorInfoController.h"
#import "ChineseString.h"
#import "TFRefresh.h"
#import "TFModelView.h"

@interface TFAddressBookController ()<UITableViewDelegate,UITableViewDataSource,HQTFSearchHeaderDelegate,HQTFTwoLineCellDelegate,TFModelViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;

/** 常用联系人 */
@property (nonatomic, strong) NSMutableArray *conmmonlyContacts;
/** 保存所有常用联系人 */
@property (nonatomic, strong) NSMutableArray *totalConmmonlyContacts;
@property (nonatomic, assign) NSInteger page;

/** 主部门名字 */
@property (nonatomic, copy) NSString *mainDepartmentName;


@property (nonatomic, strong) NSMutableArray *peopleModels;
@property (nonatomic, strong) NSMutableArray *titles;


@end

@implementation TFAddressBookController

-(NSMutableArray *)totalConmmonlyContacts{
    if (!_totalConmmonlyContacts) {
        _totalConmmonlyContacts = [NSMutableArray array];
    }
    return _totalConmmonlyContacts;
}

- (NSMutableArray *)conmmonlyContacts {

    if (!_conmmonlyContacts) {
        
        _conmmonlyContacts = [NSMutableArray array];
    }
    return _conmmonlyContacts;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self handleDatas];
}

/** 数据处理 */
-(void)handleDatas{
    
    // 常用联系人
    NSArray *datas = [DataBaseHandle queryCommonlyContactsData];
    //    self.conmmonlyContacts = [DataBaseHandle queryCommonlyContactsData];
    // 公司所有人
    NSArray *allPeople = UM.userLoginInfo.employees.allObjects;
    
    /* 数据库中存储的人有可能已经离职等，应去除掉，公司所有人中没有离职人员 */
    NSMutableArray *peos = [NSMutableArray array];
    for (TFFMDBModel *model in datas) {
        BOOL have = NO;
        for (TFEmployeeCModel *cmodel in allPeople) {
            if ([[cmodel.sign_id description] isEqualToString:[model.receiverID description]]) {
                have = YES;
                break;
            }
        }
        if (have) {
            [peos addObject:model];
        }
    }
    self.totalConmmonlyContacts = peos;
    self.page = 1;
    [self.conmmonlyContacts removeAllObjects];
    if (self.totalConmmonlyContacts.count > 10) {
        [self.conmmonlyContacts addObjectsFromArray:[self.totalConmmonlyContacts subarrayWithRange:(NSRange){0,10}]];
    }else{
        [self.conmmonlyContacts addObjectsFromArray:peos];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
    // 找到主部门
    TFDepartmentCModel *department = nil;
    
    NSArray *arr = [UM.userLoginInfo.departments allObjects];
    for (TFDepartmentCModel *model in arr) {
        
        if ([model.is_main isEqualToString:@"1"]) {
            
            department = model;
            break;
        }
    }
    self.mainDepartmentName = department.department_name;
    // 公司所有人（按名字首字母分组）
    //    [self handleNameSection];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
//    [self setupHeaderSearch];
    self.navigationItem.title = @"";
    self.navigationItem.leftBarButtonItem = [self titleItemWithTitle:@"通讯录" color:BlackTextColor imageName:nil withTarget:nil action:nil];
    
}

-(void)handleNameSection{
    
    // 公司所有人
    NSArray *allPeople = UM.userLoginInfo.employees.allObjects;
    
    NSMutableArray *nameMutArr = [NSMutableArray array];
    NSMutableArray *beginEmployArr = [NSMutableArray array];
    for (NSInteger i = 0; i < allPeople.count; i ++) {
        TFEmployeeCModel *model = allPeople[i];
        NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%ld", TEXT(model.employee_name), i];
        [nameMutArr addObject:nameIdStr];
        [beginEmployArr addObject:model];
    }
    NSMutableArray *arr1 = [ChineseString IndexArray:nameMutArr];// 获取名字首字母
    NSMutableArray *arr2 = [ChineseString LetterSortArray:nameMutArr];// 名字和index
    self.titles = arr1;
    
    if (arr1.count) {
        if ([arr1.firstObject isEqualToString:@"#"]) {// 将#放到最后
            id obj1 = arr1.firstObject;
            id obj2 = arr2.firstObject;
            [arr1 removeObjectAtIndex:0];
            [arr2 removeObjectAtIndex:0];
            [arr1 addObject:obj1];
            [arr2 addObject:obj2];
        }
    }
    
    // 将人员按字母排序分组
    NSMutableArray *peopleModels = [NSMutableArray array]; // 二维数组
    for (NSInteger i = 0; i < arr2.count; i ++) {
        NSMutableArray *sub = [NSMutableArray array];
        for (NSString *str in arr2[i]) {
            
            NSArray  *contentArr = [str componentsSeparatedByString:@"HJHQID"];
            
            NSInteger subscriptNum = [[contentArr lastObject] integerValue];
            
            //根据名字的排序，再根据下标，得到MODEL排序
            [sub addObject:beginEmployArr[subscriptNum]];
        }
        [peopleModels addObject:sub];
    }
    
    self.peopleModels = peopleModels;
    [self.titles insertObject:@"常" atIndex:0];
    [self.titles insertObject:@"搜" atIndex:0];
    
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    UIView *view = [UIView new];
    view.layer.masksToBounds = YES;
    view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    header.y = -20;
    [view addSubview:header];
    self.tableView.tableHeaderView = view;
    header.button.backgroundColor = BackGroudColor;
    header.backgroundColor = WhiteColor;
    header.delegate = self;
    
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.type = SearchHeaderTypeMove;
    headerSearch.delegate = self;
    
}

- (void)searchHeaderClicked{
    TFSearchPeopleController *search = [[TFSearchPeopleController alloc] init];
    search.isSee = YES;
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
//    //索引栏颜色
//    tableView.sectionIndexBackgroundColor = [UIColor clearColor];
//    //索引栏文字颜色
//    tableView.sectionIndexColor = ExtraLightBlackTextColor;
    
    // 头部view
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,84 + 44 + 20}];
    view.backgroundColor = WhiteColor;
    tableView.tableHeaderView = view;
    view.layer.masksToBounds = YES;
    
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    header.y = -20;
    [view addSubview:header];
    header.button.backgroundColor = BackGroudColor;
    header.backgroundColor = WhiteColor;
    header.delegate = self;
    
    NSArray *arr = [UM.userLoginInfo.departments allObjects];
    // 主部门id
    NSString *departmentName = @"所在部门";
    for (TFDepartmentCModel *model in arr) {
        
        if ([model.is_main isEqualToString:@"1"]) {// 找到主部门
            
            departmentName = model.department_name;
            break;
        }
    }
    
    NSArray *names = @[@"组织架构",departmentName,@"我的群聊"];
    NSArray *images = @[@"通讯录_组织架构",@"通讯录所在部门",@"通讯录群聊"];
    for (NSInteger i = 0; i < names.count; i ++) {
        TFModelView *mView = [TFModelView modelView];
        mView.frame = CGRectMake(SCREEN_WIDTH/3 * i, 44 + 20, SCREEN_WIDTH/3, 84);
        [view addSubview:mView];
        mView.nameLabel.text = names[i];
        mView.nameLabel.font = FONT(14);
        mView.nameLabel.numberOfLines = 1;
        mView.imageView.image = IMG(images[i]);
        mView.handleBtn.hidden = YES;
        mView.tag = i;
        mView.delegate = self;
        __weak __typeof(mView)weakV = mView;
        [weakV.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(weakV);
        }];
    }
    
    
    
    // 做一个
    tableView.mj_footer = [TFRefresh footerBackRefreshWithBlock:^{
        NSInteger num = self.totalConmmonlyContacts.count / 10;
        NSInteger row = self.totalConmmonlyContacts.count % 10;
        if (row > 0) {
            num += 1;
        }
        if (self.page >= num) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ((self.page+1) * 10 >= self.totalConmmonlyContacts.count) {
                    [self.conmmonlyContacts addObjectsFromArray:[self.totalConmmonlyContacts subarrayWithRange:(NSRange){self.page*10,self.totalConmmonlyContacts.count - self.page * 10}]];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.conmmonlyContacts addObjectsFromArray:[self.totalConmmonlyContacts subarrayWithRange:(NSRange){self.page*10,10}]];
                    [self.tableView.mj_footer endRefreshing];
                }
                self.page += 1;
                [self.tableView reloadData];
            });
        }
    }];
    
}
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return  self.titles;
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2 + self.peopleModels.count;
    return 2 ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return self.conmmonlyContacts.count;
    }else{
        NSArray *arr = self.peopleModels[section - 2];
        return arr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;

        cell.bottomLine.hidden = NO;
        cell.headMargin = 76;
        if (indexPath.row == 0) {
            
            cell.topLabel.text = @"组织架构";
            [cell.titleImage setImage:[UIImage imageNamed:@"通讯录_组织架构"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"通讯录_组织架构"] forState:UIControlStateHighlighted];
        }else if (indexPath.row == 1){
            
            cell.topLabel.text = TEXT(self.mainDepartmentName);
            
            [cell.titleImage setImage:[UIImage imageNamed:@"组织架构"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"组织架构"] forState:UIControlStateHighlighted];
        }
        else {
            cell.topLabel.text = @"我的群聊";
        
            [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateNormal];
            [cell.titleImage setImage:[UIImage imageNamed:@"群组45"] forState:UIControlStateHighlighted];
            cell.bottomLine.hidden = YES;
        }
        
        [cell.titleImage setBackgroundImage:nil forState:UIControlStateNormal];
        cell.titleImage.imageView.layer.cornerRadius = cell.titleImage.imageView.width/2.0;
        cell.titleImage.imageView.layer.masksToBounds = YES;
        [cell.titleImage setBackgroundColor:ClearColor];
        cell.enterImage.hidden = YES;
        return cell;

    }
    else if (indexPath.section == 1) {
    
        TFFMDBModel *model = self.conmmonlyContacts[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeTwo;
        
        cell.headMargin = 76;
        cell.delegate = self;
        cell.titleImage.userInteractionEnabled = YES;
        cell.titleImage.tag = 0x12345 * indexPath.section +indexPath.row;
        cell.enterImage.tag = 0x12345 * indexPath.section +indexPath.row;
        
        //根据sign_id查本地保存的公司人员信息
        TFEmployeeCModel *cModel = [HQHelper employeeWithEmployeeID:nil signId:model.receiverID];
        model.receiverName = cModel.employee_name;
        model.avatarUrl = cModel.picture;
        
        if (![model.avatarUrl isEqualToString:@""]&&model.avatarUrl != nil) {
            
            [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal];
//            [cell.titleImage yy_setImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal options:0];
            [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:ClearColor];
        }
        else {
            
            [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.receiverName] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:GreenColor];
        }
        [cell.titleImage setImage:nil forState:UIControlStateNormal];
//        [cell.titleImage setImage:[UIImage imageNamed:@"机器人45"] forState:UIControlStateHighlighted];
        
//        [cell.titleImage sd_setImageWithURL:[HQHelper URLWithString:model.avatarUrl] forState:UIControlStateNormal placeholderImage:PlaceholderHeadImage];
        cell.titleImage.layer.cornerRadius = 45/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        
        cell.topLabel.text = model.receiverName;
        cell.topLabel.font = FONT(16);
        cell.topLabel.textColor = BlackTextColor;
        
        cell.bottomLabel.text = IsStrEmpty(cModel.post_name)?@"--":cModel.post_name;
        cell.bottomLabel.font = FONT(13);
        cell.delegate = self;
        cell.enterImage.userInteractionEnabled = YES;
        cell.enterImage.hidden = NO;
        [cell.enterImage setImage:IMG(@"电话chat") forState:UIControlStateNormal];
        if (indexPath.row == self.conmmonlyContacts.count-1) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        return cell;
    }
    else{
        NSArray *arr = self.peopleModels[indexPath.section - 2];
        TFEmployeeCModel *model = arr[indexPath.row];
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeTwo;
        
        cell.headMargin = 76;
        cell.delegate = self;
        cell.titleImage.userInteractionEnabled = YES;
        cell.titleImage.tag = 0x12345 * indexPath.section +indexPath.row;
        cell.enterImage.tag = 0x12345 * indexPath.section +indexPath.row;
        
        if (![model.picture isEqualToString:@""]&&model.picture != nil) {
            
            [cell.titleImage sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.picture] forState:UIControlStateNormal];
            [cell.titleImage setTitle:@"" forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:ClearColor];
        }
        else {
            
            [cell.titleImage sd_setBackgroundImageWithURL:nil forState:UIControlStateNormal];
            [cell.titleImage setTitle:[HQHelper nameWithTotalName:model.employee_name] forState:UIControlStateNormal];
            [cell.titleImage setTitleColor:WhiteColor forState:UIControlStateNormal];
            [cell.titleImage setBackgroundColor:GreenColor];
        }
        [cell.titleImage setImage:nil forState:UIControlStateNormal];
        cell.titleImage.layer.cornerRadius = 45/2.0;
        cell.titleImage.layer.masksToBounds = YES;
        
        cell.topLabel.text = model.employee_name;
        
        cell.bottomLabel.text = IsStrEmpty(model.post_name)?@"--":model.post_name;
        
        cell.delegate = self;
        cell.enterImage.userInteractionEnabled = YES;
        cell.enterImage.hidden = NO;
        [cell.enterImage setImage:IMG(@"电话chat") forState:UIControlStateNormal];
        if (indexPath.row == arr.count-1) {
            cell.bottomLine.hidden = YES;
        }else{
            cell.bottomLine.hidden = NO;
        }
        return cell;
    }
}

#pragma mark - TFModelViewDelegate
-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    switch (modelView.tag) {
        case 0:
        {
            
            TFContactsWorkFrameController *item = [[TFContactsWorkFrameController alloc] init];
            item.isSee = YES;
            TFFilePathModel *model = [[TFFilePathModel alloc] init];
            model.name = @"通讯录";
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                model.className = [TFContactsWorkFrameController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                model.vcTag = vc.vcTag+1;
            }else{
                
                model.className = [TFContactsWorkFrameController class];
                model.vcTag = self.vcTag+1;
            }
            
            item.vcTag = self.vcTag + 1;
            [item.paths addObject:model];
            [self.navigationController pushViewController:item animated:YES];
            
        }
            break;
        case 1:
        {
            TFContactsWorkFrameController *item = [[TFContactsWorkFrameController alloc] init];
            item.isSee = YES;
            item.isMianDepartment = YES;
            TFFilePathModel *model = [[TFFilePathModel alloc] init];
            model.name = @"通讯录";
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                model.className = [TFContactsWorkFrameController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                model.vcTag = vc.vcTag+1;
            }else{
                
                model.className = [TFContactsWorkFrameController class];
                model.vcTag = self.vcTag+1;
            }
            item.vcTag = self.vcTag + 1;
            [item.paths addObject:model];
            [self.navigationController pushViewController:item animated:YES];
            
            
        }
            break;
        case 2:
        {
            
            TFChatGroupListController *group = [[TFChatGroupListController alloc] init];
            
            group.isSendFromFileLib = NO;
            
            [self.navigationController pushViewController:group animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFContactsWorkFrameController *item = [[TFContactsWorkFrameController alloc] init];
            item.isSee = YES;
            TFFilePathModel *model = [[TFFilePathModel alloc] init];
            model.name = @"通讯录";
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                model.className = [TFContactsWorkFrameController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                model.vcTag = vc.vcTag+1;
            }else{
                
                model.className = [TFContactsWorkFrameController class];
                model.vcTag = self.vcTag+1;
            }
            
            item.vcTag = self.vcTag + 1;
            [item.paths addObject:model];
            [self.navigationController pushViewController:item animated:YES];
            
            
        }
        else if (indexPath.row == 1) {
            
//            self.vcTag = 0x123454;
            TFContactsWorkFrameController *item = [[TFContactsWorkFrameController alloc] init];
            item.isSee = YES;
            item.isMianDepartment = YES;
            TFFilePathModel *model = [[TFFilePathModel alloc] init];
            model.name = @"通讯录";
            if (self.parentViewController && ![self.parentViewController isKindOfClass:[HQBaseNavigationController class]]) {
                model.className = [TFContactsWorkFrameController class];
                HQBaseViewController *vc = (HQBaseViewController *)self.parentViewController;
                model.vcTag = vc.vcTag+1;
            }else{
                
                model.className = [TFContactsWorkFrameController class];
                model.vcTag = self.vcTag+1;
            }
            item.vcTag = self.vcTag + 1;
            [item.paths addObject:model];
            [self.navigationController pushViewController:item animated:YES];
            
            
        }
        else if (indexPath.row == 2) {
        
            TFChatGroupListController *group = [[TFChatGroupListController alloc] init];
            
            group.isSendFromFileLib = NO;
            
            [self.navigationController pushViewController:group animated:YES];
        }
    }
    else if (indexPath.section == 1){
        
//        NSMutableArray *commonlys = [DataBaseHandle queryCommonlyContactsData];
//
//#warning 暂时过滤最后一条空数据
//        if (indexPath.row < commonlys.count-1) {
//
//            TFFMDBModel *model = commonlys[indexPath.row];
//
////            TFPersonalMaterialController *personMaterial = [[TFPersonalMaterialController alloc] init];
////
////            personMaterial.signId = model.receiverID;
////
////            [self.navigationController pushViewController:personMaterial animated:YES];
//
//            TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
//
//            personMaterial.signId = model.receiverID;
//
//            [self.navigationController pushViewController:personMaterial animated:YES];
//
//
//
//        }
            TFFMDBModel *model = self.conmmonlyContacts[indexPath.row];

            TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];

            personMaterial.signId = model.receiverID;

            [self.navigationController pushViewController:personMaterial animated:YES];
        
    }else{
        NSArray *arr = self.peopleModels[indexPath.section - 2];
        TFEmployeeCModel *model = arr[indexPath.row];
        
        TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
        
        personMaterial.signId = model.sign_id;
        
        [self.navigationController pushViewController:personMaterial animated:YES];
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        if (self.conmmonlyContacts.count) {
            return 35;
        }else{
            return 0;
        }
    }else{
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
//        UIView *view = [[UIView alloc] init];
//        view.layer.masksToBounds = YES;
//        view.backgroundColor = [UIColor whiteColor];
//        HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
//        self.header = header;
//        header.y = -20;
//        [view addSubview:header];
//        header.button.backgroundColor = BackGroudColor;
//        header.backgroundColor = WhiteColor;
//        header.delegate = self;
//        return view;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
        
    }else if (section == 1) {
        if (self.conmmonlyContacts.count) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = BackGroudColor;
            
            UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 35) title:@"   常用联系人" titleColor:ExtraLightBlackTextColor titleFont:14 bgColor:ClearColor];
            lab.textAlignment = NSTextAlignmentLeft;
            [view addSubview:lab];
            return view;
        }else{
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
    }else{
        
        NSString *str = self.titles[section];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BackGroudColor;
        UILabel *lab = [UILabel initCustom:CGRectMake(0, 0, SCREEN_WIDTH, 35) title:[NSString stringWithFormat:@"    %@",str] titleColor:kUIColorFromRGB(0xBBBBC3) titleFont:14 bgColor:ClearColor];
        lab.textAlignment = NSTextAlignmentLeft;
        [view addSubview:lab];
        return view;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark ---

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
////修改编辑按钮文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 1) {
//        
//        return @"删除";
//    }
//    else {
//        
//        return @"";;
//    }
//    
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (indexPath.section == 1) {
//        
//        return UITableViewCellEditingStyleDelete;
//    }
//    else {
//        
//        return UITableViewCellEditingStyleNone;
//    }
//    
//    
//}
////先设置Cell可移动
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return YES;
//}
//
////进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    HQLog(@"Action - tableView");
//    
//    if (indexPath.section == 1) {
//        
//    }
//    
//    
//}

#pragma mark HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    NSInteger section = cell.titleImage.tag / 0x12345;
    NSInteger index = cell.titleImage.tag % 0x12345;
    TFEmployeeCModel *cModel;
    if (section == 1) {
        TFFMDBModel *model = self.conmmonlyContacts[index];
        
        //根据sign_id查本地保存的公司人员信息
        cModel = [HQHelper employeeWithEmployeeID:nil signId:model.receiverID];
        
        if (IsStrEmpty(cModel.phone)) {
            return;
        }
    }else{
        NSArray *arr = self.peopleModels[section - 2];
        cModel = arr[index];
        if (IsStrEmpty(cModel.phone)) {
            return;
        }
    }
    
    NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",cModel.phone];
    
    UIWebView *callWebview = [[UIWebView alloc]init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
    
}
- (void)twoLineCell:(HQTFTwoLineCell *)cell titleImage:(UIButton *)photoBtn {

    NSInteger section = cell.titleImage.tag / 0x12345;
    NSInteger index = cell.titleImage.tag % 0x12345;
    
    if (section == 1) {
        
        TFFMDBModel *model = self.conmmonlyContacts[index];
        
        TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
        
        personMaterial.signId = model.receiverID;
        
        [self.navigationController pushViewController:personMaterial animated:YES];
        
    }else{
        NSArray *arr = self.peopleModels[section - 2];
        TFEmployeeCModel *model = arr[index];
        TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
        
        personMaterial.signId = model.sign_id;
        
        [self.navigationController pushViewController:personMaterial animated:YES];
        
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y <= 22) {
        self.shadowLine.hidden = YES;
    }else{
        self.shadowLine.hidden = NO;
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (targetContentOffset->y <= 22) {
        targetContentOffset->y = 0;
    }else if (targetContentOffset->y <= 44) {
        targetContentOffset->y = 44;
    }
}
@end
