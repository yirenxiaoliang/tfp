//
//  TFApprovalAttemdanceController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/6/18.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFApprovalAttemdanceController.h"
#import "TFAttendanceBL.h"
#import "TFModelView.h"
#import "TFReferenceApprovalModel.h"
#import "TFAddCustomController.h"
#import "TFApprovalMainController.h"

@interface TFApprovalAttemdanceController ()<HQBLDelegate,UITableViewDelegate,UITableViewDataSource,TFModelViewDelegate>

@property (nonatomic, weak) UITableView *tableView ;

@property (nonatomic, strong) TFAttendanceBL *attendanceBL;

@end

@implementation TFApprovalAttemdanceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    self.attendanceBL = [TFAttendanceBL build];
    self.attendanceBL.delegate = self;
    [self.attendanceBL requestReferenceApprovalList];
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
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    cell.textLabel.text = @"审批记录";
    cell.textLabel.textColor = LightBlackTextColor;
    cell.imageView.image = IMG(@"审批列表");
    cell.accessoryView = [[UIImageView alloc] initWithImage:IMG(@"下一级浅灰")];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    TFApprovalMainController *approval = [[TFApprovalMainController alloc] init];
    approval.selectIndex = @0;
    approval.type = 2;
    [self.navigationController pushViewController:approval animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
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

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_attendanceReferenceApprovalList) {
        
        NSArray *arr = resp.body;
        
        if (arr.count != 0) {
            UIView *header = [UIView new];
            header.backgroundColor = WhiteColor;
            for (NSInteger i = 0; i < arr.count; i++) {
                
                NSInteger row = i /4;
                NSInteger col = i % 4;
                TFModelView *view = [TFModelView modelView];
                [header addSubview:view];
                view.frame = CGRectMake(col * (SCREEN_WIDTH / 4), row * (SCREEN_WIDTH / 4) + 10, (SCREEN_WIDTH / 4), (SCREEN_WIDTH / 4));
                TFReferenceApprovalModel *model = arr[i];
                TFModuleModel *module = [[TFModuleModel alloc] init];
                module.chinese_name = model.relevance_title;
                module.english_name = model.relevance_bean;
                module.icon_url = model.icon_url;
                module.icon_type = model.icon_type;
                module.icon_color = model.icon_color;
                module.id = model.relevance_id;
                view.delegate = self;
                [view refreshViewWithModule:module type:0];
            }
            header.frame = CGRectMake(0, 0, SCREEN_WIDTH, (arr.count + 3)/4 * (SCREEN_WIDTH / 4));
            self.tableView.tableHeaderView = header;
        }
        [self.tableView reloadData];
    }
    
}

#pragma mark - TFModelViewDelegate
-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    TFAddCustomController *add = [[TFAddCustomController alloc] init];
    add.bean = module.english_name;
    add.moduleId = module.id;
    add.tableViewHeight = SCREEN_HEIGHT - 64;
    [self.navigationController pushViewController:add animated:YES];
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
