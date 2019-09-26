//
//  TFAddEmailsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddEmailsController.h"
#import "HQTFInputCell.h"
#import "TFEmailsContactsController.h"
#import "TFEmailsSignCell.h"
#import "TFManyLableCell.h"
#import "FDActionSheet.h"
#import "ZYQAssetPickerController.h"
#import "AlertView.h"
#import "TFEmailsSelectSenderController.h"
#import "TFEmailRecentContactsModel.h"
#import "HQTFTwoLineCell.h"
#import "TFEmailAddessBookItemModel.h"
#import "TFCustomerCommentController.h"
#import "TFEmailApproverAndCoperController.h"
#import "TFFileMenuController.h"

#import "TFEmailsEditCell.h"

#import "TFEmailAccountModel.h"
#import "TFEmailsDetailWebViewCell.h"
#import "TFEmailReceiveListModel.h"
#import "TFEmialApproverModel.h"
#import "TFFolderListModel.h"

#import "TFEmailsTagCell.h"
#import "TFEmailsBottomView.h"
#import "TFTagListView.h"
#import "MWPhotoBrowser.h"
#import "FileManager.h"

#import "TFMailBL.h"
#import "TFCustomBL.h"

@interface TFAddEmailsController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,FDActionSheetDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,TFEmailsSignCellDelegate,UITextFieldDelegate,HQBLDelegate,UITextViewDelegate,HQTFTwoLineCellDelegate,TFEmailsDetailWebViewCellDelegate,TFEmailsBottomViewDelegate,TFEmailsEditCellDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) TFMailBL *mailBL;

@property (nonatomic, strong) TFCustomBL *customBL;

@property (nonatomic, assign) NSInteger index;

/** 发件人 */
@property (nonatomic, copy) NSString *senderStr;

/** 主题 */
@property (nonatomic, copy) NSString *subject;

/** 账号id */
@property (nonatomic, strong) NSNumber *accountId;

/** 正文内容 */
@property (nonatomic, copy) NSString *mailContent;

/** 接收人 */
@property (nonatomic, copy) NSString *receiversStr;

/** 抄送人 */
@property (nonatomic, copy) NSString *copyersStr;

/** 密送人 */
@property (nonatomic, copy) NSString *secretsStr;

@property (nonatomic, assign) float webViewHeight;

@property (nonatomic, strong) TFEmailReceiveListModel *sendModel;

//是否要获取编辑框的内容
@property (nonatomic, assign) BOOL isGetContent;

/** 个人有效账号 */
@property (nonatomic, strong) NSArray *accounts;

@property (nonatomic, strong) TFEmialApproverModel *approveModel;

/** 是否文件库选 */
@property (nonatomic, assign) BOOL isFileLibraySelect;

/** 是否是保存草稿 */
@property (nonatomic, assign) BOOL isSaveDraft;

@property (nonatomic, assign) float editCellHeight;

@end

@implementation TFAddEmailsController

- (NSArray *)accounts {

    if (!_accounts) {
        
        _accounts = [NSArray array];
    }
    return _accounts;
}

- (TFEmailReceiveListModel *)sendModel {

    if (!_sendModel) {
        
        _sendModel = [[TFEmailReceiveListModel alloc] init];
    }
    return _sendModel;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(goReturn) image:@"返回灰" text:@"返回" textColor:kUIColorFromRGB(0x69696C)];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.receiversStr = @"";
    self.copyersStr = @"";
    self.secretsStr = @"";
    
    //草稿
    if (self.type == 3) {
        
        [self fillEmialData];
        
        [self createBottomView];
    }
    
    //再次编辑
    else if (self.type == 4) {
        
        [self fillEmialData];
    }
    
    self.mailBL = [TFMailBL build];
    
    self.mailBL.delegate = self;
    
    self.customBL = [TFCustomBL build];
    
    self.customBL.delegate = self;
    
    //获取个人账号
    [self.mailBL getPersonnelMailAccount];
    
    //是否走审批流程
    [self.customBL requestGetCustomApprovalCheckChooseNextApproval];
    
    //选人、选附件回填通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleSelectEmail:) name:@"selectEmialModuleAccountNotification" object:nil];
}

- (void)setNavi {

    self.navigationItem.title = @"发邮件";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sendEmail) image:@"邮件发送" highlightImage:@"邮件发送"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 填充值 */
