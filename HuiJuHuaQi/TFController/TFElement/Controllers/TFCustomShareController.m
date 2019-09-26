//
//  TFCustomShareController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/12/12.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomShareController.h"
#import "TFCustomShareModel.h"
#import "TFSelectPeopleCell.h"
#import "HQSelectTimeCell.h"
#import "TFCustomShareHandleView.h"
#import "TFSelectChatPeopleController.h"
#import "FDActionSheet.h"
#import "TFCustomBL.h"
#import "TFNormalPeopleModel.h"
#import "TFChangeHelper.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFRoleModel.h"
#import "TFParameterModel.h"
#import "TFDynamicParameterModel.h"

@interface TFCustomShareController ()<UITableViewDelegate,UITableViewDataSource,TFCustomShareHandleViewDelegate,FDActionSheetDelegate,UIAlertViewDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** shares */
@property (nonatomic, strong) NSMutableArray *shares;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


@end

@implementation TFCustomShareController

-(NSMutableArray *)shares{
    if (!_shares) {
        _shares = [NSMutableArray array];
    }
    return _shares;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.type == 0) {
        
        [self.customBL requestCustomShareListWithDataId:self.dataId bean:self.bean];
        
    }else if (self.type == 1){
        TFCustomShareModel *model = [[TFCustomShareModel alloc] init];
        model.auth = @0;
        [self.shares addObject:model];
    }else{
        if (self.shareModel) {
            [self.shares addObject:self.shareModel];
        }
    }
}



#pragma mark - navi
- (void)setupNavi{
    
    self.navigationItem.title = @"共享";
    if (self.type == 0) {
        
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"新增" textColor:GreenColor];
    }else{
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(saveClicked) text:@"保存" textColor:GreenColor];
    }
}

- (void)rightClicked{
    TFCustomShareController *share = [[TFCustomShareController alloc] init];
    share.type = 1;
    share.bean = self.bean;
    share.dataId = self.dataId;
    share.refreshAction = ^{
        
        [self.customBL requestCustomShareListWithDataId:self.dataId bean:self.bean];
    };
    [self.navigationController pushViewController:share animated:YES];
}

