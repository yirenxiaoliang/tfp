
//
//  TFApprovalCopyerController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/1/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalCopyerController.h"
#import "HQTFTwoLineCell.h"
#import "HQEmployModel.h"
#import "TFEmployModel.h"
#import "TFSelectChatPeopleController.h"
#import "TFCustomBL.h"
#import "HQTFNoContentView.h"

@interface TFApprovalCopyerController ()<UITableViewDelegate,UITableViewDataSource,HQTFTwoLineCellDelegate,HQBLDelegate>
/** UITableView *tableView */
@property (nonatomic, weak) UITableView *tableView ;

/** peoples */
@property (nonatomic, strong) NSMutableArray *participants;
/** peoples */
@property (nonatomic, strong) NSMutableArray *peoples;


/** TFCustomerBL */
@property (nonatomic, strong) TFCustomBL *customBL;

/** type :客户成员列表 1：选择成员 */
@property (nonatomic, assign) NSInteger type;

/** noContentView */
@property (nonatomic, strong) HQTFNoContentView *noContentView;


@end

@implementation TFApprovalCopyerController

-(HQTFNoContentView *)noContentView{
    
    if (!_noContentView) {
        _noContentView = [HQTFNoContentView noContentView];
        
        [_noContentView setupImageViewRect:(CGRect){30,(self.tableView.height-Long(150))/2,SCREEN_WIDTH - 60,Long(150)} imgImage:@"图123" withTipWord:[NSString stringWithFormat:@"暂无%@",self.naviTitle]];
    }
    return _noContentView;
}

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 3; i ++) {
//            HQEmployModel *model = [[HQEmployModel alloc] init];
//            model.employeeName = @"亮亮";
//            model.id = @1;
//            [_peoples addObject:model];
//        }
        
        [_peoples addObjectsFromArray:self.employees];
    }
    return _peoples;
}

