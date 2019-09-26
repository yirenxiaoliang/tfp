//
//  TFCustomTransferController.m
//  HuiJuHuaQi
//
//  Created by HQ-30 on 2017/12/13.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCustomTransferController.h"
#import "TFSelectPeopleCell.h"
#import "HQBaseCell.h"
#import "TFSelectChatPeopleController.h"
#import "FDActionSheet.h"
#import "HQSelectTimeCell.H"
#import "TFCustomBL.h"
#import "HQEmployModel.h"
#import "TFChangeHelper.h"

@interface TFCustomTransferController ()<UITableViewDelegate,UITableViewDataSource,FDActionSheetDelegate,HQBLDelegate>

/** tableView */
@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *peoples;

@property (assign, nonatomic) NSInteger index;

/** customBL */
@property (nonatomic, strong) TFCustomBL *customBL;


@end

@implementation TFCustomTransferController

-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self setupNavi];
    
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    
}
#pragma mark - mark Navi
- (void)setupNavi{
    
    self.navigationItem.title = @"转移负责人";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

-(void)sure{
    
    if (self.peoples.count == 0) {
        [MBProgressHUD showError:@"请选择人员" toView:self.view];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HQEmployModel *model = self.peoples[0];
    
    NSMutableDictionary *di = [NSMutableDictionary dictionaryWithDictionary:self.principal];
    if (self.dataId) {
        [di setObject:self.dataId forKey:@"id"];// 数据ID
    }
    if ([self.principal valueForKey:@"id"]) {
        [di setObject:[self.principal valueForKey:@"id"] forKey:@"principal"];// 负责人ID
    }
    
    [self.customBL requestCustomTransforPrincipalWithDataId:model.id bean:self.bean principalId:@[di] share:@(self.index)];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.cmdId == HQCMD_customTransferPrincipal) {
        
        if (self.refreshAction) {
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
    
    NSString *str = @"将当前数据的负责人成功转移给其他负责人后，该操作将无法恢复。";
    CGSize size = [HQHelper sizeWithFont:FONT(16) maxSize:(CGSize){SCREEN_WIDTH-30,MAXFLOAT} titleStr:str];
    UIView *header = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,size.height + 20}];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,10,SCREEN_WIDTH-30,size.height}];
    [header addSubview:label];
    label.font = FONT(16);
    label.text = str;
    label.numberOfLines = 0;
    label.textColor = LightBlackTextColor;
    tableView.tableHeaderView = header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TFSelectPeopleCell *cell = [TFSelectPeopleCell selectPeopleCellWithTableView:tableView];
        [cell refreshSelectPeopleCellWithPeoples:self.peoples structure:@"1" chooseType:@"0" showAdd:YES clear:NO];
        cell.requireLabel.hidden = YES;
        cell.titleLabel.text = @"选择负责人";
        cell.topLine.hidden = YES;
        return cell;
    }else{
        
        if (indexPath.row == 0) {
            
            static NSString *indentifier = @"HQBaseCell";
            HQBaseCell *cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
            cell.textLabel.text = @"转移后是否确定共享给当前数据负责人？";
            cell.textLabel.textColor = ExtraLightBlackTextColor;
            cell.textLabel.font = FONT(14);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.topLine.hidden = YES;
            return cell;
        }else{
            
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = self.index == 0 ? @"否" : @"是";;
            cell.timeTitle.textColor = LightBlackTextColor;
            cell.time.text = @"";
            cell.time.textColor = BlackTextColor;
            cell.arrowShowState = YES;
            cell.fieldControl = @"0";
            cell.structure = @"1";
            return cell;
            
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
        select.peoples = self.peoples;
        select.type = 1;
        select.isSingle = YES;
        select.actionParameter = ^(NSArray *parameter) {
            
            self.peoples = [NSMutableArray arrayWithArray:parameter];
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:select animated:YES];
    }else{
        
        if (indexPath.row == 1) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" titles:@[@"否",@"是"]];
            sheet.tag = indexPath.section;
            [sheet show];
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return [TFSelectPeopleCell refreshSelectPeopleCellHeightWithStructure:@"1"];
    }else{
        
        return 40;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
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


#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    
    self.index = buttonIndex;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
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