- (void)saveClicked{
    
        
    TFCustomShareModel *model = self.shares[0];
    if (!model.peoples || model.peoples.count == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.type == 2) {// 编辑
        [dict setObject:model.id forKey:@"id"];
    }
    
    if (self.bean) {
        [dict setObject:self.bean forKey:@"bean_name"];
    }
    if (self.dataId) {
        [dict setObject:self.dataId forKey:@"dataId"];
    }
    
    NSMutableDictionary *basics = [NSMutableDictionary dictionary];
    [basics setObject:model.auth forKey:@"access_permissions"];
    
    
    NSString *target_label = @"";
    NSMutableArray *allot_employee = [NSMutableArray array];
   
    for (TFParameterModel *em in model.peoples) {
        
        target_label = [target_label stringByAppendingString:[NSString stringWithFormat:@"%@,",em.name]];
        NSMutableDictionary *di = [NSMutableDictionary dictionary];
        if (em.id) {
            [di setObject:em.id forKey:@"id"];
        }
        if (em.name) {
            [di setObject:em.name forKey:@"name"];
        }
        if (em.picture) {
            [di setObject:em.picture forKey:@"picture"];
        }
        if (em.sign_id) {
            [di setObject:em.sign_id forKey:@"sign_id"];
        }
        if (em.type) {
            [di setObject:em.type forKey:@"type"];
        }
        if (em.value) {
            [di setObject:em.value forKey:@"value"];
        }
        
        [allot_employee addObject:di];
    }
    
    if (target_label.length) {
        target_label = [target_label substringToIndex:target_label.length-1];
    }
    [basics setObject:target_label forKey:@"target_lable"];
    [basics setObject:allot_employee forKey:@"allot_employee"];
    
    
    [dict setObject:basics forKey:@"basics"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 1) {// 新增
        [self.customBL requestCustomShareSaveWithDict:dict];
    }
    if (self.type == 2) {// 编辑
        [self.customBL requestCustomShareEditWithDict:dict];
    }
    
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    NSString *str = @"指定的数据共享设置，可将部门或成员一起共享此单个数据。";
    CGSize size = [HQHelper sizeWithFont:FONT(14) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:str];
    UILabel *label = [HQHelper labelWithFrame:(CGRect){15,10,SCREEN_WIDTH-30,size.height} text:str textColor:LightGrayTextColor textAlignment:NSTextAlignmentLeft font:FONT(14)];
    label.numberOfLines = 0;
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,size.height + 20}];
    [view addSubview:label];
    tableView.tableHeaderView = view;
    
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.shares.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    TFCustomShareModel *model = self.shares[indexPath.section];
    
    if (indexPath.row == 0) {
        TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
        [cell refreshSelectPeopleCellWithParameters:model.peoples structure:@"1" chooseType:@"1" showAdd:self.type == 0 ? NO : YES clear:NO];
        cell.requireLabel.hidden = YES;
        cell.titleLabel.text = @"共享给";
        cell.topLine.hidden = YES;
        return cell;
    }else{
        
        HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
        cell.timeTitle.text = @"访问权限";
        
        NSString *str = @"只读";
        if ([model.auth isEqualToNumber:@1]) {
            str = @"读/写";
        }else if ([model.auth isEqualToNumber:@2]){
            str = @"读/写/删";
        }
        
        cell.time.text = str;
        cell.time.textColor = BlackTextColor;
        cell.arrowShowState = YES;
        cell.fieldControl = @"0";
        cell.structure = @"1";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    TFCustomShareModel *model = self.shares[indexPath.section];
    
    if (self.type != 0) {
        if (indexPath.row == 0) {
            
//            TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
//            select.peoples = model.peoples;
//            select.type = 1;
//            select.isSingle = NO;
//            select.actionParameter = ^(NSArray *parameter) {
//
//                model.peoples = [NSMutableArray arrayWithArray:parameter];
//                [self.tableView reloadData];
//            };
//            [self.navigationController pushViewController:select animated:YES];
            
            NSMutableArray *peos = [NSMutableArray array];
            for (TFParameterModel *pa in model.peoples) {
                if ([pa.type isEqualToNumber:@1]) {// 人员
                    HQEmployModel *em = [[HQEmployModel alloc] init];
                    em.id = pa.id;
                    em.type = pa.type;
                    em.employeeName = pa.name;
                    em.sign_id = pa.sign_id;
                    em.photograph = pa.picture;
                    em.value = pa.value;
                    [peos addObject:em];
                }else if ([pa.type isEqualToNumber:@0]){
                    TFDepartmentModel *em = [[TFDepartmentModel alloc] init];
                    em.id = pa.id;
                    em.type = pa.type;
                    em.name = pa.name;
                    em.value = pa.value;
                    [peos addObject:em];
                }else if ([pa.type isEqualToNumber:@2]){
                    TFRoleModel *em = [[TFRoleModel alloc] init];
                    em.id = pa.id;
                    em.type = pa.type;
                    em.name = pa.name;
                    em.value = pa.value;
                    [peos addObject:em];
                }else if ([pa.type isEqualToNumber:@3]){
                    TFDynamicParameterModel *em = [[TFDynamicParameterModel alloc] init];
                    em.id = pa.id;
                    em.type = pa.type;
                    em.name = pa.name;
                    em.value = pa.value;
                    em.identifer = pa.identifer;
                    [peos addObject:em];
                }
            }
            
            TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
            scheduleVC.selectType = 0;
            scheduleVC.isSingleSelect = NO;
            scheduleVC.defaultPoeples = peos;
            //            scheduleVC.noSelectPoeples = model.selects;
            scheduleVC.bean = self.bean;
            scheduleVC.actionParameter = ^(NSArray *parameter) {
                
                NSMutableArray *arr = [NSMutableArray array];
                for (id obj in parameter) {
                    if ([obj isKindOfClass:[HQEmployModel class]]) {
                        HQEmployModel *em = (HQEmployModel *)obj;
                        TFParameterModel *model = [[TFParameterModel alloc] init];
                        model.id = em.id;
                        model.name = em.employeeName;
                        model.type = @1;
                        model.picture = em.photograph;
                        model.sign_id = em.sign_id;
                        model.value = em.value;
                        [arr addObject:model];
                    }else if ([obj isKindOfClass:[TFDepartmentModel class]]){
                        TFDepartmentModel *em = (TFDepartmentModel *)obj;
                        TFParameterModel *model = [[TFParameterModel alloc] init];
                        model.id = em.id;
                        model.name = em.name;
                        model.type = @0;
                        model.value = em.value;
                        [arr addObject:model];
                    }else if ([obj isKindOfClass:[TFRoleModel class]]){
                        TFRoleModel *em = (TFRoleModel *)obj;
                        TFParameterModel *model = [[TFParameterModel alloc] init];
                        model.id = em.id;
                        model.name = em.name;
                        model.type = @2;
                        model.value = em.value;
                        [arr addObject:model];
                    }else if ([obj isKindOfClass:[TFDynamicParameterModel class]]){
                        TFDynamicParameterModel *em = (TFDynamicParameterModel *)obj;
                        TFParameterModel *model = [[TFParameterModel alloc] init];
                        model.id = em.id;
                        model.name = em.name;
                        model.type = @3;
                        model.value = em.value;
                        model.identifer = em.identifer;
                        [arr addObject:model];
                    }
                }
                
                model.peoples = [NSMutableArray arrayWithArray:arr];
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:scheduleVC animated:YES];
            
        }
        
        if (indexPath.row == 1) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"选择权限" delegate:self cancelButtonTitle:@"取消" titles:@[@"只读",@"读/写",@"读/写/删"]];
            sheet.tag = indexPath.section;
            [sheet show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"1"];
    }
    
    return 64;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (self.type == 0) {
        return 36;
    }else{
        return 0.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.type == 0) {
        TFCustomShareHandleView *view = [TFCustomShareHandleView customShareHandleView];
        view.deleteBtn.tag = section;
        view.editBtn.tag = section;
        view.delegate = self;
        
        return view;
    }else{
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - TFCustomShareHandleViewDelegate
-(void)customShareHandleViewDidClickedEditBtn:(UIButton *)editBtn{
    
    TFCustomShareModel *model = self.shares[editBtn.tag];
    TFCustomShareController *share = [[TFCustomShareController alloc] init];
    share.type = 2;
    share.bean = self.bean;
    share.dataId = self.dataId;
    share.shareModel = model;
    share.refreshAction = ^{
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:share animated:YES];
}

-(void)customShareHandleViewDidClickedDeleteBtn:(UIButton *)deleteBtn{
    
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除该数据共享？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.delegate = self;
    alertView.tag = deleteBtn.tag;
    [alertView show];
}
#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        TFCustomShareModel *model = self.shares[alertView.tag];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomShareDeleteWithDataId:model.id];
        
        kWEAKSELF
        self.deleteAction = ^{
            [weakSelf.shares removeObject:model];
            [weakSelf.tableView reloadData];
        };
    }
}


#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    TFCustomShareModel *model = self.shares[sheet.tag];
    
    model.auth = @(buttonIndex);
    
    [self.tableView reloadData];
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customShareList) {
        
        NSArray *arr = resp.body;
        
        [self.shares removeAllObjects];
        for (NSDictionary *dict in arr) {
            TFCustomShareModel *model = [[TFCustomShareModel alloc] init];
            model.id = [dict valueForKey:@"id"];
            model.auth = @([[dict valueForKey:@"access_permissions"] integerValue]);
            
            NSArray *peos = [dict valueForKey:@"allot_employee"];
            NSMutableArray *peoples = [NSMutableArray array];
            for (NSDictionary *di in peos) {
                TFParameterModel *nor = [[TFParameterModel alloc] initWithDictionary:di error:nil];

                if (nor) {
                    [peoples addObject:nor];
                }
                
            }
            model.peoples = peoples;
            
            [self.shares addObject:model];
        }
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_customShareSave) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_customShareEdit) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.refreshAction) {
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_customShareDelete) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.deleteAction) {
            self.deleteAction();
        }
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