- (void)fillEmialData {

    TFEmailReceiveListModel *model = self.detailModel;

    self.subject = model.subject;
    self.accountId = model.account_id;
    self.mailContent = model.mail_content;
    self.sendModel.attachments_name = model.attachments_name; //附件
    

    if (self.type == 1 ) { //回复，回填并交换发送人和接收人角色

            
        //发送人变接收人
        TFEmailPersonModel *personModel = [[TFEmailPersonModel alloc] init];
        personModel.mail_account = model.from_recipient;
        personModel.employee_name = model.from_recipient_name?:@"";
        [self.sendModel.to_recipients addObject:personModel]; //收件人
        
        //接收人变发送人(从多个联系人中遍历自己)
        for (TFEmailAccountModel *accountModel in self.accounts) {
            
            for (TFEmailPersonModel *pModel in model.to_recipients) {
                
                if ([accountModel.account isEqualToString:pModel.mail_account]) {
                    
                    self.sendModel.from_recipient = pModel.mail_account;
                    self.sendModel.from_recipient_name = pModel.employee_name;
                    
                    self.senderStr = [NSString stringWithFormat:@"%@%@",self.sendModel.from_recipient_name,self.sendModel.from_recipient];
                    
                    break;
                }
            }
        }
        
        
        
        
    }
    else if (self.type == 2) { //转发
    
        self.subject = [NSString stringWithFormat:@"转发：%@",model.subject];
    }
    else {
    
        self.senderStr = model.from_recipient;
        self.sendModel.to_recipients = model.to_recipients; //收件人
        self.sendModel.cc_recipients = model.cc_recipients; //抄送人
        self.sendModel.bcc_recipients = model.bcc_recipients; //密送人
    }
    
    //收件人
    if (self.sendModel.to_recipients.count > 0) {
        
        self.receiversStr = @"";
        for (TFEmailRecentContactsModel *model2 in self.sendModel.to_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            
            person.mail_account = model2.mail_account;
            person.employee_name = model2.employee_name;
            
            if (model2.employee_name == nil) {
                
                self.receiversStr = [self.receiversStr stringByAppendingString:[NSString stringWithFormat:@"、%@",model2.mail_account]];
            }
            else {
                
                
                self.receiversStr = [self.receiversStr stringByAppendingString:[NSString stringWithFormat:@"、%@%@",model2.employee_name,model2.mail_account]];
            }
            
            
            
        }
        self.receiversStr = [self.receiversStr substringFromIndex:1]; //截取掉下标1之前的

    }
    
    if (self.sendModel.cc_recipients.count > 0) {
        
        //抄送人
        for (TFEmailRecentContactsModel *model2 in self.sendModel.cc_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            person.employee_name = model2.employee_name;
            person.mail_account = model2.mail_account;
            self.copyersStr = [self.copyersStr stringByAppendingString:[NSString stringWithFormat:@"、%@%@",model2.employee_name,model2.mail_account]];
            
        }
        self.copyersStr = [self.copyersStr substringFromIndex:1]; //截取掉下标1之前的
    }
    
    if (self.sendModel.bcc_recipients.count > 0) {
        
        //密送人
        for (TFEmailRecentContactsModel *model2 in self.sendModel.bcc_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            person.employee_name = model2.employee_name;
            person.mail_account = model2.mail_account;
            self.secretsStr = [self.secretsStr stringByAppendingString:[NSString stringWithFormat:@"、%@%@",model2.employee_name,model2.mail_account]];
            
        }
        self.secretsStr = [self.secretsStr substringFromIndex:1]; //截取掉下标1之前的
    }
    
    [self.tableView reloadData];
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
            return 6;
        
        
    }
    else {

        return self.sendModel.attachments_name.count;

    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
    
        if (indexPath.row == 0) {
            
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            
            cell.delegate = self;
            cell.requireLabel.hidden = NO;
            cell.titleLabel.text = @"发件人";
            
            cell.textField.text = self.senderStr;
            cell.textField.placeholder = @"";
            cell.textField.userInteractionEnabled = NO;
            
            [cell.enterBtn setImage:IMG(@"下一级浅灰") forState:UIControlStateNormal];
            cell.enterBtn.tag = 0*123+indexPath.row;
            cell.bottomLine.hidden = NO;
            //        [cell refreshInputCellWithType:0];
            
            cell.textField.secureTextEntry = NO;
            
            
            
            return cell;
        }
        else if (indexPath.row == 1){
            
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            
            cell.requireLabel.hidden = NO;
            cell.delegate = self;
            cell.titleLabel.text = @"收件人";
            cell.textField.placeholder = @"请输入";
            cell.textField.delegate = self;
            [cell.enterBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
            cell.enterBtn.tag = 0*123+indexPath.row;
            cell.textField.tag = 100+indexPath.row;
            cell.bottomLine.hidden = NO;
            cell.textField.secureTextEntry = NO;
            
            cell.textField.text = self.receiversStr;
            
            cell.enterBtn.hidden = NO;
            
            return cell;
             
            
//            TFEmailsTagCell *cell = [TFEmailsTagCell emailsTagCellWithTableView:tableView];
//            
//            
//            
//            return cell;
        }
        else if (indexPath.row == 2){
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            
            cell.requireLabel.hidden = YES;
            cell.delegate = self;
            cell.titleLabel.text = @"抄送人";
            cell.textField.placeholder = @"请输入";
            cell.textField.delegate = self;
            [cell.enterBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
            cell.enterBtn.tag = 0*123+indexPath.row;
            cell.textField.tag = 100+indexPath.row;
            cell.bottomLine.hidden = NO;
            cell.textField.secureTextEntry = NO;
            
            cell.textField.text = self.copyersStr;
            
            cell.enterBtn.hidden = NO;
            
            return cell;
        }
        else if (indexPath.row == 3){
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            
            cell.requireLabel.hidden = YES;
            cell.delegate = self;
            cell.titleLabel.text = @"密送人";
            cell.textField.placeholder = @"请输入";
            cell.textField.delegate = self;
            cell.enterBtn.tag = 0*123+indexPath.row;
            cell.textField.tag = 100+indexPath.row;
            cell.bottomLine.hidden = NO;
            cell.textField.secureTextEntry = NO;
            
            cell.textField.text = self.secretsStr;
            
            [cell.enterBtn setImage:IMG(@"添加收件人") forState:UIControlStateNormal];
            
            cell.enterBtn.hidden = NO;
            return cell;
//            TFEmailsEditCell *cell = [TFEmailsEditCell emailsEditCellWithTableView:tableView];
//            
//            cell.delegate = self;
//            
//            
//            return cell;
            
        }
        else if (indexPath.row == 4){
            
            HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
            
            cell.requireLabel.hidden = NO;
            cell.delegate = self;
            cell.titleLabel.text = @"主题";
            cell.textField.placeholder = @"请输入";
            cell.textField.delegate = self;
            [cell.enterBtn setImage:IMG(@"邮件附件") forState:UIControlStateNormal];
            cell.enterBtn.tag = 0*123+indexPath.row;
            cell.textField.tag = 100+indexPath.row;
            cell.bottomLine.hidden = NO;
            cell.textField.secureTextEntry = NO;
            cell.textField.text = self.subject;
            
            return cell;
        }
        //加载webview
        else if (indexPath.row == 5){
            
            TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:0];
            
            cell.type = @0;
            cell.delegate = self;
            
            if (self.type == 0 || self.type == 3 || self.type == 4) {
                
                self.detailModel.type = @0;
            }
            else {
            
                self.detailModel.type = @1;
            }
            
//            [cell refreshEmailsDetailWebViewCellWithData:self.detailModel];
            cell.mailContent = self.detailModel.mail_content;
            
            if (self.isGetContent) { //保存草稿或发送信息时，先获取webview内容
                
                self.isGetContent = NO;
                
                //获取webview正文内容
                [cell getEmailContentFromWebview];
                
            }
            else {
            
                if (self.type == 1 || self.type == 2) { //回复
                    
                    [cell replayEmailWithWebViewCellWithData:self.detailModel];
                }
                else {
                
                    
                }
                
            }
            
            
            
            
            return cell;
        }

    }
    else { //附件
    
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.type = TwoLineCellTypeTwo;
        cell.titleImageWidth = 40.0;
        
        TFFileModel *model = self.sendModel.attachments_name[indexPath.row];
        
        [cell refreshCellWithAddNoteAttachFileModel:model];
        
//        [cell.titleImage sd_setImageWithURL:[NSURL URLWithString:model.file_url] forState:UIControlStateNormal];
//        cell.topLabel.text = model.file_name;
//        cell.bottomLabel.text = [HQHelper fileSizeForKB:[model.file_size integerValue]];
        cell.enterImage.hidden = NO;

        
        [cell.enterImage setImage:IMG(@"邮件已删除") forState:UIControlStateNormal];
        cell.enterImage.tag = 0*123+indexPath.row;
        
        cell.delegate = self;
        
        return cell;
    }
    return nil;

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            TFEmailsSelectSenderController *sender = [[TFEmailsSelectSenderController alloc] init];
            
            sender.accountId = self.accountId;
            sender.refreshAction = ^(id parameter) {
                
                TFEmailAccountModel *model = parameter;
                
                self.senderStr = model.account;
                self.accountId = model.id;
                
                
                [self.tableView reloadData];
                
            };
            
            [self.navigationController pushViewController:sender animated:YES];
        }
        else if (indexPath.row == 5) {
            
            
        }
        else {
            
            
        }

    }
    else {
    
        TFFileModel *model = self.sendModel.attachments_name[indexPath.row-3];
        if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"] || [[model.file_type lowercaseString] isEqualToString:@".jpg"] || [[model.file_type lowercaseString] isEqualToString:@".png"] || [[model.file_type lowercaseString] isEqualToString:@".gif"] || [[model.file_type lowercaseString] isEqualToString:@".jpeg"]) {// 查看图片
            
            
            [self didLookAtPhotoActionWithIndex:indexPath.row-3];
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exl"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exls"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"zip"]){
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HQHelper cacheFileWithUrl:model.file_url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    
                    // 临时文件夹
                    NSString *tmpPath = [FileManager dirTmp];
                    // 创建文件路径
                    NSString *filePath = [FileManager createFile:model.file_name forPath:tmpPath];
                    // 将文件写入该路径
                    BOOL pass = [data writeToFile:filePath atomically:YES];
                    
                    if (pass) {// 写入成功
                        
                        UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                        ctrl.delegate = self;
                        [ctrl presentPreviewAnimated:YES];
                    }
                }else{
                    [MBProgressHUD showError:@"读取文件失败" toView:self.view];
                }
                
            }];
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
            
            
            
        }else{
            
            [MBProgressHUD showError:@"未知文件无法预览" toView:KeyWindow];
        }

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 3) {
            
            if (self.editCellHeight <50) {
                
                return 50;
            }
            else {
            
                return self.editCellHeight;
            }
            
        }
        if (indexPath.row == 5) {
        
            return self.webViewHeight;
        }
    }
    else if (indexPath.section == 1) {
  
        return 55;
        
    }
    

    return 50;
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

