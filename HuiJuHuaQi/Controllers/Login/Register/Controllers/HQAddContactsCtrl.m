//
//  HQAddContactsCtrl.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/1/14.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAddContactsCtrl.h"
#import "HQContactsModel.h"
#import "HQAddContactsCell.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "HQBaseTabBarViewController.h"
//#import <MessageUI/MessageUI.h>
#import "HQTFSearchHeader.h"
#import "ChineseString.h"
#import "HQTFContactChoiceView.h"


@interface HQAddContactsCtrl () <UITableViewDataSource, UITableViewDelegate , HQTFSearchHeaderDelegate,HQAddContactsCellDelegate>
//<ABPersonViewControllerDelegate, MFMessageComposeViewControllerDelegate >
{
    
    NSMutableArray * contactMutableArray; // 选中的联系人
}

@property (nonatomic, assign) ABAddressBookRef addressBookRef;

//@property (nonatomic, strong) NSMutableArray *dataList;//原始数据
@property (nonatomic, strong) NSMutableArray *searchList;//显示数据

@property (nonatomic, strong) NSMutableArray *contactArr;  //所有数据

@property (nonatomic, strong) NSMutableArray *phoneMutArr;


@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UITextField *searchTextFiled;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** HQTFSearchHeader *header */
@property (nonatomic, strong) HQTFSearchHeader *header;
/** HQTFSearchHeader *header */
@property (nonatomic, strong) UIView *headerView;



@property (nonatomic, strong)NSMutableArray * searchSectionArray ; //搜索的sectionTitle数据

@property (nonatomic, strong)NSMutableArray * searchTitleArray;    //搜索的row

@property (nonatomic, strong)NSMutableArray * searchEmoloyArray;   //搜索数据(就是当前显示的)


@end

@implementation HQAddContactsCtrl


- (NSMutableArray *)contactArr{
    if (_contactArr == nil) {
        _contactArr = [NSMutableArray array];
    }
    return _contactArr;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
//    [self setFromNavBottomEdgeLayout];
    
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = @"手机联系人";
    
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self
//                                                           action:@selector(sureAction:)
//                                                             text:@"确定"];
    
    self.phoneMutArr = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -44, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    [self.view addSubview:tableView];
    _contactsTableView = tableView;
    _contactsTableView.backgroundColor = BackGroudColor;
    
//    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,46}];
//    view.layer.masksToBounds = YES;
//    [view addSubview:self.headerSearch];
//    _contactsTableView.tableHeaderView = view;
    
    //索引栏颜色
    _contactsTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    //索引栏文字颜色
    _contactsTableView.sectionIndexColor = ExtraLightBlackTextColor;
    
    
    
    [self setupHeaderSearch];
    
    
    
    
    CFErrorRef error;
    _addressBookRef = ABAddressBookCreateWithOptions(NULL, &error);
    
    ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getContactsFromAddressBook];
            });
        } else {
            // TODO: Show alert
            HQLog(@"please get me authority!");
        }
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - headerSearch
- (void)setupHeaderSearch{
    HQTFSearchHeader *header = [HQTFSearchHeader searchHeader];
    self.header = header;
    UIView *headerView = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44}];
    header.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    [headerView addSubview:header];
    headerView.backgroundColor = HexAColor(0xe7e7e7, 1);
    self.headerView = headerView;
    self.contactsTableView.tableHeaderView = headerView;
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
        self.contactsTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }completion:^(BOOL finished) {
        
        self.contactsTableView.tableHeaderView = nil;
        self.contactsTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        self.contactsTableView.contentOffset = CGPointMake(0, -44);
    }];
    
}


-(void)searchHeaderCancelClicked{
    
    self.header.type = SearchHeaderTypeNormal;
    self.headerSearch.type = SearchHeaderTypeNormal;
    [self.headerSearch.textField resignFirstResponder];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.headerSearch.y = 24;
        self.contactsTableView.contentInset = UIEdgeInsetsMake(88, 0, 0, 0);
        self.contactsTableView.contentOffset = CGPointMake(0, -88);
    }completion:^(BOOL finished) {
        
        self.contactsTableView.tableHeaderView = self.headerView;
        self.contactsTableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
        [self.headerSearch removeFromSuperview];
    }];
    
}

