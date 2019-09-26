//
//  TFTaskColumnAddController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/4/14.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFTaskColumnAddController.h"
#import "HQBaseCell.h"
#import "TFProjectTaskBL.h"
@interface TFTaskColumnAddController ()<UITableViewDataSource,UITableViewDelegate,HQBLDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;


@end

@implementation TFTaskColumnAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    if (!self.projectRow) {
        self.projectRow = [[TFProjectRowModel alloc] init];
    }
    self.projectRow.projectId = self.projectId;
    self.projectRow.sectionId = self.sectionId?:self.projectColumnModel.id;
    
    [self setupTableView];
    [self setupNavigation];
}

- (void)setupNavigation{
    
    if (self.type == 0) {
        if (self.index == 0) {
            self.navigationItem.title = @"新增任务分组";
        }else if (self.index == 1) {
            self.navigationItem.title = @"新增任务列表";
        }
    }else{
        if (self.index == 0) {
            self.navigationItem.title = @"修改任务分组名称";
        }else if (self.index == 1) {
            self.navigationItem.title = @"修改任务列名称";
        }
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:HexColor(0x3689e9)];
    
}
- (void)sure{
    
    [self.view endEditing:YES];
    
    if (!self.projectRow.name || [self.projectRow.name isEqualToString:@""]) {
        [MBProgressHUD showError:@"名称不能为空" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.index == 0) {// 分组
        
        if (self.type == 0) {// 新增
            
            [self.projectTaskBL requestCreateProjectSectionWithModel:self.projectRow];
            
        }else{// 修改
            
            [self.projectTaskBL requestUpdateProjectSectionWithModel:self.projectRow];
           
        }
    }else{// 任务列
        
        if (self.type == 0) {// 新增
            
            [self.projectTaskBL requestCreateProjectSectionTasksWithModel:self.projectRow];
            
        }else{// 修改
            
            [self.projectTaskBL requestUpdateProjectSectionTasksWithModel:self.projectRow];
           
        }
    }
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if (self.type == 1) {
        if (self.refresh) {
            self.refresh(self.projectRow);
        }
    }else{
        if (self.refresh) {
            self.refresh(nil);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
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
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    HQBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[HQBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.topLine.hidden = NO;
    cell.bottomLine.hidden = NO;
    cell.headMargin = 0;
    
    UITextField *textFeild = [[UITextField alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 30)];
    [cell.contentView addSubview:textFeild];
    textFeild.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFeild.textColor = HexColor(0x909090);
    textFeild.placeholder = @"请输入25字以内名称（必填）";
    textFeild.text = self.projectRow.name;
    [textFeild addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (void)textChange:(UITextField *)textFeild{
    
    UITextRange *range = [textFeild markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textFeild positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        if (textFeild.text.length > 25) {
            
            textFeild.text = [textFeild.text substringToIndex:25];
            [MBProgressHUD showError:@"25字以内" toView:KeyWindow];
        }
        
        self.projectRow.name = textFeild.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
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