#pragma mark 底部按钮
- (void)createBottomView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-49);
        
    NSArray *labs = @[@"评论",@"更多"];
    NSArray *imgs = @[@"邮件评论",@"更多-9"];
    
    TFEmailsBottomView *emailsBottomView = [[TFEmailsBottomView alloc] initWithBottomViewFrame:CGRectMake(0, SCREEN_HEIGHT-64-49, SCREEN_WIDTH, 49) labs:labs image:imgs];
    
    emailsBottomView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    emailsBottomView.delegate = self;
    
    [self.view addSubview:emailsBottomView];
}

#pragma mark HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn {

    NSInteger index = enterBtn.tag-0*123;
    
        
    [self.sendModel.attachments_name removeObjectAtIndex:index];

    
    [self.tableView reloadData];
}

#pragma mark ---TFEmailsBottomViewDelegate
- (void)emailBottomButtonClicked:(NSInteger)buttonIndex {

    if (buttonIndex == 0) { //评论
        
        TFCustomerCommentController *comment = [[TFCustomerCommentController alloc] init];
        
        comment.id = self.detailModel.id;
        comment.bean = @"email";

        
        [self.navigationController pushViewController:comment animated:YES];
    }
    else if (buttonIndex == 1) { //更多
    
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"彻底删除", nil];
        
        sheet.tag = 1002;
        
        [sheet show];
    }
}