- (void)keyboardHide{
    
}

-(void)searchHeaderTextChange:(UITextField *)textField{
    
    [self textFieldChangeOfAddContact:textField];
}

/**
 * 返回上一层
 */
-(void)popLastNavi{
    
    [self.navigationController popViewControllerAnimated:YES] ;
}



- (void)textFieldChangeOfAddContact:(UITextField *)textField
{
    
    NSMutableArray * nameMutArr  = [[NSMutableArray alloc] init];     //用于存加入标识（下标）后的名字
    
    NSMutableArray *beginEmployArr = [[NSMutableArray alloc] init];
    
    int i = 0;
    
    UITextRange *textRange = [textField markedTextRange];// 高亮文字范围
    
    NSString *highStr = [textField textInRange:textRange];
    
    if (highStr.length <= 0) {// 没有高亮时进行搜索
        
        for (HQContactsModel *contactsModel in self.searchList) {
            
            
            //只要搜索框里的字被包含，或搜索框里无字时，保存
            if ([TEXT(contactsModel.lastName) rangeOfString:TEXT(textField.text)].length > 0  ||  textField.text.length == 0) {
                
                NSString *nameIdStr = [NSString stringWithFormat:@"%@HJHQID%d", TEXT(contactsModel.lastName), i];
                
                [nameMutArr addObject:nameIdStr];
                
                [beginEmployArr addObject:contactsModel];
                
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
        
        
        [_contactsTableView reloadData];
    }
}





- (void)getContactsFromAddressBook
{
    [self.contactArr removeAllObjects];
    
    //get all people info from the address book
    ABAddressBookRef addressBook = ABAddressBookCreate();
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);//这是个数组的引用
    for(int i = 0; i<CFArrayGetCount(people); i++){
        
        
        HQContactsModel *contact = [[HQContactsModel alloc] init];
        
        //parse each person of addressbook
        ABRecordRef record=CFArrayGetValueAtIndex(people, i);//取出一条记录
        //以下的属性都是唯一的，即一个人只有一个FirstName，一个Organization。。。
        CFStringRef firstName = ABRecordCopyValue(record,kABPersonFirstNameProperty);
        CFStringRef lastName =  ABRecordCopyValue(record,kABPersonLastNameProperty);
//        CFStringRef company = ABRecordCopyValue(record,kABPersonOrganizationProperty);
//        CFStringRef department = ABRecordCopyValue(record,kABPersonDepartmentProperty);
//        CFStringRef job = ABRecordCopyValue(record,kABPersonJobTitleProperty);
        contact.firstName = (__bridge NSString *)firstName;
        contact.lastName  = (__bridge NSString *)lastName;
        
        //"CFStringRef"这个类型也是个引用，可以转成NSString*
//        HQLog((__bridge NSString *)firstName);
        //......
        //所有这些应用都是要释放的，手册里是说“you are responsible to release it"
        (firstName==NULL)?:CFRelease(firstName);
        (lastName==NULL)?:CFRelease(lastName);
//        (company==NULL)?:CFRelease(company);
//        (department==NULL)?:CFRelease(department);
//        (job==NULL)?:CFRelease(job);
        //.......
        //有些属性不是唯一的，比如一个人有多个电话：手机，主电话，传真。。。
        ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        //所有ABMutableMultiValueRef这样的引用的东西都是这样一个元组（id，label，value）
        multiPhone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        for (CFIndex i = 0; i < ABMultiValueGetCount(multiPhone); i++) {
            
//            CFStringRef labelRef = ABMultiValueCopyLabelAtIndex(multiPhone, i);
            CFStringRef numberRef = ABMultiValueCopyValueAtIndex(multiPhone, i);

            
//            //手机
//            if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Mobile>!$_"]) {
//                
//                
//            //住宅
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Home>!$_"]) {
//            
//                
//            //工作
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Work>!$_"]) {
//                
//                
//            //IPHONE
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"iPhone"]) {
//                
//                
//            //主要
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Main>!$_"]) {
//            
//            
//            //住宅传呼
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<HomeFAX>!$_"]) {
//             
//                
//            //工作传真
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<WorkFAX>!$_"]) {
//            
//               
//            //传真
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Pager>!$_"]) {
//             
//                
//            //其它
//            }else if ([(__bridge NSString *)labelRef isEqualToString:@"_$!<Other>!$_"]) {
//                
//            }
            
            
            NSString *phone = (__bridge NSString *)numberRef;
            if (!contact.phones) {
                contact.phones = [NSMutableArray array];
            }
            [contact.phones addObject:phone];
            
            CFRelease(numberRef);
        }
        
        CFRelease(multiPhone);
        
        [self.contactArr addObject:contact];
    }
    
    
    self.searchList = [NSMutableArray arrayWithArray:self.contactArr];
    
    [self textFieldChangeOfAddContact:nil];
}




