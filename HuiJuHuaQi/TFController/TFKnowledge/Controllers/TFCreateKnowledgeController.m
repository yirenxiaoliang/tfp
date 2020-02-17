
//
//  TFCreateKnowledgeController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateKnowledgeController.h"
#import "TFGeneralSingleOldCell.h"
#import "TFSubformAddView.h"
#import "TFCustomAttributeTextOldCell.h"
#import "TFCustomSelectOptionOldCell.h"
#import "TFCustomAttachmentsOldCell.h"
#import "TFCustomAlertView.h"
#import "TFAttributeTextController.h"
#import "ZYQAssetPickerController.h"
#import "TFModelEnterController.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFProjectApprovalCell.h"
#import "TFCustomListItemModel.h"
#import "TFQuoteTaskItemModel.h"
#import "TFApprovalListItemModel.h"
#import "TFNoteDataListModel.h"
#import "TFEmailReceiveListModel.h"
#import "TFKnowledgeBL.h"
#import "TFCategoryModel.h"
#import "TFFileMenuController.h"
#import "TFFolderListModel.h"
#import "TFNewProjectTaskItemCell.h"

@interface TFCreateKnowledgeController ()<UITableViewDelegate,UITableViewDataSource,TFGeneralSingleOldCellDelegate,TFCustomAttributeTextOldCellDelegate,TFCustomSelectOptionOldCellDelegate,TFCustomAttachmentsOldCellDelegate,TFSubformAddViewDelegate,TFCustomAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,TFNewProjectCustomCellDelegate,TFProjectNoteCellDelegate,TFProjectTaskItemCellDelegate,TFProjectApprovalCellDelegate,HQBLDelegate,TFNewProjectTaskItemCellDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 选项弹窗 */
@property (nonatomic, strong) TFCustomAlertView *optionAlertView;
/** 添加附件及图片时对应的Model ,也用于记录子表单下拉对应的Model */
@property (nonatomic, strong) TFCustomerRowsModel *attachmentModel;
@property (nonatomic, copy) NSString *editStr;

/** 知识 */
@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;
/** 分类s */
@property (nonatomic, strong) NSArray *categorys;

@end

@implementation TFCreateKnowledgeController

-(TFCustomAlertView *)optionAlertView{
    if (!_optionAlertView) {
        _optionAlertView = [[TFCustomAlertView alloc] init];
        _optionAlertView.delegate = self;
    }
    return _optionAlertView;
}
-(TFCreateKnowledgeModel *)knowledge{
    if (!_knowledge) {
        _knowledge = [[TFCreateKnowledgeModel alloc] init];
        _knowledge.type = self.type;
        if (self.type == 1) {
            _knowledge.content.field.fieldControl = @"0";
            _knowledge.content.label = @"描述";
        }
    }
    return _knowledge;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(back) text:@"取消" textColor:GreenColor];
}