#pragma mark UITextFieldDelegate
- ( void )textFieldDidBeginEditing:( UITextField*)textField {

    self.index = textField.tag-100;
    
//    [self.tableView reloadData];
    

}


- (void)textFieldDidEndEditing:(UITextField *)textField {

    NSInteger index = textField.tag - 100;
    if (index == 1) { //收件人
        
        self.receiversStr = textField.text;
        
//        TFEmailPersonModel *model = [[TFEmailPersonModel alloc] init];
//        
//        model.mail_account = textField.text;
//        model.employee_name = @"";
//        
//        [self.sendModel.to_recipients addObject:model];
        
    }
    else if (index == 2) { //抄送人
    
        self.copyersStr = textField.text;
    }
    else if (index == 3) { //密送人
        
        self.secretsStr = textField.text;
    }
    else if (index == 4) { //主题
        
        self.subject = textField.text;
    }
    
    
}


#pragma mark HQTFInputCellDelegate
- (void)inputCellDidClickedEnterBtn:(UIButton *)button {

    NSInteger index = button.tag-0*123;
    if (index == 0 ) { //发件人
        
        TFEmailsSelectSenderController *sender = [[TFEmailsSelectSenderController alloc] init];
        
        sender.refreshAction = ^(id parameter) {
          
            TFEmailAccountModel *model = parameter;
            
            self.senderStr = model.account;
            self.accountId = model.id;
            
            [self.tableView reloadData];
            
        };
        
        [self.navigationController pushViewController:sender animated:YES];
    }
    else if (index == 1 || index == 2 || index == 3) { //收件人//抄送人//密送人
    
        TFEmailsContactsController *emailsContactsVC = [[TFEmailsContactsController alloc] init];
        
        emailsContactsVC.type = 1;
        emailsContactsVC.tableViewHeight = SCREEN_HEIGHT-64;
        emailsContactsVC.index = index;//索引
        
        emailsContactsVC.actionParameter = ^(id parameter) {
          
//            NSString *string = @"";
            for (TFEmailRecentContactsModel *model in parameter) {
                
                TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
                person.employee_name = model.employee_name;
                person.mail_account = model.mail_account;
                
                
                
//                string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@%@",model.employee_name,model.mail_account]];
                
                if (index == 1) {
                    
                    if (self.sendModel.to_recipients.count == 0) { //还没有选择接收人
                        
                         [self.sendModel.to_recipients addObject:person];
                    }
                    else { //已有联系人则判断有没有重复
                    
                        BOOL have = NO;
                        for (TFEmailPersonModel *perModel in self.sendModel.to_recipients) {
                            
                            if ([person.mail_account isEqualToString:perModel.mail_account]) {
                                
                                have = YES;
                                break;
                            }
                            
                        }
                        
                        if (!have) {
                            
                            [self.sendModel.to_recipients addObject:person];
                        }
                    }
                    
                }
                else if (index == 2) {
                
                    [self.sendModel.cc_recipients addObject:person];
                }
                else if (index == 3) {
                
                    [self.sendModel.bcc_recipients addObject:person];
                }
            }
            
            NSString *string = @"";
            if (index == 1) {
                
                
                for (TFEmailRecentContactsModel *contactsModel in self.sendModel.to_recipients) {
                    
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@%@",contactsModel.employee_name,contactsModel.mail_account]];
                    
                    
                }
                
                string = [string substringFromIndex:1]; //截取掉下标1之前的
                
                self.receiversStr = string;
            }
            else if (index == 2) {
                
                for (TFEmailRecentContactsModel *contactsModel in self.sendModel.cc_recipients) {
                    
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@%@",contactsModel.employee_name,contactsModel.mail_account]];
                }
                
                string = [string substringFromIndex:1]; //截取掉下标1之前的
                
                self.copyersStr = string;
            }
            else if (index == 3) {
                
                for (TFEmailRecentContactsModel *contactsModel in self.sendModel.bcc_recipients) {
                    
                    string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@%@",contactsModel.employee_name,contactsModel.mail_account]];
                }
                
                string = [string substringFromIndex:1]; //截取掉下标1之前的
                
                self.secretsStr = string;
            }
            
//            string = [string substringFromIndex:1]; //截取掉下标1之前的
            
//            if (index == 1) {
//                
//                self.receiversStr = string;
//            }
//            else if (index == 2) {
//                
//                self.copyersStr = string;
//            }
//            else if (index == 3) {
//                
//                self.secretsStr = string;
//            }
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:emailsContactsVC animated:YES];
    }

    else if (index == 4) {
        
        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中上传",@"从文件库中选择", nil];
        
        sheet.tag = 1000;
        
        [sheet show];
    }
}

