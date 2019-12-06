//
//  TFAddEmailsController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/2/6.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFEmailsNewController.h"
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
#import "TFEmailsAddHeadView.h"

#import "TFMailBL.h"
#import "TFCustomBL.h"
#import "IQKeyboardManager.h"
#import "HQSelectTimeCell.h"
#import "TFAttributeTextController.h"

@interface TFEmailsNewController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,FDActionSheetDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,TFEmailsSignCellDelegate,UITextFieldDelegate,HQBLDelegate,UITextViewDelegate,HQTFTwoLineCellDelegate,TFEmailsDetailWebViewCellDelegate,TFEmailsBottomViewDelegate,TFEmailsEditCellDelegate,TFEmailsAddHeadViewDelegate,UIDocumentInteractionControllerDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) TFMailBL *mailBL;
@property (nonatomic, strong) TFCustomBL *customBL;
@property (nonatomic,strong) TFEmailsAddHeadView *addHeadView;

@property (nonatomic, assign) NSInteger index;
/** 主题 */
@property (nonatomic, copy) NSString *subject;
/** 账号id */
@property (nonatomic, strong) NSNumber *accountId;
/** 个人有效账号 */
@property (nonatomic, strong) NSArray *accounts;
/** 正文内容 */
@property (nonatomic, copy) NSString *mailContent;

@property (nonatomic, assign) float webViewHeight;
@property (nonatomic, assign) float editCellHeight;
@property (nonatomic, assign) CGFloat keyboardH;

@property (nonatomic, strong) TFEmailReceiveListModel *sendModel;
@property (nonatomic, strong) TFEmialApproverModel *approveModel;

/** 是否文件库选 */
@property (nonatomic, assign) BOOL isFileLibraySelect;
/** 是否是保存草稿 */
@property (nonatomic, assign) BOOL isSaveDraft;
/** 用于回复、转发界面点击返回 */
@property (nonatomic, assign) BOOL isFirstContent;
@property (nonatomic, assign) BOOL isSend;
@property (nonatomic, copy) NSString *firstContent;

@end