- (void)didBack:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}









- (void)sureAction:(id)sender
{
    if (self.vCType == HQAddContactsCtrlType_import) {
        
        
        NSMutableArray *contacts = [NSMutableArray array];
        
        for (int i=0; i<self.searchList.count; i++) {
            
            HQContactsModel *model = self.searchList[i];
            
            if (model.selected == YES) {
                
                [contacts addObject:model];
            }
        }
        
        if (contacts.count == 0) {
            
            [MBProgressHUD showError:@"请选择联系人" toView:self.view];
            return;
        }
        
        if ([self.delegate respondsToSelector:@selector(addContactsCtrlSelectedContancts:)]) {
            [self.delegate addContactsCtrlSelectedContancts:contacts];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        [_phoneMutArr removeAllObjects];
        for (int i=0; i<self.searchList.count; i++) {
            
            HQContactsModel *model = self.searchList[i];
            
            NSString *phoneStr = [[model.phones firstObject] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            if (model.selected == YES) {
                
                if (![HQHelper checkTel:phoneStr]) {
                    [MBProgressHUD showError:@"该手机号格式有误" toView:self.view];
                    return;
                }
                
                
                [_phoneMutArr addObject:phoneStr];
            }
        }
        
        if (_phoneMutArr.count == 0) {
            
            [MBProgressHUD showError:@"请选择联系人" toView:self.view];
            return;
        }
        
        
//        [MBProgressHUD showMessag:LoadTitle toView:self.view];
        
//        HQEmployCModel *employ = [HQUserManager defaultUserInfoManager].userLoginInfo.employee;
        
        
//        [registerBL getQuestInvitationCodeWithTelephones:_phoneMutArr];

    }
    
}



- (void)delayAddContactAction
{
    if (_registerOrLookAtState == YES) {
        
        [self.navigationController popViewControllerAnimated:YES];
    
    
    }else {
        
//        for (UIViewController *viewCtrl in self.navigationController.viewControllers) {
        
//            if ([viewCtrl isKindOfClass:[HQSelectCompanyController class]]) {
//                
//                [self.navigationController popToViewController:viewCtrl animated:YES];
//                return;
//            }
//        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UITableViewDelegate And UITableViewDataSource

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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.searchEmoloyArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *arr = self.searchEmoloyArray[section];
    
    return  arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"addContacts-cell";
    
    HQAddContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HQAddContactsCell" owner:nil options:nil] firstObject];
    }
    
    HQContactsModel *contactsModel = self.searchEmoloyArray[indexPath.section][indexPath.row];
    

    [cell refreshCellWithModel:contactsModel];
    cell.delegate = self;
    
    return cell;
}

-(void)addContactsCellDidClickedAddBtnWithModel:(HQContactsModel *)model{
    
    if (model) {
        if (self.actionParameter) {
            self.actionParameter(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    HQContactsModel *model = self.searchEmoloyArray[indexPath.section][indexPath.row];
//
//    model.selected = !model.selected;
//
//    [self.searchList replaceObjectAtIndex:indexPath.row withObject:model];
//
//    
//    [_contactsTableView reloadData];
//    
//    
//    [HQTFContactChoiceView showContactChoiceView:[NSString stringWithFormat:@"邀请%@", model.phones[0]] onLeftTouched:^{
//        
//    } onRightTouched:^(id parameter) {
//        NSNumber *num = (NSNumber *)parameter;
//        HQLog(@"%ld", num.integerValue);
//        
//    }];
    
    
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
