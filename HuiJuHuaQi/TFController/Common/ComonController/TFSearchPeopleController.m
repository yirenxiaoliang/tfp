//
//  TFSearchPeopleController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/20.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFSearchPeopleController.h"
#import "HQTFSearchHeader.h"
#import "HQTFNoContentView.h"
#import "TFPeopleBL.h"
#import "TFSelectPeopleElementCell.h"
#import "TFContactorInfoController.h"

@interface TFSearchPeopleController ()<HQTFSearchHeaderDelegate,UITextFieldDelegate,HQBLDelegate,UITableViewDelegate,UITableViewDataSource,TFSelectPeopleElementCellDelegate>
/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;

/** HQTFSearchHeader *headerSearch */
@property (nonatomic, strong) HQTFSearchHeader *headerSearch;
/** keyWord */
@property (nonatomic, copy) NSString *keyWord;
/** tableView */
@property (nonatomic, weak) UITableView *tableView;
/** TFPeopleBL */
@property (nonatomic, strong) TFPeopleBL *peopleBL;

/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;


@end

@implementation TFSearchPeopleController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:nil action:nil text:@""];
    [self.navigationController.navigationBar addSubview:self.headerSearch];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.headerSearch removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeader];
    [self setupTableView];
    self.peopleBL = [TFPeopleBL build];
    self.peopleBL.delegate = self;
    [self.headerSearch.textField becomeFirstResponder];
}

- (void)setupHeader{
    
    HQTFSearchHeader *headerSearch = [HQTFSearchHeader searchHeader];
    self.headerSearch = headerSearch;
    headerSearch.frame = CGRectMake(0, -20, SCREEN_WIDTH, 64);
    if (self.isSee) {
        
        headerSearch.type = SearchHeaderTypeMove;
    }else{
        
        headerSearch.type = SearchHeaderTypeTwoBtn;
    }
    headerSearch.textField.returnKeyType = UIReturnKeySearch;
    headerSearch.delegate = self;
    headerSearch.textField.delegate = self;
}

#pragma mark - HQTFSearchHeaderDelegate
- (void)searchHeaderRightBtnClicked{
    
    if (self.isSee) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (TFEmployModel *model in self.peoples) {
            if ([model.select isEqualToNumber:@1]) {
                [arr addObject:model];
            }
        }
        if (self.actionParameter) {
            self.actionParameter(arr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)searchHeaderleftBtnClicked{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = self.keyWord;
}

- (void)searchHeaderTextChange:(UITextField *)textField{
    
    self.keyWord = textField.text;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length <= 0) {
        return YES;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.peopleBL requsetFindByUserNameWithDepartmentId:self.departmentId employeeName:textField.text dismiss:self.dismiss];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [self.peoples removeAllObjects];
    
    [self.peoples addObjectsFromArray:resp.body];
    
    if (self.peoples.count) {
        self.tableView.backgroundView = [UIView new];
    }else{
        self.tableView.backgroundView = self.noContentView;
    }
    
    [self.tableView reloadData];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}



-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:@"暂无数据"];
    }
    return _noContentView;
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
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peoples.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFSelectPeopleElementCell *cell = [TFSelectPeopleElementCell selectPeopleElementCellWithTableView:tableView index:indexPath.section * 999 + indexPath.row];
    cell.delegate = self;
    TFEmployModel *model = self.peoples[indexPath.row];
    [cell refreshCellWithEmployeeModel:model isSingle:self.isSee?YES:NO];
    cell.selectBtn.tag = 0x999 * indexPath.section + indexPath.row;
    cell.selectBtn.userInteractionEnabled = NO;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (self.isSee) {
        
        TFEmployModel *model = self.peoples[indexPath.row];
        
        TFContactorInfoController *personMaterial = [[TFContactorInfoController alloc] init];
        
        personMaterial.signId = model.sign_id;
        
        [self.navigationController pushViewController:personMaterial animated:YES];
        
    }else{
        
        if (self.isSingleSelect) {
            
            for (TFEmployModel *model in self.peoples) {
                
                model.select = @0;
            }
            
            TFEmployModel *model1 = self.peoples[indexPath.row];
            model1.select = @1;
            
            [self.tableView reloadData];
            
        }else{
            
            TFEmployModel *model1 = self.peoples[indexPath.row];
            model1.select = [model1.select isEqualToNumber:@1]?@0:@1;
            
            [self.tableView reloadData];
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