-(void)back{
    NSString *str = [self.knowledge toJSONString];
    if ([str isEqualToString:self.editStr]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消编辑？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
//    [self.knowledgeBL requestGetKnowledgeCategoryAndLabel];
    if (self.type != 2) {
        [self.knowledgeBL requestGetKnowledgeCategory];
    }
    self.editStr = [self.knowledge toJSONString];
    [self setupNavi];
    [self setupTableView];
}

/** 导航栏 */
-(void)setupNavi{
    
    if (self.edit == 0) {
        
        if (self.knowledge.type == 0) {
            self.navigationItem.title = @"新建知识";
        }else if (self.knowledge.type == 1) {
            self.navigationItem.title = @"新建提问";
        }else{
            self.navigationItem.title = @"写回答";
        }
    }else{
        if (self.knowledge.type == 0) {
            self.navigationItem.title = @"编辑知识";
        }else if (self.knowledge.type == 1) {
            self.navigationItem.title = @"编辑提问";
        }else{
            self.navigationItem.title = @"编辑回答";
        }
    }
    
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定" textColor:GreenColor];
}

-(void)sure{
    
    // 检验
    if (self.type == 0 || self.type == 1) {
        
        if (IsStrEmpty(self.knowledge.title.fieldValue)) {
            [MBProgressHUD showError:@"请填写标题" toView:self.view];
            return;
        }
    }
    if (self.type == 0 || self.type == 2) {

        if (IsStrEmpty(self.knowledge.content.fieldValue)) {
            [MBProgressHUD showError:@"请填写内容" toView:self.view];
            return;
        }
    }
    if (self.type == 0 || self.type == 1) {
        
        if (self.knowledge.category.selects.count == 0) {
            [MBProgressHUD showError:@"请选择分类" toView:self.view];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.type == 2) {// 回答
        if (self.edit == 0) {
            [self.knowledgeBL requestAnwserSaveWithDict:[self getAnwser]];
        }else{
            [self.knowledgeBL requestAnwserUpdateWithDict:[self getAnwser]];
        }
    }else{// 知识及提问
        if (self.edit == 0) {
            [self.knowledgeBL requestSaveKnowledgeWithDict:[self getData]];
        }else{
            [self.knowledgeBL requestUpdateKnowledgeWithDict:[self getData]];
        }
    }
    
}

/** 知识及提问提交 */
-(NSDictionary *)getAnwser{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.knowledge.content.fieldValue) {
        [dict setObject:self.knowledge.content.fieldValue forKey:@"content"];
    }
    if (self.parentId) {
        [dict setObject:self.parentId forKey:@"repository_id"];
    }
    
    // 引用 1：审批 2：任务 3：邮件 4：备忘录 5：自定义
    NSMutableArray *references = [NSMutableArray array];
    for (TFProjectRowFrameModel *model in self.knowledge.approvals) {// 审批
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.projectRow.bean_name) {
            [dd setObject:model.projectRow.bean_name forKey:@"bean_name"];
        }
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowModel *model in self.knowledge.tasks) {// 任务
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"project_custom" forKey:@"bean_name"];
        if (model.id) {
            [dd setObject:model.id forKey:@"relation_id"];
        }
        if (model.projectId) {
            [dd setObject:model.projectId forKey:@"projectId"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.emails) {// 邮件
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"email" forKey:@"bean_name"];
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.notes) {// 备忘录
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"memo" forKey:@"bean_name"];
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.customs) {// 自定义
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.projectRow.bean_name) {
            [dd setObject:model.projectRow.bean_name forKey:@"bean_name"];
        }
        if (model.projectRow.bean_id) {
            [dd setObject:model.projectRow.bean_id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    [dict setObject:references forKey:@"references"];
    
    
    // 附件
    if (self.knowledge.files.selects) {
        
        NSMutableArray *aaa = [NSMutableArray array];
        
        for (TFFileModel *ff in self.knowledge.files.selects) {
            
            NSDictionary *dd = [ff toDictionary];
            
            if (dd) {
                [aaa addObject:dd];
            }
        }
        [dict setObject:aaa forKey:@"repository_answer_attachment"];
    }
    
    if (self.edit == 1) {
        [dict setObject:self.dataId forKey:@"id"];
    }
    return dict;
}
/** 知识及提问提交 */
-(NSDictionary *)getData{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 类型
    [dict setObject:@(self.type) forKey:@"type_status"];
    // 标题
    if (self.knowledge.title.fieldValue) {
        [dict setObject:self.knowledge.title.fieldValue forKey:@"title"];
    }
    // 内容
    if (self.knowledge.content.fieldValue) {
        [dict setObject:self.knowledge.content.fieldValue forKey:@"content"];
    }
    
    // 分类
    NSString *categoryIds = @"";
    for (TFCustomerOptionModel *model in self.knowledge.category.selects) {
        categoryIds = [categoryIds stringByAppendingString:[NSString stringWithFormat:@"%@,",model.value]];
    }
    if (categoryIds.length > 0) {
        categoryIds = [categoryIds substringToIndex:categoryIds.length-1];
    }
    [dict setObject:categoryIds forKey:@"classification_id"];
    
    // 标签
    NSString *labelIds = @"";
    for (TFCustomerOptionModel *model in self.knowledge.labels.selects) {
        labelIds = [labelIds stringByAppendingString:[NSString stringWithFormat:@"%@,",model.value]];
    }
    if (labelIds.length > 0) {
        labelIds = [labelIds substringToIndex:labelIds.length-1];
    }
    [dict setObject:labelIds forKey:@"label_ids"];
    
    // 引用 1：审批 2：任务 3：邮件 4：备忘录 5：自定义
    NSMutableArray *references = [NSMutableArray array];
    for (TFProjectRowFrameModel *model in self.knowledge.approvals) {// 审批
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.projectRow.bean_name) {
            [dd setObject:model.projectRow.bean_name forKey:@"bean_name"];
        }
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowModel *model in self.knowledge.tasks) {// 任务
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"project_custom" forKey:@"bean_name"];
        if (model.bean_id) {
            [dd setObject:model.bean_id forKey:@"relation_id"];
        }
        if (model.projectId) {
            [dd setObject:model.projectId forKey:@"projectId"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.emails) {// 邮件
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"email" forKey:@"bean_name"];
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.notes) {// 备忘录
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        [dd setObject:@"memo" forKey:@"bean_name"];
        if (model.projectRow.id) {
            [dd setObject:model.projectRow.id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    for (TFProjectRowFrameModel *model in self.knowledge.customs) {// 自定义
        NSMutableDictionary *dd = [NSMutableDictionary dictionary];
        if (model.projectRow.bean_name) {
            [dd setObject:model.projectRow.bean_name forKey:@"bean_name"];
        }
        if (model.projectRow.bean_id) {
            [dd setObject:model.projectRow.bean_id forKey:@"relation_id"];
        }
        [references addObject:dd];
    }
    
    [dict setObject:references forKey:@"references"];
    
    // 附件
    if (self.knowledge.files.selects) {
        
        NSMutableArray *aaa = [NSMutableArray array];
        
        for (TFFileModel *ff in self.knowledge.files.selects) {
            
            NSDictionary *dd = [ff toDictionary];
            
            if (dd) {
                [aaa addObject:dd];
            }
        }
        [dict setObject:aaa forKey:@"repository_lib_attachment"];
    }
    
    // 编辑时传id
    if (self.edit == 1) {
        [dict setObject:self.dataId forKey:@"id"];
    }
    
    return dict;
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
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {// 标题、内容、描述
        return 2;
    }else if (section == 5){// 自定义
        return self.knowledge.customs.count;
    }else if (section == 2){// 任务
        return self.knowledge.tasks.count;
    }else if (section == 4){// 备忘录
        return self.knowledge.notes.count;
    }else if (section == 1){// 审批
        return self.knowledge.approvals.count;
    }else if (section == 3){// 邮件
        return self.knowledge.emails.count;
    }else{// 分类、标签、附件
        return 3;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {// 标题、内容、描述
        
        if (indexPath.row == 0) {
            
            TFGeneralSingleOldCell *cell = [TFGeneralSingleOldCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = self.knowledge.title.label;
            cell.content = self.knowledge.title.fieldValue;
            cell.placeholder = self.knowledge.title.field.pointOut;
            cell.fieldControl = self.knowledge.title.field.fieldControl;
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = @"";
            cell.tipImage = @"";
            cell.edit = YES;
            cell.showEdit = YES;
            cell.rightImage = @"";
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.model = self.knowledge.title;
            return cell;
        }else{
            
            TFCustomAttributeTextOldCell *cell = [TFCustomAttributeTextOldCell customAttributeTextCellWithTableView:tableView type:0 index:indexPath.section * 0x11 + indexPath.row];
            cell.delegate = self;
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.title = self.knowledge.content.label;
            cell.fieldControl = self.knowledge.content.field.fieldControl;
            [cell reloadDetailContentWithContent:self.knowledge.content.fieldValue];
            cell.showEdit = YES;
            return cell;
        }
        
    }else if (indexPath.section == 5){// 自定义
        
        TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
        cell.frameModel = self.knowledge.customs[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.edit = YES;
        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
        
    }else if (indexPath.section == 2){// 任务
        
//        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//        cell.frameModel = self.knowledge.tasks[indexPath.row];
//        cell.hidden = NO;
//        cell.knowledge = YES;
//        cell.edit = YES;
//        cell.tag = indexPath.row;
//        cell.delegate = self;
//        return cell;
        
        TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
        [cell refreshNewProjectTaskItemCellWithModel:self.knowledge.tasks[indexPath.row] haveClear:YES];
        cell.tag = indexPath.row;
        cell.hidden = NO;
        cell.delegate = self;
        cell.contentView.backgroundColor = WhiteColor;
        cell.backgroundColor = WhiteColor;
        return cell;
        
    }else if (indexPath.section == 4){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = self.knowledge.notes[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.edit = YES;
        cell.tag = indexPath.row;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 1){// 审批
        
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.knowledge.approvals[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.tag = indexPath.row;
        cell.edit = YES;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section == 3){// 邮件
        
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.knowledge.emails[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.tag = indexPath.row;
        cell.edit = YES;
        cell.delegate = self;
        return cell;
        
    }else{// 分类、标签、附件
        
        if (indexPath.row == 0) {// 分类
            
            TFCustomSelectOptionOldCell *cell = [TFCustomSelectOptionOldCell customSelectOptionCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = self.knowledge.category.label;
            cell.fieldControl = self.knowledge.category.field.fieldControl;
            cell.edit = YES;
            cell.showEdit = YES;
            cell.model = self.knowledge.category;
            return cell;
        }else if (indexPath.row == 1){// 标签
            
            TFCustomSelectOptionOldCell *cell = [TFCustomSelectOptionOldCell customSelectOptionCellWithTableView:tableView];
            cell.delegate = self;
            cell.title = self.knowledge.labels.label;
            cell.fieldControl = self.knowledge.labels.field.fieldControl;
            cell.edit = YES;
            cell.showEdit = YES;
            cell.model = self.knowledge.labels;
            return cell;
        }else{
            TFCustomAttachmentsOldCell *cell = [TFCustomAttachmentsOldCell CustomAttachmentsCellWithTableView:tableView];
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.delegate = self;
            cell.title = self.knowledge.files.label;
            cell.fieldControl = self.knowledge.files.field.fieldControl;
            cell.type = AttachmentsCellEdit;
            cell.showEdit = YES;
            cell.model = self.knowledge.files;
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            
            TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
            att.fieldLabel = self.knowledge.content.label;
            att.content = self.knowledge.content.fieldValue;
            att.contentAction = ^(NSString *parameter) {
                
                self.knowledge.content.fieldValue = parameter;
                
                TFCustomAttributeTextOldCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell reloadDetailContentWithContent:parameter];
                
                [self.tableView reloadData];
                
            };
            [self.navigationController pushViewController:att animated:YES];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (self.knowledge.type == 2) {// 回答
            if (indexPath.row == 1) {
                
                return [self.knowledge.content.height floatValue]<150?150:[self.knowledge.content.height floatValue];
            }
            return 0;
        }else{// 知识、提问
            
            if (indexPath.row == 0) {
                
                return [TFGeneralSingleOldCell refreshGeneralSingleCellHeightWithModel:self.knowledge.title];
                
            }else{
                return [self.knowledge.content.height floatValue]<150?150:[self.knowledge.content.height floatValue];
               
            }
        }
        
    }
    
    if (indexPath.section == 6) {
        
        if (self.knowledge.type == 2) {// 回答
            
            if (indexPath.row == 2) {
                return [TFCustomAttachmentsOldCell refreshCustomAttachmentsCellHeightWithModel:self.knowledge.files type:AttachmentsCellEdit]<75?75:[TFCustomAttachmentsOldCell refreshCustomAttachmentsCellHeightWithModel:self.knowledge.files type:AttachmentsCellEdit];
            }
            return 0;
            
        }else{// 知识、提问
            
            if (indexPath.row == 0) {
                
                return [TFCustomSelectOptionOldCell refreshCustomSelectOptionCellHeightWithModel:self.knowledge.category showEdit:YES]<=0?75:[TFCustomSelectOptionOldCell refreshCustomSelectOptionCellHeightWithModel:self.knowledge.category showEdit:YES];
                
            }else if (indexPath.row == 1){
                
                return [TFCustomSelectOptionOldCell refreshCustomSelectOptionCellHeightWithModel:self.knowledge.labels showEdit:YES]<=0?75:[TFCustomSelectOptionOldCell refreshCustomSelectOptionCellHeightWithModel:self.knowledge.labels showEdit:YES];
            }else{
                
                return [TFCustomAttachmentsOldCell refreshCustomAttachmentsCellHeightWithModel:self.knowledge.files type:AttachmentsCellEdit]<75?75:[TFCustomAttachmentsOldCell refreshCustomAttachmentsCellHeightWithModel:self.knowledge.files type:AttachmentsCellEdit];
            }
        }
    }
    if (indexPath.section == 5){// 自定义
        
        TFProjectRowFrameModel *frame = self.knowledge.customs[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 2){// 任务
//        TFProjectRowFrameModel *frame = self.knowledge.tasks[indexPath.row];
//        return frame.cellHeight;
        TFProjectRowModel *model = self.knowledge.tasks[indexPath.row];
        return [model.cellHeight floatValue];
    }else if (indexPath.section == 4){// 备忘录
        TFProjectRowFrameModel *frame = self.knowledge.notes[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 1){// 审批
        TFProjectRowFrameModel *frame = self.knowledge.approvals[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 3){// 邮件
        TFProjectRowFrameModel *frame = self.knowledge.emails[indexPath.row];
        return frame.cellHeight;
    }
    
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 6) {
        TFSubformAddView *view = [TFSubformAddView subformAddView];
        view.tag = 0x999 + section;
        view.delegate = self;
        return view;
    }
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = WhiteColor;
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){15,0,SCREEN_WIDTH-30,30}];
        label.textColor = BlackTextColor;
        label.font = BFONT(12);
        label.text = @"引用";
        [view addSubview:label];
        return view;
    }
    return [UIView new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 6) {
        return 44;
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return 30;
    }
    return 0;
    
}

#pragma mark - TFGeneralSingleOldCellDelegate
-(void)generalSingleCell:(TFGeneralSingleOldCell *)cell changedHeight:(CGFloat)height{
    if (cell.textView.isFirstResponder) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}


#pragma mark - TFCustomAttributeTextOldCellDelegate
-(void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell getWebViewHeight:(CGFloat)height{
    
   
//    [self.tableView reloadData];
}

-(void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell getWebViewContent:(NSString *)content{
    
    self.knowledge.content.fieldValue = content;
  
    
    [self.tableView reloadData];
}


#pragma mark - TFCustomSelectOptionOldCellDelegate
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level{
    
    self.attachmentModel = model;
    self.optionAlertView.isSingle = isSingle;
    [self.optionAlertView refreshCustomAlertViewWithData:options];
    [self.optionAlertView showAnimation];
        
}

#pragma mark - TFCustomAlertViewDelegate
-(void)sureClickedWithOptions:(NSMutableArray *)options{
   
    self.attachmentModel.selects = options;
//    if ([self.attachmentModel.name isEqualToString:@"category"]) {// 它决定了标签的选项
//        TFCustomerOptionModel *option = options.firstObject;
//        self.knowledge.labels.entrys = option.subList;
//        if (self.knowledge.labels.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
//            TFCustomerOptionModel *option1 = self.knowledge.labels.selects.firstObject;
//            if (![[option1.parentId description] isEqualToString:option.value]) {
//                self.knowledge.labels.selects = nil;
//            }
//        }
//    }
    
        if ([self.attachmentModel.name isEqualToString:@"category"]) {// 它决定了标签的选项
            TFCustomerOptionModel *oo = options.firstObject;
            if (oo.subList == nil) {
                [self.knowledgeBL requestGetKnowledgeLabelWithCategoryId:@([oo.value longLongValue])];
            }else{
                TFCustomerOptionModel *option = options.firstObject;
                self.knowledge.labels.entrys = option.subList;
                if (self.knowledge.labels.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
                    TFCustomerOptionModel *option1 = self.knowledge.labels.selects.firstObject;
                    if (![[option1.parentId description] isEqualToString:option.value]) {
                        self.knowledge.labels.selects = nil;
                        for (TFCustomerOptionModel *oi in self.knowledge.labels.entrys) {// 选中态取消
                            oi.open = nil;
                        }
                    }
                }
            }
        }
    [self.tableView reloadData];
}


#pragma mark - TFSubformAddViewDelegate
-(void)subformAddView:(TFSubformAddView *)subformAddView didClickedAddBtn:(UIButton *)button{
    
    TFModelEnterController *enter = [[TFModelEnterController alloc] init];
    enter.type = 6;
    enter.parameterAction = ^(NSDictionary *parameter) {
        
        NSString *bean = [parameter valueForKey:@"bean"];
        NSString *approval = [parameter valueForKey:@"approval"];
        NSArray *list = [parameter valueForKey:@"list"];
        NSString *projectId = [[parameter valueForKey:@"projectId"] description];
        
        if ([bean containsString:@"project_custom"]) {// 任务
            
            NSString *ids = @"";
            for (TFQuoteTaskItemModel *item in list) {
                
                ids = [ids stringByAppendingString:[NSString stringWithFormat:@"%@,",[item.id description]]];
            }
            if (ids.length) {
                ids = [ids substringToIndex:ids.length-1];
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (IsStrEmpty(projectId)) {// 个人任务
                [self.knowledgeBL requestChangeItemToCardWithIds:ids beanType:@5];
            }else{
                [self.knowledgeBL requestChangeItemToCardWithIds:ids beanType:@2];
            }
            
            
        }else if ([approval isEqualToString:@"approval"]){// 审批
            
            for (TFApprovalListItemModel *item in list) {
                
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                row.dataType = @4;
                row.bean_type = @4;
                row.id = @([item.approval_data_id longLongValue]);
                row.bean_id = @([item.approval_data_id longLongValue]);
                row.process_name = item.process_name;
                row.process_field_v = item.process_field_v;
                row.task_id = @([item.task_id integerValue]);
                row.approval_data_id = item.approval_data_id;
                row.task_key = item.task_key;
                row.process_key = item.process_key;
                row.create_time = item.create_time;
                row.begin_user_id = item.begin_user_id;
                row.begin_user_name = item.begin_user_name;
                row.picture = item.picture;
                row.process_definition_id = item.process_definition_id;
                row.process_status = item.process_status;
                row.bean_name = bean;
                
                model.projectRow = row;
                [self.knowledge.approvals addObject:model];
            }
            
            
        }else if ([bean isEqualToString:@"memo"]){// 备忘录
            
            for (TFNoteDataListModel *item in list) {
                
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                row.dataType = @1;
                row.id = item.id;
                row.bean_id = item.id;
                row.bean_type = @1;
                row.bean_name = bean;
                row.remind_time = item.remind_time;
                row.title = item.title;
                row.create_time = item.create_time;
                row.share_ids = item.share_ids;
                row.create_by = item.create_by;
                row.picture = item.createObj.picture;
                row.begin_user_name = item.createObj.employee_name;
                
                model.projectRow = row;
                [self.knowledge.notes addObject:model];
            }
            
        }else if ([bean isEqualToString:@"email"]){// 邮件
           
            for (TFEmailReceiveListModel *item in list) {

                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                row.dataType = @5;
                row.id = item.id;
                row.bean_id = item.id;
                row.bean_type = @5;
                row.bean_name =bean;
                row.create_time = @([item.create_time longLongValue]);
                row.subject = item.subject;
                row.from_recipient = item.from_recipient;
                model.projectRow = row;
                [self.knowledge.emails addObject:model];
            }
            
        }else{// 自定义
            
            for (TFCustomListItemModel *item in list) {
                
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                TFProjectRowModel *row = [[TFProjectRowModel alloc] init];
                row.dataType = @3;
                row.id = @([item.id.value longLongValue]);
                row.rows = item.row;
                row.module_name = item.moduleName;
                row.bean_name = bean;
                row.bean_id = @([item.id.value longLongValue]);
                row.icon_url = item.icon_url;
                row.icon_type = @([item.icon_type integerValue]);
                row.icon_color = item.icon_color;
                row.module_bean = bean;
                row.bean_type = @3;
                
                model.projectRow = row;
                [self.knowledge.customs addObject:model];
            }
            
            
        }
        
        [self.tableView reloadData];
        
    };
    [self.navigationController pushViewController:enter animated:YES];
}


#pragma mark - TFCustomAttachmentsOldCellDelegate
- (void)deleteAttachmentsWithIndex:(NSInteger)index{
    [self.tableView reloadData];
}
- (void)addAttachmentsClickedWithCell:(TFCustomAttachmentsOldCell *)cell{
    
    [self.view endEditing:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照",@"文库件选",  nil];
    sheet.tag = 0x5400;
    [sheet showInView:self.view];
    
}


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 0x5400) {// 附件
        if (buttonIndex == 0) {
            
            [self openAlbum];
        }
        if (buttonIndex == 1) {
            
            [self openCamera];
        }
        if (buttonIndex == 2) {
            
            [self pushFileLibray];
        }
    }
    
}

/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    // 选择照片上传
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.knowledgeBL chatFileWithImages:arr withVioces:@[] bean:@"repository_libraries"];
}


#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 9;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    
    //图片数量
    picker.maximumNumberOfSelection = 1000000; // 选择图片最大数量
    
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        [arr addObject:tempImg];
        
    }
    if (arr.count == 0) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.knowledgeBL chatFileWithImages:arr withVioces:@[] bean:@"repository_libraries"];
    
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //        picker.allowsEditing = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    TFFileModel *model = [[TFFileModel alloc] init];
    model.file_name = @"这是一张自拍图";
    model.file_type = @"jpg";
    model.image = image;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.knowledgeBL chatFileWithImages:@[image] withVioces:@[] bean:@"repository_libraries"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ---文件库选
- (void)pushFileLibray {
    
    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;

        model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        TFFileModel *file = [[TFFileModel alloc] init];
        file.file_url = model.fileUrl;
        file.file_name = model.name;
        file.file_size = @([model.size integerValue]);
        file.file_type = model.siffix;
        file.original_file_name = model.name;
        file.upload_by = UM.userLoginInfo.employee.employee_name;
        file.upload_time = @([HQHelper getNowTimeSp]);
    
        if (self.knowledge.files.selects) {
            [self.knowledge.files.selects addObjectsFromArray:@[file]];
        }else{
            self.knowledge.files.selects = [NSMutableArray arrayWithArray:@[file]];
        }
        
        [self.tableView reloadData];
        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}

#pragma mark - TFNewProjectCustomCellDelegate
-(void)newProjectCustomCellDidClickedClearBtn:(TFNewProjectCustomCell *)cell{
    
    NSInteger tag = cell.tag;
    
    [self.knowledge.customs removeObjectAtIndex:tag];
    
    [self.tableView reloadData];
}

#pragma mark - TFProjectTaskItemCellDelegate
-(void)projectTaskItemCellDidClickedClearBtn:(TFProjectTaskItemCell *)cell{
    
    NSInteger tag = cell.tag;
    
    [self.knowledge.tasks removeObjectAtIndex:tag];
    
    [self.tableView reloadData];
}

#pragma mark - TFProjectNoteCellDelegate
-(void)projectNoteCellDidClickedClearBtn:(TFProjectNoteCell *)cell{
    
    NSInteger tag = cell.tag;
    
    [self.knowledge.notes removeObjectAtIndex:tag];
    
    [self.tableView reloadData];
}
#pragma mark - TFProjectApprovalCellDelegate
-(void)projectApprovalCellDidClickedClearBtn:(TFProjectApprovalCell *)cell{
    
    NSInteger tag = cell.tag;
    
    [self.knowledge.approvals removeObjectAtIndex:tag];
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_changeItemToCard) {
        
        for (NSDictionary *dict in resp.body) {
            TFProjectRowModel *row = [HQHelper projectRowWithTaskDict:dict];
            
            row.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:YES]);
            [self.knowledge.tasks addObject:row];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    if (resp.cmdId == HQCMD_getKnowledgeCategoryAndLabel) {
        
        NSArray *arr =  resp.body;
        self.categorys = arr;
        
        NSMutableArray<Optional,TFCustomerOptionModel> *ops = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        for (TFCategoryModel *model in arr) {
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = [model.id description];
            option.label = model.name;
            NSMutableArray<Optional,TFCustomerOptionModel> *subs = [NSMutableArray<Optional,TFCustomerOptionModel> array];
            for (TFCategoryModel *mm in model.labels) {
                TFCustomerOptionModel *option1 = [[TFCustomerOptionModel alloc] init];
                option1.value = [mm.id description];
                option1.label = mm.name;
                option1.parentId = mm.classification_id;
                [subs addObject:option1];
            }
            option.subList = subs;
            [ops addObject:option];
        }
        self.knowledge.category.entrys =ops ;
        
    }
    if (resp.cmdId == HQCMD_getKnowledgeCategory) {
        
        NSArray *arr =  resp.body;
        NSMutableArray<Optional,TFCustomerOptionModel> *ops = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        for (TFCategoryModel *model in arr) {
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = [model.id description];
            option.label = model.name;
            [ops addObject:option];
        }
        self.knowledge.category.entrys =ops ;
    }
    
    if (resp.cmdId == HQCMD_saveKnowledge || resp.cmdId == HQCMD_updateKnowledge) {
        
        if (self.refresh) {
            self.refresh();
        }
    
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_knowledgeLabel) {
        
        NSArray *arr =  resp.body;
        NSMutableArray<Optional,TFCustomerOptionModel> *ops = [NSMutableArray<Optional,TFCustomerOptionModel> array];
        for (TFCategoryModel *model in arr) {
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = [model.id description];
            option.label = model.name;
            [ops addObject:option];
        }
        self.knowledge.labels.entrys = ops;
        
        TFCustomerOptionModel *option = self.knowledge.category.selects.firstObject;
        for (TFCustomerOptionModel *kk in self.knowledge.category.entrys) {// 将标签放入该分类的下级
            if ([option.value isEqualToString:kk.value]) {
                kk.subList = ops;
            }
        }
        
        if (ops.count) {
            if (self.knowledge.labels.selects.count) {// 标签的选中值在不在该分类下，不在就清空，要重选
                TFCustomerOptionModel *option1 = self.knowledge.labels.selects.firstObject;
                if (![[option1.parentId description] isEqualToString:option.value]) {
                    self.knowledge.labels.selects = nil;
                    for (TFCustomerOptionModel *oi in self.knowledge.labels.entrys) {// 选中态取消
                        oi.open = nil;
                    }
                    [self.tableView reloadData];
                }
            }
        }else{
            self.knowledge.labels.selects = nil;
            for (TFCustomerOptionModel *oi in self.knowledge.labels.entrys) {// 选中态取消
                oi.open = nil;
            }
            [self.tableView reloadData];
        }
        
    }
    
    if (resp.cmdId == HQCMD_anwserSave || resp.cmdId == HQCMD_anwserUpdate) {
        
        if (self.refresh) {
            self.refresh();
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_ChatFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.knowledge.files.selects) {
            [self.knowledge.files.selects addObjectsFromArray:resp.body];
        }else{
            self.knowledge.files.selects = [NSMutableArray arrayWithArray:resp.body];
        }
        
        [self.tableView reloadData];
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
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