@implementation TFEmailsNewController

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
    
    self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(goReturn) image:@"返回灰色" text:@"返回" textColor:GreenColor];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    [self setupTableView];
    [self emailsHeadView];
    if (self.detailModel) {
        self.mailContent = self.detailModel.mail_content;
    }
    
    if (self.type == 0) {
        self.firstContent = @"";
        self.isFirstContent = NO;
        [self fillEmialData];
    }
    else {
        self.isFirstContent = YES;
    }

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setNavi {
    
    self.navigationItem.title = @"发邮件";
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sendEmail) image:@"邮件发送" highlightImage:@"邮件发送"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)emailsHeadView {
    
    self.addHeadView = [[TFEmailsAddHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    self.addHeadView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    self.addHeadView.delegate = self;
    //    [self.view addSubview:self.addHeadView];
    self.tableView.tableHeaderView = self.addHeadView;
}

/** 填充值 */
- (void)fillEmialData {
    
    TFEmailReceiveListModel *model = self.detailModel;
    
    self.subject = model.subject;
    self.accountId = model.account_id;
    self.mailContent = model.mail_content;
    if (self.type != 1) {// 新需求，回复不带原来邮件的附件，20181120修改
        self.sendModel.attachments_name = model.attachments_name; //附件
    }
    
    
    if (self.type == 1 ) { //回复，回填并交换发送人和接收人角色
        
//        [self.addHeadView.oneEditView resignFirstResponder];
//        [self.addHeadView.twoEditView resignFirstResponder];
//        [self.addHeadView.threeEditView resignFirstResponder];
        
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
                    
//                    self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@%@",self.sendModel.from_recipient_name,self.sendModel.from_recipient];
                    self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@",self.sendModel.from_recipient];
                    
                    break;
                }
            }
        }
        
    }
    else if (self.type == 2) { //转发
        

        //接收人变发送人(从多个联系人中遍历自己)
        for (TFEmailAccountModel *accountModel in self.accounts) {
            
            if ([accountModel.account_default isEqualToString:@"1"]) { //默认账号
                
                for (TFEmailPersonModel *pModel in model.to_recipients) {
                    
                    if ([accountModel.account isEqualToString:pModel.mail_account]) {
                        
                        self.sendModel.from_recipient = pModel.mail_account;
                        self.sendModel.from_recipient_name = pModel.employee_name;
                        
//                        self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@%@",self.sendModel.from_recipient_name,self.sendModel.from_recipient];
                        self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@",self.sendModel.from_recipient];
                        
                        break;
                    }
                }

            }
            else {
            
                for (TFEmailPersonModel *pModel in model.to_recipients) {
                    
                    if ([accountModel.account isEqualToString:pModel.mail_account]) {
                        
                        self.sendModel.from_recipient = pModel.mail_account;
                        self.sendModel.from_recipient_name = IsStrEmpty(pModel.employee_name)?accountModel.nickname:pModel.employee_name;
                        
//                        self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@%@",self.sendModel.from_recipient_name,self.sendModel.from_recipient];
                        self.addHeadView.sendLab.text = [NSString stringWithFormat:@"%@",self.sendModel.from_recipient];
                        
//                        break;
                    }
                }
            }
            

        }
        
        self.subject = [NSString stringWithFormat:@"转发：%@",model.subject];
    }
    else {
        
        self.addHeadView.sendLab.text = model.from_recipient;
        self.sendModel.to_recipients = model.to_recipients; //收件人
        self.sendModel.cc_recipients = model.cc_recipients; //抄送人
        self.sendModel.bcc_recipients = model.bcc_recipients; //密送人
    }
    
    //收件人
    if (self.sendModel.to_recipients.count > 0) {
        
        for (TFEmailRecentContactsModel *model2 in self.sendModel.to_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            
            person.mail_account = model2.mail_account;
            person.employee_name = model2.employee_name;
            
            
            [self.addHeadView fromSelectContacts:person.mail_account type:1 name:person.employee_name];
            
            
        }
        
    }
    
    if (self.sendModel.cc_recipients.count > 0) {
        
        //抄送人
        for (TFEmailRecentContactsModel *model2 in self.sendModel.cc_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            person.employee_name = model2.employee_name;
            person.mail_account = model2.mail_account;
            
            [self.addHeadView fromSelectContacts:person.mail_account type:2 name:person.employee_name];
            
        }
        
    }
    
    if (self.sendModel.bcc_recipients.count > 0) {
        
        //密送人
        for (TFEmailRecentContactsModel *model2 in self.sendModel.bcc_recipients) {
            
            TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
            person.employee_name = model2.employee_name;
            person.mail_account = model2.mail_account;
            
            [self.addHeadView fromSelectContacts:person.mail_account type:3 name:person.employee_name];
            
        }
    }
    
    [self.tableView reloadData];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    self.tableView.contentSize = CGSizeMake(0,216);
//}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
//    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 1) {
        if (self.sendModel.attachments_name.count == 0) {
            return 0;
        }else{
            if ([self.sendModel.showFile isEqualToNumber:@1]) {
                
                return self.sendModel.attachments_name.count + 1;
            }else{
                
                return 1;
            }
        }
        
    }
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
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
        cell.inputLeftW.constant = 64;
        return cell;

    }
    else if (indexPath.section == 2) {
        
        TFEmailsDetailWebViewCell *cell = [TFEmailsDetailWebViewCell emailsDetailWebViewCellWithTableView:tableView from:0];
        
        cell.type = @0;
        cell.delegate = self;
        cell.mailContent = self.mailContent;
        if (self.type == 0 || self.type == 3 || self.type == 4) {
            
            self.detailModel.type = @0;
        }
        else {
            self.detailModel.type = @1;
            
            if (self.type == 1 || self.type == 2) { //回复
                
                [cell replayEmailWithWebViewCellWithData:self.detailModel];
                
            }
        }
        
        return cell;
    }
    else { //附件
        
        if (indexPath.row == 0) {
         
            HQSelectTimeCell *cell = [HQSelectTimeCell selectTimeCellWithTableView:tableView];
            cell.timeTitle.text = [NSString stringWithFormat:@"附件(%ld)",self.sendModel.attachments_name.count];
//            if ([self.sendModel.showFile isEqualToNumber:@1]) {
//                cell.arrow.image = IMG(@"custom收起");
//                cell.bottomLine.hidden = YES;
//            }else{
//                cell.arrow.image = IMG(@"下一级浅灰");
//                cell.bottomLine.hidden = NO;
//            }
            
            if ([self.sendModel.showFile isEqualToNumber:@1]) {
                cell.arrow.transform = CGAffineTransformMakeRotation(M_PI_2);
                cell.bottomLine.hidden = YES;
            }else{
                cell.bottomLine.hidden = NO;
                cell.arrow.transform = CGAffineTransformIdentity;
            }
            cell.topLine.hidden = YES;
            return cell;
            
        }
        
        HQTFTwoLineCell *cell = [HQTFTwoLineCell twoLineCellWithTableView:tableView];
        
        cell.type = TwoLineCellTypeTwo;
        cell.titleImageWidth = 40.0;
        
        TFFileModel *model = self.sendModel.attachments_name[indexPath.row-1];
        
        [cell refreshCellWithAddNoteAttachFileModel:model];
        
        cell.enterImage.hidden = NO;
        cell.enterImage.userInteractionEnabled = YES;
        
        [cell.enterImage setImage:IMG(@"邮件已删除") forState:UIControlStateNormal];
        cell.enterImage.tag = 0*123+indexPath.row-1;
        cell.topLabel.width = SCREEN_WIDTH-160;
        cell.delegate = self;
        cell.enterImgTrailW.constant = -10;
        if (indexPath.row == self.sendModel.attachments_name.count) {
            cell.bottomLine.hidden = NO;
        }else{
            cell.bottomLine.hidden = YES;
        }
        cell.topLine.hidden = YES;
        return cell;
    }
    return nil;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