#pragma mark FDActionSheetDelegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {

    if (sheet.tag == 1000) {
        
        if (buttonIndex == 0) {
            
            [self openCamera];
        }
        else if (buttonIndex == 1) {
            
            [self openAlbum];
        }
        else if (buttonIndex == 2) {
            
            self.isFileLibraySelect = YES;
            [self pushFileLibray];
        }
    }
    else if (sheet.tag == 1001) {
    
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
//            self.isGetContent = YES;
//            
//            [self.tableView reloadData];

            [self sendDatas];
            
        }
    }
    else if (sheet.tag == 1002) { //草稿删除
    
        
        [self.mailBL requesMailOperationDeleteDraftWithData:[NSString stringWithFormat:@"%@",self.detailModel.id]];
    }
}

#pragma mark TFEmailsEditCellDelegate
- (void)editCellHeight:(float)height {

    self.editCellHeight = height;
    
    [self.tableView reloadData];
}

#pragma mark TFEmailsDetailWebViewCellDelegate(获取webview高度及正文内容)
- (void)getWebViewHeight:(CGFloat)height {
    
    if (self.webViewHeight != height) {
        
        self.webViewHeight = height;
        
        [self.tableView reloadData];
    }
    
    
}

- (void)giveWebViewContentForAddEmail:(NSString *)content {

    self.mailContent = content;
    
    if (self.isSaveDraft) {
        
        [self saveDraftData];
    }
    else {
    
        [self sendDatas];
    }
    
    
}