-(NSMutableArray *)participants{
    if (!_participants) {
        _participants = [NSMutableArray array];
        
//        for (NSInteger i = 0; i < 3; i ++) {
//            HQEmployModel *model = [[HQEmployModel alloc] init];
//            model.employeeName = @"亮亮";
//            model.id = @1;
//            [_participants addObject:model];
//        }
    }
    return _participants;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
    if (self.peoples.count == 0) {
        self.tableView.backgroundView = self.noContentView;
    }else{
        self.tableView.backgroundView = nil;
    }
}
#pragma mark - navigation
- (void)setupNavi{
    
    self.navigationItem.title = self.naviTitle;
//    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

- (void)sure{
    
    if (self.actionParameter) {
        self.actionParameter(self.peoples);
        [self.navigationController popViewControllerAnimated:YES];
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
    //    tableView.tableFooterView = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"已经到底了..." textColor:LightGrayTextColor textAlignment:NSTextAlignmentCenter font:FONT(14)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
//        return self.participants.count;
        return 0;
    }
    
    if (section == 1) {
        return 0;
    }
    
    return self.peoples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeTwo;
        [cell.enterImage setImage:nil forState:UIControlStateNormal];
        [cell.enterImage setImage:nil forState:UIControlStateNormal];
        cell.delegate = self;
        cell.enterImage.tag = 0x111 + indexPath.row;
        cell.enterImage.hidden = YES;
        cell.enterImgTrailW.constant = 0;
        [cell refreshCellWithEmployeeModel:self.participants[indexPath.row]];
        cell.bottomLine.hidden = YES;
        return cell;
        
    }else if (indexPath.section == 1){
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeOne;
        [cell.enterImage setImage:nil forState:UIControlStateNormal];
        [cell.enterImage setImage:nil forState:UIControlStateNormal];
        cell.delegate = self;
        cell.enterImage.tag = 0x222 + indexPath.row;
        cell.enterImage.hidden = YES;
        cell.enterImgTrailW.constant = 0;
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateNormal];
        [cell.titleImage setImage:[UIImage imageNamed:@"添加协作"] forState:UIControlStateNormal];
        cell.topLabel.text = [NSString stringWithFormat:@"添加%@",self.naviTitle];
        cell.topLabel.textColor = GreenColor;
        cell.bottomLine.hidden = YES;
        return cell;
    }else{
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        cell.type = TwoLineCellTypeTwo;
        if (self.type == 0) {
            cell.enterImage.hidden = NO;
            [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
            [cell.enterImage setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        }else{
            cell.enterImage.hidden = YES;
        }
        cell.delegate = self;
        cell.enterImage.tag = 0x333 + indexPath.row;
        [cell refreshCellWithEmployeeModel:self.peoples[indexPath.row]];
        cell.enterImgTrailW.constant = 0;
        cell.topLine.hidden = YES;
        if (self.type == 0) {
            cell.topLine.hidden = YES;
            if (self.peoples.count - 1 == indexPath.row) {
                
                cell.bottomLine.hidden = YES;
            }else{
                
                cell.bottomLine.hidden = NO;
            }
        }else{
            if (self.peoples.count - 1 == indexPath.row) {
                
                cell.bottomLine.hidden = YES;
            }else{
                
                cell.bottomLine.hidden = NO;
            }
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 1) {
        
        
        TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
        select.type = 1;
        select.isSingle = NO;
        select.peoples = self.peoples;
        select.actionParameter = ^(NSArray *parameter) {
            
            [self.peoples addObjectsFromArray:parameter];
            
            NSString *str = @"";
            for (HQEmployModel *em in self.peoples) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%lld,",[em.id longLongValue]]];
            }
            if (str.length) {
                str = [str substringToIndex:str.length-1];
            }
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            if (self.approvalItem.process_definition_id) {
                [dict setObject:self.approvalItem.process_definition_id forKey:@"processInstanceId"];
            }
            if (self.approvalItem.task_key) {
                [dict setObject:self.approvalItem.task_key forKey:@"taskDefinitionKey"];
            }
            if (str) {
                [dict setObject:str forKey:@"ccTo"];
            }
            if (self.approvalItem.module_bean) {
                [dict setObject:self.approvalItem.module_bean forKey:@"beanName"];
            }
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestApprovalCopyWithDict:dict];
            
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:select animated:YES];
        
    }
    
    if (self.type == 1) {
        
        if (indexPath.section == 0) {
            
            NSMutableArray *arr = [NSMutableArray array];
            
            [arr addObject:self.participants[indexPath.row]];
            
            if (self.actionParameter) {
                self.actionParameter(arr);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
        if (indexPath.section == 2) {
            
            NSMutableArray *arr = [NSMutableArray array];
            
            [arr addObject:self.peoples[indexPath.row]];
            
            if (self.actionParameter) {
                self.actionParameter(arr);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.type == 1) {
        if (indexPath.section == 1) {
            return 0;
        }
    }
    return 70;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0 ) {
//        return 30;
        return .5;
    }
    if (section == 1 ) {
        return 30;
    }
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.5;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
//        UILabel *label = [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:@"    负责人" textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
//        label.layer.masksToBounds = YES;
//        return label;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = BackGroudColor;
        return view;
    }
    
    if (section == 1) {
        return [HQHelper labelWithFrame:(CGRect){0,0,SCREEN_WIDTH,30} text:[NSString stringWithFormat:@"    %@(%ld)",self.naviTitle,self.peoples.count] textColor:ExtraLightBlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
    }
    
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BackGroudColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    if (section == 1) {
        if (self.peoples.count) {
            view.backgroundColor = WhiteColor;
        }else{
            view.backgroundColor = BackGroudColor;
        }
    }else{
        
        view.backgroundColor = BackGroudColor;
    }
    return view;
}

#pragma mark - HQTFTwoLineCellDelegate
-(void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn{
    
    NSInteger index = enterBtn.tag - 0x333;
    
    [self.peoples removeObjectAtIndex:index];
    
    NSString *str = @"";
    for (HQEmployModel *em in self.peoples) {
        
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%lld,",[em.id longLongValue]]];
    }
    if (str.length) {
        str = [str substringToIndex:str.length-1];
    }
    
//    [self.customerBL requestUpdateCustomerPeopleWithCustomerId:self.customer_id participant:str];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
//    if (resp.cmdId == HQCMD_getCustomerPeople) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        NSArray *participants = IsNilOrNull([resp.body valueForKey:@"participant"])?@[]:[resp.body valueForKey:@"participant"];
//        NSDictionary *principal = [resp.body valueForKey:@"principal"];
//        
//        TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:principal error:nil];
//        if (model) {
//            [self.participants addObject:[model employee]];
//        }
//        
//        
//        for (NSDictionary *dict in participants) {
//            
//            TFEmployModel *model = [[TFEmployModel alloc] initWithDictionary:dict error:nil];
//            if (model) {
//                [self.peoples addObject:[model employee]];
//            }
//        }
//        
//        [self.tableView reloadData];
//    }
    
    if (resp.cmdId == HQCMD_customApprovalCopy) {
        
        if (self.actionParameter) {
            self.actionParameter(self.peoples);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.tableView reloadData];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    //    [self.tableView.mj_footer endRefreshing];
    //    [self.tableView.mj_header endRefreshing];
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