//    if (indexPath.section == 0) {
//
//        TFEmailsSelectSenderController *sender = [[TFEmailsSelectSenderController alloc] init];
//        sender.accountId = self.accountId;
//        sender.refreshAction = ^(id parameter) {
//
//            TFEmailAccountModel *model = parameter;
//
//            self.addHeadView.sendLab.text = model.account;
//            self.accountId = model.id;
//
////            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
////            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
//
//        };
//
//        [self.navigationController pushViewController:sender animated:YES];
//
//    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            self.sendModel.showFile = [self.sendModel.showFile isEqualToNumber:@1] ? @0 : @1;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
//            [self.tableView reloadData];
            return;
        }
        
        TFFileModel *model = self.sendModel.attachments_name[indexPath.row-1];
        model.file_type = [model.file_type stringByReplacingOccurrencesOfString:@"." withString:@""];
        if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
            
            [self didLookAtPhotoActionWithIndex:indexPath.row-3];
            
        }
        else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exl"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"exls"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
                  [[model.file_type lowercaseString] isEqualToString:@"pdf"] ||
                 [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
                 [[model.file_type lowercaseString] isEqualToString:@"rar"]){
            
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [HQHelper cacheFileWithUrl:model.file_url fileName:model.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (error == nil) {
                    
                    // 保存文件
                    NSString *filePath = [HQHelper saveCacheFileWithFileName:model.file_name data:data];
                    
                    if (filePath) {// 写入成功
                        
                        UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                        ctrl.delegate = self;
                        [ctrl presentPreviewAnimated:YES];
                    }
                }else{
                    [MBProgressHUD showError:@"读取文件失败" toView:self.view];
                }
                
            } fileHandler:^(NSString *path) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                ctrl.delegate = self;
                [ctrl presentPreviewAnimated:YES];
            }];
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
            
            
            
        }else if ([[model.file_type lowercaseString] isEqualToString:@"mp4"]){
            
            
            
        }else{
            
            [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
        }
        
    }
    
    if (indexPath.section == 2) {
        
        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
        att.fieldLabel = @"描述";
        att.content = self.mailContent;
        att.contentAction = ^(NSString *parameter) {
            
            self.mailContent = parameter;
            self.detailModel.mail_content = parameter;
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:att animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 2) {
        
        return self.webViewHeight;
    }
    else if (indexPath.section == 1) {
        
        return 55;
        
    }
    
    return 50;
}


#pragma mark 底部按钮
- (void)createBottomView {
    
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight-BottomHeight);
    
    NSArray *labs = @[@"评论",@"更多"];
    NSArray *imgs = @[@"邮件评论",@"更多-9"];
    
    TFEmailsBottomView *emailsBottomView = [[TFEmailsBottomView alloc] initWithBottomViewFrame:CGRectMake(0, SCREEN_HEIGHT-NaviHeight-BottomHeight, SCREEN_WIDTH, TabBarHeight) labs:labs image:imgs];
    
    emailsBottomView.backgroundColor = kUIColorFromRGB(0xF2F2F2);
    emailsBottomView.delegate = self;
    
    [self.view addSubview:emailsBottomView];
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    //界面所有输入框都停止编辑
//    [self.view endEditing:YES];
//}