#pragma mark 返回
/** 返回 */
- (void)goReturn {

    if ([self.senderStr isEqualToString:@""]) {
        
        
    }
    //保存草稿
    self.isSaveDraft = YES;
    
    self.isGetContent = YES;
    
    [self.tableView reloadData];
    
}

- (void)saveDraftData {

    if (self.type == 3) {
        
        if (![self.mailContent isEqualToString:@""] && self.mailContent != nil) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃修改",@"保存草稿", nil];
            
            sheet.tag = 1001;
            
            [sheet show];
        }
        else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        
        if (self.sendModel.attachments_name.count!=0 || self.subject!=nil || self.mailContent != nil) {
            
            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃修改",@"保存草稿", nil];
            
            sheet.tag = 1001;
            self.type = 10;
            
            [sheet show];
        }
        else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

#pragma mark 通知方法
- (void)moduleSelectEmail:(NSNotification *)note {

    NSArray *arr = note.object;
    
    NSString *string = @"";
    for (TFEmailAddessBookItemModel *model in arr) {
        
        TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
        person.employee_name = model.name?model.name:model.employee_name;
        person.mail_account = model.mail_address?model.mail_address:model.mail_account;
        
//        if ([person.mail_account isEqualToString:@""] || person.mail_account == nil) {
//            
//            string = @"";
//        }
//        else {
//        
//        }
        string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@%@",person.employee_name,person.mail_account]];
        
        if ([model.index integerValue] == 1) {
            
            [self.sendModel.to_recipients addObject:person];
        }
        else if ([model.index integerValue] == 2) {
            
            [self.sendModel.cc_recipients addObject:person];
        }
        else if ([model.index integerValue] == 3) {
            
            [self.sendModel.bcc_recipients addObject:person];
        }
    }
    string = [string substringFromIndex:1]; //截取掉下标1之前的
    
    TFEmailAddessBookItemModel *model2 = arr[0];
    if ([model2.index integerValue] == 1) {
        
        self.receiversStr = string;
    }
    else if ([model2.index integerValue] == 2) {
        
        self.copyersStr = string;
    }
    else if ([model2.index integerValue] == 3) {
        
        self.secretsStr = string;
    }
    
    [self.tableView reloadData];
}

#pragma mark 发送按钮
- (void)sendEmail {
    
    if (self.type == 3 || self.type == 4 || self.type == 10) { //如果是草稿，编辑完发送的时候跟新增邮件一样
        
        self.type = 0;
    }
    
    self.isSaveDraft = NO;
    
    self.isGetContent = YES;
    
    [self.tableView reloadData];
    
    
    
}

- (void)sendDatas {
    
    
    TFEmailReceiveListModel *model = [[TFEmailReceiveListModel alloc] init];
    
    model.subject = self.subject;
    model.account_id = self.accountId;
    model.from_recipient = self.senderStr;
    model.mail_content = self.mailContent;
    model.to_recipients = self.sendModel.to_recipients; //收件人
    model.cc_recipients = self.sendModel.cc_recipients; //抄送人
    model.bcc_recipients = self.sendModel.bcc_recipients; //密送人
    model.is_plain = @"1"; //是否纯文本
    model.mail_source = @"1"; //0：pc 1：手机
    model.attachments_name = self.sendModel.attachments_name; //附件
    model.from_recipient_name = UM.userLoginInfo.employee.employee_name;
    
    if (self.type == 3) { //草稿箱进来编辑草稿
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        model.id = self.detailModel.id;
        
        [self.mailBL requesMailOperationEditDraftWithData:model];
        
        return;
    }
    
    if (self.type == 10) { //保存草稿
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        

        [self.mailBL requesMailOperationSaveToDraftWithData:model];
        
        return;
    }
    
    if ([model.from_recipient isEqualToString:@""] || model.from_recipient == nil) {
        
        [MBProgressHUD showError:@"请选择发件人!" toView:self.view];
        return;
    }
    
    /** 如果是手动输入，则判断有没有输入值 */
    if (self.sendModel.to_recipients.count == 0) { //收件人
        
        if (![self.receiversStr isEqualToString:@""] && self.receiversStr != nil) {
            
            TFEmailPersonModel *personModel = [[TFEmailPersonModel alloc] init];
            
            personModel.mail_account = self.receiversStr;
            [model.to_recipients addObject:personModel];
        }
        
        if (model.to_recipients.count == 0) {
            
            [MBProgressHUD showError:@"请选择收件人!" toView:self.view];
            return;
        }
        
        
    }
    
    if (self.sendModel.cc_recipients.count == 0) {
        
        if (![self.copyersStr isEqualToString:@""] && self.copyersStr != nil) {
            
            TFEmailPersonModel *personModel = [[TFEmailPersonModel alloc] init];
            
            personModel.mail_account = self.copyersStr;
            [model.cc_recipients addObject:personModel];
        }
    }
    
    if (self.sendModel.bcc_recipients.count == 0) {
        
        if (![self.secretsStr isEqualToString:@""] && self.secretsStr != nil) {
            
            TFEmailPersonModel *personModel = [[TFEmailPersonModel alloc] init];
            
            personModel.mail_account = self.secretsStr;
            [model.bcc_recipients addObject:personModel];
        }
    }
    
    if ([model.subject isEqualToString:@""] || model.subject == nil) {
        
        [MBProgressHUD showError:@"请输入邮件主题!" toView:self.view];
        return;
    }
    if ([model.mail_content isEqualToString:@""] || model.mail_content == nil) {
        
        [MBProgressHUD showError:@"请输入邮件内容!" toView:self.view];
        return;
    }
    
    
    
    
    
    if (self.type == 0 || self.type == 4) { //发送邮件判断是否走审批流程（回复、转发不走审批）
        

        if ([self.approveModel.processType isEqualToNumber:@2]) {

            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
            model.id = self.detailModel.id;
            
            [self.mailBL sendMailWithData:model];//发送
        }
        else {
        
            TFEmailApproverAndCoperController *approverAndCoperVC = [[TFEmailApproverAndCoperController alloc] init];
            
            approverAndCoperVC.model = model;
            
            [self.navigationController pushViewController:approverAndCoperVC animated:YES];
        }
        
    }
    
    else if (self.type == 1) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        model.id = self.detailModel.id;
        [self.mailBL replayMailWithData:model];//回复
    }
    else if (self.type == 2) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        model.id = self.detailModel.id;
        [self.mailBL forwardMailWithData:model];//转发
    }
    
    
}


