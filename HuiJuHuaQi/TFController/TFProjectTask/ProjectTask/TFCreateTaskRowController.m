
//
//  TFCreateTaskRowController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/3.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateTaskRowController.h"
#import "TFTaskRowTemplateCell.h"
#import "TFTaskRowNameCell.h"
#import "TFProjectTaskBL.h"
#import "TFWorkFlowModelController.h"
#import "HQTFInputCell.h"

@interface TFCreateTaskRowController ()<UITableViewDelegate,UITableViewDataSource,TFTaskRowNameCellDelegate,HQBLDelegate,TFTaskRowTemplateCellDelegate,HQTFInputCellDelegate>

/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** rows */
@property (nonatomic, strong) NSMutableArray *rows;

/** TFProjectTaskBL */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** isTemplate */
@property (nonatomic, assign) BOOL isTemplate;

/** templateDict */
@property (nonatomic, strong) NSDictionary *templateDict;

/** sectionName */
@property (nonatomic, copy) NSString *sectionName;

@end

@implementation TFCreateTaskRowController

-(NSMutableArray *)rows{
    if (!_rows) {
        _rows = [NSMutableArray array];
        
        [_rows addObject:@""];
    }
    return _rows;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    self.navigationItem.title = @"新建任务分组";
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(rightClicked) text:@"完成" textColor:GreenColor];
    [self setupTableView];
}

- (void)rightClicked{
    
    if (self.sectionName.length == 0) {
        [MBProgressHUD showError:@"请输入分组名称" toView:self.view];
        return;
    }
    
    if (self.isTemplate) {
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSDictionary *dd in [self.templateDict valueForKey:@"nodes"]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if ([dd valueForKey:@"text"]) {
                [dict setObject:[dd valueForKey:@"text"] forKey:@"name"];
            }
            if ([dd valueForKey:@"key"]) {
                [dict setObject:[dd valueForKey:@"key"] forKey:@"flowId"];
            }
            [arr addObject:dict];
        }
        
        TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
        row.projectId = self.projectId;
        row.sectionId = self.projectColumnModel.id;
        row.names = arr;
        row.flowStatus = @1;
        row.name = self.sectionName;
        row.flowId = [self.templateDict valueForKey:@"id"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestCreateProjectSectionWithModel:row];
        
        
    }else{
        
        NSMutableArray *arr = [NSMutableArray array];
        
        for (NSString *str in self.rows) {
            if (str.length > 0) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:str forKey:@"name"];
                [arr addObject:dict];
            }
        }
        
        if (arr.count <= 0) {
            
            [MBProgressHUD showError:@"请输入列表名称" toView:self.view];
            return;
        }
        
        TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
        row.projectId = self.projectId;
        row.sectionId = self.projectColumnModel.id;
        row.name = self.sectionName;
        row.names = arr;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.projectTaskBL requestCreateProjectSectionWithModel:row];
    }
    
}
#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
 
    if (self.refreshAction) {
        self.refreshAction();
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 2) {
        if (self.isTemplate) {
            return 0;
        }
        return self.rows.count;
    }else if (section == 3){
        if (self.isTemplate) {
            return 0;
        }
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        TFTaskRowTemplateCell *cell = [TFTaskRowTemplateCell taskRowTemplateCellWithTableView:tableView];
        cell.nameLabel.text = @"工作流模板";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.isTemplate == NO) {
            cell.arrowBtn.selected = self.isTemplate;
            cell.templateLabel.text = @"请选择";
        }else{
            cell.arrowBtn.selected = self.isTemplate;
            cell.templateLabel.hidden = !self.isTemplate;
            cell.templateLabel.text = [self.templateDict valueForKey:@"name"];
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 1){
        
        HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
        cell.titleLabel.text = @"分组名称";
        cell.fieldControl = @"2";// 必填
        cell.enterBtn.hidden = YES;
        cell.textFieldTrailW.constant = 0;
        cell.textField.textAlignment = NSTextAlignmentRight;
        cell.delegate = self;
        cell.textField.text = self.sectionName;
        cell.textField.placeholder = @"请输入分组名称";
        return cell;
        
    }else if (indexPath.section == 2){
        
        TFTaskRowNameCell *cell = [TFTaskRowNameCell taskRowNameCellWithTableView:tableView];
        cell.textField.placeholder = @"请输入列表名称";
        cell.textField.text = self.rows[indexPath.row];
        cell.delegate = self;
        cell.minusBtn.hidden = cell.textField.text.length == 0 ? YES : NO;
        cell.textField.tag = indexPath.row;
        cell.minusBtn.tag = indexPath.row;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.topLine.hidden = YES;
        cell.bottomLine.hidden = NO;
        return cell;
        
    }else{
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.imageView.image = [UIImage imageNamed:@"加号"];
        cell.textLabel.text = @"添加列表";
        cell.textLabel.textColor = HexColor(0x549aff);
        return cell;
        
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        [self enterWorkflow];
    }
    
    if (indexPath.section == 3) {
        
        [self.rows addObject:@""];
        [self.tableView reloadData];
    }
}

- (void)enterWorkflow{
    
    TFWorkFlowModelController *flow = [[TFWorkFlowModelController alloc] init];
    
    flow.parameter = ^(NSDictionary *parameter) {
      
        self.templateDict = parameter;
        self.isTemplate = YES;
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:flow animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        return 44;
    }
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    if (section == 2) {
        return 0;
    }
    return 12;
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

#pragma mark - TFTaskRowNameCellDelegate
-(void)textFieldTextChange:(HQAdviceTextView *)textField{
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        if (textField.text.length > 25) {
            
            textField.text = [textField.text substringToIndex:25];
            [MBProgressHUD showError:@"最长25个字符" toView:KeyWindow];
        }
        
    }
    
    [self.rows replaceObjectAtIndex:textField.tag withObject:textField.text];
    
    TFTaskRowNameCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textField.tag inSection:2]];
    cell.minusBtn.hidden = textField.text.length == 0 ? YES : NO;
    
}

-(void)taskRowNameCellDidMinusBtn:(UIButton *)button{
    
    [self.rows removeObjectAtIndex:button.tag];
    if (self.rows.count == 0) {
        [self.rows addObject:@""];
    }
    [self.tableView reloadData];
}

#pragma mark - TFTaskRowTemplateCellDelegate
-(void)taskRowTemplateCellDidClickedEnterButton:(UIButton *)button{
    
    if (button.selected) {// 删除
        
        self.isTemplate = NO;
        [self.tableView reloadData];
        
    }else{// 进入
        
        [self enterWorkflow];
    }
    
}
#pragma mark - HQTFInputCellDelegate
- (void)inputCellWithTextField:(UITextField *)textField{
    
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        if (textField.text.length > 25) {
            
            textField.text = [textField.text substringToIndex:25];
            [MBProgressHUD showError:@"最长25个字符" toView:KeyWindow];
        }
        
        self.sectionName = textField.text;
    }
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