#pragma mark HQTFTwoLineCellDelegate
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn {
    
    NSInteger index = enterBtn.tag-0*123;
    
    [self.sendModel.attachments_name removeObjectAtIndex:index];
    
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
        
//        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"彻底删除", nil];
//
//        sheet.tag = 1002;
//
//        [sheet show];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"更多操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"彻底删除",nil];
        sheet.tag = 1002;
        [sheet showInView:self.view];
    }
}

#pragma mark UITextFieldDelegate
- ( void )textFieldDidBeginEditing:( UITextField*)textField {
    
    self.index = textField.tag-100;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSInteger index = textField.tag - 100;
    
    if (index == 0) { //主题
        
        self.subject = textField.text;
    }
    
}


#pragma mark HQTFInputCellDelegate
- (void)inputCellDidClickedEnterBtn:(UIButton *)button {
    
    [self.view endEditing:YES];
    NSInteger index = button.tag-0*123;

    if (index == 0) {
        
//        FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册中上传",@"从文件库中选择", nil];
//
//        sheet.tag = 1000;
//
//        [sheet show];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中上传",@"从文件库中选择", nil];
        sheet.tag = 1000;
        [sheet showInView:self.view];
        
    }
    
}

#pragma mark FDActionSheetDelegate
//- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex {
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)buttonIndex{

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
        else if (buttonIndex == 1) {
            
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
    
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark TFEmailsDetailWebViewCellDelegate(获取webview高度及正文内容)
- (void)getWebViewHeight:(CGFloat)height {
    
    if (self.webViewHeight != height) {
        
        self.webViewHeight = height<150?150:height;
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
    
}

- (void)giveWebViewContentForAddEmail:(NSString *)content {
    
    if (self.isFirstContent) {
        
        self.isFirstContent = NO;
//        self.firstContent = content;
    }
    
    if (self.isSaveDraft) {
        
        if ([self.firstContent isEqualToString:content]) { //无内容修改
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            self.mailContent = content;
            [self saveDraftData];
        }
        
    }
    if (self.isSend) {
        
        self.mailContent = content;
        [self sendDatas];
    }

}

//- (void)webViewIsFucus {
//
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.keyboardH, 0);
//}

- (void)keyBoardWillShow:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    NSValue *endValue      = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame        = endValue.CGRectValue;
    
    self.keyboardH = endFrame.size.height;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.keyboardH, 0);
}