#pragma mark ----TFEmailsSignCellDelegate
- (void)deleteMineSign {

    [AlertView showAlertView:@"确定要删除吗？" onLeftTouched:^{
        
    } onRightTouched:^{
        
    }];

}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 拍照上传

//    [self.attImages addObject:image];
//    
//    NSData *data = UIImageJPEGRepresentation(image, 1.0);
//    
//    NSInteger size = data.length;
//
//    NSDictionary *dic = @{
//                          @"fileName":@"这是一张自拍",
//                          @"fileUrl":image,
//                          @"fileSize":fileSize
//                          };


    [self.mailBL chatFileWithImages:@[image] withVioces:nil bean:@"mail"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 6 ; // 选择图片最大数量
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
    
    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        
//        UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        // 选择照片上传
        
//        [self.attImages addObject:image];
       
//        NSInteger size = [representation size];

        [arr addObject:image];
        
    }
    
//    [self.mailBL uploadFileWithImages:@[] withAudios:@[] withVideo:@[] bean:@""];
    [self.mailBL chatFileWithImages:arr withVioces:nil bean:@"mail"];
    
//    [self.tableView reloadData];
    
}

#pragma mark ---文件库选
- (void)pushFileLibray {

    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;
        
        TFFileModel *fileModel = [[TFFileModel alloc] init];
        fileModel.file_url = model.fileUrl;
        fileModel.file_size = @([model.size integerValue]);
        fileModel.file_type = model.siffix;
        fileModel.file_name = model.name;
        
        [self.sendModel.attachments_name addObject:fileModel];
        
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}