- (void)keyBoardWillHide:(NSNotification *)noti {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma mark 返回
/** 返回 */
- (void)goReturn {
    
    [self.view endEditing:YES];
    
    //保存草稿
    self.isSaveDraft = YES;
    TFEmailsDetailWebViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    [cell getEmailContentFromWebview];
}

- (void)saveDraftData {
    
    if (self.type == 3) {
        
        if (![self.mailContent isEqualToString:@""] && self.mailContent != nil) {
            
//            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃修改",@"保存草稿", nil];
//
//            sheet.tag = 1001;
//
//            [sheet show];
            
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"放弃修改",@"保存草稿",nil];
            sheet.tag = 1001;
            [sheet showInView:self.view];
        }
        else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else {
        
        if (self.sendModel.attachments_name.count!=0 || self.subject!=nil || self.mailContent != nil) {
            
//            FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃修改",@"保存草稿", nil];
//
//            sheet.tag = 1001;
//
//            [sheet show];
            
            self.type = 10;
            
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"放弃修改",@"保存草稿",nil];
            sheet.tag = 1001;
            [sheet showInView:self.view];
        }
        else {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark 通知方法
- (void)moduleSelectEmail:(NSNotification *)note {
    
    NSArray *arr = note.object;
    
    for (TFEmailAddessBookItemModel *model in arr) {
        
        TFEmailPersonModel *person = [[TFEmailPersonModel alloc] init];
        person.employee_name = model.name?model.name:model.employee_name;
        person.mail_account = model.mail_address?model.mail_address:model.mail_account;
        
        [self.addHeadView fromSelectContacts:person.mail_account type:[model.index integerValue] name:person.employee_name];
    }
    
//    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

#pragma mark 发送按钮
- (void)sendEmail {
    
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (self.type == 3 || self.type == 4 || self.type == 10) { //如果是草稿，编辑完发送的时候跟新增邮件一样
        
        self.type = 0;
    }
    
    self.isSaveDraft = NO;
    self.isSend = YES;
    TFEmailsDetailWebViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
    [cell getEmailContentFromWebview];
}

- (void)sendDatas {
    
    TFEmailReceiveListModel *model = [[TFEmailReceiveListModel alloc] init];
    
    model.subject = self.subject;
    model.account_id = self.accountId;
    model.from_recipient = self.addHeadView.sendLab.text;
//    model.mail_content = self.mailContent;
    model.mail_content = @"<br /><br /><br /><br /><p>    <br /></p><p>    转发：<span>来自友人的一封感谢信</span></p><p>    发件人： yirenxiaoliang@163.com </p><p>    时间：2019-06-25 10:25:06</p><span>收件人：<span> 123yinmingliang@163.com </span></span><p>    <br /></p><br /><br /><p>    <br /></p><p>        你好！</p><p>        很高兴认识你。</p><br /><p>    <br /></p>";
    model.to_recipients = self.sendModel.to_recipients; //收件人
    model.cc_recipients = self.sendModel.cc_recipients; //抄送人
    model.bcc_recipients = self.sendModel.bcc_recipients; //密送人
    model.is_plain = @0; //是否纯文本
    model.mail_source = @1; //0：pc 1：手机
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
        self.isSend = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD showError:@"请选择发件人!" toView:self.view];
        return;
    }
    
    /** 如果是手动输入，则判断有没有输入值 */
    if (self.sendModel.to_recipients.count == 0) { //收件人
        
        self.isSend = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD showError:@"请选择收件人!" toView:self.view];
        return;
        
        
    }
    
    if ([model.subject isEqualToString:@""] || model.subject == nil) {
        
        self.isSend = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD showError:@"请输入邮件主题!" toView:self.view];
        return;
    }
    if ([model.mail_content isEqualToString:@""] || model.mail_content == nil) {
        
        self.isSend = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD showError:@"请输入邮件内容!" toView:self.view];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.type == 0 || self.type == 4) { //发送邮件判断是否走审批流程（回复、转发不走审批）
        
        
//        备注：processType：0固定流程、1自由流程；
//        choosePersonnel：角色对应的员工集合
//        ccTo：抄送人（0：显示抄送人，1：不显示抄送人。选人范围：全公司）
//        规则：processType == 2【为2时表示邮件没有审批流程，不弹框】
//        processType == 1 【1为自由流程，从全公司组织架构中选择下一审批人】
//        processType == 0 && choosePersonnel.size()!=0 从choosePersonnel中选择
//        processType == 0 && choosePersonnel.size()==0 不弹框

        if ([self.approveModel.processType isEqualToNumber:@2]) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            model.id = self.detailModel.id;
            
            [self.mailBL sendMailWithData:model];//发送
        }
        else if ([self.approveModel.processType isEqualToNumber:@0]) {
        
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

#pragma mark TFEmailsAddHeadViewDelegate
- (void)headViewHeight:(float)height {
    
    self.addHeadView.height = 50+height;
    
    CGRect newFrame = self.addHeadView.frame;
    newFrame.size.height = newFrame.size.height;
    self.addHeadView.frame = newFrame;
    //    [self.tableView setTableHeaderView:self.addHeadView];
//    [self.tableView beginUpdates];
    [self.tableView setTableHeaderView:self.addHeadView];
//    [self.tableView endUpdates];
    
}

//输入框内容（传回来的邮件地址）
- (void)headViewContents:(NSMutableArray *)contents type:(NSInteger)type {

    HQLog(@"--------contents----------:%@",contents);
    
    NSMutableArray<TFEmailPersonModel> *contactsArr = [NSMutableArray<TFEmailPersonModel> array];
    for (TFEmailPersonModel *model in contents) {
        
        if ([HQHelper checkEmail:model.employee_name]) {
            if (![HQHelper checkEmail:model.mail_account]) {
                model.mail_account = model.employee_name;
            }
        }
        [contactsArr addObject:model];
        
    }
    
    //接收人
    if (type == 1) {
        
        self.sendModel.to_recipients = contactsArr;
        
    }
    //抄送人
    if (type == 2) {
        
        self.sendModel.cc_recipients = contactsArr;

    }
    //密送人
    if (type == 3) {
        
        self.sendModel.bcc_recipients = contactsArr;

    }

}

//选择发送人
- (void)selectSenderClicked {
    
    TFEmailsSelectSenderController *sender = [[TFEmailsSelectSenderController alloc] init];
    
    sender.accountId = self.accountId;
    sender.refreshAction = ^(id parameter) {
        
        TFEmailAccountModel *model = parameter;
        
        self.addHeadView.sendLab.text = model.account;
        self.accountId = model.id;
        
    };
    
    [self.navigationController pushViewController:sender animated:YES];
}


/**  添加邮件联系人
 *
 * @param type 1:接收人 2:抄送人 3:密送人
 */
- (void)addEmailContactsClicked:(NSInteger)type {

    TFEmailsContactsController *emailsContactsVC = [[TFEmailsContactsController alloc] init];
    
    emailsContactsVC.type = 1;
    emailsContactsVC.tableViewHeight = SCREEN_HEIGHT-NaviHeight;
    emailsContactsVC.index = type;//索引
    
    emailsContactsVC.actionParameter = ^(id parameter) {
      
        for (TFEmailRecentContactsModel *model in parameter) {
            
            NSMutableArray *recipients = [NSMutableArray array];
            
            if (type == 1) {
                
                recipients = self.sendModel.to_recipients;

            }
            if (type == 2) {
                
                recipients = self.sendModel.cc_recipients;

            }
            if (type == 3) {
                
                recipients = self.sendModel.bcc_recipients;
                
            }
            
            
            BOOL have = NO;
            for (TFEmailPersonModel *per in recipients) {
                
                //去重
                if ([model.mail_account isEqualToString:per.mail_account]) {
                    
                    have = YES;
                    break;
                    
                }
            }
            if (!have) {
                
                [self.addHeadView fromSelectContacts:model.mail_account type:type name:model.employee_name];
            }
           
        }
        
    };
    
    [self.navigationController pushViewController:emailsContactsVC animated:YES];
}


#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

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

/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    
    [self.mailBL chatFileWithImages:arr withVioces:nil bean:@"email"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    picker.modalPresentationStyle = UIModalPresentationFullScreen;

    [self.navigationController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        
//                UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];
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
    
    [self.mailBL chatFileWithImages:arr withVioces:nil bean:@"email"];

    
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
        
        
        if (self.sendModel.attachments_name) {
            
            [self.sendModel.attachments_name addObject:fileModel];
        }
        else {
            
            NSMutableArray <TFFileModel,Optional>*files = [NSMutableArray <TFFileModel,Optional>array];
            [files addObject:fileModel];
            
            self.sendModel.attachments_name = files;
        }
        
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (self.refresh) {
        
        self.refresh();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_queryPersonnelAccount) { //获取个人有效账号
        
        self.accounts = resp.body;
        
        if (self.type == 0) { //新增
            
            for (TFEmailAccountModel *model in self.accounts) {
                
                if ([model.account_default isEqualToString:@"1"]) { //默认账号
                    
                    self.addHeadView.sendLab.text = model.account;
                    self.accountId = model.id;
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
                    
                    self.addHeadView.sendLab.text = model.account;
                    break;
                }
                
            }
            
            
            [self fillEmialData];
        }
//        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

    }
    if (resp.cmdId == HQCMD_mailOperationSend) { //发送邮件
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([self.approveModel.processType isEqualToNumber:@2]) { //无需审批
            
            [MBProgressHUD showError:@"发送成功！" toView:self.view];
            
            if (self.refresh) {
                
                self.refresh();
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的邮件已进入审批环节，请在审批模块查看。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            alert.delegate = self;
            [alert show];
        }
        
        
    }
    if (resp.cmdId == HQCMD_mailOperationMailReply) { //回复邮件
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"回复成功！" toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    if (resp.cmdId == HQCMD_mailOperationMailForward) { //转发
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:@"转发成功！" toView:self.view];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
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
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }
    if (resp.cmdId == HQCMD_mailOperationSaveToDraft) { //保存草稿
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MBProgressHUD showError:@"保存成功" toView:self.view];
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    if (resp.cmdId == HQCMD_mailOperationEditDraft) { //编辑草稿
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showError:@"保存成功" toView:self.view];
        
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
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

@end