#pragma mark - 图片浏览器

- (void)didLookAtPhotoActionWithIndex:(NSInteger)index{
    
    // 浏览图片
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO; // 分享按钮,默认是
    browser.alwaysShowControls = NO ; // 控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES; // 是否全屏,默认是
    browser.enableSwipeToDismiss = NO;
    [browser showNextPhotoAnimated:NO];
    [browser showPreviousPhotoAnimated:NO];
    [browser setCurrentPhotoIndex:index];
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [self.navigationController pushViewController:browser animated:YES] ;
}

/**
 * 标题
 */
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.sendModel.attachments_name.count] ;
}

/**
 * 图片总数量
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.sendModel.attachments_name.count;
}

/**
 * 图片设置
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    TFFileModel *model = self.sendModel.attachments_name[index];
    MWPhoto *mwPhoto = nil;
    
    if (model.image) {
        mwPhoto = [MWPhoto photoWithImage:model.image];
    }else{
        mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:model.file_url]];
    }
    
    return mwPhoto;
    
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryPersonnelAccount) { //获取个人有效账号
        
        self.accounts = resp.body;

        if (self.type == 0) { //新增
            
            for (TFEmailAccountModel *model in self.accounts) {
                
                if ([model.account_default isEqualToString:@"1"]) { //默认账号
                    
                    self.senderStr = model.account;
                    break;
                }
                
            }
        }
        //回复
        else if (self.type == 1) {
            
            self.navigationItem.title = @"回复";
            [self fillEmialData];
        }
        
        //转发
        else if (self.type == 2) {
            
            self.navigationItem.title = @"转发";
            
            for (TFEmailAccountModel *model in self.accounts) {
                
                if ([model.account_default isEqualToString:@"1"]) { //默认账号
                    
                    self.senderStr = model.account;
                    break;
                }
                
            }

            
            [self fillEmialData];
        }
        
        
        
        
        [self.tableView reloadData];
    }
    if (resp.cmdId == HQCMD_mailOperationSend) { //发送邮件
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"发送成功！" toView:self.view];
        
        if (self.refresh) {
            
            self.refresh();
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (resp.cmdId == HQCMD_mailOperationMailReply) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"回复成功！" toView:self.view];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_mailOperationMailForward) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"转发成功！" toView:self.view];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_ChatFile) { //上传文件
        
        if (self.sendModel.attachments_name.count == 0) {
            
            self.sendModel.attachments_name = resp.body;
            
        }
        else {
        
            NSMutableArray *arr = [NSMutableArray array];
            arr = resp.body;
            
            [self.sendModel.attachments_name addObjectsFromArray:arr];
        }
        
        
        [self.tableView reloadData];
        
        
    }
    if (resp.cmdId == HQCMD_mailOperationSaveToDraft) { //保存草稿
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存成功！" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_mailOperationEditDraft) { //编辑草稿
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存成功！" toView:self.view];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    if (resp.cmdId == HQCMD_mailOperationDeleteDraft) { //草稿删除
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_CustomApprovalCheckChooseNextApproval) {
        
        self.approveModel = resp.body;
        
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
