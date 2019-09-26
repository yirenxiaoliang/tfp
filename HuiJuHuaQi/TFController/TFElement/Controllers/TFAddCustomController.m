//
//  TFAddCustomController.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2017/11/29.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFAddCustomController.h"
#import "TFCustomBaseModel.h"
#import "TFFileElementCell.h"
#import "HQTFInputCell.h"
#import "HQSelectTimeCell.h"
#import "TFManyLableCell.h"
#import "HQSelectTimeView.h"
#import "FDActionSheet.h"
#import "HQTFUploadFileView.h"
#import "FileManager.h"
#import "MWPhotoBrowser.h"
#import "TFPlayVoiceController.h"
#import "TFCustomerPieCell.h"
#import "TFSingleTextCell.h"
#import "TFCustomerRowsModel.h"
#import "TFCustomerOptionModel.h"
#import "TFStatisticsCell.h"
#import "HQTFMorePeopleCell.h"
#import "HQTFPeopleCell.h"
#import "TFSubformCell.h"
#import "TFSelectChatPeopleController.h"
#import "TFMapController.h"
#import "TFCustomLocationCell.h"
#import "HQAddressView.h"
#import "IQKeyboardManager.h"
#import "JCHATToolBar.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "ZYQAssetPickerController.h"
#import "HQAreaManager.h"
#import "TFCustomBL.h"
#import "TFSubformSectionView.h"
#import "TFSubformAddView.h"
#import "TFSubformHeadCell.h"
#import "TFSelectOptionController.h"
#import "TFSelectDateView.h"
#import "TFSelectCalendarView.h"
#import "TFColumnView.h"
#import "TFSelectPeopleCell.h"
#import "TFLabelTextView.h"
#import "TFReferenceSearchController.h"
#import "TFNormalPeopleModel.h"
#import "TFChangeHelper.h"
#import "TFCustomOptionCell.h"
#import "TFReferenceListModel.h"
#import "TFCustomSearchController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFChooseRangePeopleController.h"
#import "TFApprovalCopyerController.h"
//#import "TFCustomDetailController.h"
#import "TFNewCustomDetailController.h"
#import "TFCustomRangePeopleController.h"
#import "HQSwitchCell.h"
#import "TFProjectTaskBL.h"
//#import "TFAttributeTextCell.h"
#import "TFAttributeTextController.h"
#import "TFContactsDepartmentController.h"
#import "TFGeneralSingleCell.h"
#import "TFCustomSelectOptionCell.h"
#import "TFScanCodeController.h"
#import "StyleDIY.h"
#import "TFCustomAttachmentsCell.h"
#import "TFCustomMultiSelectCell.h"
#import "TFCustomAlertView.h"
#import "TFTCustomSubformHeaderCell.h"
#import "TFCustomImageCell.h"
#import "TFCustomAttributeTextCell.h"
#import "TFEmailsNewController.h"
#import "TFWebLinkListController.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFCustomDepartmentCell.h"
#import "TFRequest.h"

@interface TFAddCustomController ()<UITableViewDelegate,UITableViewDataSource,HQTFInputCellDelegate,FDActionSheetDelegate,TFFileElementCellDelegate,UIDocumentInteractionControllerDelegate,MWPhotoBrowserDelegate,UITextViewDelegate,TFSubformCellDelegate,TFSingleTextCellDelegate,TFCustomLocationCellDelegate,UINavigationControllerDelegate, ZYQAssetPickerControllerDelegate, UIImagePickerControllerDelegate ,SendMessageDelegate,HQBLDelegate,TFSubformSectionViewDelegate,TFSubformAddViewDelegate,TFSubformHeadCellDelegate,TFColumnViewDelegate,HQSelectTimeCellDelegate,TFCustomOptionCellDelegate,TFSelectPeopleCellDelegate,HQSwitchCellDelegate,TFGeneralSingleCellDelegate,TFCustomSelectOptionCellDelegate,TFCustomAttachmentsCellDelegate,TFCustomAlertViewDelegate,TFCustomImageCellDelegate,TFCustomAttributeTextCellDelegate,TFCustomMultiSelectCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate,TFCustomDepartmentCellDelegate,TFTCustomSubformHeaderCellDelegate>
/** tableView */
@property (nonatomic, weak) UITableView *tableView;

/** images */
@property (nonatomic, strong) NSMutableArray *images;


/** TFCustomBaseModel */
@property (nonatomic, strong) TFCustomBaseModel *customModel;
/** 详情数据 */
@property (nonatomic, strong) NSDictionary *customDict;

/** HQAddressView */
@property (nonatomic, strong) HQAddressView *addressView;


/** --------------------------语音录制------------------------- */
/** 输入框 */
@property (strong, nonatomic) JCHATToolBarContainer *recoder;
/** 录音 */
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
/** 管理录音工具对象 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;
/** ----------------------------end--------------------------- */


/** 添加附件及图片时对应的Model ,也用于记录子表单下拉对应的Model */
@property (nonatomic, strong) TFCustomerRowsModel *attachmentModel;

/** 详情数据 */
@property (nonatomic, strong) NSDictionary *detailDict;
/** HQAreaManager */
@property (nonatomic, strong) HQAreaManager *areaManager;

/** 自定义请求 */
@property (nonatomic, strong) TFCustomBL *customBL;

/** layouts */
@property (nonatomic, strong) NSMutableArray *layouts;

/** 自定义请求 */
@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

/** 保存的数据 */
@property (nonatomic, strong) NSDictionary *saveDict;

/** 选项弹窗 */
@property (nonatomic, strong) TFCustomAlertView *optionAlertView;

/** level */
@property (nonatomic, assign) NSInteger level;

/** 联动条件字段 */
@property (nonatomic, strong) NSArray *linkageConditions;

/** 记录初始值 */
@property (nonatomic, copy) NSString *startDict;

@property (nonatomic, strong) NSNumber  *oprationType;

@end

@implementation TFAddCustomController

-(TFCustomAlertView *)optionAlertView{
    if (!_optionAlertView) {
        _optionAlertView = [[TFCustomAlertView alloc] init];
        _optionAlertView.delegate = self;
    }
    return _optionAlertView;
}

-(HQAreaManager *)areaManager{
    if (!_areaManager) {
        _areaManager = [HQAreaManager defaultAreaManager];
    }
    return _areaManager;
}

-(HQAddressView *)addressView{
    if (!_addressView) {
        _addressView = [[HQAddressView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight)];
        [self.view addSubview:_addressView];
    }
    
    return _addressView;
}

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = NO;
    
    if (self.translucent) {
        
        if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
            
            [self.navigationController.navigationBar setBackgroundImage:[HQHelper createImageWithColor:ClearColor] forBarMetrics:UIBarMetricsDefault];
            
            [self.navigationController.navigationBar setShadowImage:[HQHelper createImageWithColor:ClearColor size:(CGSize){SCREEN_WIDTH,0.5}]];
        }
        [self.navigationController.navigationBar setTranslucent:YES];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:WhiteColor,NSFontAttributeName:FONT(20)}];
    }
    NSAssert(self.tableViewHeight > 0, @"tableView的高度要大于0，请设置tableView的高度，否则看不见tableView。");
    
    if (self.isChild) {
        [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        self.tableView.scrollEnabled = NO;
    }else{
        self.navigationItem.leftBarButtonItem = [self itemWithTarget:self action:@selector(didBack:) text:@"取消" textColor:GreenColor];
    }
}

-(void)didBack:(UIButton *)sender{
    NSString *str = [[self dictData] description];
    if (![str isEqualToString:self.startDict]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定放弃此次编辑吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
//    manager.enable = YES;
    if (self.isChild) {
        [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardFrame.size.height, 0);
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
    /** type 0:新增 1:详情 2：编辑 3：复制 */
    /** operationType  1:自定义表单 2:新增 3:编辑 4:详情 7：重新编辑(含：发起人撤销、驳回到发起人)  */
    
    NSNumber  *oprationType = nil;
    if (self.type == 0) {
        oprationType = @2;
    }else if (self.type == 1){
        oprationType = @4;
    }else if (self.type == 2){
        oprationType = @3;
    }else if (self.type == 3){
        oprationType = @3;
    }else if (self.type == 7){
        oprationType = @7;
    }
    self.oprationType = oprationType;
    
    if (self.type != 1) {
        [self.customBL requestGetConditionFieldListWithBean:self.bean];
    }
    
    if (self.type != 0) {
        [self.customBL requsetCustomDetailWithBean:self.bean dataId:[self.dataId description] taskKey:self.taskKey processFieldV:self.processFieldV];
    }else{
        [self.customBL requestCustomLayoutWithBean:self.bean taskKey:self.taskKey operationType:self.oprationType dataId:[self.dataId description] isSeasPool:self.isSeasPool processFieldV:self.processFieldV];
    }
    if (self.type == 1) {
        kWEAKSELF
        self.refreshAction = ^{
            [weakSelf.customBL requsetCustomDetailWithBean:weakSelf.bean dataId:[weakSelf.dataId description] taskKey:weakSelf.taskKey processFieldV:weakSelf.processFieldV];
        };
    }
    
    [self setupTableView];
    [self setupNavi];
    [self setupToolBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    if (self.type != 1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
}

/** 观察者 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGSize size = [[change valueForKey:@"new"] CGSizeValue];
//    [[NSNotificationCenter defaultCenter] postNotificationName:CustomDetailHeightNotification object:@(size.height)];
    if (self.heightBlock) {
        self.heightBlock(@(size.height));
    }
}

/** 移除观察者 */
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupNavi{
    
    if (self.type == 0) {
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@",TEXT(self.customModel.title)];
//        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
        UIBarButtonItem *item1 = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
        UIBarButtonItem *item2 = [self itemWithTarget:self action:@selector(linkClicked) image:@"链接" highlightImage:@"链接"];
        self.navigationItem.rightBarButtonItems = @[item1,item2];
        
    }else if (self.type == 1){
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@详情",TEXT(self.customModel.title)];
        
    }else if (self.type == 2 || self.type == 7){
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@",TEXT(self.customModel.title)];
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    }else if (self.type == 3){
        
        self.navigationItem.title = [NSString stringWithFormat:@"复制%@",TEXT(self.customModel.title)];
        self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(sure) text:@"确定"];
    }
}

-(void)linkClicked{
    
    TFWebLinkListController *link = [[TFWebLinkListController alloc] init];
    
    if ([self.isSeasPool isEqualToString:@"1"]) {
        link.source = @3;
        link.seasPoolId = self.seaPoolId;
        link.moduleBean = self.bean;
    }else{
        link.source = @2;
        link.moduleBean = self.bean;
    }
    
    if (self.lastDetailDict) {
        
        NSArray *refers = [self getReferenceRows];
        NSArray *keys = self.lastDetailDict.allKeys;
        
        for (TFCustomerRowsModel *model in refers) {
            
            BOOL have = NO;
            for (NSString *key in keys) {
                
                if ([key isEqualToString:model.relevanceField.fieldName]) {// 找到需要赋值关联组件
                    have = YES;
                    link.source = @4;
                    link.moduleBean = self.bean;
                    link.relevanceField = model.name;
                    link.relevanceModule = self.sorceBean;
                    link.relevanceValue = [self.dataId description];
                    
                    break;
                }
                
            }
            
            if (have) {
                break;
            }
            
        }
        
    }
    
    [self.navigationController pushViewController:link animated:YES];
}

/** 判断某个组件是否必填 */
- (BOOL)chechRequireWithModel:(TFCustomerRowsModel *)model{
    
    BOOL required = YES;
    if ([model.field.fieldControl isEqualToString:@"2"]) {// 必填
        
        if ([model.type isEqualToString:@"picture"] || [model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"] || [model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"] || [model.type isEqualToString:@"mutlipicklist"]) {
            
            if (!model.selects.count) {
                
                if (!IsStrEmpty(model.subformName)) {
                    TFCustomerRowsModel *sub = [self getRowWithName:model.subformName];
                    
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@-%@不能为空",sub.label,model.label] toView:KeyWindow];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",model.label] toView:KeyWindow];
                }
                
                required = NO;
            }
            
        }else{
            
            if (!model.fieldValue || [model.fieldValue isEqualToString:@""]) {// 校验
                
                if (!IsStrEmpty(model.subformName)) {
                    TFCustomerRowsModel *sub = [self getRowWithName:model.subformName];
                    
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@-%@不能为空",sub.label,model.label] toView:KeyWindow];
                }else{
                    [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",model.label] toView:KeyWindow];
                }
                
                required = NO;
            }
        }
    }
    
    return required;
}

/** 必填字段校验 */
- (BOOL)requiredSure{
    
    BOOL required = YES;
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (layout.isOptionHidden) {// 选项控制隐藏
            continue;
        }
        
        if (![layout.isHideInCreate isEqualToString:@"1"]) {
            
            if (![layout.name isEqualToString:@"systemInfo"]) {// 基本信息
                
                if (![layout.terminalApp isEqualToString:@"1"]) {
                    continue;
                }
                
                for (TFCustomerRowsModel *model in layout.rows) {
                    
                    if (model.field.isOptionHidden) {// 选项控制隐藏
                        continue;
                    }
                    
                    if (![model.field.terminalApp isEqualToString:@"1"]) {
                        continue;
                    }
                    
                    if (self.type == 0 || self.type == 3) {
                        
                        if (![model.field.addView isEqualToString:@"0"]){
                            
                            if ([model.type isEqualToString:@"subform"]) {
                                
                                if ([model.field.fieldControl isEqualToString:@"2"]) {// 子表单必填
                                    if (model.subforms.count == 0) {
                                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",model.label] toView:self.view];
                                        required = NO;
                                        break;
                                    }
                                }
                                
                                BOOL rowRequire = YES;
                                for (NSArray *rowArr in model.subforms) {
                                    
                                    for (TFCustomerRowsModel *row in rowArr) {
                                        
                                        rowRequire = [self chechRequireWithModel:row];
                                        if (rowRequire == NO) {
                                            required = NO;
                                            break;
                                        }
                                    }
                                    if (rowRequire == NO) {
                                        break;
                                    }
                                }
                                
                            }else{
                                
                                BOOL rowRequire = [self chechRequireWithModel:model];
                                if (rowRequire == NO) {
                                    required = NO;
                                    break;
                                }
                            }
                            
                        }
                        
                    }else if (self.type == 2 || self.type == 7){
                        
                        if (![model.field.editView isEqualToString:@"0"]) {
                            
                            if ([model.type isEqualToString:@"subform"]) {
                                
                                if ([model.field.fieldControl isEqualToString:@"2"]) {// 子表单必填
                                    if (model.subforms.count == 0) {
                                        required = NO;
                                        [MBProgressHUD showError:[NSString stringWithFormat:@"%@不能为空",model.label] toView:self.view];
                                        break;
                                    }
                                }
                                BOOL rowRequire = YES;
                                for (NSArray *rowArr in model.subforms) {
                                    
                                    for (TFCustomerRowsModel *row in rowArr) {
                                        
                                        rowRequire = [self chechRequireWithModel:row];
                                        if (rowRequire == NO) {
                                            required = NO;
                                            break;
                                        }
                                    }
                                    if (rowRequire == NO) {
                                        break;
                                    }
                                }
                                
                            }else{
                                
                                BOOL rowRequire = [self chechRequireWithModel:model];
                                if (rowRequire == NO) {
                                    required = NO;
                                    break;
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
        if (!required) {
            break;
        }
    }
    
    return required;
}

- (BOOL)formatSureWithModel:(TFCustomerRowsModel *)model{
    
    BOOL format = YES;
    if ([model.type isEqualToString:@"phone"]) {
        
        if ([model.field.phoneType isEqualToString:@"1"]) {// 手机号
            if ([model.field.phoneLenth isEqualToString:@"1"]) {// 11位
                if (model.fieldValue.length && model.fieldValue.length != 11) {
                    [MBProgressHUD showError:[NSString stringWithFormat:@"请输入【%@】%@位数",model.label,@"11"] toView:KeyWindow];
                    format = NO;
                }
            }
        }
        
    }
    if ([model.type isEqualToString:@"email"]) {
        
        if (model.fieldValue.length) {// 校验
            
            if (![HQHelper checkEmail:model.fieldValue]) {
                [MBProgressHUD showError:@"请填写正确邮箱" toView:KeyWindow];
                format = NO;
            }
        }
    }
    
    if ([model.type isEqualToString:@"url"]) {
        
        if (model.fieldValue.length) {// 校验
            
            if (![HQHelper checkUrl:model.fieldValue]) {
                [MBProgressHUD showError:@"请填写正确链接" toView:KeyWindow];
                format = NO;
            }
        }
    }
    
    if ([model.type isEqualToString:@"number"]) {
        
        if (model.fieldValue.length) {
            
            CGFloat min = 0.0;
            CGFloat max = 0.0;
            if (!model.field.betweenMin || [model.field.betweenMin isEqualToString:@""]) {
                min = -MAXFLOAT;
            }else{
                min = [model.field.betweenMin floatValue];
            }
            if (!model.field.betweenMax || [model.field.betweenMax isEqualToString:@""]) {
                max = MAXFLOAT;
            }else{
                max = [model.field.betweenMax floatValue];
            }
            
            if (!([model.fieldValue floatValue] >= min && [model.fieldValue floatValue] <= max)) {
                
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@输入范围为%@~%@",model.label,model.field.betweenMin,model.field.betweenMax] toView:KeyWindow];
                format = NO;
            }
        }
    }
    return format;
}


/** 格式校验 */
- (BOOL)formatSure{
    
    BOOL format = YES;
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.isHideInCreate isEqualToString:@"1"]) {
           
            if (![layout.name isEqualToString:@"systemInfo"]) {// 基本信息
                
                if (![layout.terminalApp isEqualToString:@"1"]) {
                    continue;
                }
                
                for (TFCustomerRowsModel *model in layout.rows) {
                    
                    if (![model.field.terminalApp isEqualToString:@"1"]) {
                        continue;
                    }
                    if (self.type == 0 || self.type == 3) {
                        
                        if (![model.field.addView isEqualToString:@"0"]){
                            
                            if ([model.type isEqualToString:@"subform"]) {
                                
                                BOOL rowRequire = YES;
                                for (NSArray *rowArr in model.subforms) {
                                    
                                    for (TFCustomerRowsModel *row in rowArr) {
                                        
                                        rowRequire = [self formatSureWithModel:row];
                                        if (rowRequire == NO) {
                                            format = NO;
                                            break;
                                        }
                                    }
                                    if (rowRequire == NO) {
                                        break;
                                    }
                                }
                                
                                
                            }else{
                                
                                BOOL rowRequire = [self formatSureWithModel:model];
                                if (rowRequire == NO) {
                                    format = NO;
                                    break;
                                }
                            }
                            
                        }
                        
                    }else if (self.type == 2 || self.type == 7){
                        
                        if (![model.field.editView isEqualToString:@"0"]) {
                            
                            if ([model.type isEqualToString:@"subform"]) {
                                
                                BOOL rowRequire = YES;
                                for (NSArray *rowArr in model.subforms) {
                                    
                                    for (TFCustomerRowsModel *row in rowArr) {
                                        
                                        rowRequire = [self formatSureWithModel:row];
                                        if (rowRequire == NO) {
                                            format = NO;
                                            break;
                                        }
                                    }
                                    if (rowRequire == NO) {
                                        break;
                                    }
                                }
                                
                            }else{
                                
                                BOOL rowRequire = [self formatSureWithModel:model];
                                if (rowRequire == NO) {
                                    format = NO;
                                    break;
                                }
                            }
                            
                        }
                    }
                    
                }
            }
        }
        
        if (!format) {
            break;
        }
    }
    
    return format;
}

/** 将某组件所需提交的数据放入字典中 */
- (void)getDataWithModel:(TFCustomerRowsModel *)model withDict:(NSMutableDictionary *)dataDict{
    
#pragma mark - 选项控制隐藏的组件不提交
    if ([model.field.isOptionHidden isEqualToString:@"1"]) {
        [dataDict setObject:@"" forKey:model.name];
        return;
    }
    
    if ([model.type isEqualToString:@"identifier"] ||
        [model.type isEqualToString:@"serialnum"]) {// 自动编号不提交，自动生成
        return;
    }
    
//    if (self.type == 0) {
//        if ([model.field.addView isEqualToString:@"0"]) {
//            return;
//        }
//    }
    
    if (model.fieldValue) {
        
        [dataDict setObject:model.fieldValue forKey:model.name];
    }else{
        
        [dataDict setObject:@"" forKey:model.name];
    }
    
    if ([model.type isEqualToString:@"location"]) {// 详细地址
        
        if (model.fieldValue && ![model.fieldValue isEqualToString:@""]) {
            
            NSMutableDictionary *loca = [NSMutableDictionary dictionary];
            
            [loca setObject:model.fieldValue forKey:@"value"];
            
            if (model.otherDict) {
                
                if ([model.otherDict valueForKey:@"longitude"]) {
                    
                    [loca setObject:[[model.otherDict valueForKey:@"longitude"] description] forKey:@"lng"];
                }
                if ([model.otherDict valueForKey:@"latitude"]) {
                    
                    [loca setObject:[[model.otherDict valueForKey:@"latitude"] description] forKey:@"lat"];
                }
                
                if ([model.otherDict valueForKey:@"area"]) {
                    [loca setObject:[model.otherDict valueForKey:@"area"] forKey:@"area"];
                }
            }
            
            [dataDict setObject:loca forKey:model.name];
        }else{
            
            [dataDict setObject:@"" forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"] || [model.type isEqualToString:@"mutlipicklist"]) {// 选项时
        
        if (model.selects && model.selects.count) {
            
            NSMutableArray *optArr = [NSMutableArray array];
            for (TFCustomerOptionModel *option in model.selects) {
                TFCustomerOptionModel *opt = [option copy];
                opt.subList = nil;
                [optArr addObject:[opt toDictionary]];
            }
            [dataDict setObject:optArr forKey:model.name];
        }else{
            [dataDict setObject:@"" forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"datetime"]) {// 转成时间戳
        
        if (model.fieldValue) {
            [dataDict setObject:@([HQHelper changeTimeToTimeSp:model.fieldValue formatStr:model.field.formatType]) forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"number"]) {// 数字类型
        
        if (![model.field.numberType isEqualToString:@"1"]) {// 小数
            
            if (model.fieldValue && ![model.fieldValue isEqualToString:@""]) {
                
                NSArray *nums = [model.fieldValue componentsSeparatedByString:@"."];
                if (nums.count == 1) {
                    
                    NSString *sttt = @"";
                    for (NSInteger k = 0; k < [model.field.numberLenth integerValue]; k ++) {
                        
                        sttt = [sttt stringByAppendingString:@"0"];
                    }
                    NSString *nu = [NSString stringWithFormat:@"%@.%@",nums.lastObject,sttt];
//                    [dataDict setObject:[NSNumber numberWithFloat:[nu floatValue]] forKey:model.name];
                    // 20180828 数字组件传值由数字类型转为字符串
                    [dataDict setObject:nu forKey:model.name];
                    
                }else if (nums.count == 2) {
                    
                    NSString *last = nums.lastObject;
                    NSInteger numLast = last.length;
                    for (NSInteger k = 0; k < [model.field.numberLenth integerValue]-numLast; k ++) {
                        
                        last = [last stringByAppendingString:@"0"];
                    }
                    NSString *nu = [NSString stringWithFormat:@"%@.%@",nums.firstObject,last];
//                    [dataDict setObject:[NSNumber numberWithFloat:[nu floatValue]] forKey:model.name];
                    // 20180828 数字组件传值由数字类型转为字符串
                    [dataDict setObject:nu forKey:model.name];
                    
                }
            }
            
        }
    }
    
    
    if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"] || [model.type isEqualToString:@"picture"]) {// 附件，图片
        
        if (model.selects.count) {
            
            NSMutableArray *aaa = [NSMutableArray array];
            
            for (TFFileModel *ff in model.selects) {
                
                NSDictionary *dd = [ff toDictionary];
                
                if (dd) {
                    [aaa addObject:dd];
                }
            }
            
            [dataDict setObject:aaa forKey:model.name];
        }
    }
    
    
    if ([model.type isEqualToString:@"reference"]) {// 关联关系
        
        if (model.relevanceField.fieldId) {// 显示名称，传递id
            [dataDict setObject:model.relevanceField.fieldId forKey:model.name];
        }
    }
    
    if ([model.type isEqualToString:@"personnel"]) {// 人员
        
        NSMutableArray *selects = [NSMutableArray array];
        NSString *str = @"";
        if (model.selects.count) {
            
            for (HQEmployModel *emp in model.selects) {
                
                NSDictionary *di = [[TFChangeHelper normalPeopleForEmployee:emp] toDictionary];
                [selects addObject:di];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[emp.id description]]];
            }
        }
        
        if (str.length) {
            [dataDict setObject:[str substringToIndex:str.length-1] forKey:model.name];
        }else{
            
            [dataDict setObject:str forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"department"]) {// 部门
        
        NSString *str = @"";
        if (model.selects.count) {
            
            for (TFDepartmentModel *emp in model.selects) {
                
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[emp.id description]]];
            }
        }
        
        if (str.length) {
            [dataDict setObject:[str substringToIndex:str.length-1] forKey:model.name];
        }else{
            
            [dataDict setObject:str forKey:model.name];
        }
        
    }
    
    if ([model.type isEqualToString:@"subform"]){
        
        // 普通处理
        NSMutableArray *subforms = [NSMutableArray array];
        
        for (NSArray *subs in model.subforms) {
            
            NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
            for (TFCustomerRowsModel *row in subs) {// 子表单进行递归
                
                [self getDataWithModel:row withDict:subDict];
                
            }
            [subforms addObject:subDict];
        }
        
        [dataDict setObject:subforms forKey:model.name];
    }
    
}

/** 布局表单数据 */
- (NSMutableDictionary *)dictData{
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.name isEqualToString:@"systemInfo"]) {// 基本信息
            
            for (TFCustomerRowsModel *model in layout.rows) {
                
                [self getDataWithModel:model withDict:dataDict];
            }
        }
    }
    
    // 公海池
    if ([self.isSeasPool isEqualToString:@"1"]) {
        
        [dataDict setObject:self.seaPoolId forKey:@"seas_pool_id"];
    }
    
    return dataDict;
}



///** 子表单是否有重复数据 */
//- (BOOL)subformCkeckRepeatWithDataDict:(NSDictionary *)dataDict{
//
//    // 子表单数组
//    NSArray *subforms = [self getSubformElement];
//
//
//    for (TFCustomerRowsModel *model in subforms) {
//
//        // 某个子表单需查重的组件
//        NSMutableArray *repeats = [NSMutableArray array];
//        if (model.subforms.count) {
//            NSArray *subs = model.subforms[0];
//            for (TFCustomerRowsModel *subModel in subs) {
//
//                if ([subModel.field.repeatCheck isEqualToString:@"2"]) {
//                    [repeats addObject:subModel];
//                }
//            }
//        }
//        // 某个子表单组件提交的数值数组
//        NSArray *datas = [dataDict valueForKey:model.name];
//        if (![datas isKindOfClass:[NSArray class]]) {
//            return NO;
//        }
//        if (datas.count <= 1) {// 一个栏目就没什么可重复的了
//            return NO;
//        }
//
//        // 取出需要查重组件的值
//        NSMutableArray *repeatVales = [NSMutableArray array];
//        for (TFCustomerRowsModel *repEle in repeats) {
//            NSMutableArray *values = [NSMutableArray array];
//            for (NSDictionary *dict in datas) {
//                [values addObject:[dict valueForKey:repEle.name]];
//            }
//            [repeatVales addObject:values];
//        }
//
//        // 比较查重组件是否有相同的值
//        for (NSInteger k = 0; k < repeatVales.count; k ++) {
//            NSArray *arr = repeatVales[k];
//            for (NSInteger i = 0; i < arr.count-1; i ++) {
//                NSString *strI = [arr[i] description];
//                for (NSInteger j = i + 1; j < arr.count; j ++) {
//                    NSString *strJ = [arr[j] description];
//                    if (![strI isEqualToString:@""] &&
//                        ![strJ isEqualToString:@""] &&
//                        [strI isEqualToString:strJ]) {// 有相同的
//
//                        TFCustomerRowsModel *re = repeats[k];
//                        [MBProgressHUD showError:[NSString stringWithFormat:@"【%@】内【%@】存在【%@】重复数据，请检查",model.label,re.label,strI] toView:self.view];
//
//                        return YES;
//                    }
//                }
//            }
//        }
//    }
//    return NO;
//}
/** 子表单是否有重复数据 */
- (BOOL)subformCkeckRepeatWithDataDict:(NSDictionary *)dataDict{
    
    BOOL have = NO;
    // 子表单数组
    NSArray *subforms = [self getSubformElement];
    
    for (TFCustomerRowsModel *model in subforms) {
        have = [self subformCkeckRepeatWithDataDict:dataDict model:model];
        if (have) {
            return have;
        }
    }
    return have;
}
/** 某个子表单是否有重复数据 */
- (BOOL)subformCkeckRepeatWithDataDict:(NSDictionary *)dataDict model:(TFCustomerRowsModel *)model{
        
        // 某个子表单需查重的组件
        NSMutableArray *repeats = [NSMutableArray array];
        if (model.subforms.count) {
            NSArray *subs = model.subforms[0];
            for (TFCustomerRowsModel *subModel in subs) {
                
                if ([subModel.field.repeatCheck isEqualToString:@"2"]) {
                    [repeats addObject:subModel];
                }
            }
        }
        // 某个子表单组件提交的数值数组
        NSArray *datas = [dataDict valueForKey:model.name];
        if (![datas isKindOfClass:[NSArray class]]) {
            return NO;
        }
        if (datas.count <= 1) {// 一个栏目就没什么可重复的了
            return NO;
        }
        
        // 取出需要查重组件的值
        NSMutableArray *repeatVales = [NSMutableArray array];
        for (TFCustomerRowsModel *repEle in repeats) {
            NSMutableArray *values = [NSMutableArray array];
            for (NSDictionary *dict in datas) {
                [values addObject:[dict valueForKey:repEle.name]];
            }
            [repeatVales addObject:values];
        }
        
        // 比较查重组件是否有相同的值
        for (NSInteger k = 0; k < repeatVales.count; k ++) {
            NSArray *arr = repeatVales[k];
            for (NSInteger i = 0; i < arr.count-1; i ++) {
                NSString *strI = [arr[i] description];
                for (NSInteger j = i + 1; j < arr.count; j ++) {
                    NSString *strJ = [arr[j] description];
                    if (![strI isEqualToString:@""] &&
                        ![strJ isEqualToString:@""] &&
                        [strI isEqualToString:strJ]) {// 有相同的
                        
                        TFCustomerRowsModel *re = repeats[k];
                        [MBProgressHUD showError:[NSString stringWithFormat:@"【%@】内【%@】存在【%@】重复数据，请检查",model.label,re.label,strI] toView:self.view];
                        
                        return YES;
                    }
                }
            }
        }
    return NO;
}

/** 获取子表单组件 */
- (NSArray *)getSubformElement{
    
    NSMutableArray *subforms = [NSMutableArray array];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.name isEqualToString:@"systemInfo"]) {// 基本信息
            
            for (TFCustomerRowsModel *model in layout.rows) {
                
                if ([model.type isEqualToString:@"subform"]) {
                    
                    [subforms addObject:model];
                }
            }
        }
    }
    
    return subforms;
}

- (void)sure{
    
    [self.view endEditing:YES];
    // 1 校验
    // 1.1 必填校验
    if (![self requiredSure]) {
        return;
    }
    // 1.2 格式校验
    if (![self formatSure]) {
        return;
    }
    
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    // 2 获取布局表单数据
    NSMutableDictionary *dict = [self dictData];
    
    // 2.0 子表单查重
    if ([self subformCkeckRepeatWithDataDict:dict]) {
        return;
    }
    
    self.saveDict = [NSDictionary dictionaryWithDictionary:dict];
    
    // 2.1 拼装
    [dataDict setObject:self.bean forKey:@"bean"];
    
    if (self.type == 7) {// 撤销编辑
        [dict setObject:@1 forKey:@"data_type"];
    }
    [dataDict setObject:dict forKey:@"data"];
    
    // 编辑
    if (self.type == 2 || self.type == 7) {
        [dataDict setObject:self.dataId forKey:@"id"];
    }
    
    // 提交新增字段layout_data--20181206
    NSMutableDictionary *layout = [NSMutableDictionary dictionary];
    if ([self.customDict valueForKey:@"layout"]) {
        [layout setObject:[self.customDict valueForKey:@"layout"] forKey:@"layout"];
    }
    if (self.moduleId) {
        [layout setObject:self.moduleId forKey:@"moduleId"];
    }
    if (self.customModel.title) {
        [layout setObject:self.customModel.title forKey:@"title"];
    }
//    if (self.type == 7) {
        if (self.customModel.processId) {
            [layout setObject:self.customModel.processId forKey:@"processId"];
        }
//    }
    [dataDict setObject:layout forKey:@"layout_data"];
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // 添加2019/07/31添加审批判断
    if (!IsStrEmpty(self.customModel.processId)) {
        
        NSMutableDictionary *ddoo = [NSMutableDictionary dictionaryWithDictionary:dict];
        [ddoo setObject:self.bean forKey:@"bean"];
        
        [[TFRequest sharedManager] requestPOST:[self.customBL urlFromCmd:HQCMD_checkApprovalTime] body:ddoo progress:nil success:^(NSDictionary  *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // 3 提交数据
            self.navigationItem.rightBarButtonItem.enabled = NO;
            if (self.type == 2 || self.type == 7) {
                // 编辑将老数据提交（20181229添加）
                [dataDict setObject:self.detailDict forKey:@"oldData"];
                
                [self.customBL requsetCustomEditWithDictData:dataDict];
            }else if (self.type == 0 || self.type == 3) {
                [self.customBL requsetCustomSaveWithDictData:dataDict];
            }
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:error.debugDescription toView:self.view];
        }];
        
        
    }else{
        
        // 3 提交数据
        self.navigationItem.rightBarButtonItem.enabled = NO;
        if (self.type == 2 || self.type == 7) {
            // 编辑将老数据提交（20181229添加）
            [dataDict setObject:self.detailDict forKey:@"oldData"];
            
            [self.customBL requsetCustomEditWithDictData:dataDict];
        }else if (self.type == 0 || self.type == 3) {
            [self.customBL requsetCustomSaveWithDictData:dataDict];
        }
    }
    
    
    
}

-(void)setTableViewHeight:(CGFloat)tableViewHeight{
    _tableViewHeight = tableViewHeight;
    self.tableView.height = tableViewHeight;
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableViewHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    tableView.backgroundColor = BackGroudColor;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.layouts.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    TFCustomerLayoutModel *model = self.layouts[section];
    
    if ([model.isSpread isEqualToString:@"0"]) {
        
        return model.rows.count;
    }else{
        
        return 0;
    }
    
}

/** 详情隐藏必填 */
- (NSString *)detailHiddenRequireWithField:(TFCustomerFieldModel *)field{
    
    NSString *control = field.fieldControl;
    if (self.type == 1) {// 详情
        if ([field.fieldControl isEqualToString:@"2"]) {
            control = @"0";
        }
    }
    return control;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerLayoutModel *layout = self.layouts[indexPath.section];
    TFCustomerRowsModel *model = layout.rows[indexPath.row];
    TFCustomerFieldModel *field = model.field;
    
    if ([model.type isEqualToString:@"text"]) {// 单行文本
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.leftImage = nil;
        cell.tipImage = nil;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
                cell.rightImage = nil;
            }else{
                cell.edit = YES;
                if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                    cell.rightImage = @"custom查重";
                }else{
                    cell.rightImage = nil;
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            cell.rightImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
        
    }else if ([model.type isEqualToString:@"area"]){// area
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [self.areaManager regionWithRegionData:TEXT(model.fieldValue)];
        cell.placeholder = field.pointOut;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.edit = NO;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.rightImage = nil;
            }else{
                if (model.fieldValue.length) {
                    cell.rightImage = @"清除";
                }else{
                    cell.rightImage = @"下一级浅灰";
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.placeholder = @"";
            cell.rightImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"location"]) {// 定位
        
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.leftImage = nil;
        cell.tipImage = nil;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
                cell.rightImage = nil;
            }else{
                cell.edit = YES;
                cell.rightImage = @"custom定位";
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                cell.rightImage = @"custom定位";
            }else{
                cell.rightImage = nil;
            }
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
        
    }else if ([model.type isEqualToString:@"textarea"]){// 多行文本
        
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
            }else{
                cell.edit = YES;
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
        
    }else if ([model.type isEqualToString:@"multitext"]){// 富文本组件
        

        TFCustomAttributeTextCell *cell = [TFCustomAttributeTextCell customAttributeTextCellWithTableView:tableView type:self.type index:indexPath.section * 0x11 + indexPath.row];
        cell.model = model;
        cell.delegate = self;
        cell.tag = 0x777 *indexPath.section + indexPath.row;
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        [cell reloadDetailContentWithContent:model.fieldValue];
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"number"]){// 数字


        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [HQHelper changeNumberFormat:model.fieldValue bit:model.field.numberDelimiter];
        cell.placeholder = field.pointOut;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        if ([model.field.numberType isEqualToString:@"1"]) {// 整数
            cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            cell.textView.keyboardType = UIKeyboardTypeDecimalPad;
        }
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
            }else{
                cell.edit = YES;
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            cell.showEdit = NO;
        }
        if ([model.field.numberType isEqualToString:@"2"]) {// 百分比
            if (self.type != 1) {// 防止复用，用一张图片代替
                cell.rightImage = @"custom百分号";
            }
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"phone"]){// 电话
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeNumberPad;
        cell.leftImage = nil;
        if (self.type != 1) {// 非详情
            cell.tipImage = nil;
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
                cell.rightImage = nil;
            }else{
                cell.edit = YES;
                if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                    cell.rightImage = @"custom查重";
                }else{
                    cell.rightImage = nil;
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            if (IsStrEmpty(model.fieldValue)) {
                cell.rightImage = nil;
            }else{
                cell.rightImage = @"customD电话";
            }
            cell.tipImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
        
    }else if ([model.type isEqualToString:@"email"]){// 邮箱
        

        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        if (self.type != 1) {// 非详情
            cell.tipImage = nil;
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
                cell.rightImage = nil;
            }else{
                cell.edit = YES;
                if (field.repeatCheck && ![field.repeatCheck isEqualToString:@"0"]) {
                    cell.rightImage = @"custom查重";
                }else{
                    cell.rightImage = nil;
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            cell.rightImage = nil;
            if (IsStrEmpty(model.fieldValue)) {
                cell.rightImage = nil;
            }else{
                cell.rightImage = @"customD邮件";
            }
            cell.tipImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
        
    }else if ([model.type isEqualToString:@"attachment"]){// 附件
        
        TFCustomAttachmentsCell *cell = [TFCustomAttachmentsCell CustomAttachmentsCellWithTableView:tableView];
        cell.tag = 0x777 *indexPath.section + indexPath.row;
        cell.model = model;
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        if (self.type != 1) {
            cell.type = AttachmentsCellEdit;
            cell.showEdit = YES;
        }else{
            cell.type = AttachmentsCellDetail;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"resumeanalysis"]){// 简历解析
        
        TFCustomAttachmentsCell *cell = [TFCustomAttachmentsCell CustomAttachmentsCellWithTableView:tableView];
        cell.tag = 0x777 *indexPath.section + indexPath.row;
        cell.model = model;
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        if (self.type != 1) {
            cell.type = AttachmentsCellEdit;
            cell.showEdit = YES;
        }else{
            cell.type = AttachmentsCellDetail;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"picture"]){// 图片
        
        TFCustomImageCell *cell = [TFCustomImageCell CustomImageCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        [cell refreshCustomImageCellWithModel:model withType:self.type==1?0:1 withColumn:6];
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"datetime"]){// 时间/日期
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.rightImage = nil;
            }else{
                if (model.fieldValue.length) {
                    cell.rightImage = @"清除";
                }else{
                    cell.rightImage = @"custom日期";
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.placeholder = @"";
            cell.rightImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"identifier"]){// 自动编号
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"serialnum"]){// 流水号组件
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"url"]){// 超链接
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeURL;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.edit = NO;
            }else{
                cell.edit = YES;
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.edit = NO;
            cell.placeholder = @"";
            cell.textView.textColor = GreenColor;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"reference"]){// 关联关系
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.leftBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.rightImage = nil;
            }else{
                if (model.fieldValue.length) {
                    cell.rightImage = @"清除";
                }else{
                    cell.rightImage = @"custom关联";
                }
                if ([model.field.allowScan isEqualToString:@"1"]) {// 开启关联扫一扫
                    if (model.subformName == nil) {// 主表显示在关联组件上，子表单的显示在子表单组件上
                        cell.leftImage = @"referScan";
                    }
                }
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.placeholder = @"";
            cell.rightImage = nil;
            cell.textView.textColor = GreenColor;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"functionformula"]){// 公式
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [HQHelper changeNumberFormat:model.fieldValue bit:model.field.numberDelimiter];
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"citeformula"]){// 引用公式
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [HQHelper changeNumberFormat:model.fieldValue bit:model.field.numberDelimiter];
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"formula"]){// 公式
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [HQHelper changeNumberFormat:model.fieldValue bit:model.field.numberDelimiter];
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        
        
        return cell;
        
    }else if ([model.type isEqualToString:@"seniorformula"]){// 公式
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = [HQHelper changeNumberFormat:model.fieldValue bit:model.field.numberDelimiter];
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.rightImage = nil;
        cell.edit = NO;
        cell.placeholder = @"";
        if (self.type != 1) {
            cell.showEdit = YES;
        }else{
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"picklist"]){// 下拉列表
        
        TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = field.fieldControl;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.model = model;
        if (self.type != 1) {
            cell.edit = YES;
            cell.showEdit = YES;
        }else{
            cell.edit = NO;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"multi"]){// 复选框
        
        TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = field.fieldControl;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.model = model;
        if (self.type != 1) {
            cell.edit = YES;
            cell.showEdit = YES;
        }else{
            cell.edit = NO;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
    }else if ([model.type isEqualToString:@"personnel"]){// 人员
        
        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeDefault;
        cell.leftImage = nil;
        cell.tipImage = nil;
        cell.edit = NO;
        if (self.type != 1) {// 非详情
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.rightImage = nil;
            }else{
                cell.rightImage = @"custom人员";
            }
            cell.showEdit = YES;
        }else{// 详情
            cell.placeholder = @"";
            cell.rightImage = nil;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"department"]){// 部门
        
        if (self.type != 1) {
            
            TFCustomDepartmentCell *cell = [TFCustomDepartmentCell customDepartmentCellWithTableView:tableView];
            cell.delegate = self;
            cell.edit = YES;
            cell.title = model.label;
            cell.placeholder = field.pointOut;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                cell.rightImage = @"";
            }else{
                cell.rightImage = @"custom部门";
            }
            cell.model = model;
            [cell refreshCustomDepartmentCellWithModel:model edit:YES];
            [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
            return cell;
            
        }else{// 详情
            TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
            cell.delegate = self;
            cell.model = model;
            cell.title = model.label;
            cell.content = model.fieldValue;
            cell.placeholder = field.pointOut;
            cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
            cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
            cell.fieldControl = [self detailHiddenRequireWithField:field];
            cell.textView.keyboardType = UIKeyboardTypeDefault;
            cell.leftImage = nil;
            cell.tipImage = nil;
            cell.edit = NO;
            if (self.type != 1) {// 非详情
                if ([field.fieldControl isEqualToString:@"1"]) {// 只读
                    cell.rightImage = nil;
                }else{
                    cell.rightImage = @"custom部门";
                }
                cell.showEdit = YES;
            }else{// 详情
                cell.placeholder = @"";
                cell.rightImage = nil;
                cell.showEdit = NO;
            }
            [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
            return cell;
        }
        
    }else if ([model.type isEqualToString:@"subform"]){
        
        TFTCustomSubformHeaderCell *cell = [TFTCustomSubformHeaderCell customSubformHeaderCellWithTableView:tableView];
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.model = model;
        cell.delegate = self;
        if (self.type != 1) {// 非详情
            cell.showEdit = YES;
        }else{// 详情
            cell.showEdit = NO;
        }
        return cell;
        
    }else if ([model.type isEqualToString:@"mutlipicklist"]){// 多级下拉选项
        
        TFCustomSelectOptionCell *cell = [TFCustomSelectOptionCell customSelectOptionCellWithTableView:tableView];
        cell.delegate = self;
        cell.title = model.label;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.model = model;
        if (self.type != 1) {
            cell.edit = YES;
            cell.showEdit = YES;
        }else{
            cell.edit = NO;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
        
    }else if ([model.type isEqualToString:@"barcode"]){
        

        TFGeneralSingleCell *cell = [TFGeneralSingleCell generalSingleCellWithTableView:tableView];
        cell.delegate = self;
        cell.model = model;
        cell.title = model.label;
        cell.content = model.fieldValue;
        cell.placeholder = field.pointOut;
        cell.textView.tag = 0x777 *indexPath.section + indexPath.row;
        cell.rightBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.leftBtn.tag = 0x777 *indexPath.section + indexPath.row;
        cell.fieldControl = [self detailHiddenRequireWithField:field];
        cell.textView.keyboardType = UIKeyboardTypeEmailAddress;
        cell.tipImage = nil;
        if (self.type != 1) {// 非详情
            cell.leftImage = @"获取条码";
            cell.rightImage = @"启用扫一扫";
            cell.edit = YES;
            cell.showEdit = YES;
        }else{// 详情
            cell.placeholder = @"";
            cell.rightImage = @"查看条码";
            cell.leftImage = nil;
            cell.edit = NO;
            cell.showEdit = NO;
        }
        [self hiddenBottomLineForCell:cell indexPath:indexPath layout:layout];
        return cell;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    cell.textLabel.text = @"";
    return cell;
}

- (void)hiddenBottomLineForCell:(HQBaseCell *)cell indexPath:(NSIndexPath *)indexPath layout:(TFCustomerLayoutModel *)layout{
    
    if (indexPath.row  == layout.rows.count-1) {
        if ([layout.virValue isEqualToString:@"1"]) {
            cell.bottomLine.hidden = NO;
        }else{
            cell.bottomLine.hidden = YES;
        }
    }else{
        cell.bottomLine.hidden = NO;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    [self.view endEditing:YES];
    TFCustomerLayoutModel *layout = self.layouts[indexPath.section];
    TFCustomerRowsModel *model = layout.rows[indexPath.row];
    
    if (self.type == 1) {
        
        if ([model.name containsString:@"personnel"]) {
            
            BOOL jump = NO;
            if ([model.field.structure isEqualToString:@"0"]) {
                if (model.selects.count > 7) {
                    jump = YES;
                }
            }else{
                if (model.selects.count > 5) {
                    jump = YES;
                }
            }
            if (jump) {
                
                TFApprovalCopyerController *copyer = [[TFApprovalCopyerController alloc] init];
                copyer.naviTitle = model.label;
                copyer.employees = model.selects;
                copyer.actionParameter = ^(id parameter) {
                    
                    model.selects = parameter;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:copyer animated:YES];
                
            }
        }
        
        // 关联跳转
        if ([model.type isEqualToString:@"reference"]) {
            
            if (!model.relevanceField.fieldId || [model.relevanceField.fieldId isEqualToString:@""]) {
                return;
            }
            self.attachmentModel = model;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL requestHaveReadAuthWithModuleBean:model.relevanceModule.moduleName withDataId:@([model.relevanceField.fieldId longLongValue])];
            
        }
        
        // 超链接跳转
        if ([model.type isEqualToString:@"url"]) {
            
            if ([HQHelper checkUrl:TEXT(model.fieldValue)]) {
                
                if (!([model.fieldValue containsString:@"http"] || [model.fieldValue containsString:@"https"] || [model.fieldValue containsString:@"ftp"])) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://%@",model.fieldValue] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }else{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[model.fieldValue stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
                }
                
            }else{
                [MBProgressHUD showError:@"链接格式有误" toView:KeyWindow];
            }
        }
        
        if ([model.type isEqualToString:@"location"]) {
            
            if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                
                TFMapController *locationVc = [[TFMapController alloc] init];
                locationVc.type = LocationTypeLookLocation;
                locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
            
                [self.navigationController pushViewController:locationVc animated:YES];
            }else if (!IsStrEmpty(model.fieldValue)){
                [MBProgressHUD showError:@"没有经纬度无法查看位置" toView:KeyWindow];
            }
            
        }
        
        return;
    }
    
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    
    if ([model.type isEqualToString:@"multitext"]) {
        
        TFAttributeTextController *att = [[TFAttributeTextController alloc] init];
        att.fieldLabel = model.label;
        att.content = model.fieldValue;
        att.contentAction = ^(NSString *parameter) {
            
            model.fieldValue = parameter;
            TFCustomAttributeTextCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell reloadDetailContentWithContent:parameter];
            
            [self.tableView reloadData];
            
        };
        [self.navigationController pushViewController:att animated:YES];
    }
    
    if ([model.type isEqualToString:@"datetime"]) {
        
        [self dateTimeHandleWithModel:model];
        
    }
    
//    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"] || [model.type isEqualToString:@"mutlipicklist"]) {// 下拉or复选or多级下拉
//
//
//        // 选项
//        NSMutableArray *arr = [NSMutableArray array];
//        for (TFCustomerOptionModel *opt in model.entrys) {
//            [arr addObject:opt.label];
//        }
//        BOOL singleChoose = NO;
//        if ([model.field.chooseType isEqualToString:@"0"]) {// 单选
//            singleChoose = YES;
//        }else{// 多选
//            singleChoose = NO;
//        }
//        if ([model.type isEqualToString:@"mutlipicklist"]) {
//            singleChoose = YES;
//            [self handleMutilOptionsWithModel:model];// 处理二级下拉
//        }
//
//        TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
//        select.entrys = model.controlEntrys.count > 0 ? model.controlEntrys : model.entrys;
//        select.isSingleSelect = singleChoose;
//        select.backVc = self;
//        select.selectAction = ^(NSMutableArray * parameter) {
//
//            // 下拉控制及隐藏
//            [self picklistOptionControlAndHiddenWithModel:model parameter:parameter];
//
//            [self.tableView reloadData];
//
//        };
//        [self.navigationController pushViewController:select animated:YES];
//
//    }
    
    
    if ([model.type isEqualToString:@"personnel"]) {// 人员
        
        [self personnelHandleWithModel:model];
    }
    
    if ([model.type isEqualToString:@"department"]) {
        
        [self departmentHandleWithModel:model];
    }
    
    if ([model.type isEqualToString:@"area"]) {
        
        [self areaHandleWithModel:model];
    }
    
    if ([model.type isEqualToString:@"reference"]){// 关联关系
        // 选关联
        [self referenceHandleWithModel:model];
    }
    
    
}

/** 消除该pickList以下的pickList控制的组件 */
- (void)cancelPicklistUnderWithModel:(TFCustomerRowsModel *)model{
    
    // 1.获取所有下拉组件
//    NSArray *picklistRows = [self getPickListRows];
//    BOOL start = NO;
//    for (TFCustomerRowsModel *pickRow in picklistRows) {
//        
//        if ([pickRow.name isEqualToString:model.name]) {// 2.当前组件以下
//            start = YES;
//            continue;
//        }
//        if (start) {
//            // 3.该下拉也控制别的组件的时候，要消除隐藏，选项还原
//            if (pickRow.selects.count) {
//                TFCustomerOptionModel *option = pickRow.selects[0];
//                if (option.hidenFields.count) {
//                    [self restoreHiddenWithModel:pickRow];
//                    [self restoreOptionWithModel:pickRow];
//                    pickRow.fieldValue = nil;
//                    pickRow.selects = nil;
//                }
//            }
//            
//        }
//    }
    
    // 恢复该选项控制的
    BOOL last = NO;
    for (TFCustomerLayoutModel *layout in self.layouts) {
        if (last) {
            layout.optionHiddenName = nil;
            layout.isOptionHidden = @"0";
        }
        for (TFCustomerRowsModel *mo in layout.rows){
            if ([mo.name isEqualToString:model.name]) {// 2.当前下拉组件以下
                last = YES;
                continue;
            }
            if (last) {
                mo.field.isOptionHidden = nil;
                mo.field.optionHiddenName = nil;
            }
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TFCustomerLayoutModel *layout = self.layouts[indexPath.section];
    TFCustomerRowsModel *model = layout.rows[indexPath.row];
    TFCustomerFieldModel *field = model.field;
    
    // 1. 不显示某组
    if ([layout.terminalApp isEqualToString:@"0"]) {
        
        return 0;
    }
    
    // 新建or编辑不显示系统信息
    if (self.type != 1) {
        if ([layout.name isEqualToString:@"systemInfo"]) {
            return 0;
        }
    }
    
    if (self.type == 1) {// 详情时显示
        if ([layout.isHideInDetail isEqualToString:@"1"]) {
            return 0;
        }
    }else{// 新建or编辑
        if ([layout.isHideInCreate isEqualToString:@"1"]) {
            return 0;
        }
    }
    
    if ([field.terminalApp isEqualToString:@"0"]) {
        
        return 0;
    }
    
    // 3. 属性决定的不显示
    if (self.type == 0 || self.type == 3) {// 新增
        
        if ([field.addView isEqualToString:@"0"]) {
            
            return 0;
        }
        
    }
    
    if (self.type == 1) {// 详情
        
        if ([field.detailView isEqualToString:@"0"]) {
            
            return 0;
        }
        
    }
    if (self.type == 2 || self.type == 7) {// 编辑
        
        if ([field.editView isEqualToString:@"0"]) {
            
            return 0;
        }
    }
    
#pragma mark - 选项字段控制隐藏
    if ([field.isOptionHidden isEqualToString:@"1"]) {
        
        return 0;
    }
    
//    if ([model.type isEqualToString:@"formula"] || [model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"] || [model.type isEqualToString:@"seniorformula"]) {
//        if (self.type != 1) {
//            return 0;
//        }
//    }
    
    
     // 4.显示多高
     if ([model.type isEqualToString:@"text"] ||
     [model.type isEqualToString:@"area"] ||
     [model.type isEqualToString:@"phone"] ||
     [model.type isEqualToString:@"number"] ||
     [model.type isEqualToString:@"email"] ||
     [model.type isEqualToString:@"datetime"] ||
     [model.type isEqualToString:@"url"] ||
     [model.type isEqualToString:@"reference"] ||
     [model.type isEqualToString:@"identifier"] ||
     [model.type isEqualToString:@"serialnum"] ||
     [model.type isEqualToString:@"formula"] ||
     [model.type isEqualToString:@"functionformula"] ||
     [model.type isEqualToString:@"citeformula"] ||
     [model.type isEqualToString:@"seniorformula"] ||
     [model.type isEqualToString:@"personnel"] ||
     [model.type isEqualToString:@"barcode"] ||
     [model.type isEqualToString:@"location"] ||
     [model.type isEqualToString:@"textarea"] ||
     [model.type isEqualToString:@"department"] ) {
     
     return [TFGeneralSingleCell refreshGeneralSingleCellHeightWithModel:model];
     }
     
     if ([model.type isEqualToString:@"picklist"] ||
     [model.type isEqualToString:@"mutlipicklist"] ||
     [model.type isEqualToString:@"multi"]){
     return [TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:self.type!=1?YES:NO];
     }
    
     if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"]) {
     return [TFCustomAttachmentsCell refreshCustomAttachmentsCellHeightWithModel:model type:self.type == 1?AttachmentsCellDetail:AttachmentsCellEdit];
     }
     if ([model.type isEqualToString:@"subform"]) {
     return [TFTCustomSubformHeaderCell refreshCustomSubformHeaderCellHeightWithModel:model];
     }
     if ([model.type isEqualToString:@"picture"]) {
     return [TFCustomImageCell refreshCustomImageHeightWithModel:model withType:self.type != 1 ? 1 :0 withColumn:6];
     }
     if ([model.type isEqualToString:@"multitext"]) {
     CGFloat height = [model.height floatValue];
     HQLog(@"multitext--height:%f",height);
     return [model.height floatValue]<150?150:[model.height floatValue];
     }
    
    // 剩余组件
    return 75;
}
/** 计算cell高度 */
-(void)caculateCellHeightWithModel:(TFCustomerRowsModel *)model{

    if ([model.type isEqualToString:@"text"] ||
        [model.type isEqualToString:@"area"] ||
        [model.type isEqualToString:@"phone"] ||
        [model.type isEqualToString:@"number"] ||
        [model.type isEqualToString:@"email"] ||
        [model.type isEqualToString:@"datetime"] ||
        [model.type isEqualToString:@"url"] ||
        [model.type isEqualToString:@"reference"] ||
        [model.type isEqualToString:@"identifier"] ||
        [model.type isEqualToString:@"serialnum"] ||
        [model.type isEqualToString:@"formula"] ||
        [model.type isEqualToString:@"functionformula"] ||
        [model.type isEqualToString:@"citeformula"] ||
        [model.type isEqualToString:@"seniorformula"] ||
        [model.type isEqualToString:@"personnel"] ||
        [model.type isEqualToString:@"barcode"] ||
        [model.type isEqualToString:@"location"] ||
        [model.type isEqualToString:@"textarea"] ||
        [model.type isEqualToString:@"department"] ) {
        
        model.height = @([TFGeneralSingleCell refreshGeneralSingleCellHeightWithModel:model]);
    }
    
    if ([model.type isEqualToString:@"picklist"] ||
        [model.type isEqualToString:@"mutlipicklist"] ||
        [model.type isEqualToString:@"multi"]){
        model.height = @([TFCustomSelectOptionCell refreshCustomSelectOptionCellHeightWithModel:model showEdit:self.type!=1?YES:NO]);
    }
    
    if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"]) {
        model.height = @([TFCustomAttachmentsCell refreshCustomAttachmentsCellHeightWithModel:model type:self.type == 1?AttachmentsCellDetail:AttachmentsCellEdit]);
    }
    if ([model.type isEqualToString:@"subform"]) {
        model.height = @([TFTCustomSubformHeaderCell refreshCustomSubformHeaderCellHeightWithModel:model]);
    }
    if ([model.type isEqualToString:@"picture"]) {
        model.height = @([TFCustomImageCell refreshCustomImageHeightWithModel:model withType:self.type != 1 ? 1 :0 withColumn:6]);
    }
}

/* 异步处理cell的高度 */
-(void)asyncHandleCellHeight{
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("yml.concurrent", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_semaphore_t lock = dispatch_semaphore_create(1);
    
    for (TFCustomerLayoutModel *loyout in self.layouts) {
        for (TFCustomerRowsModel *model in loyout.rows) {
            dispatch_group_async(group, concurrentQueue, ^{
                dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                [self caculateCellHeightWithModel:model];
                dispatch_semaphore_signal(lock);
            });
        }
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    // app权限
    if ([layout.terminalApp isEqualToString:@"0"]) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }
    if (self.type != 1) {
        // 新增or编辑才能隐藏分栏名称
        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
        
    }
    
    if ([layout.isSpread isEqualToString:@"1"]) {
        
        if ([layout.show isEqualToString:@"1"]) {
            return 48;
        }
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }
    
    // 新建or编辑不显示系统信息
    if (self.type != 1) {
        if ([layout.name isEqualToString:@"systemInfo"]) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }
    if (self.type == 1) {// 详情时显示
        if ([layout.isHideInDetail isEqualToString:@"1"]) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }else{// 新建or编辑
        if ([layout.isHideInCreate isEqualToString:@"1"]) {
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }
#pragma mark - 选项字段控制头部是否隐藏
    if ([layout.isOptionHidden isEqualToString:@"1"]) {
        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
            return 0.5;
        }
        return 0;
    }
    
    // 增加栏目
    if ([layout.virValue isEqualToString:@"2"]) {
        if (self.type != 1) {
            // 该组的头部为上组的尾巴（添加栏目受上面组的隐藏控制）
            if (section-1>=0) {
                TFCustomerLayoutModel *lastLa = self.layouts[section-1];
                if ([lastLa.isOptionHidden isEqualToString:@"1"]) {// 上组隐藏了，那么该头部也隐藏
                    
                    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                        return 0.5;
                    }
                    return 0;
                }
                // 该子表单组隐藏与否
                TFCustomerRowsModel *subformModel = [self getRowWithName:lastLa.fieldName];
                
                /** type 0:新增 1:详情 2：编辑 3：复制 7：重新编辑(含：发起人撤销、驳回到发起人)  */
                if (self.type == 0 || self.type == 3) {
                    if ([subformModel.field.addView isEqualToString:@"0"]) {
                        
                        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                            return 0.5;
                        }
                        return 0;
                    }
                }else{
                    if ([subformModel.field.editView isEqualToString:@"0"]) {
                        
                        if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                            return 0.5;
                        }
                        return 0;
                    }
                }
            }
            
            if ([layout.fieldControl isEqualToString:@"1"]) {// 该栏目只读
                if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                    return 0.5;
                }
                return 0;
            }
            return 40;
        }else{
            if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
                return 0.5;
            }
            return 0;
        }
    }
    // 分栏
    if ([layout.virValue isEqualToString:@"0"]) {
        return 48;
    }
    // 栏目几
    if ([layout.virValue isEqualToString:@"1"] && layout.rows != nil) {
        return 40;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return 0.5;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11.0) {
        return 0.5;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    // app权限
    if ([layout.terminalApp isEqualToString:@"0"]) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    // 新建or编辑不显示系统信息
    if (self.type != 1) {
        if ([layout.name isEqualToString:@"systemInfo"]) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
    }
    if (self.type == 1) {// 详情时显示
        if ([layout.isHideInDetail isEqualToString:@"1"]) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        
    }else{// 新建or编辑
        if ([layout.isHideInCreate isEqualToString:@"1"]) {
            
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            return view;
        }
        
    }
    
    
    if ([layout.virValue isEqualToString:@"0"]) {
        
        TFColumnView *view = [TFColumnView columnView];
        view.isSpread = layout.isSpread;
        view.tag = 0x4455 + section;
        view.delegate = self;
        view.titleLebel.text = layout.title;
        if (self.type != 1) {
            
            if ([layout.isHideColumnName isEqualToString:@"1"]) {
                view.titleLebel.hidden = YES;
            }else{
                view.titleLebel.hidden = NO;
            }
        }else{
            
            view.titleLebel.hidden = NO;
        }
        return view;
    }
    
    if ([layout.virValue isEqualToString:@"1"] && layout.rows != nil) {
        
        TFSubformSectionView *view = [TFSubformSectionView subformSectionView];
        view.tag = 0x888 + section;
        view.titleLabel.text = [NSString stringWithFormat:@"栏目%ld",(long)[layout.position integerValue]];
        view.delegate = self;
        view.isEdit = self.type != 1 ? ([layout.fieldControl isEqualToString:@"1"] ? NO : YES) : NO;
        return view;
        
    }
    
    if ([layout.virValue isEqualToString:@"2"]) {
        
        TFSubformAddView *view = [TFSubformAddView subformAddView];
        view.tag = 0x999 + section;
        view.delegate = self;
        return view;
        
//        UIView *view = [[UIView alloc] init];
//        view.backgroundColor = [UIColor clearColor];
//        return view;
        
    }
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 省市区选择
- (void)areaHandleWithModel:(TFCustomerRowsModel *)model{
    
    if ([model.field.areaType isEqualToString:@"0"] || [model.field.areaType isEqualToString:@"1"]) {
        
        if ([model.field.areaType isEqualToString:@"0"]){// 省市区
            [self.addressView showViewWithComponents:3 selectRows:model.fieldValue.length > 0 ? [model.fieldValue componentsSeparatedByString:@","] : [model.field.defaultValue componentsSeparatedByString:@","]];
        }else if ([model.field.areaType isEqualToString:@"1"]){// 省市
            [self.addressView showViewWithComponents:2 selectRows:model.fieldValue.length > 0 ? [model.fieldValue componentsSeparatedByString:@","] : [model.field.defaultValue componentsSeparatedByString:@","]];
        }
        __weak TFAddCustomController *this = self;
        self.addressView.sureAddressBlock = ^(id result) {
            
            if (!model.otherDict) {
                model.otherDict = [NSMutableDictionary dictionary];
                
            }
            
            [model.otherDict setObject:result[@"name"] forKey:@"address"];
            [model.otherDict setObject:result[@"id"] forKey:@"addressId"];
            [model.otherDict setObject:result[@"data"] forKey:@"addressData"];
            
            model.fieldValue = result[@"data"];
            
            [this.tableView reloadData];
            [this.addressView cancelView];
            // 联动
            [this generalSingleCellWithModel:model];
            
        };
        
    }else if ([model.field.areaType isEqualToString:@"2"]){// 省
        
        if (self.areaManager.provinceDicts == nil) {
            NSMutableArray *provices = [NSMutableArray array];
            for (NSDictionary *dict in self.areaManager.provinceArr) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [provices addObject:dict];
                }
            }
            self.areaManager.provinceDicts = provices;
        }
        TFProviceCityDistrictSelectController *vc = [[TFProviceCityDistrictSelectController alloc] init];
        vc.datas = self.areaManager.provinceDicts;
        vc.isSingle = [model.field.chooseType isEqualToString:@"0"] ? YES : NO;
        vc.selectDatas = model.selects;
        vc.selectBlock = ^(NSArray *arr) {
            model.selects = [NSMutableArray arrayWithArray:arr];
            NSString *str = @"";
            for (NSDictionary *dict in arr) {
                NSString *idStr = [dict valueForKey:@"id"];
                NSString *nameStr = [dict valueForKey:@"name"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",idStr,nameStr]];
            }
            if (str.length > 0) {
                str = [str substringToIndex:str.length-1];
            }
            model.fieldValue = str;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.field.areaType isEqualToString:@"3"]){// 市
        
        if (self.areaManager.cityDicts == nil) {
            NSMutableArray *citys = [NSMutableArray array];
            for (NSArray *proArr in self.areaManager.cityArr) {
                if ([proArr isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dict in proArr) {
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            [citys addObject:dict];
                        }
                    }
                }
            }
            self.areaManager.cityDicts = citys;
        }
        TFProviceCityDistrictSelectController *vc = [[TFProviceCityDistrictSelectController alloc] init];
        vc.datas = self.areaManager.cityDicts;
        vc.isSingle = [model.field.chooseType isEqualToString:@"0"] ? YES : NO;
        vc.selectDatas = model.selects;
        vc.selectBlock = ^(NSArray *arr) {
            model.selects = [NSMutableArray arrayWithArray:arr];
            NSString *str = @"";
            for (NSDictionary *dict in arr) {
                NSString *idStr = [dict valueForKey:@"id"];
                NSString *nameStr = [dict valueForKey:@"name"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",idStr,nameStr]];
            }
            if (str.length > 0) {
                str = [str substringToIndex:str.length-1];
            }
            model.fieldValue = str;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.field.areaType isEqualToString:@"4"]){// 区
        
        if (self.areaManager.areaDicts == nil) {
            NSMutableArray *districts = [NSMutableArray array];
            for (NSArray *proArr in self.areaManager.areaArr) {
                if ([proArr isKindOfClass:[NSArray class]]) {
                    for (NSArray *cityArr in proArr) {
                        if ([cityArr isKindOfClass:[NSArray class]]) {
                            for (NSDictionary *dict in cityArr) {
                                if ([dict isKindOfClass:[NSDictionary class]]) {
                                    [districts addObject:dict];
                                }
                            }
                        }
                    }
                }
            }
            self.areaManager.areaDicts = districts;
        }
        TFProviceCityDistrictSelectController *vc = [[TFProviceCityDistrictSelectController alloc] init];
        vc.datas = self.areaManager.areaDicts;
        vc.isSingle = [model.field.chooseType isEqualToString:@"0"] ? YES : NO;
        vc.selectDatas = model.selects;
        vc.selectBlock = ^(NSArray *arr) {
            model.selects = [NSMutableArray arrayWithArray:arr];
            NSString *str = @"";
            for (NSDictionary *dict in arr) {
                NSString *idStr = [dict valueForKey:@"id"];
                NSString *nameStr = [dict valueForKey:@"name"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@:%@,",idStr,nameStr]];
            }
            if (str.length > 0) {
                str = [str substringToIndex:str.length-1];
            }
            model.fieldValue = str;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}


#pragma mark - 部门选择
-(void)departmentHandleWithModel:(TFCustomerRowsModel *)model{
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不可编辑" toView:KeyWindow];
        return;
    }
    
    BOOL isSingle ;
    if (!model.field.chooseType || [model.field.chooseType isEqualToString:@"0"]) {// 单选
        isSingle = YES;
    }else{// 多选
        isSingle = NO;
    }
    
    
    TFContactsDepartmentController *scheduleVC = [[TFContactsDepartmentController alloc] init];
    scheduleVC.isSingleUse = YES;
    scheduleVC.type = 1;
    scheduleVC.isSingleSelect = isSingle;
    scheduleVC.tableViewHeight = self.tableViewHeight;
    scheduleVC.defaultDepartments = model.selects;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSString *str = @"";
        for (TFDepartmentModel *em in parameter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",em.name]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }
        
        model.fieldValue = str;
        model.selects = [NSMutableArray arrayWithArray:parameter];
        [self.tableView reloadData];
        
        // 联动
        [self generalSingleCellWithModel:model];
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

#pragma mark - 人员选择
-(void)personnelHandleWithModel:(TFCustomerRowsModel *)model{
    
    if (self.employ) {
        [MBProgressHUD showError:@"不可编辑" toView:KeyWindow];
        return;
    }
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"不可编辑" toView:KeyWindow];
        return;
    }
    
    BOOL isSingle ;
    if (!model.field.chooseType || [model.field.chooseType isEqualToString:@"0"]) {// 单选
        isSingle = YES;
    }else{// 多选
        isSingle = NO;
    }
    
    NSMutableArray *arrss = [NSMutableArray array];
    for (TFEmployModel *ee in model.field.choosePersonnel) {
        
        HQEmployModel *eeee = [TFChangeHelper tfEmployeeToHqEmployee:ee];
        
        if (eeee) {
            [arrss addObject:eeee];
        }
    }
    
    if (arrss.count) {// 审批人人员范围
        
        TFSelectChatPeopleController *select = [[TFSelectChatPeopleController alloc] init];
        select.type = 1;
        select.isSingle = isSingle;
        select.peoples = model.selects;
        select.dataPeoples = arrss;
        select.actionParameter = ^(NSArray *parameter) {
            
            model.fieldValue = [self handlePeopleTooLongWithPeople:parameter model:model];
            model.selects = [NSMutableArray arrayWithArray:parameter];
            [self.tableView reloadData];
            // 联动
            [self generalSingleCellWithModel:model];
        };
        
        [self.navigationController pushViewController:select animated:YES];
        
    } else if (model.field.chooseRange.count){// 选择人员范围
        
        TFCustomRangePeopleController *frameWork = [[TFCustomRangePeopleController alloc] init];
        
        frameWork.isSingleSelect = isSingle;
        frameWork.peoples = model.selects;
        frameWork.rangePeople = model.field.chooseRange;
        frameWork.actionParameter = ^(NSArray *parameter) {
            
            model.fieldValue = [self handlePeopleTooLongWithPeople:parameter model:model];
            model.selects = [NSMutableArray arrayWithArray:parameter];
            [self.tableView reloadData];
            // 联动
            [self generalSingleCellWithModel:model];
        };
        [self.navigationController pushViewController:frameWork animated:YES];
        
    }else{
        
        
        TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
        scheduleVC.selectType = 1;
        scheduleVC.isSingleSelect = isSingle;
        scheduleVC.defaultPoeples = model.selects;
        //            scheduleVC.noSelectPoeples = model.selects;
        scheduleVC.actionParameter = ^(NSArray *parameter) {
            
            model.fieldValue = [self handlePeopleTooLongWithPeople:parameter model:model];
            model.selects = [NSMutableArray arrayWithArray:parameter];
            [self.tableView reloadData];
            // 联动
            [self generalSingleCellWithModel:model];
            
        };
        [self.navigationController pushViewController:scheduleVC animated:YES];
        
    }
}
/** 处理人员过长问题 */
-(NSString *)handlePeopleTooLongWithPeople:(NSArray *)people model:(TFCustomerRowsModel *)model{
    NSString *str = @"";
    NSInteger index = 0;
    
    if ([model.field.structure isEqualToString:@"1"]) {// 左右结构
        index = 3;
        
    }else{// 上下结构
        index = 6;
    }
    for (NSInteger i = 0; i < (people.count > index ? index : people.count); i ++) {
        HQEmployModel *em = people[i];
        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",em.employee_name?:em.employeeName]];
    }
    if (str.length) {
        str = [str substringToIndex:str.length - 1];
    }
    if (people.count > index) {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"  等%ld人",people.count]];
    }
    
    return str;
}

#pragma mark - 日期选择
-(void)dateTimeHandleWithModel:(TFCustomerRowsModel *)model{
    DateViewType type = DateViewType_YearMonthDay;
    NSInteger index = 0;
    if ([model.field.formatType isEqualToString:@"yyyy-MM-dd"]) {
        type = DateViewType_YearMonthDay;
    }else if ([model.field.formatType isEqualToString:@"yyyy-MM"]) {
        type = DateViewType_YearMonth;
    }else if ([model.field.formatType isEqualToString:@"yyyy"]) {
        type = DateViewType_Year;
    }else if ([model.field.formatType isEqualToString:@"yyyy-MM-dd HH"]) {
        type = DateViewType_Hour;
        index = 1;
    }else if ([model.field.formatType isEqualToString:@"yyyy-MM-dd HH:mm"]) {
        type = DateViewType_HourMinute;
        index = 1;
    }else if ([model.field.formatType isEqualToString:@"yyyy-MM-dd HH:mm:ss"]) {
        type = DateViewType_HourMinuteSecond;
        index = 1;
    }else if ([model.field.formatType isEqualToString:@"HH:mm:ss"]) {
        type = DateViewType_HourMinuteSecond;
    }else if ([model.field.formatType isEqualToString:@"HH:mm"]) {
        type = DateViewType_HourMinute;
    }else if ([model.field.formatType isEqualToString:@"HH"]) {
        type = DateViewType_Hour;
    }
    
    if (index == 0) {
        
        long long timeSp = [HQHelper changeTimeToTimeSp:model.fieldValue formatStr:model.field.formatType];
        
        [TFSelectDateView selectDateViewWithType:type timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
            
            
            model.fieldValue = time;
            
            [self.tableView reloadData];
            // 联动
            [self generalSingleCellWithModel:model];
        }];
    }else{
        
        long long timeSp = [HQHelper changeTimeToTimeSp:model.fieldValue formatStr:model.field.formatType];
        
        [TFSelectCalendarView selectCalendarViewWithType:type timeSp:timeSp<=0?[HQHelper getNowTimeSp]:timeSp onRightTouched:^(NSString *time) {
            
            model.fieldValue = time;
            
            [self.tableView reloadData];
            // 联动
            [self generalSingleCellWithModel:model];
            
        }];
    }
}

#pragma mark - 关联组件选择
-(void)referenceHandleWithModel:(TFCustomerRowsModel *)model{
    
    TFReferenceSearchController *refrence = [[TFReferenceSearchController alloc] init];
    refrence.bean = self.bean;
    refrence.searchField = model.name;
    NSArray *arr = [self getReferenceRows];// 此处只能拿到子表单的键，值无法拿到
    if (!IsStrEmpty(model.subformName)) {// 去拿值
        TFCustomerRowsModel *ref = [self getRowWithName:model.subformName];
        if ([model.position integerValue]-1 < ref.subforms.count) {
            // 取出该栏目中的值
            NSArray *subItems = ref.subforms[[model.position integerValue]-1];
            NSMutableArray *dodo = [NSMutableArray array];
            for (TFCustomerRowsModel *dfg in subItems) {
                if ([dfg.type isEqualToString:@"reference"]) {
                    [dodo addObject:dfg];
                }
            }
            NSMutableArray *too = [NSMutableArray array];
            for (TFCustomerRowsModel *lll in arr) {
                BOOL con = NO;
                for (TFCustomerRowsModel *ppp in dodo) {
                    if ([ppp.name isEqualToString:lll.name]) {
                        con = YES;
                        [too addObject:ppp];
                        break;
                    }
                }
                if (!con) {
                    [too addObject:lll];
                }
            }
            arr = too;
        }
    }
    NSMutableDictionary *from = [NSMutableDictionary dictionary];
    NSMutableDictionary *reylonForm = [NSMutableDictionary dictionary];
    for (TFCustomerRowsModel *row in arr) {
        if ([row.name isEqualToString:model.name]) {// 选择的该关联的字段不带值
            [from setObject:@"" forKey:row.name];
        }
        [reylonForm setObject:TEXT(row.relevanceField.fieldId) forKey:row.name];
    }
    refrence.from = from;
    refrence.reylonForm = reylonForm;
    // 子表单中的关联关系
    if (model.subformName && ![model.subformName isEqualToString:@""]) {
        refrence.subform = model.subformName;
    }
    if (model.subformName) {
        if (model.relevanceField.fieldId) {
            refrence.isMulti = NO;
        }else{
            refrence.isMulti = YES;
        }
    }
    // 子表关联
    if (model.subformRelation) {
        refrence.isMulti = YES;
        refrence.subform = model.name;
        refrence.bean = self.bean;
        refrence.searchField = model.subformRelation.controlField;
        TFCustomerRowsModel *relation = [self getRowWithName:model.subformRelation.controlField];
        refrence.searchFieldId = [relation.relevanceField.fieldId integerValue];
        refrence.type = 1;
    }
    refrence.parameterAction = ^(id obj) {
        
        if ([obj isKindOfClass:[NSArray class]]) {// 选多个
            
            NSMutableArray *list = obj;// 转化为数据
            // 判断是否需要增加栏目，增加多少栏目
            // 将已有的赋值，剩下的增加栏目，若没有剩余就无需插入
            
            // 1.将该子表单所有栏目拿出来
            NSMutableArray *columns = [NSMutableArray array];
            for (TFCustomerLayoutModel *latt in self.layouts) {
                if (refrence.type == 1) {// 子表关联
                    if ([latt.fieldName isEqualToString:model.name] && [latt.virValue isEqualToString:@"1"]) {
                        [columns addObject:latt];
                    }
                }else{
                    if ([latt.fieldName isEqualToString:model.subformName] && [latt.virValue isEqualToString:@"1"]) {
                        [columns addObject:latt];
                    }
                }
            }
            // 2.找到当前选择的关联组件的序号，拿出它所在的栏目及后续栏目
            BOOL have = NO;
            NSMutableArray *haves = [NSMutableArray array];
            for (NSInteger index = 0; index < columns.count; index ++) {
                TFCustomerLayoutModel *latty = columns[index];
                if (!have) {// 去找
                    for (TFCustomerRowsModel *abc in latty.rows) {
                        if ([abc isEqual:model]) {// 找到了点击的关联组件
                            have = YES;
                            break;
                        }
                    }
                }
                if (have) {
                    [haves addObject:latty];
                }
            }
            // 3.将找到的栏目中的关联组件赋值，并记录是否有选会来的数据没有用上，没用上的用来产生新的栏目
            for (TFCustomerLayoutModel *kk in haves) {
                // 没有了就代表用完了，即选回来的数据少于需要赋值的栏目数
                if (list.count == 0) {
                    break;
                }
                // 有可能haves中的关联组件有值，有值则跳过; 没有值就赋值，并把已使用的数据从list中删除
                for (TFCustomerRowsModel *mnb in kk.rows) {
                    if ([mnb.name isEqualToString:model.name]) {// 找到关联关系组件
                        
                        if (mnb.relevanceField.fieldId) {//有值则跳过
                            break;
                        }
                        TFReferenceListModel *parameter = list.firstObject;
#pragma mark - 回填关联映射
                        // 回填关联映射
                        [self handleReferanceMapFieldWithDict:parameter.relationField currentModel:mnb];
                        
#pragma mark - 回填关联字段
                        for (TFFieldNameModel *f in parameter.row) {
                            
                            if ([f.name isEqualToString:mnb.relevanceField.fieldName]) {
                                
                                mnb.fieldValue = [HQHelper stringWithFieldNameModel:f];
                                mnb.relevanceField.value = [HQHelper stringWithFieldNameModel:f];
                                mnb.relevanceField.fieldId = [parameter.id.value description];
                                break;
                            }
                        }
                        // 联动
                        [self generalSingleCellWithModel:mnb];
                        // 删除该赋值的parameter
                        [list removeObject:parameter];
                        break;
                    }
                }
            }
            
            // 4.此处用来确定在哪个栏目下开始插入，及它的序号
            TFCustomerLayoutModel *layout = nil;
            NSInteger section = 0;
            for (NSInteger se = 0; se < self.layouts.count; se ++) {
                TFCustomerLayoutModel *lay = self.layouts[se];
                if (refrence.type == 0) {
                    if ([model.subformName isEqualToString:lay.fieldName]) {
                        layout = lay;
                        section = se;
                    }
                }else{// 子表关联
                    if ([model.name isEqualToString:lay.fieldName]) {
                        layout = lay;
                        section = se;
                    }
                }
            }
            TFCustomerRowsModel *sectionSubform = [self getRowWithName:layout.fieldName];
            
            // 5.将剩下的list生成栏目
            NSMutableArray *adds = [NSMutableArray array];
            for (NSInteger ii = 0; ii < list.count; ii ++) {
                TFReferenceListModel *parameter = list[ii];
                
                TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                sublay.virValue = @"1";
                sublay.isSpread = @"0";
                sublay.level = layout.level;
                sublay.fieldName = sectionSubform.name;
                sublay.position = @(sectionSubform.subforms.count + 1);
                sublay.name = sectionSubform.type;
                
                // 该分栏不显示大于组件不显示
                if ([layout.terminalApp isEqualToString:@"0"]) {
                    sublay.terminalApp = layout.terminalApp;
                }else{
                    sublay.terminalApp = sectionSubform.field.terminalApp;
                }
                sublay.isHideInCreate = layout.isHideInCreate;
                sublay.isHideInDetail = layout.isHideInDetail;
                sublay.isHideColumnName = @"0";
                
                NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                for (TFCustomerRowsModel *sub in sectionSubform.componentList) {
                    
                    TFCustomerRowsModel *copSub = [sub copy];
                    copSub.subformName = sectionSubform.name;
                    copSub.position = sublay.position;
                    if ([sectionSubform.field.fieldControl isEqualToString:@"1"]) {
                        copSub.field.fieldControl = sectionSubform.field.fieldControl;
                    }
                    [subforms addObject:copSub];
                }
                sublay.rows = subforms;
                if (sectionSubform.subforms) {
                    [sectionSubform.subforms addObject:subforms];
                }else{
                    sectionSubform.subforms = [NSMutableArray arrayWithObject:subforms];
                }
                // 新加栏目也要设置默认值
                for (TFCustomerRowsModel *mm in sublay.rows) {
                    [self handleDefaultWithModel:mm];
                }
                [adds addObject:sublay];
                
                // 选回来的值放入关联关系中
                for (TFCustomerRowsModel *copSub in sublay.rows) {
                    if (refrence.type == 0) {
                        if ([copSub.name isEqualToString:model.name]) {
                            // 回填关联映射
                            [self handleReferanceMapFieldWithDict:parameter.relationField currentModel:copSub];
                            
#pragma mark - 回填关联字段
                            for (TFFieldNameModel *f in parameter.row) {
                                
                                if ([f.name isEqualToString:copSub.relevanceField.fieldName]) {
                                    
                                    copSub.fieldValue = [HQHelper stringWithFieldNameModel:f];
                                    copSub.relevanceField.value = [HQHelper stringWithFieldNameModel:f];
                                    copSub.relevanceField.fieldId = [parameter.id.value description];
                                    break;
                                }
                            }
                            // 联动
                            [self generalSingleCellWithModel:copSub];
                            break;
                        }
                    }else{
                        [self customerRowsModel:copSub WithDict:parameter.relationField];
                    }
                }
                
            }
            // 6.插入到section的位置
            for (TFCustomerLayoutModel *ll in adds) {
                section ++;
                [self.layouts insertObject:ll atIndex:section];
            }
            [self.tableView reloadData];
            
            
        }
        else{
            TFReferenceListModel *parameter = obj;
#pragma mark - 回填关联映射
            // 回填关联映射
            [self handleReferanceMapFieldWithDict:parameter.relationField currentModel:model];
            
#pragma mark - 回填关联字段
            for (TFFieldNameModel *f in parameter.row) {
                
                if ([f.name isEqualToString:model.relevanceField.fieldName]) {
                    
                    model.fieldValue = [HQHelper stringWithFieldNameModel:f];
                    model.relevanceField.value = [HQHelper stringWithFieldNameModel:f];
                    model.relevanceField.fieldId = [parameter.id.value description];
                    break;
                }
            }
            
            // 假如它有依赖字段，那么依赖的字段值要被干掉（因为控制字段的值变化后，依赖字段的范围会发生变化）
            [self clearReferenceFieldWithModel:model];
            
            [self.tableView reloadData];
            
            // 联动
            [self generalSingleCellWithModel:model];
        }
    };
    
    [self.navigationController pushViewController:refrence animated:YES];
}

/** 将依赖字段的值清空  model:控制字段 */
-(void)clearReferenceFieldWithModel:(TFCustomerRowsModel *)model{
    
    NSArray *arr = [model.relyonFields componentsSeparatedByString:@","];
    if (!IsStrEmpty(model.subformName)) {// 子表单中的关联依赖
        // 只影响它所在的栏目
        TFCustomerRowsModel *subform = [self getRowWithName:model.subformName];
        // 找到所在栏目
        if ([model.position integerValue] -1 < subform.subforms.count) {
            NSArray *rows = subform.subforms[[model.position integerValue] -1];
            [self names:arr rows:rows];
        }
        
    }else{// 非子表单
        for (NSString *name in arr) {
            if ([name containsString:@"subform"]) {// 子表单中的字段
                NSArray *subforms = [self getSubformElement];
                for (TFCustomerRowsModel *subform in subforms) {
                    for (NSArray *subs in subform.subforms) {
                        for (TFCustomerRowsModel *sub in subs) {
                            if ([sub.name isEqualToString:name]) {
                                sub.fieldValue = @"";
                                sub.relevanceField.value = nil;
                                sub.relevanceField.fieldId = nil;
                                break;
                            }
                        }
                    }
                }
                
            }else{
                TFCustomerRowsModel *row = [self getRowWithName:name];
                row.fieldValue = @"";
                row.relevanceField.value = nil;
                row.relevanceField.fieldId = nil;
                [self clearReferenceFieldWithModel:row];
            }
        }
    }
}

/** 子表单某栏目进行清空  */
-(void)names:(NSArray *)names rows:(NSArray *)rows{
    for (NSString *name in names) {
        for (TFCustomerRowsModel *opq in rows) {
            if ([opq.name isEqualToString:name]) {
                opq.fieldValue = @"";
                opq.relevanceField.value = nil;
                opq.relevanceField.fieldId = nil;
                NSArray *arr = [opq.relyonFields componentsSeparatedByString:@","];
                [self names:arr rows:rows];
            }
        }
    }
}


#pragma mark - 处理关联映射的值
- (void)handleReferanceMapFieldWithDict:(NSDictionary *)dict currentModel:(TFCustomerRowsModel *)model{
    
    // 子表单中的关联组件只会映射当前子表单中的字段，且只映射该栏目的字段，其他栏目不受影响
    if (model.subformName) {// 子表单中的关联
        
        TFCustomerRowsModel *row = [self getRowWithName:model.subformName];
        if (row.subforms.count > ([model.position integerValue]-1)) {// 确保找对了子表单，有该栏目
            NSArray *rows = row.subforms[[model.position integerValue] - 1];
            for (TFCustomerRowsModel *subRow in rows) {
                if ([dict valueForKey:subRow.name]) {
                    [self customerRowsModel:subRow WithDict:dict];// 赋值
                }
            }
        }
    }else{
        
        // 获取所有的字段key
        NSArray *keys = [dict allKeys];
        for (NSString *key in keys) {
            TFCustomerRowsModel *row = [self getRowWithName:key];
            if (!row) continue;
            // 遇到子表单是插入栏目，并给栏目赋值
            if ([row.type isEqualToString:@"subform"]) {
                // 此处用来确定在哪个栏目下开始插入，及它的序号
                TFCustomerLayoutModel *layout = nil;
                NSInteger section = 0;
                for (NSInteger se = 0; se < self.layouts.count; se ++) {
                    TFCustomerLayoutModel *lay = self.layouts[se];
                    if ([row.name isEqualToString:lay.fieldName]) {
                        layout = lay;
                        section = se;
                    }
                }
                
                NSArray *list = [dict valueForKey:row.name];
                NSMutableArray *adds = [NSMutableArray array];
                for (NSInteger ii = 0; ii < list.count; ii++) {
                    
                    TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                    sublay.virValue = @"1";
                    sublay.isSpread = @"0";
                    sublay.level = layout.level;
                    sublay.fieldName = row.name;
                    sublay.position = @(row.subforms.count + 1);
                    sublay.name = row.type;
                    
                    // 该分栏不显示大于组件不显示
                    if ([layout.terminalApp isEqualToString:@"0"]) {
                        sublay.terminalApp = layout.terminalApp;
                    }else{
                        sublay.terminalApp = row.field.terminalApp;
                    }
                    sublay.isHideInCreate = layout.isHideInCreate;
                    sublay.isHideInDetail = layout.isHideInDetail;
                    sublay.isHideColumnName = @"0";
                    
                    NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                    for (TFCustomerRowsModel *sub in row.componentList) {
                        
                        TFCustomerRowsModel *copSub = [sub copy];
                        copSub.subformName = row.name;
                        copSub.position = sublay.position;
                        if ([row.field.fieldControl isEqualToString:@"1"]) {
                            copSub.field.fieldControl = row.field.fieldControl;
                        }
                        [subforms addObject:copSub];
                    }
                    sublay.rows = subforms;
                    if (row.subforms) {
                        [row.subforms addObject:subforms];
                    }else{
                        row.subforms = [NSMutableArray arrayWithObject:subforms];
                    }
                    
                    // 新加栏目也要设置默认值
                    for (TFCustomerRowsModel *mm in sublay.rows) {
                        [self handleDefaultWithModel:mm];
                    }
                    [adds addObject:sublay];
                    
                    // 把这组布局的赋值
                    for (TFCustomerRowsModel *pp in sublay.rows){
                        [self customerRowsModel:pp WithDict:list[ii]];
                    }
                    
                }
                
                // 插入到section的位置
                for (TFCustomerLayoutModel *ll in adds) {
                    section ++;
                    [self.layouts insertObject:ll atIndex:section];
                }
                
            }
            else{
                if ([dict valueForKey:row.name]) {
                    [self customerRowsModel:row WithDict:dict];// 赋值
                }
            }
        }
    }
}


#pragma mark - 下拉控制及隐藏
-(void)picklistOptionControlAndHiddenWithModel:(TFCustomerRowsModel *)model parameter:(NSMutableArray *)parameter{
    
    // 若该组件现在的选项隐藏了某组件，那么在改变选项之前，要将该选项隐藏的组件显示出来
    [self restoreHiddenWithModel:model];
    
    model.selects = parameter;
    
    NSString *string = @"";
    for (TFCustomerOptionModel *option in parameter) {
        
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@,",option.label]];
    }
    if (string.length > 0) {
        model.fieldValue = [string substringToIndex:string.length-1];
    }else{
        model.fieldValue = @"";
    }
    
    if (parameter.count) {
        TFCustomerOptionModel *option = parameter[0];
        
        
#pragma mark - 设置选项依赖的选项
        [self relevanceWithOption:option];
        
        if (option.hidenFields.count) {
            
            // 消除该组件下面的所有下拉控制
            [self cancelPicklistUnderWithModel:model];
        }
        
#pragma mark - 设置选项控制字段隐藏及显示
        // 当前下拉控制选项是否隐藏组件
        [self optionHiddenWithModel:model];
        
    }
    
}
#pragma mark - TFCustomDepartmentCellDelegate
-(void)customDepartmentCellChangeHeightWithModel:(TFCustomerRowsModel *)model{
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    });
}

#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 0x9876) {
        
        if (buttonIndex == 1) {
            
            TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
            TFEmailReceiveListModel *ee = [[TFEmailReceiveListModel alloc] init];
            ee.from_recipient = UM.userLoginInfo.employee.email;
            TFEmailPersonModel *em = [[TFEmailPersonModel alloc] init];
            em.mail_account = self.attachmentModel.fieldValue;
            ee.to_recipients = [NSMutableArray <TFEmailPersonModel,Optional>arrayWithObject:em];
            newEmail.detailModel = ee;
            [self.navigationController pushViewController:newEmail animated:YES];
        }
    }
}

#pragma mark - TFGeneralSingleCellDelegate
-(void)generalSingleCell:(TFGeneralSingleCell *)cell changedHeight:(CGFloat)height{
    if (cell.textView.isFirstResponder) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}
-(void)generalSingleCellDidClickedRightBtn:(UIButton *)rightBtn{
    
    NSInteger section = rightBtn.tag / 0x777;
    NSInteger row = rightBtn.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"text"] || [model.type isEqualToString:@"identifier"] || [model.type isEqualToString:@"serialnum"]) {// 单行文本
        
        TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
        search.keyLabel = model.label;
        search.bean = self.bean;
        search.keyWord = model.fieldValue;
        search.searchMatch = model.name;
        search.isSeasPool = self.isSeasPool;
        search.seaPoolId = self.seaPoolId;
        search.searchType = 1;
        search.dataId = self.dataId;
        search.processId = self.customModel.processId;
        search.parameterAction = ^(id parameter) {
            
            
        };
        [self.navigationController pushViewController:search animated:YES];
        
    }
    if ([model.type isEqualToString:@"phone"]) {// 电话
        
        if (self.type != 1) {
            
            TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
            search.keyLabel = model.label;
            search.bean = self.bean;
            search.keyWord = model.fieldValue;
            search.searchMatch = model.name;
            search.isSeasPool = self.isSeasPool;
            search.seaPoolId = self.seaPoolId;
            search.searchType = 1;
            search.dataId = self.dataId;
            search.processId = self.customModel.processId;
            search.parameterAction = ^(id parameter) {
                
                
            };
            [self.navigationController pushViewController:search animated:YES];
        }else{
            
            if ([model.secret isEqualToString:@"1"]) {// 保密字段
                [MBProgressHUD showError:@"保密数据不可操作" toView:self.view];
                return;
            }
            
            NSString *tele = [model.fieldValue stringByReplacingOccurrencesOfString:@" " withString:@""];
            tele = [tele stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            NSMutableString *str=[[NSMutableString alloc]initWithFormat:@"tel:%@",tele];
            
            UIWebView *callWebview = [[UIWebView alloc]init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
        }
        
    }
    
    if ([model.type isEqualToString:@"email"]) {// 邮件
        
        if (self.type != 1) {
            TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
            search.keyLabel = model.label;
            search.bean = self.bean;
            search.keyWord = model.fieldValue;
            search.searchMatch = model.name;
            search.isSeasPool = self.isSeasPool;
            search.seaPoolId = self.seaPoolId;
            search.searchType = 1;
            search.dataId = self.dataId;
            search.processId = self.customModel.processId;
            search.parameterAction = ^(id parameter) {
                
                
            };
            [self.navigationController pushViewController:search animated:YES];
        }else{
            
            if ([model.secret isEqualToString:@"1"]) {// 保密字段
                [MBProgressHUD showError:@"保密数据不可操作" toView:self.view];
                return;
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:model.fieldValue delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"发邮件", nil];
            alert.delegate = self;
            alert.tag = 0x9876;
            [alert show];
            self.attachmentModel = model;
            
//            TFEmailsNewController *newEmail = [[TFEmailsNewController alloc] init];
//            TFEmailReceiveListModel *ee = [[TFEmailReceiveListModel alloc] init];
//            ee.from_recipient = UM.userLoginInfo.employee.email;
//            TFEmailPersonModel *em = [[TFEmailPersonModel alloc] init];
//            em.mail_account = self.attachmentModel.fieldValue;
//            ee.to_recipients = [NSMutableArray <TFEmailPersonModel,Optional>arrayWithObject:em];
//            newEmail.detailModel = ee;
//            [self.navigationController pushViewController:newEmail animated:YES];
        }
        
    }
    if ([model.type isEqualToString:@"location"]) {// 定位
        
        if (self.type != 1) {
            
            TFMapController *locationVc = [[TFMapController alloc] init];
            locationVc.type = LocationTypeSearchLocation;
            locationVc.keyword = model.fieldValue;
            if (model.otherDict) {
                
                locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
            }
            locationVc.locationAction = ^(TFLocationModel *parameter){
                
                if (!model.otherDict) {
                    
                    model.otherDict = [NSMutableDictionary dictionary];
                }
                
                if (parameter.city) {
                    [model.otherDict setObject:parameter.city forKey:@"city"];
                }
                if (parameter.name) {
                    [model.otherDict setObject:parameter.name forKey:@"name"];
                }
                [model.otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
                [model.otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
                [model.otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
                
                model.fieldValue = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
                [self.tableView reloadData];
                
                // 联动
                [self generalSingleCellWithModel:model];
                
                
            };
            [self.navigationController pushViewController:locationVc animated:YES];
        }else{
            
            if ([model.secret isEqualToString:@"1"]) {// 保密字段
                [MBProgressHUD showError:@"保密数据不可操作" toView:self.view];
                return;
            }
            
            if (model.otherDict && [model.otherDict valueForKey:@"latitude"] && [model.otherDict valueForKey:@"longitude"]) {
                
                TFMapController *locationVc = [[TFMapController alloc] init];
                locationVc.type = LocationTypeLookLocation;
                locationVc.address = model.fieldValue;
                locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
                
                [self.navigationController pushViewController:locationVc animated:YES];
            }
        }
    }
    
    if ([model.type isEqualToString:@"datetime"]) {// 日期时间
        
        if (IsStrEmpty(model.fieldValue)) {// 选
            
            [self dateTimeHandleWithModel:model];
            
        }else{// 清除
            model.fieldValue = @"";
            [self.tableView reloadData];
        }
    }
    
    if ([model.type isEqualToString:@"area"]) {// 省市区
        
        if (IsStrEmpty(model.fieldValue)) {// 选
            
            [self areaHandleWithModel:model];
            
        }else{// 清除
            model.otherDict = nil;
            model.fieldValue = @"";
            [self.tableView reloadData];
        }
    }
    
    
    if ([model.type isEqualToString:@"reference"]) {// 关联关系
        
        
        if (IsStrEmpty(model.fieldValue)) {// 选
            
            [self referenceHandleWithModel:model];
            
        }else{// 清除
            model.fieldValue = nil;
            model.relevanceField.fieldId = nil;
            model.relevanceField.value = nil;
            
            // 清空依赖的值
            [self clearReferenceFieldWithModel:model];
            
            [self.tableView reloadData];
        }
    }

    if ([model.type isEqualToString:@"personnel"]) {
        
        [self personnelHandleWithModel:model];
        
        
    }
    
    if ([model.type isEqualToString:@"department"]) {
        
        [self departmentHandleWithModel:model];
        
    }
    
    if ([model.type isEqualToString:@"barcode"]) {
        self.attachmentModel = model;
        if (self.type != 1) {// 扫一扫
            
            TFScanCodeController *scan = [[TFScanCodeController alloc] init];
            scan.style = [StyleDIY weixinStyle];
            scan.isOpenInterestRect = YES;
            scan.libraryType = SLT_ZXing;
            scan.scanCodeType = SCT_QRCode;
            //镜头拉远拉近功能
            scan.isVideoZoom = YES;
            scan.isNeedScanImage = YES;
            scan.scanAction = ^(NSString *parameter) {
              
                model.fieldValue = parameter;
                [self.tableView reloadData];
                
                // 联动
                [self generalSingleCellWithModel:model];
                
            };
            
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
            [self presentViewController:navi animated:YES completion:nil];
            
        }else{// 查看条形码
            
            if (!IsStrEmpty(model.fieldValue)) {// 不为空
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL requestBarcodePictureWithBean:self.bean barcodeValue:model.fieldValue];
            }
        }
    }
    
}

-(void)generalSingleCellDidClickedLeftBtn:(UIButton *)leftBtn{
    
    NSInteger section = leftBtn.tag / 0x777;
    NSInteger row = leftBtn.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"barcode"]) {
        self.attachmentModel = model;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCreateBarcodeWithBarcodeType:model.field.codeStyle barcodeValue:model.fieldValue];
    }
    if ([model.type isEqualToString:@"reference"]) {// 关联扫一扫
        self.attachmentModel = model;
        
        TFScanCodeController *scan = [[TFScanCodeController alloc] init];
        scan.style = [StyleDIY weixinStyle];
        scan.isOpenInterestRect = YES;
        scan.libraryType = SLT_ZXing;
        scan.scanCodeType = SCT_QRCode;
        //镜头拉远拉近功能
        scan.isVideoZoom = YES;
        scan.isNeedScanImage = YES;
        scan.scanAction = ^(NSString *str) {
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            if (self.bean) {
                [dic setObject:self.bean forKey:@"bean"];
            }
            if (model.name) {
                [dic setObject:model.name forKey:@"searchField"];
            }
            NSArray *arr = [self getReferenceRows];// 此处只能拿到子表单的键，值无法拿到
            if (!IsStrEmpty(model.subformName)) {// 去拿值
                TFCustomerRowsModel *ref = [self getRowWithName:model.subformName];
                if ([model.position integerValue]-1 < ref.subforms.count) {
                    // 取出该栏目中的值
                    NSArray *subItems = ref.subforms[[model.position integerValue]-1];
                    NSMutableArray *dodo = [NSMutableArray array];
                    for (TFCustomerRowsModel *dfg in subItems) {
                        if ([dfg.type isEqualToString:@"reference"]) {
                            [dodo addObject:dfg];
                        }
                    }
                    NSMutableArray *too = [NSMutableArray array];
                    for (TFCustomerRowsModel *lll in arr) {
                        BOOL con = NO;
                        for (TFCustomerRowsModel *ppp in dodo) {
                            if ([ppp.name isEqualToString:lll.name]) {
                                con = YES;
                                [too addObject:ppp];
                                break;
                            }
                        }
                        if (!con) {
                            [too addObject:lll];
                        }
                    }
                    arr = too;
                }
            }
            NSMutableDictionary *from = [NSMutableDictionary dictionary];
            NSMutableDictionary *reylonForm = [NSMutableDictionary dictionary];
            for (TFCustomerRowsModel *row in arr) {
                if ([row.name isEqualToString:model.name]) {// 选择的该关联的字段不带值
                    [from setObject:@"" forKey:row.name];
                }
                [reylonForm setObject:TEXT(row.relevanceField.fieldId) forKey:row.name];
            }
            [from setObject:str forKey:@"barcode_value"];
            [dic setObject:from forKey:@"form"];
            
            [dic setObject:reylonForm forKey:@"reylonForm"];
            
            if (model.subformName && ![model.subformName isEqualToString:@""]) {
                [dic setObject:model.subformName forKey:@"subform"];
            }
            
            NSMutableDictionary *pageInfo = [NSMutableDictionary dictionary];
            [pageInfo setObject:@(10) forKey:@"pageSize"];
            [pageInfo setObject:@(1) forKey:@"pageNum"];
            [dic setObject:pageInfo forKey:@"pageInfo"];
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[TFRequest sharedManager] requestPOST:[self.customBL urlFromCmd:HQCMD_customRefernceSearch] body:dic progress:nil success:^(NSDictionary  *response) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *dataDic = response[kData];
                NSArray *arr = [dataDic valueForKey:@"dataList"];
                if (arr.count == 0) {
                    [MBProgressHUD showError:@"未找到数据" toView:self.view];
                }else{
                    NSDictionary *dict = arr.firstObject;
                    TFReferenceListModel *parameter = [[TFReferenceListModel alloc] initWithDictionary:dict error:nil];
                    parameter.relationField = [dict valueForKey:@"relationField"];
                    
        #pragma mark - 回填关联映射
                    // 回填关联映射
                    [self handleReferanceMapFieldWithDict:parameter.relationField currentModel:model];
        
        #pragma mark - 回填关联字段
                    for (TFFieldNameModel *f in parameter.row) {
        
                        if ([f.name isEqualToString:model.relevanceField.fieldName]) {
        
                            model.fieldValue = [HQHelper stringWithFieldNameModel:f];
                            model.relevanceField.value = [HQHelper stringWithFieldNameModel:f];
                            model.relevanceField.fieldId = [parameter.id.value description];
                            break;
                        }
                    }
        
                    // 假如它有依赖字段，那么依赖的字段值要被干掉（因为控制字段的值变化后，依赖字段的范围会发生变化）
                    [self clearReferenceFieldWithModel:model];
                    [self.tableView reloadData];
        
                    // 联动
                    [self generalSingleCellWithModel:model];
                    
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [MBProgressHUD showError:error.debugDescription toView:self.view];
            }];
            
        };
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
        [self presentViewController:navi animated:YES completion:nil];
        
    }
}

-(void)generalSingleCellWithModel:(TFCustomerRowsModel *)model{
    
    
    if ([model.linkage isEqualToString:@"1"]) {
        
        self.attachmentModel = model;
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (!IsStrEmpty(self.bean)) {
            [dict setObject:self.bean forKey:@"bean"];
        }
        
        // 取出需要联动的所有组件
        for (NSString *name in self.linkageConditions) {
            TFCustomerRowsModel *row = [self getRowWithName:name];
            if (row == nil) {
                continue;
            }
            [self linkageRow:row dict:dict];
        }
    
        // 加入该字段为子表单中的字段，需要子表单name和该字段的index
        if (!IsStrEmpty(model.subformName)) {
            [self linkageRow:model dict:dict];
            [dict setObject:model.subformName forKey:@"subform"];
            [dict setObject:@([model.position integerValue]-1) forKey:@"currentSubIndex"];
            
            TFCustomerRowsModel *subform = [self getRowWithName:model.subformName];
            NSArray *iii = subform.subforms[[model.position integerValue]-1];
            for (TFCustomerRowsModel *ll in iii) {
                if ([ll.linkage isEqualToString:@"1"]) {
                    [self linkageRow:ll dict:dict];
                }
            }
        }
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.customBL requestGetLinkageFieldListWithDict:dict];
    }
    
}

/** 联动获取某组件的值 */
-(void)linkageRow:(TFCustomerRowsModel *)row dict:(NSMutableDictionary *)dict{
    
    NSMutableDictionary *value = [NSMutableDictionary dictionary];
    [self getDataWithModel:row withDict:value];// model的值
    
    [dict setObject:[value valueForKey:row.name] forKey:row.name];
    
    if ([row.type isEqualToString:@"reference"]) {// 关联关系特殊处理
        
        if (row.relevanceField.fieldId) {
            [dict setObject:row.relevanceField.fieldId forKey:row.name];
        }else{
            [dict setObject:@"" forKey:row.name];
        }
    }
    if ([row.type isEqualToString:@"picklist"] || [row.type isEqualToString:@"multi"]) {// 下拉特殊处理
        NSMutableArray *oooarr = [NSMutableArray array];
        for (TFCustomerOptionModel *op in row.selects) {// 虽然只有单选才有联动，以防需求变化还是用循环全拼接（现在该处只有一个元素）
            NSMutableDictionary *opDic = [NSMutableDictionary dictionaryWithDictionary:[op toDictionary]];
            [opDic removeObjectForKey:@"subList"];
            if (opDic) {
                [oooarr addObject:opDic];
            }
        }
        [dict setObject:oooarr forKey:row.name];
        
    }
    if ([row.type isEqualToString:@"location"]) {// 定位特殊处理
        //            [dict setObject:model.otherDict forKey:@"value"];
        
        NSMutableDictionary *loca = [NSMutableDictionary dictionary];
        [loca setObject:row.fieldValue forKey:row.name];
        
        if (row.otherDict) {
            
            if ([row.otherDict valueForKey:@"longitude"]) {
                
                [loca setObject:[[row.otherDict valueForKey:@"longitude"] description] forKey:@"lng"];
            }
            if ([row.otherDict valueForKey:@"latitude"]) {
                
                [loca setObject:[[row.otherDict valueForKey:@"latitude"] description] forKey:@"lat"];
            }
            
            if ([row.otherDict valueForKey:@"area"]) {
                [loca setObject:[row.otherDict valueForKey:@"area"] forKey:@"area"];
            }
        }
        
        [dict setObject:loca forKey:row.name];
    }
}


- (NSMutableArray *)areaHandleWithAreas:(NSArray *)areas{
    NSMutableArray *arr = [NSMutableArray array];
    
    for (id obj in areas) {
        
        if ([obj isKindOfClass:[NSArray class]]) {
            [arr addObjectsFromArray:[self areaHandleWithAreas:obj]];
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [arr addObject:obj];
        }
    }
    
    return arr;
}
#pragma mark - TFTCustomSubformHeaderCellDelegate
-(void)customSubformHeaderCellClickedAddWithModel:(TFCustomerRowsModel *)model{
    [self referenceHandleWithModel:model];
}
-(void)customSubformHeaderCellClickedScanWithModel:(TFCustomerRowsModel *)subform{
    
    TFCustomerRowsModel *model = nil;
    for (TFCustomerRowsModel *row in subform.componentList) {
//        if ([row.type isEqualToString:@"reference"]) {
        if ([row.type isEqualToString:@"reference"] && [row.field.allowScan isEqualToString:@"1"]) {// 此处相当于点击了子表单中的关联组件
            model = [row copy];
            model.subformName = subform.name;
            model.position = subform.position;
//            if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                model.field.fieldControl = subform.field.fieldControl;
//            }
            break;
        }
    }
    if (model == nil) {
        return;
    }
    
    TFScanCodeController *scan = [[TFScanCodeController alloc] init];
    scan.style = [StyleDIY weixinStyle];
    scan.isOpenInterestRect = YES;
    scan.libraryType = SLT_ZXing;
    scan.scanCodeType = SCT_QRCode;
    //镜头拉远拉近功能
    scan.isVideoZoom = YES;
    scan.isNeedScanImage = YES;
    scan.scanAction = ^(NSString *str) {
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if (self.bean) {
            [dic setObject:self.bean forKey:@"bean"];
        }
        if (model.name) {
            [dic setObject:model.name forKey:@"searchField"];
        }
        NSArray *arr = [self getReferenceRows];// 此处只能拿到子表单的键，值无法拿到
        // 此处为插入，不需要值
        
        NSMutableDictionary *from = [NSMutableDictionary dictionary];
        NSMutableDictionary *reylonForm = [NSMutableDictionary dictionary];
        for (TFCustomerRowsModel *row in arr) {
            if ([row.name isEqualToString:model.name]) {// 选择的该关联的字段不带值
                [from setObject:@"" forKey:row.name];
            }
            [reylonForm setObject:TEXT(row.relevanceField.fieldId) forKey:row.name];
        }
        [from setObject:str forKey:@"barcode_value"];
        [dic setObject:from forKey:@"form"];
        
        [dic setObject:reylonForm forKey:@"reylonForm"];
        
        if (model.subformName && ![model.subformName isEqualToString:@""]) {
            [dic setObject:model.subformName forKey:@"subform"];
        }
        
        NSMutableDictionary *pageInfo = [NSMutableDictionary dictionary];
        [pageInfo setObject:@(10) forKey:@"pageSize"];
        [pageInfo setObject:@(1) forKey:@"pageNum"];
        [dic setObject:pageInfo forKey:@"pageInfo"];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[TFRequest sharedManager] requestPOST:[self.customBL urlFromCmd:HQCMD_customRefernceSearch] body:dic progress:nil success:^(NSDictionary  *response) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dataDic = response[kData];
            NSArray *arr = [dataDic valueForKey:@"dataList"];
            if (arr.count == 0) {
                [MBProgressHUD showError:@"未找到数据" toView:self.view];
            }else{
                NSDictionary *dict = arr.firstObject;
                TFReferenceListModel *parameter = [[TFReferenceListModel alloc] initWithDictionary:dict error:nil];
                parameter.relationField = [dict valueForKey:@"relationField"];
                
                if (parameter) {
                    // 插入一栏目，确定在哪个栏目下开始插入，及它的序号
                    TFCustomerLayoutModel *layout = nil;
                    NSInteger section = 0;
                    for (NSInteger se = 0; se < self.layouts.count; se ++) {
                        TFCustomerLayoutModel *lay = self.layouts[se];
                        if ([model.subformName isEqualToString:lay.fieldName]) {
                            layout = lay;
                            section = se;
                        }
                    }
                    
                    TFCustomerRowsModel *sectionSubform = [self getRowWithName:layout.fieldName];
                    
                    TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                    sublay.virValue = @"1";
                    sublay.isSpread = @"0";
                    sublay.level = layout.level;
                    sublay.fieldName = sectionSubform.name;
                    sublay.position = @(sectionSubform.subforms.count + 1);
                    sublay.name = sectionSubform.type;
                    
                    // 该分栏不显示大于组件不显示
                    if ([layout.terminalApp isEqualToString:@"0"]) {
                        sublay.terminalApp = layout.terminalApp;
                    }else{
                        sublay.terminalApp = sectionSubform.field.terminalApp;
                    }
                    sublay.isHideInCreate = layout.isHideInCreate;
                    sublay.isHideInDetail = layout.isHideInDetail;
                    sublay.isHideColumnName = @"0";
                    
                    NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                    for (TFCustomerRowsModel *sub in sectionSubform.componentList) {
                        
                        TFCustomerRowsModel *copSub = [sub copy];
                        copSub.subformName = sectionSubform.name;
                        copSub.position = sublay.position;
                        if ([sectionSubform.field.fieldControl isEqualToString:@"1"]) {
                            copSub.field.fieldControl = sectionSubform.field.fieldControl;
                        }
                        [subforms addObject:copSub];
                    }
                    sublay.rows = subforms;
                    if (sectionSubform.subforms) {
                        [sectionSubform.subforms addObject:subforms];
                    }else{
                        sectionSubform.subforms = [NSMutableArray arrayWithObject:subforms];
                    }
                    // 新加栏目也要设置默认值
                    for (TFCustomerRowsModel *mm in sublay.rows) {
                        [self handleDefaultWithModel:mm];
                    }
                    // 选回来的值放入关联关系中
                    for (TFCustomerRowsModel *copSub in sublay.rows) {
                        
                        if ([copSub.name isEqualToString:model.name]) {
                            // 回填关联映射
                            [self handleReferanceMapFieldWithDict:parameter.relationField currentModel:copSub];
                            
#pragma mark - 回填关联字段
                            for (TFFieldNameModel *f in parameter.row) {
                                
                                if ([f.name isEqualToString:copSub.relevanceField.fieldName]) {
                                    
                                    copSub.fieldValue = [HQHelper stringWithFieldNameModel:f];
                                    copSub.relevanceField.value = [HQHelper stringWithFieldNameModel:f];
                                    copSub.relevanceField.fieldId = [parameter.id.value description];
                                    break;
                                }
                            }
                            // 联动
                            [self generalSingleCellWithModel:copSub];
                            break;
                        }
                    }
                    section ++;
                    [self.layouts insertObject:sublay atIndex:section];
                    
                    [self.tableView reloadData];
                    
                }
            }
                
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showError:error.debugDescription toView:self.view];
        }];
        
    };
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:scan];
    [self presentViewController:navi animated:YES completion:nil];
    
}

#pragma mark - TFCustomSelectOptionCellDelegate
-(void)customOptionItemCellDidClickedOptions:(NSArray *)options isSingle:(BOOL)isSingle model:(TFCustomerRowsModel *)model level:(NSInteger)level{
    
    if (model.field.commonlyArea) {// 省、市、区
        
        NSMutableArray *province = nil;
        if ([model.field.commonlyArea isEqualToString:@"1"]) {
            if (self.areaManager.provinceDicts) {
                province = self.areaManager.provinceDicts;
            }else{
                province = [self areaHandleWithAreas:self.areaManager.provinceArr];
                self.areaManager.provinceDicts = province;
            }
        }else if ([model.field.commonlyArea isEqualToString:@"2"]) {
            if (self.areaManager.cityDicts) {
                province = self.areaManager.cityDicts;
            }else{
                province = [self areaHandleWithAreas:self.areaManager.cityArr];
                self.areaManager.cityDicts = province;
            }
        }else if ([model.field.commonlyArea isEqualToString:@"3"]) {
            if (self.areaManager.areaDicts) {
                province = self.areaManager.areaDicts;
            }else{
                province = [self areaHandleWithAreas:self.areaManager.areaArr];
                self.areaManager.areaDicts = province;
            }
        }
        
        NSMutableArray<TFCustomerOptionModel> *provs = [NSMutableArray<TFCustomerOptionModel> array];// 选项
        for (NSDictionary *dict in province) {
            TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
            op.label = [dict valueForKey:@"name"];
            op.value = [dict valueForKey:@"id"];
            [provs addObject:op];
        }
        
        for (TFCustomerOptionModel *oopp in model.selects) {
            for (TFCustomerOptionModel *oo in provs) {
                if ([[oopp.label description] isEqualToString:[oo.label description]]) {
                    oo.open = @1;
                    break;
                }
            }
        }
        
        self.level = level;
        self.attachmentModel = model;
        self.optionAlertView.isSingle = isSingle;
        [self.optionAlertView refreshCustomAlertViewWithData:provs];
        [self.optionAlertView showAnimation];
        
    }
    else{// 正常状态
        
        for (TFCustomerOptionModel *oopp in model.selects) {
            for (TFCustomerOptionModel *oo in options) {
                if ([[oopp.label description] isEqualToString:[oo.label description]]) {
                    oo.open = @1;
                    break;
                }
            }
        }
        self.level = level;
        self.attachmentModel = model;
//        self.optionAlertView.isSingle = isSingle;
//        [self.optionAlertView refreshCustomAlertViewWithData:options];
//        [self.optionAlertView showAnimation];
        
//        TFCustomSelectOptionController *optionVc = [[TFCustomSelectOptionController alloc] init];
//        [self.navigationController pushViewController:optionVc animated:YES];
        
        if ([model.type isEqualToString:@"multi"]) {
            [TFMultiSelectView showMultiSelectViewWithSingle:[model.field.chooseType isEqualToString:@"0"]?YES:NO options:options sureBlock:^(NSMutableArray *parameter) {
                
                // 下拉控制及隐藏
                [self picklistOptionControlAndHiddenWithModel:model parameter:parameter];
                
                [self.tableView reloadData];
                
                // 联动
                [self generalSingleCellWithModel:model];
                
            } cancelBlock:^{
                
            }];
            
        }else{
            TFSelectOptionController *select = [[TFSelectOptionController alloc] init];
            select.entrys = options;
            select.isSingleSelect = isSingle;
            select.backVc = self;
            select.selectAction = ^(NSMutableArray * parameter) {
                
                // 下拉控制及隐藏
                [self picklistOptionControlAndHiddenWithModel:model parameter:parameter];
                
                [self.tableView reloadData];
                // 联动
                [self generalSingleCellWithModel:model];
                
            };
            [self.navigationController pushViewController:select animated:YES];
        }
        
    }
        
}
#pragma mark - TFCustomAlertViewDelegate
-(void)sureClickedWithOptions:(NSMutableArray *)options{
    
    if ([self.attachmentModel.type isEqualToString:@"picklist"]) {
        self.attachmentModel.selects = options;
        [self picklistOptionControlAndHiddenWithModel:self.attachmentModel parameter:options];
        
        // 触发联动
        [self generalSingleCellWithModel:self.attachmentModel];
        
    }else{
        NSArray *arr = [self.attachmentModel.selects subarrayWithRange:(NSRange){0,self.level}];
        NSMutableArray *selects = [NSMutableArray arrayWithArray:arr];
        [selects addObjectsFromArray:options];
        for (TFCustomerOptionModel *oo in options) {
            if (oo.subList.count) {
                for (TFCustomerOptionModel *sub in oo.subList) {
                    sub.open = @0;
                }
            }
        }
        self.attachmentModel.selects = selects;
    }
    [self.tableView reloadData];
}
#pragma mark - TFCustomMultiSelectCellDelegate
-(void)customMultiSelectCellDidOptionWithModel:(TFCustomerRowsModel *)model{
    
    // 触发联动
    [self generalSingleCellWithModel:model];
    
}


#pragma mark - TFCustomAttachmentsCellDelegate
- (void)deleteAttachmentsWithIndex:(NSInteger)index{
    [self.tableView reloadData];
}
- (void)addAttachmentsClickedWithCell:(TFCustomAttachmentsCell *)cell{
    
    [self.view endEditing:YES];
    
    NSInteger section = cell.tag / 0x777;
    NSInteger row = cell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    
    self.attachmentModel = model;
    
    if ([model.field.countLimit isEqualToString:@"1"]) {// 限制
        
        if (model.selects.count >= [model.field.maxCount integerValue]) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"最大上传数量为%@",model.field.maxCount] toView:KeyWindow];
            return;
        }
        
    }
    
    if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"]) {
        
//        [HQTFUploadFileView showAlertView:@"上传附件" withType:13 parameterAction:^(NSNumber *parameter) {
//
//            HQLog(@"======%@",parameter);
//
//            [self uploadFileWithType:[parameter integerValue] model:model];
//
//        }];
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传附件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        sheet.tag = 0x5400;
        [sheet showInView:self.view];
    }
    
}

-(void)customAttachmentsCell:(TFCustomAttachmentsCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    NSInteger section = cell.tag / 0x777;
    NSInteger row = cell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    [self seeFileWithFileModel:file withRows:fileCus withIndex:index];
}
#pragma mark - TFCustomImageCellDelegate
-(void)customImageCellAddImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model{
    
    [self.view endEditing:YES];
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    
    self.attachmentModel = model;
    
    if ([model.field.countLimit isEqualToString:@"1"]) {// 限制
        
        if (model.selects.count >= [model.field.maxCount integerValue]) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"最大上传数量为%@",model.field.maxCount] toView:KeyWindow];
            return;
        }
        
    }
    
    
    if ([model.type isEqualToString:@"picture"]) {
        
//        [HQTFUploadFileView showAlertView:@"上传图片" withType:13 parameterAction:^(NSNumber *parameter) {
//
//            HQLog(@"======%@",parameter);
//
//            [self uploadFileWithType:[parameter integerValue] model:model];
//
//        }];
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"上传图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        sheet.tag = 0x5411;
        [sheet showInView:self.view];
    }
}
-(void)customImageCellDeleteImageClicked:(NSInteger)index{
    
    [self.tableView reloadData];
}
-(void)customImageCellSeeImageClicked:(TFCustomImageCell *)cell withModel:(TFCustomerRowsModel *)model index:(NSInteger)index{
    
    [self.images removeAllObjects];
    
    for (TFFileModel *file in model.selects) {
        
        if ([file.file_type integerValue] == 0) {
            
            [self.images addObject:file];
        }
    }
    
    [self didLookAtPhotoActionWithIndex:index];
    
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
    }
    if (actionSheet.tag == 0x5411) {// 图片
        
        if (buttonIndex == 0) {
            
            [self openAlbum];
        }
        if (buttonIndex == 1) {
            
            [self openCamera];
        }
    }
}

#pragma mark - TFCustomAttributeTextCellDelegate
-(void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewHeight:(CGFloat)height{
    
//    NSInteger section = cell.tag / 0x777;
//    NSInteger row = cell.tag % 0x777;
//
//    if (section > self.layouts.count-1 ) {
//        return;
//    }
//    TFCustomerLayoutModel *layout = self.layouts[section];
//
//    if (row > layout.rows.count-1 ) {
//        return;
//    }
//    TFCustomerRowsModel *model = layout.rows[row];
//
//    if (height != [model.height floatValue]) {
//
//        model.height = [NSNumber numberWithFloat:(height < 150 ? 150 : height)];
//
//        [self.tableView reloadData];
//        [self.tableView beginUpdates];
//        [self.tableView endUpdates];
//    }
    
    HQLog(@"TFCustomAttributeTextCell 的高度===%lf",height);
    [self.tableView reloadData];
}

-(void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell getWebViewContent:(NSString *)content{
    
    NSInteger section = cell.tag / 0x777;
    NSInteger row = cell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    model.fieldValue = content;
    
    [self.tableView reloadData];
}

-(void)customAttributeTextCell:(TFCustomAttributeTextCell *)cell didClickedImage:(NSURL *)url{
    
    [self.images removeAllObjects];
    
    TFFileModel *file = [[TFFileModel alloc] init];
    file.file_url = [url absoluteString];
    [self.images addObject:file];
    
    [self didLookAtPhotoActionWithIndex:0];
    
}


#pragma mark - HQSwitchCellDelegate
-(void)switchCellDidSwitchButton:(UISwitch *)switchButton{
    
    NSInteger section = switchButton.tag / 0x777;
    NSInteger row = switchButton.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    model.fieldValue = switchButton.on?@"1":@"0";

    if (switchButton.on) {
        
        for (TFCustomerOptionModel *option in model.field.defaultEntrys) {
            for (TFFieldNameModel *hideName in option.hidenFields) {
                
                TFCustomerRowsModel *mo = [self getRowWithName:hideName.name];
                
                mo.field.isOptionHidden = nil;
                mo.field.optionHiddenName = nil;
            }
        }
    }else{
        
        for (TFCustomerOptionModel *option in model.field.defaultEntrys) {
            for (TFFieldNameModel *hideName in option.hidenFields) {
                
                TFCustomerRowsModel *mo = [self getRowWithName:hideName.name];
                
                mo.field.isOptionHidden = @"1";
                mo.field.optionHiddenName = model.name;
            }
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark -TFColumnViewDelegate
-(void)columnView:(TFColumnView *)columnView isSpread:(NSString *)isSpread{
    
    NSInteger index = columnView.tag - 0x4455;
    TFCustomerLayoutModel *model = [self.layouts objectAtIndex:index];
    model.isSpread = isSpread;
    model.show = @"1";
    
    
    for (TFCustomerLayoutModel *layout in self.layouts) {
        if ([layout.level isEqualToString:model.level]) {
            layout.isSpread = isSpread;
        }
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - TFSubformSectionViewDelegate
-(void)subformSectionView:(TFSubformSectionView *)subformSectionView didClickedDeleteBtn:(UIButton *)button{
    
    NSInteger index = subformSectionView.tag - 0x888;
    TFCustomerLayoutModel *model = [self.layouts objectAtIndex:index];
    
    // 删除布局中保存的数据
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *row in layout.rows) {
            
            if ([row.name isEqualToString:model.fieldName]) {
                
                if ([model.position integerValue]-1 < row.subforms.count) {
//                    if (row.subforms.count == 1 && [row.field.fieldControl isEqualToString:@"2"]) {
//                        [MBProgressHUD showError:@"该子表单为必填项，需填写一栏" toView:self.view];
//                        return;
//                    }
                    [row.subforms removeObjectAtIndex:[model.position integerValue]-1];
                }
            }
        }
    }
    if (index < self.layouts.count) {
        [self.layouts removeObjectAtIndex:index];
    }
    
    
    // 更新栏目序号
    NSInteger i = 0;
    for (TFCustomerLayoutModel *mo in self.layouts) {
        
        if ([mo.virValue isEqualToString:@"1"] && mo.rows.count) {
            
            if ([mo.fieldName isEqualToString:model.fieldName]) {
                i += 1;
                mo.position = @(i);
                for (TFCustomerRowsModel *ee in mo.rows) {
                    ee.position = mo.position;
                }
            }
        }
    }
    
    
    [self.tableView reloadData];
    
}
#pragma mark - TFSubformAddViewDelegate
-(void)subformAddView:(TFSubformAddView *)subformAddView didClickedAddBtn:(UIButton *)button{
    
    NSInteger section = subformAddView.tag - 0x999;
    
    TFCustomerLayoutModel *model = [self.layouts objectAtIndex:section-1];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout) {
        
        for (TFCustomerRowsModel *row in layout.rows) {
            
            if ([row.name isEqualToString:model.fieldName]) {
                
                TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                sublay.virValue = @"1";
                sublay.isSpread = @"0";
                sublay.level = model.level;
                sublay.fieldName = row.name;
                sublay.position = @(row.subforms.count + 1);
                sublay.name = row.type;
                
                // 该分栏不显示大于组件不显示
                if ([layout.terminalApp isEqualToString:@"0"]) {
                    sublay.terminalApp = layout.terminalApp;
                }else{
                    sublay.terminalApp = row.field.terminalApp;
                }
                sublay.isHideInCreate = layout.isHideInCreate;
                sublay.isHideInDetail = layout.isHideInDetail;
                sublay.isHideColumnName = @"0";
                
                
                NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                for (TFCustomerRowsModel *sub in row.componentList) {
                    
                    TFCustomerRowsModel *copSub = [sub copy];
                    copSub.subformName = row.name;
                    copSub.position = sublay.position;
//                    if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                        copSub.field.fieldControl = row.field.fieldControl;
//                    }
                    [subforms addObject:copSub];
                }
                sublay.rows = subforms;
                if (row.subforms) {
                    [row.subforms addObject:subforms];
                }else{
                    row.subforms = [NSMutableArray arrayWithObject:subforms];
                }
                
                // 新加栏目也要设置默认值
                for (TFCustomerRowsModel *mm in sublay.rows) {
                    [self handleDefaultWithModel:mm];
                }
                
//                [self.layouts insertObject:sublay atIndex:section+row.subforms.count];
                [self.layouts insertObject:sublay atIndex:section];
                
            }
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma mark - TFSubformHeadCellDelegate
-(void)subformHeadCell:(TFSubformHeadCell *)subformHeadCell didClickedAddButton:(UIButton *)button{
    
    NSInteger section = button.tag / 0x777;
//    NSInteger row = button.tag % 0x777;
    
    TFCustomerLayoutModel *model = [self.layouts objectAtIndex:section];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *row in layout.rows) {
            
            if ([row.name isEqualToString:model.fieldName]) {
                
                TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                sublay.virValue = @"1";
                sublay.isSpread = @"0";
                sublay.level = model.level;
                sublay.fieldName = row.name;
                sublay.position = @(row.subforms.count + 1);
                sublay.name = row.type;
                
                // 该分栏不显示大于组件不显示
                if ([layout.terminalApp isEqualToString:@"0"]) {
                    sublay.terminalApp = layout.terminalApp;
                }else{
                    sublay.terminalApp = row.field.terminalApp;
                }
                sublay.isHideInCreate = layout.isHideInCreate;
                sublay.isHideInDetail = layout.isHideInDetail;
                sublay.isHideColumnName = @"0";
                
                
                NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                for (TFCustomerRowsModel *sub in row.componentList) {
//                    [subforms addObject:[sub copy]];
                    
                    TFCustomerRowsModel *copSub = [sub copy];
                    copSub.subformName = row.name;
                    copSub.position = sublay.position;
//                    if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                        copSub.field.fieldControl = row.field.fieldControl;
//                    }
                    [subforms addObject:copSub];
                }
                sublay.rows = subforms;
                [row.subforms addObject:subforms];
                
                // 新加栏目也要设置默认值
                for (TFCustomerRowsModel *mm in sublay.rows) {
                    [self handleDefaultWithModel:mm];
                }
                
                [self.layouts insertObject:sublay atIndex:section+row.subforms.count];
                
            }
        }
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - TFSingleTextCellDelegate
-(void)singleTextCell:(TFSingleTextCell *)singleTextCell didClilckedEnterBtn:(UIButton *)enterBtn{
    
    NSInteger section = enterBtn.tag / 0x777;
    NSInteger row = enterBtn.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"location"]) {// 定位
        
        TFMapController *locationVc = [[TFMapController alloc] init];
        locationVc.type = LocationTypeSearchLocation;
        locationVc.keyword = model.fieldValue;
        if (model.otherDict) {
            
            locationVc.location = CLLocationCoordinate2DMake([[model.otherDict valueForKey:@"latitude"] doubleValue], [[model.otherDict valueForKey:@"longitude"] doubleValue]);
        }
        locationVc.locationAction = ^(TFLocationModel *parameter){
            
            if (!model.otherDict) {
                
                model.otherDict = [NSMutableDictionary dictionary];
            }
            
            if (parameter.city) {
                [model.otherDict setObject:parameter.city forKey:@"city"];
            }
            if (parameter.name) {
                [model.otherDict setObject:parameter.name forKey:@"name"];
            }
            [model.otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
            [model.otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
            [model.otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
            
            model.fieldValue = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:locationVc animated:YES];
    }
    
    if ([model.type isEqualToString:@"text"] ||
        [model.type isEqualToString:@"identifier"] ||
        [model.type isEqualToString:@"serialnum"] ||
        [model.type isEqualToString:@"phone"] ||
        [model.type isEqualToString:@"email"]) {// 单行文本
        
        TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
        search.keyLabel = model.label;
        search.bean = self.bean;
        search.keyWord = model.fieldValue;
        search.searchMatch = model.name;
        search.isSeasPool = self.isSeasPool;
        search.seaPoolId = self.seaPoolId;
        search.searchType = 1;
        search.dataId = self.dataId;
        search.processId = self.customModel.processId;
        search.parameterAction = ^(id parameter) {
          
        };
        [self.navigationController pushViewController:search animated:YES];
        
    }
}


#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSInteger section = textView.tag / 0x777;
    NSInteger row = textView.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"number"]) {
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            
            if ([textView.text containsString:@"."]) {
                
                if ([text containsString:@"."]) {
                    [MBProgressHUD showError:@"输入不合法" toView:KeyWindow];
                    return NO;
                }else{
                    
                    if (text.length) {
                        if (![text haveNumber]) {
                            
                            [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                            return NO;
                        }
                    }
                }
                
            }else{
                
                if ([text isEqualToString:@""] || [text isEqualToString:@"."] || [text haveNumber]) {
                    return YES;
                }else{
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
            
        }else{
            
            if (text.length) {
                if (![text haveNumber]) {
                    
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
        }
    }
    
    if ([model.type isEqualToString:@"phone"]) {
        if ([model.field.phoneLenth isEqualToString:@"1"]) {
            if (text.length) {
                if (![text haveNumber]) {
                    
                    [MBProgressHUD showError:@"请输入数字" toView:KeyWindow];
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    
    NSInteger section = textView.tag / 0x777;
    NSInteger row = textView.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    
    if ([model.type isEqualToString:@"number"]) {
        
        if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
            NSArray *arr = [textView.text componentsSeparatedByString:@"."];
            
            if (arr.count > 2) {
                
                [MBProgressHUD showError:@"输入不合法" toView:KeyWindow];
                textView.text = [textView.text substringToIndex:textView.text.length-1];
            }else if (arr.count == 2){
                NSString *rrr = arr[0];
                NSString *sss = arr[1];
                NSInteger location = textView.selectedRange.location;
                
                if ([model.field.numberLenth isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showError:@"不可输入小数" toView:KeyWindow];
                    textView.text = [textView.text substringToIndex:textView.text.length-1];
                }else if ([model.field.numberLenth isEqualToString:@"不限"]) {
                    
                    
                }else{
                    
                    NSString *temp = sss;
                    if (sss.length <= [model.field.numberLenth integerValue]) {// 用0补齐所有小数位
                        
                        for (NSInteger i = 0; i < ([model.field.numberLenth integerValue]-sss.length); i ++) {
                            temp = [temp stringByAppendingString:@"0"];
                        }
                        textView.text = [[NSString stringWithFormat:@"%@.",rrr] stringByAppendingString:temp];
                        textView.selectedRange = NSMakeRange(location, 0);
                    }else{
                        
                        
                        NSInteger location1 = textView.selectedRange.location;
                        
                        if (location1 == textView.text.length) {// 光标在最后
                            
                            if (sss.length > [model.field.numberLenth integerValue]) {
                                
                                [MBProgressHUD showError:[NSString stringWithFormat:@"最多输入%@位小数",model.field.numberLenth] toView:KeyWindow];
                                
                            }
                        }
                        
                        if (sss.length > [model.field.numberLenth integerValue]) {
                            
                            textView.text = [[NSString stringWithFormat:@"%@.",rrr] stringByAppendingString:[sss substringToIndex:[model.field.numberLenth integerValue]]];
                        }else{
                            textView.text = [textView.text substringToIndex:textView.text.length-1];
                        }
        
                        textView.selectedRange = NSMakeRange(location1, 0);
                        
                        
                    }
                    
                }
            }
            
        }
        
        if (textView.text.length) {
            
            CGFloat min = 0.0;
            CGFloat max = 0.0;
            if (!model.field.betweenMin || [model.field.betweenMin isEqualToString:@""]) {
                min = -MAXFLOAT;
            }else{
                min = [model.field.betweenMin floatValue];
            }
            if (!model.field.betweenMax || [model.field.betweenMax isEqualToString:@""]) {
                max = MAXFLOAT;
            }else{
                max = [model.field.betweenMax floatValue];
            }
            
            if ([textView.text floatValue] > max) {
                
                [MBProgressHUD showError:[NSString stringWithFormat:@"%@输入范围为%@~%@",model.label,model.field.betweenMin,model.field.betweenMax] toView:KeyWindow];
                textView.text = [textView.text substringToIndex:textView.text.length-1];
            }
        }
        
    }
    
    UITextRange *range = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textView positionFromPosition:range.start offset:0];
    
    if ([model.type isEqualToString:@"location"]) {
        
        
        if (!position) {
            
            if (textView.text.length > 50) {
                
                textView.text = [textView.text substringToIndex:50];
                [MBProgressHUD showError:@"最长50个字符" toView:KeyWindow];
            }
        }
    }
    
    if ([model.type isEqualToString:@"textarea"]) {
        
        if (!position) {
            
            if (textView.text.length > 1000) {
                
                textView.text = [textView.text substringToIndex:1000];
                [MBProgressHUD showError:@"最长1000个字符" toView:KeyWindow];
            }
        }
    }
    
    model.fieldValue = textView.text;
}


#pragma mark - HQTFInputCellDelegate
-(void)inputCellWithTextField:(UITextField *)textField{
    
    NSInteger section = textField.tag / 0x777;
    NSInteger row = textField.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    
    UITextRange *range = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:range.start offset:0];
    
    if (!position) {
        
        if (textField.text.length > 50) {
            
            textField.text = [textField.text substringToIndex:50];
            [MBProgressHUD showError:@"最长50个字符" toView:KeyWindow];
        }
        
        model.fieldValue = textField.text;
    }
    
    
}

- (void)inputCellDidClickedEnterBtn:(UIButton *)button{
    
    
    NSInteger section = button.tag / 0x777;
    NSInteger row = button.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.type isEqualToString:@"text"]) {// 单行文本
        
        TFCustomSearchController  *search = [[TFCustomSearchController alloc] init];
        search.keyLabel = model.label;
        search.bean = self.bean;
        search.keyWord = model.fieldValue;
        search.searchMatch = model.name;
        search.isSeasPool = self.isSeasPool;
        search.seaPoolId = self.seaPoolId;
        search.searchType = 1;
        search.dataId = self.dataId;
        search.processId = self.customModel.processId;
        search.parameterAction = ^(id parameter) {
            
            
        };
        [self.navigationController pushViewController:search animated:YES];
        
    }
    
}


#pragma mark - FDActionSheetDelegate
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    
    NSInteger section = sheet.tag / 0x234;
    NSInteger row = sheet.tag % 0x234;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    TFCustomerOptionModel *option = model.entrys[buttonIndex];
    model.fieldValue = option.label;
    
    model.selects = [NSMutableArray arrayWithObject:option];
    
    [self.tableView reloadData];
    
}

#pragma mark - HQSelectTimeCellDelegate
#pragma mark - TFCustomOptionCellDelegate
-(void)arrowClicked:(NSInteger)index section:(NSInteger)section{
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[index];
    
    if ([model.type isEqualToString:@"datetime"]) {
        
        model.fieldValue = @"";
    }
    if ([model.type isEqualToString:@"area"]) {
        model.otherDict = nil;
        model.fieldValue = @"";
    }
    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"] || [model.type isEqualToString:@"mutlipicklist"]) {
        
        for (TFCustomerOptionModel *op in model.entrys) {
            op.open = @0;
        }
        
        // 恢复该选项控制隐藏的组件
        [self restoreHiddenWithModel:model];
        // 去掉选项依赖
        if (model.selects.count) {
            
            TFCustomerOptionModel *option = model.selects[0];
            
            if (option.controlField && ![option.controlField isEqualToString:@""]) {
                
                TFCustomerRowsModel *rrow = [self findRowWithName:option.controlField];
                
                // 依赖数组
                rrow.controlEntrys = nil;
            }
            
            if (option.hidenFields.count) {
                
                // 消除该组件下面的picklist控制的
                [self cancelPicklistUnderWithModel:model];
            }
            
        }
        
        
        
        model.selects = nil;
        
    }
    
    if ([model.type isEqualToString:@"reference"]) {
        model.fieldValue = nil;
        model.relevanceField.fieldId = nil;
        model.relevanceField.value = nil;
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - TFSelectPeopleCellDelegate
-(void)selectPeopleCell:(TFSelectPeopleCell *)selectPeopleCell clearedEmployee:(HQEmployModel *)employee{
    
    NSInteger section = selectPeopleCell.tag / 0x777;
    NSInteger row = selectPeopleCell.tag % 0x777;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    [model.selects removeObject:employee];
    
    [self.tableView reloadData];
}

#pragma mark - TFFileElementCellDelegate
-(void)fileElementCellDidClickedSelectFile:(TFFileElementCell *)fileElementCell {
    
    [self.view endEditing:YES];
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *model = layout.rows[row];
    
    if ([model.field.fieldControl isEqualToString:@"1"]) {
        [MBProgressHUD showError:@"只读属性不可更改" toView:KeyWindow];
        return;
    }
    
    self.attachmentModel = model;
    
    if ([model.field.countLimit isEqualToString:@"1"]) {// 限制
        
        if (model.selects.count >= [model.field.maxCount integerValue]) {
            
            [MBProgressHUD showError:[NSString stringWithFormat:@"最大上传数量为%@",model.field.maxCount] toView:KeyWindow];
            return;
        }
        
    }
    
    if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"]) {
        
        [HQTFUploadFileView showAlertView:@"上传附件" withType:13 parameterAction:^(NSNumber *parameter) {
            
            HQLog(@"======%@",parameter);
            
            [self uploadFileWithType:[parameter integerValue] model:model];
            
        }];
    }
    
    if ([model.type isEqualToString:@"picture"]) {
        
        [HQTFUploadFileView showAlertView:@"上传图片" withType:13 parameterAction:^(NSNumber *parameter) {
            
            HQLog(@"======%@",parameter);
            
            [self uploadFileWithType:[parameter integerValue] model:model];
            
        }];
    }
}

-(void)fileElementCell:(TFFileElementCell *)fileElementCell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    TFFileModel *model = file;
    
    [self seeFileWithFileModel:model withRows:fileCus withIndex:index];
    
}
/** 查看文件 */
-(void)seeFileWithFileModel:(TFFileModel *)model withRows:(TFCustomerRowsModel *)rows withIndex:(NSInteger)index{
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        
        [self.images removeAllObjects];
        
        for (TFFileModel *model in rows.selects) {
            
            if ([model.file_type integerValue] == 0) {
                
                [self.images addObject:model];
            }
        }
        
        [self didLookAtPhotoActionWithIndex:index];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"doc"] ||
              [[model.file_type lowercaseString] isEqualToString:@"docx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xls"] ||
              [[model.file_type lowercaseString] isEqualToString:@"xlsx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ppt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pptx"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ai"] ||
              [[model.file_type lowercaseString] isEqualToString:@"cdr"] ||
              [[model.file_type lowercaseString] isEqualToString:@"dwg"] ||
              [[model.file_type lowercaseString] isEqualToString:@"ps"] ||
              [[model.file_type lowercaseString] isEqualToString:@"txt"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pdf"] ||
              [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"]){
        
        
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        [HQHelper cacheFileWithUrl:model.file_url fileName:model.file_name completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
            if (error == nil) {
                
                // 保存文件
                NSString *filePath = [HQHelper saveCacheFileWithFileName:model.file_name data:data];
                
                if (filePath) {// 写入成功
                    
                    UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
                    ctrl.delegate = self;
                    [ctrl presentPreviewAnimated:YES];
                }
            }else{
                [MBProgressHUD showError:@"读取文件失败" toView:KeyWindow];
            }
            
        } fileHandler:^(NSString *path) {
            
            [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
            
            UIDocumentInteractionController *ctrl = [UIDocumentInteractionController  interactionControllerWithURL:[NSURL fileURLWithPath:path]];
            ctrl.delegate = self;
            [ctrl presentPreviewAnimated:YES];
            
        }];
        
    }else if ([[model.file_type lowercaseString] isEqualToString:@"mp3"]){
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:KeyWindow];
    }
}

-(void)fileElementCellDidDeleteFile:(TFFileElementCell *)fileElementCell withIndex:(NSInteger)index{
    
    NSInteger section = fileElementCell.tag / 0x345;
    NSInteger row = fileElementCell.tag % 0x345;
    
    TFCustomerLayoutModel *layout = self.layouts[section];
    TFCustomerRowsModel *fileCus = layout.rows[row];
    
    [fileCus.selects removeObjectAtIndex:index];
    
    [self.tableView reloadData];
}


- (MWPhotoBrowser *)didLookAtPhotoActionWithIndex:(NSInteger)index{
    
    // 浏览图片
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES; // 分享按钮,默认是
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
    
    return browser;
}
#pragma mark - 图片浏览器

/**
 * 标题
 */
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%lu/%lu",(unsigned long)index+1,(unsigned long)self.images.count] ;
}

/**
 * 图片总数量
 */
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.images.count;
}

/**
 * 图片设置
 */
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    TFFileModel *model = self.images[index];
    MWPhoto *mwPhoto = nil;
    
    if (model.image) {
        mwPhoto = [MWPhoto photoWithImage:model.image];
    }else{
        mwPhoto = [MWPhoto photoWithURL:[HQHelper URLWithString:model.file_url]];
    }
    
    return mwPhoto;
    
}

#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

//可选的2个代理方法 （主要是调整预览视图弹出时候的动画效果，如果不实现，视图从底部推出）
- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    return self.view.frame;
}


#pragma mark - 上传文件
- (void)uploadFileWithType:(NSInteger)type model:(TFCustomerRowsModel *)model{
    
    //    if (type == 3) {// 文件库
    //
    //
    //        FLLibarayViewController *file = [[FLLibarayViewController alloc] init];
    //        file.isFromOutside = YES;
    //        file.fileArrBlock = ^(NSArray *array) {
    //
    //            for (TFFileModel *file in array) {
    //
    //                file.createTime = @([HQHelper getNowTimeSp]);
    //                file.employeeName = UM.userLoginInfo.employee.employeeName;
    //                file.employeeId = UM.userLoginInfo.employee.id;
    //                file.photograph = UM.userLoginInfo.employee.photograph;
    //                file.creatorId = UM.userLoginInfo.employee.id;
    //                file.projectId = self.projectSeeModel.project.id;
    //                file.taskId = self.projectTask.id;
    //
    //            }
    //            NSMutableArray<Optional,TFFileModel> *arr = [NSMutableArray <Optional,TFFileModel>arrayWithArray:self.taskDetail.attachments];
    //            [arr addObjectsFromArray:array];
    //            self.taskDetail.attachments = arr;
    //            self.projectTask.fileCount = @(self.taskDetail.attachments.count);
    //
    //
    //            [self.projectBL requestFileUploadWithFiles:array];
    //
    //
    //
    //        };
    //        [self.navigationController pushViewController:file animated:YES];
    //
    //        return;
    //    }
    
//    if (type == 0) {// 语音
//        [self showRecord];
//    }
    if (type == 0) {// 拍照
        [self openCamera];
    }
    if (type == 1) {// 相册
        [self openAlbum];
    }
}


#pragma mark - 语音录制

- (void)setupToolBar{
    
    self.recoder = [[JCHATToolBarContainer alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- TabBarHeight, SCREEN_WIDTH, TabBarHeight)];
    self.recoder.toolbar.frame = self.recoder.bounds;
    self.recoder.toolbar.delegate = self;
    [self.recoder.toolbar setUserInteractionEnabled:YES];
    self.recoder.toolbar.voiceButton.hidden = YES;
    self.recoder.toolbar.addButton.hidden = YES;
    self.recoder.toolbar.recorderType = YES;
    [self.recoder.toolbar drawRect:self.recoder.toolbar.frame];
    [self.recoder.toolbar switchToVoiceInputMode];
    self.recoder.backgroundColor = HexAColor(0xf2f2f2, 1);
}

- (void)showRecord{
    
    // 当前窗体
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    [[window viewWithTag:0x12345] removeFromSuperview];
    
    // 背景mask窗体
    UIButton *bgView = [[UIButton alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    bgView.tag = 0x12345;
    [bgView addTarget:self action:@selector(tapBgView:) forControlEvents:UIControlEventTouchDown];
    bgView.alpha = 0;
    
    [bgView addSubview:self.recoder];
    
    [UIView animateWithDuration:0.25 animations:^{
        bgView.alpha = 1;
    }];
    
    [window addSubview:bgView];
    
    // 显示窗体
    [window makeKeyAndVisible];
}

- (void)tapBgView:(UIButton *)tap{
    
    if (self.voiceRecordHelper.recorder.isRecording) {
        return;
    }
    UIWindow *window = ((AppDelegate *)[UIApplication sharedApplication].delegate).window;
    
    [UIView animateWithDuration:0.25 animations:^{
        [window viewWithTag:0x12345].alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.recoder removeFromSuperview];
        [[window viewWithTag:0x12345] removeFromSuperview];
    }];
}


- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        kWEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            HQLog(@"已经达到最大限制时间了，进入下一步的提示");
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf finishRecorded];
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}


- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}


#pragma mark SendMessageDelegate

- (void)didStartRecordingVoiceAction {
    HQLog(@"Action - didStartRecordingVoice");
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    HQLog(@"Action - didCancelRecordingVoice");
    [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
    HQLog(@"Action - didFinishRecordingVoiceAction");
    [self finishRecorded];
}

- (void)didDragOutsideAction {
    HQLog(@"Action - didDragOutsideAction");
    [self resumeRecord];
}

- (void)didDragInsideAction {
    HQLog(@"Action - didDragInsideAction");
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    kWEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    HQLog(@"Action - startRecord");
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
        
    }];
}
#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.aac", [dateFormatter stringFromDate:now]];
    return recorderPath;
}
- (NSString *)getMp3Path {
    NSString *recorderPath = nil;
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MyMp3Sound.mp3", [dateFormatter stringFromDate:now]];
    return recorderPath;
}
- (void)finishRecorded {
    HQLog(@"Action - finishRecorded");
    kWEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        
        NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:strongSelf.voiceRecordHelper.recordPath toMp3Url:[self getMp3Path]];
        
        [strongSelf SendMessageWithVoice:[mp3Url absoluteString]
                           voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
    }];
}

#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    if ([voiceDuration integerValue]<0.5) {
        if ([voiceDuration integerValue]<0.5) {
            HQLog(@"录音时长小于 0.5s");
        }
        return;
    }
    
    [self tapBgView:nil];
    // 此处发送语音
    TFFileModel *model = [[TFFileModel alloc] init];
    model.file_name = @"这是一段语音";
    model.file_type = @"mp3";
    model.voicePath = voicePath;
    model.voiceDuration = @([voiceDuration integerValue]);
    
//    if (!self.attachmentModel.selects) {
//        self.attachmentModel.selects = [NSMutableArray array];
//    }
//    
    //    [self.attachmentModel.selects addObject:model];
//    [self.tableView reloadData];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.customBL uploadFileWithImages:@[] withAudios:@[voicePath] bean:self.bean];
}

#pragma mark - 打开相册
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    
    //图片数量
    if ([self.attachmentModel.field.countLimit isEqualToString:@"1"]) {// 限制图片大小
        
        if (self.attachmentModel.field.maxCount && ![self.attachmentModel.field.maxCount isEqualToString:@""]) {
            
            NSInteger num = [self.attachmentModel.field.maxCount integerValue] - self.attachmentModel.selects.count;
            if (num <= 0) {
                return;
            }
            picker.maximumNumberOfSelection = num; // 选择图片最大数量
        }
    }else{
        picker.maximumNumberOfSelection = 1000000; // 选择图片最大数量
    }
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
    
    if ([self.attachmentModel.type isEqualToString:@"resumeanalysis"]){// 简历解析
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestResumeWithBean:self.bean files:arr];
    }else{
        
        if ([self.attachmentModel.field.countLimit isEqualToString:@"1"]) {// 限制图片大小
            NSArray *fits = [HQHelper caculateImageSizeWithImages:arr maxSize:[self.attachmentModel.field.maxSize floatValue]];
            if (arr.count != fits.count)  {
                [MBProgressHUD showError:[NSString stringWithFormat:@"有%ld张不符合上传条件的图片",arr.count-fits.count] toView:KeyWindow];
            }
            if (fits.count) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL uploadFileWithImages:fits withAudios:@[] bean:self.bean];
            }
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL uploadFileWithImages:arr withAudios:@[] bean:self.bean];
        }
    }
    
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //        picker.allowsEditing = YES;
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
    
    if ([self.attachmentModel.type isEqualToString:@"resumeanalysis"]){// 简历解析
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestResumeWithBean:self.bean files:@[image]];
    }else{
        
        if ([self.attachmentModel.field.countLimit isEqualToString:@"1"]) {// 限制图片大小
            NSArray *fits = [HQHelper caculateImageSizeWithImages:@[image] maxSize:[self.attachmentModel.field.maxSize floatValue]];
            if (@[image].count != fits.count) {
                [MBProgressHUD showError:[NSString stringWithFormat:@"该张照片大小不符合上传条件"] toView:KeyWindow];
            }else{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.customBL uploadFileWithImages:fits withAudios:@[] bean:self.bean];
            }
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];
        }
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 重组布局 */
- (NSMutableArray *)recombinationLayout:(TFCustomBaseModel *)baseModel{
    
    if (baseModel == nil) {
        return nil;
    }
    NSMutableArray *layouts = [NSMutableArray array];
    NSInteger index = 0;
    NSInteger level = 0;
    
    for (TFCustomerLayoutModel *layout in baseModel.layout) {
        
        level ++;
        
        // 真实布局
        TFCustomerLayoutModel *lay = [[TFCustomerLayoutModel alloc] init];
        lay.level = [NSString stringWithFormat:@"%ld",(long)level];
        lay.title = layout.title;
        lay.name = layout.name;
        lay.terminalApp = layout.terminalApp;
        lay.isHideInCreate = layout.isHideInCreate;
        lay.isHideInDetail = layout.isHideInDetail;
        lay.isHideColumnName = layout.isHideColumnName;
        lay.virValue = @"0";
        lay.isSpread = layout.isSpread?:@"0";
        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
            lay.isSpread = @"0";
        }
        lay.show = @"1";
        NSMutableArray<TFCustomerRowsModel,Optional> *rows = [NSMutableArray<TFCustomerRowsModel,Optional> array];
        lay.rows = rows;
        [layouts addObject:lay];
        
        for (TFCustomerRowsModel *row in layout.rows) {
            
            // 将子表单加入
            TFCustomerLayoutModel *laymo = layouts[index];
            [laymo.rows addObject:row];
            
            if ([row.type isEqualToString:@"subform"]) {
                
                laymo.fieldName = row.name;
//#warning 测试写死了
//                row.field.fieldControl = @"1";
                if (self.type == 0 || self.type == 3) {
                    
                    if (row.defaultSubform.count) {
                        
                        row.subforms = nil;
                        for (NSInteger i = 0 ; i < row.defaultSubform.count; i ++) {
                            
                            // 将子表单中组件定义为一个布局
                            TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                            sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                            sublay.virValue = @"1";
                            sublay.name = row.type;
                            sublay.fieldName = row.name;
                            sublay.fieldControl = row.field.fieldControl;
                            // 该分栏不显示大于组件不显示
                            if ([layout.terminalApp isEqualToString:@"0"]) {
                                sublay.terminalApp = layout.terminalApp;
                            }else{
                                sublay.terminalApp = row.field.terminalApp;
                            }
                            sublay.isHideInCreate = layout.isHideInCreate;
                            sublay.isHideInDetail = layout.isHideInDetail;
                            sublay.isHideColumnName = @"0";
                            sublay.position = @(i+1);
                            sublay.isSpread = layout.isSpread?:@"0";
                            if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                                sublay.isSpread = @"0";
                            }
                            
                            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                            for (TFCustomerRowsModel *sub in row.componentList) {
                                TFCustomerRowsModel *copSub = [sub copy];
                                copSub.subformName = row.name;
                                copSub.position = sublay.position;
//                                if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                                    copSub.field.fieldControl = row.field.fieldControl;
//                                }
                                [subforms addObject:copSub];
                            }
                            if (!row.subforms) {
                                row.subforms = [NSMutableArray arrayWithObject:subforms];
                            }else{
                                if (i <= row.subforms.count-1) {
                                    [row.subforms replaceObjectAtIndex:i withObject:subforms];
                                }else{
                                    [row.subforms addObject:subforms];
                                }
                            }
                            
                            sublay.rows = subforms;
                            
                            [layouts addObject:sublay];
                            index += 1;
                        }
                        
                    }
                    else{
                        // 将子表单中组件定义为一个布局
                        TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                        sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                        sublay.virValue = @"1";
                        sublay.name = row.type;
                        sublay.fieldName = row.name;
                        sublay.fieldControl = row.field.fieldControl;
                        // 该分栏不显示大于组件不显示
                        if ([layout.terminalApp isEqualToString:@"0"]) {
                            sublay.terminalApp = layout.terminalApp;
                        }else{
                            sublay.terminalApp = row.field.terminalApp;
                        }
                        sublay.isHideInCreate = layout.isHideInCreate;
                        sublay.isHideInDetail = layout.isHideInDetail;
                        sublay.isHideColumnName = @"0";
                        sublay.position = @(1);
                        sublay.isSpread = layout.isSpread?:@"0";
                        if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                            sublay.isSpread = @"0";
                        }
                        
//                        if ([row.field.addView isEqualToString:@"1"] && [row.field.fieldControl isEqualToString:@"2"]) {// 子表单必填时默认一栏，且不可删除
//
//                            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
//                            for (TFCustomerRowsModel *sub in row.componentList) {
//                                TFCustomerRowsModel *copSub = [sub copy];
//                                copSub.subformName = row.name;
//                                copSub.position = sublay.position;
//                                [subforms addObject:copSub];
//                            }
//                            row.subforms = [NSMutableArray arrayWithObject:subforms];
//                            sublay.rows = subforms;
//                        }
                        
                        [layouts addObject:sublay];
                        index += 1;
                    }
                }
                else{
                    
                    NSArray *arr = [self.detailDict valueForKey:row.name];
                    
                    if (!arr) continue;
                    
                    if (arr.count) {
                        
                        row.subforms = nil;
                        for (NSInteger i = 0 ; i < arr.count; i ++) {
                            
                            // 将子表单中组件定义为一个布局
                            TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                            sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                            sublay.virValue = @"1";
                            sublay.name = row.type;
                            sublay.fieldName = row.name;
                            sublay.fieldControl = row.field.fieldControl;
                            // 该分栏不显示大于组件不显示
                            if ([layout.terminalApp isEqualToString:@"0"]) {
                                sublay.terminalApp = layout.terminalApp;
                            }else{
                                sublay.terminalApp = row.field.terminalApp;
                            }
                            sublay.isHideInCreate = layout.isHideInCreate;
                            sublay.isHideInDetail = layout.isHideInDetail;
                            sublay.isHideColumnName = @"0";
                            sublay.position = @(i+1);
                            sublay.isSpread = layout.isSpread?:@"0";
                            if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                                sublay.isSpread = @"0";
                            }
                            
                            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                            for (TFCustomerRowsModel *sub in row.componentList) {
//                                [subforms addObject:[sub copy]];
                                
                                TFCustomerRowsModel *copSub = [sub copy];
                                copSub.subformName = row.name;
                                copSub.position = sublay.position;
//                                if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                                    copSub.field.fieldControl = row.field.fieldControl;
//                                }
                                [subforms addObject:copSub];
                            }
                            if (!row.subforms) {
                                row.subforms = [NSMutableArray arrayWithObject:subforms];
                            }else{
#pragma mark - 2018.05.07 在编辑后,因存在subforms，不能总增加，因为可能是前面一样的
                                if (i <= row.subforms.count-1) {
                                    [row.subforms replaceObjectAtIndex:i withObject:subforms];
                                }else{
                                    [row.subforms addObject:subforms];
                                }
                            }
                            
                            sublay.rows = subforms;
                            
                            [layouts addObject:sublay];
                            index += 1;
                        }
                        
                    }
                    else{
                        
                        if (self.type == 2 && [row.field.fieldControl isEqualToString:@"2"]) {// 编辑状态
                            
                            // 将子表单中组件定义为一个布局
                            TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                            sublay.level = [NSString stringWithFormat:@"%ld",(long)level];
                            sublay.virValue = @"1";
                            sublay.fieldName = row.name;
                            sublay.name = row.type;
                            sublay.fieldControl = row.field.fieldControl;
                            // 该分栏不显示大于组件不显示
                            if ([layout.terminalApp isEqualToString:@"0"]) {
                                sublay.terminalApp = layout.terminalApp;
                            }else{
                                sublay.terminalApp = row.field.terminalApp;
                            }
                            sublay.isHideInCreate = layout.isHideInCreate;
                            sublay.isHideInDetail = layout.isHideInDetail;
                            sublay.isHideColumnName = @"0";
                            sublay.position = @(1);
                            sublay.isSpread = layout.isSpread?:@"0";
                            if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                                sublay.isSpread = @"0";
                            }
                            
                            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                            for (TFCustomerRowsModel *sub in row.componentList) {
                                //                            [subforms addObject:[sub copy]];
                                
                                TFCustomerRowsModel *copSub = [sub copy];
                                copSub.subformName = row.name;
                                copSub.position = sublay.position;
//                                if ([row.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                                    copSub.field.fieldControl = row.field.fieldControl;
//                                }
                                [subforms addObject:copSub];
                            }
                            row.subforms = [NSMutableArray arrayWithObject:subforms];
                            
                            sublay.rows = subforms;
                            
                            [layouts addObject:sublay];
                            index += 1;
                        }
                    }
                    
                }
                
                // 以子表单为分割创建另一个布局
                TFCustomerLayoutModel *model = [[TFCustomerLayoutModel alloc] init];
                model.level = [NSString stringWithFormat:@"%ld",(long)level];
                model.virValue = @"2";
                model.fieldControl = row.field.fieldControl;
                model.terminalApp = layout.terminalApp;
                model.isHideInCreate = layout.isHideInCreate;
                model.isHideInDetail = layout.isHideInDetail;
                model.isHideColumnName = @"0";
                model.isSpread = layout.isSpread?:@"0";
                if (!layout.isHideColumnName || [layout.isHideColumnName isEqualToString:@"1"]) {
                    model.isSpread = @"0";
                }
                NSMutableArray<TFCustomerRowsModel,Optional> *mos = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                model.rows = mos;
                
                [layouts addObject:model];
                index += 1;
                
            }
            
        }
        index += 1;
    }
    
    return layouts;
}

#pragma mark - 多级下拉（因二级有第三级的东西）
- (void)handleMutilOptionsWithModel:(TFCustomerRowsModel *)model{
    
    if ([model.type isEqualToString:@"mutlipicklist"]) {
        
        if ([model.field.selectType isEqualToString:@"0"]) {// 二级
            
            for (TFCustomerOptionModel *option in model.entrys) {
                for (TFCustomerOptionModel *op in option.subList) {
                    
                    op.subList = nil;
                }
            }
        }
    }
}

/** 子表单默认值 */
-(void)subformDefault{
    NSArray *subforms = [self getSubformElement];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (TFCustomerRowsModel *model in subforms) {
        if (model.defaultSubform) {
            [dict setObject:model.defaultSubform forKey:model.name];
        }
    }
    // 给子表单添加栏目和值
    [self detailHandleWithDict:dict];
}

/** 一个字典为参数，可能是多个子表单的数据，获取各个key(子表单名)下的栏目（插入多栏目)，此字典为需要插入的子表单，子表单name为key，value为数组是插入的栏目 */
-(void)subformInsertWithDict:(NSDictionary *)dict{
    
    NSArray *keys = dict.allKeys;
    
    // 确定要插入的子表单
    NSMutableArray *subforms = [NSMutableArray array];
    NSMutableArray *dicts = [NSMutableArray array];
    for (NSString *key in keys) {
        TFCustomerRowsModel *model = [self getRowWithName:key];
        [self customerRowsModel:model WithDict:dict];
        if ([model.type isEqualToString:@"subform"]) {
            [subforms addObject:model];
            if ([dict valueForKey:model.name]) {
                [dicts addObject:[dict valueForKey:model.name]];
            }
        }
    }
    
    for (NSInteger i = 0; i < subforms.count; i++) {
        TFCustomerRowsModel *model = subforms[i];
        NSArray *list = dicts[i];
        // 此处用来确定在哪个栏目下开始插入，及它的序号
        TFCustomerLayoutModel *layout = nil;
        NSInteger section = 0;
        for (NSInteger se = 0; se < self.layouts.count; se ++) {
            TFCustomerLayoutModel *lay = self.layouts[se];
            if ([model.name isEqualToString:lay.fieldName]) {
                layout = lay;
                section = se;
            }
        }
        TFCustomerRowsModel *sectionSubform = [self getRowWithName:layout.fieldName];
        
        // 将list生成栏目
        NSMutableArray *adds = [NSMutableArray array];
        for (NSInteger ii = 0; ii < list.count; ii ++) {
            NSDictionary *ddd = list[ii];
            
            TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
            sublay.virValue = @"1";
            sublay.isSpread = @"0";
            sublay.level = layout.level;
            sublay.fieldName = sectionSubform.name;
            sublay.position = @(sectionSubform.subforms.count + 1);
            sublay.name = sectionSubform.type;
            
            // 该分栏不显示大于组件不显示
            if ([layout.terminalApp isEqualToString:@"0"]) {
                sublay.terminalApp = layout.terminalApp;
            }else{
                sublay.terminalApp = sectionSubform.field.terminalApp;
            }
            sublay.isHideInCreate = layout.isHideInCreate;
            sublay.isHideInDetail = layout.isHideInDetail;
            sublay.isHideColumnName = @"0";
            
            NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
            for (TFCustomerRowsModel *sub in sectionSubform.componentList) {
                
                TFCustomerRowsModel *copSub = [sub copy];
                copSub.subformName = sectionSubform.name;
                copSub.position = sublay.position;
//                if ([sectionSubform.field.fieldControl isEqualToString:@"1"]) {// 子表单组件为只读，子组件听从子表单的
//                    copSub.field.fieldControl = sectionSubform.field.fieldControl;
//                }
                [subforms addObject:copSub];
            }
            sublay.rows = subforms;
            if (sectionSubform.subforms) {
                [sectionSubform.subforms addObject:subforms];
            }else{
                sectionSubform.subforms = [NSMutableArray arrayWithObject:subforms];
            }
            // 新加栏目也要设值
            for (TFCustomerRowsModel *mm in sublay.rows) {
                [self customerRowsModel:mm WithDict:ddd];
            }
            [adds addObject:sublay];
            
        }
        // 插入到section的位置
        for (TFCustomerLayoutModel *ll in adds) {
            section ++;
            [self.layouts insertObject:ll atIndex:section];
        }
    }
}


#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_resumeFile) {// 简历解析
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dictTotal = resp.body;
        if ([[[dictTotal valueForKey:@"code"] description] isEqualToString:@"0"]) {// 成功解析
            // 文件展示
            NSDictionary *file = [dictTotal valueForKey:@"obj"];// 文件信息
            NSError *error ;
            TFFileModel *fileM = [[TFFileModel alloc] initWithDictionary:file error:&error];
            if (fileM) {
                if (self.attachmentModel.selects) {// 只能一个
                    [self.attachmentModel.selects removeAllObjects];
                    [self.attachmentModel.selects addObject:fileM];
                }else{
                    self.attachmentModel.selects = [NSMutableArray arrayWithObject:fileM];
                }
            }
            // 主表字段
            NSDictionary *mainData = [dictTotal valueForKey:@"mainData"];// 主表字段
            NSArray *keys = [mainData allKeys];
            for (NSString *key in keys) {
                TFCustomerRowsModel *mo = [self getRowWithName:key];
                [self customerRowsModel:mo WithDict:mainData];
            }
            
            // 子表单批量插入
            NSDictionary *dict = [dictTotal valueForKey:@"subData"];// 子表单字段
        
            // 先删除栏目（更换简历的需覆盖已有值）
            NSArray *allKeys = [dict allKeys];
            NSMutableArray *allLayouts = [NSMutableArray arrayWithArray:self.layouts];
            
            for (NSString *key in allKeys) {
                for (TFCustomerLayoutModel *lay in allLayouts) {
                    if ([key isEqualToString:lay.fieldName] && [lay.virValue isEqualToString:@"1"]) {
                        [self.layouts removeObject:lay];
                    }
                }
                TFCustomerRowsModel *row = [self getRowWithName:key];
                if ([row.type isEqualToString:@"subform"]) {
                    [row.subforms removeAllObjects];
                }
            }
            
            [self subformInsertWithDict:dict];
            
            [self.tableView reloadData];
            
        }else{
            [MBProgressHUD showError:@"简历解析失败" toView:self.view];
        }
    }
    
    if (resp.cmdId == HQCMD_getReferanceReflect) {// 关联页签新建映射
        
        NSDictionary *dict = resp.body;
        [self subformInsertWithDict:dict];
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customLayout) {
        
        if (self.type != 1) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        
        TFCustomBaseModel *model = resp.body;
        self.customModel = model;
        self.customDict = resp.data;
        if (self.layoutBlock) {
            self.layoutBlock(model);
        }
        
        [self setupNavi];
        
        self.layouts = [self recombinationLayout:model];
        
#pragma mark - 处理子表单默认值 2019.03.14
        if (self.type == 0) {
            [self subformDefault];
        }
        // 新建和复制时处理默认值
        if (self.type == 0 || self.type == 2 || self.type == 3 || self.type == 7) {
            [self handleDefault];
        }
        
        if (self.type != 0) {// 详情时
            
            if (self.detailDict) {
                
                [self detailHandleWithDict:self.detailDict];
                if (self.fatherRefresh) {
                    self.fatherRefresh();
                }
            }
        }
        NSArray *emails = [self getEmails];
        // 用于详情是否有评论和动态
        NSDictionary *di = @{
                             @"commentControl":TEXT(model.commentControl),
                             @"dynamicControl":TEXT(model.dynamicControl),
                             @"emailControl":emails.count==0?@"0":@"1",
                             @"approvalControl":TEXT(model.processId)
                             };
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationCommentAndDynamic" object:self.dataId userInfo:di];
        if (self.commentBlock) {
            self.commentBlock(di);
        }
        
        [self.tableView reloadData];
        
        // 多刷几次新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.detailDict) {
                [self.tableView reloadData];
            }else{
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            }
        });
        
        
        // 邮件组件回调
        if (self.emailBlock && self.detailDict) {
            NSMutableArray *emailValues = [NSMutableArray array];
            
            for (TFCustomerRowsModel *roow in emails) {
                
                NSString *em = [self.detailDict valueForKey:roow.name];
                
                [emailValues addObject:TEXT(em)];
            }
            
            self.emailBlock(emailValues);
        }
        
        /** 传递过来的关联 */
        [self handleDeliverReference];
        
        
        // 记录联动条件字段
        for (NSString *field in self.linkageConditions) {
            if ([field containsString:@"subform"]) {// 子组件
                NSArray *subforms = [self getSubformElement];
                for (TFCustomerRowsModel *subform in subforms) {
                    for (TFCustomerRowsModel *row in subform.componentList) {
                        if ([field isEqualToString:row.name]) {
                            row.linkage = @"1";
                        }
                    }
                }
                
            }else{
                TFCustomerRowsModel *model = [self getRowWithName:field];// 找不到子表单里的子组件
                model.linkage = @"1";
            }
        }
        // 记录初始值
        self.startDict = [[self dictData] description];
        
    }
    
    if (resp.cmdId == HQCMD_getCustomConditionField) {// 获取联动条件字段
        
        self.linkageConditions = resp.body;
        
        if (self.customModel) {
            
            // 记录联动条件字段
            for (NSString *field in self.linkageConditions) {
                
                if ([field containsString:@"subform"]) {// 子组件
                    NSArray *subforms = [self getSubformElement];
                    for (TFCustomerRowsModel *subform in subforms) {
                        for (TFCustomerRowsModel *row in subform.componentList) {
                            if ([field isEqualToString:row.name]) {
                                row.linkage = @"1";
                            }
                        }
                    }
                    
                }else{
                    TFCustomerRowsModel *model = [self getRowWithName:field];// 找不到子表单里的子组件
                    model.linkage = @"1";
                }
            }
        }
    }
    
    if (resp.cmdId == HQCMD_getLinkageFieldList) {// 获取联动字段
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        // 值
        NSDictionary *dict = resp.body;
        
        // 处理联动
        [self handleLinkageFieldWithDict:dict currentModel:self.attachmentModel];
        
        // 刷新
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customSave) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(self.refreshAction){
            self.refreshAction();
        }
        if (self.taskBlock) {
            NSDictionary *dataDict = [resp.body valueForKey:@"data"];
            NSString *ids = [dataDict valueForKey:@"dataId"];
            NSMutableDictionary *dd = [NSMutableDictionary dictionary];
            [dd setObject:ids forKey:@"data"];
            [self.navigationController popViewControllerAnimated:NO];
            self.taskBlock(dd);
        }else if (self.customBlock) {
            NSDictionary *dataDict = [resp.body valueForKey:@"data"];
            NSString *ids = [dataDict valueForKey:@"dataId"];
            NSMutableDictionary *dd = [NSMutableDictionary dictionary];
            [dd setObject:ids forKey:@"data"];
            [dd setObject:[dataDict valueForKey:@"bean"] forKey:@"bean"];
            [dd setObject:[dataDict valueForKey:@"moduleId"] forKey:@"moduleId"];
            [dd setObject:[dataDict valueForKey:@"moduleName"] forKey:@"moduleName"];
            [self.navigationController popViewControllerAnimated:NO];
            self.customBlock(dd);
        }else{
            [MBProgressHUD showImageSuccess:@"新建成功" toView:KeyWindow];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
    
    
    if (resp.cmdId == HQCMD_uploadFile) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (self.attachmentModel.selects) {
            [self.attachmentModel.selects addObjectsFromArray:resp.body];
        }else{
            self.attachmentModel.selects = [NSMutableArray arrayWithArray:resp.body];
        }
        
        
        [self.tableView reloadData];
    }
    
    if (resp.cmdId == HQCMD_customDetail) {
        
        
        NSDictionary *valueDict = resp.body;
        self.detailDict = valueDict;
        
        if (!self.layouts) {
            [self.customBL requestCustomLayoutWithBean:self.bean taskKey:self.taskKey operationType:self.oprationType dataId:[self.dataId description] isSeasPool:self.isSeasPool processFieldV:self.processFieldV];
        }
//        if (!self.layouts) {
            self.layouts = [self recombinationLayout:self.customModel];
//        }else{
//            if (self.fatherRefresh) {
//                self.fatherRefresh();
//            }
//        }
        if (self.detailBlock) {

            self.detailBlock(valueDict);
        }
        
        // 详情时
        [self detailHandleWithDict:self.detailDict];
        
        [self.tableView reloadData];
        
        
        // 邮件组件回调
        if (self.emailBlock && self.customModel) {
            NSMutableArray *emailValues = [NSMutableArray array];
            NSArray *emails = [self getEmails];
            
            for (TFCustomerRowsModel *roow in emails) {
                
                NSString *em = [self.detailDict valueForKey:roow.name];
                if (em && ![em isEqualToString:@""]) {
                    
                    [emailValues addObject:TEXT(em)];
                }
            }
            
            self.emailBlock(emailValues);
        }
        
        // 记录初始值
        self.startDict = [[self dictData] description];
    }
    
    if (resp.cmdId == HQCMD_customEdit) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showImageSuccess:@"修改成功" toView:KeyWindow];
        if (self.refreshAction) {
            self.refreshAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_moduleHaveReadAuth) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        
        if (![[dict valueForKey:@"readAuth"] isEqualToNumber:@1]) {
            [MBProgressHUD showError:@"暂无数据权限" toView:self.view];
            return;
        }
        
//        TFCustomDetailController *detail = [[TFCustomDetailController alloc] init];
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = self.attachmentModel.relevanceModule.moduleName;
        detail.dataId = [NSNumber numberWithLongLong:[self.attachmentModel.relevanceField.fieldId longLongValue]];
        detail.deleteAction = ^{
            self.refreshAction();
        };
        detail.refreshAction = ^{
            
            self.refreshAction();
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    if (resp.cmdId == HQCMD_barcodePicture) {// 条形码图片
        
        NSDictionary *dict = resp.body;
        NSString *picStr = [dict valueForKey:@"barcodePic"];
        // 预览图片
//        TFFileModel *model = [[TFFileModel alloc] init];
//        model.file_url = picStr;
//        [self.images removeAllObjects];
//        [self.images addObject:model];
//        [self didLookAtPhotoActionWithIndex:0];
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,SCREEN_HEIGHT}];
        view.backgroundColor = WhiteColor;
        view.tag = 0x2222;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){30,0,SCREEN_WIDTH-60,SCREEN_HEIGHT}];
        [view addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = WhiteColor;
        [imageView sd_setImageWithURL:[HQHelper URLWithString:picStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (image) {
                [KeyWindow addSubview:view];
            }else{
                [MBProgressHUD showError:@"未获取到图片" toView:self.view];
            }
            
        }];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
        [imageView addGestureRecognizer:tap];
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(barcodeClicked:)];
        [view addGestureRecognizer:tap1];
        
        view.alpha = 0;
        [UIView animateWithDuration:0.25 animations:^{
            view.alpha = 1;
        }];
        
    }
    if (resp.cmdId == HQCMD_createBarcode) {// 生成条形码
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = resp.body;
        self.attachmentModel.fieldValue = [dict valueForKey:@"barcodeValue"];
        [self.tableView reloadData];
        
        // 联动
        [self generalSingleCellWithModel:self.attachmentModel];
    }
}

-(void)barcodeClicked:(UIGestureRecognizer *)tap{
    
    [UIView animateWithDuration:0.25 animations:^{
        [KeyWindow viewWithTag:0x2222].alpha = 0;
    } completion:^(BOOL finished) {
        [[KeyWindow viewWithTag:0x2222] removeFromSuperview];
    }];
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    
    if (resp.cmdId == HQCMD_customLayout || resp.cmdId == HQCMD_customDetail) {
        if (self.fatherRefresh) {
            self.fatherRefresh();
        }
    }
        
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

/** 处理联动字段的值 */
- (void)handleLinkageFieldWithDict:(NSDictionary *)dict currentModel:(TFCustomerRowsModel *)model{
    
    // 获取所有的字段key
    NSArray *keys = [dict allKeys];
    for (NSString *key in keys) {
        TFCustomerRowsModel *row = [self getRowWithName:key];
        if (!row) continue;
        
        if ([row.type isEqualToString:@"subform"] && [row.name isEqualToString:model.subformName]) {// 遍历到该model所在的子表单时，该联动只影响model所在的栏目
            NSDictionary *columnDict = [dict valueForKey:row.name];
            if (row.subforms.count > ([model.position integerValue]-1)) {// 确保找对了子表单，有该栏目
                NSArray *rows = row.subforms[[model.position integerValue] - 1];
                for (TFCustomerRowsModel *subRow in rows) {
                    if ([columnDict valueForKey:subRow.name]) {
                        [self customerRowsModel:subRow WithDict:columnDict];// 赋值
                    }
                }
            }
        }else if ([row.type isEqualToString:@"subform"]){// 非model所在的子表单,该子表单的所有栏目都赋值
            
#pragma mark - 联动子表单批量插入
            
            // 遇到子表单是插入栏目，并给栏目赋值
            // 此处用来确定在哪个栏目下开始插入，及它的序号
            TFCustomerLayoutModel *layout = nil;
            NSInteger section = 0;
            for (NSInteger se = 0; se < self.layouts.count; se ++) {
                TFCustomerLayoutModel *lay = self.layouts[se];
                if ([row.name isEqualToString:lay.fieldName]) {
                    layout = lay;
                    section = se;
                }
            }
            
            NSArray *list = [dict valueForKey:row.name];
            NSMutableArray *adds = [NSMutableArray array];
            for (NSInteger ii = 0; ii < list.count; ii++) {
                
                TFCustomerLayoutModel *sublay = [[TFCustomerLayoutModel alloc] init];
                sublay.virValue = @"1";
                sublay.isSpread = @"0";
                sublay.level = layout.level;
                sublay.fieldName = row.name;
                sublay.position = @(row.subforms.count + 1);
                sublay.name = row.type;
                
                // 该分栏不显示大于组件不显示
                if ([layout.terminalApp isEqualToString:@"0"]) {
                    sublay.terminalApp = layout.terminalApp;
                }else{
                    sublay.terminalApp = row.field.terminalApp;
                }
                sublay.isHideInCreate = layout.isHideInCreate;
                sublay.isHideInDetail = layout.isHideInDetail;
                sublay.isHideColumnName = @"0";
                
                NSMutableArray<TFCustomerRowsModel,Optional> *subforms = [NSMutableArray<TFCustomerRowsModel,Optional> array];
                for (TFCustomerRowsModel *sub in row.componentList) {
                    
                    TFCustomerRowsModel *copSub = [sub copy];
                    copSub.subformName = row.name;
                    copSub.position = sublay.position;
                    if ([row.field.fieldControl isEqualToString:@"1"]) {
                        copSub.field.fieldControl = row.field.fieldControl;
                    }
                    [subforms addObject:copSub];
                }
                sublay.rows = subforms;
                if (row.subforms) {
                    [row.subforms addObject:subforms];
                }else{
                    row.subforms = [NSMutableArray arrayWithObject:subforms];
                }
                
                // 新加栏目也要设置默认值
                for (TFCustomerRowsModel *mm in sublay.rows) {
                    [self handleDefaultWithModel:mm];
                }
                [adds addObject:sublay];
                
                // 把这组布局的赋值
                for (TFCustomerRowsModel *pp in sublay.rows){
                    [self customerRowsModel:pp WithDict:list[ii]];
                }
                
            }
            
            // 插入到section的位置
            for (TFCustomerLayoutModel *ll in adds) {
                section ++;
                [self.layouts insertObject:ll atIndex:section];
            }
            
            
//            NSDictionary *columnDict = [dict valueForKey:row.name];
//            for (NSArray *rows in row.subforms) {
//                for (TFCustomerRowsModel *subRow in rows) {
//                    if ([columnDict valueForKey:subRow.name]) {
//                        [self customerRowsModel:subRow WithDict:columnDict];// 赋值
//                    }
//                }
//            }
            
        }else{// 一般字段
            
            if ([dict valueForKey:row.name]) {
                [self customerRowsModel:row WithDict:dict];// 赋值
            }
            
        }
    }
    
}


/** 获取关联组件 */
- (NSMutableArray *)getReferenceRows{
    NSMutableArray *rows = [NSMutableArray array];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.name isEqualToString:@"systemInfo"]) {// !基本信息
            
            for (TFCustomerRowsModel *model1 in layout.rows) {
                
                if ([model1.type isEqualToString:@"reference"]) {
                    
//                    BOOL submit = NO;
//
//                    if (self.type == 2 || self.type == 7) {// 编辑
//                        if ([model1.field.editView isEqualToString:@"1"]) {
//                            submit = YES;
//                        }
//                    }else{
//                        if ([model1.field.addView isEqualToString:@"1"]) {
//                            submit = YES;
//                        }
//                    }
//
//                    if (submit) {
                    
                        [rows addObject:model1];
//                    }
                }
                if ([model1.type isEqualToString:@"subform"]) {

                    for (TFCustomerRowsModel *subModel in model1.componentList) {
                        
                        if ([subModel.type isEqualToString:@"reference"]) {

                            [rows addObject:subModel];
                        }
                    }
                }
            }
        }
    }
    
    return rows;
}


/** 获取下拉组件 */
- (NSMutableArray *)getPickListRows{
    NSMutableArray *rows = [NSMutableArray array];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.name isEqualToString:@"systemInfo"]) {// !基本信息
            
            for (TFCustomerRowsModel *model1 in layout.rows) {
                
                if ([model1.type isEqualToString:@"picklist"]) {
                    
                    BOOL submit = NO;
                    
                    if (self.type == 2 || self.type == 7) {// 编辑
                        if ([model1.field.editView isEqualToString:@"1"]) {
                            submit = YES;
                        }
                    }else{
                        if ([model1.field.addView isEqualToString:@"1"]) {
                            submit = YES;
                        }
                    }
                    
                    if (submit) {
                        
                        [rows addObject:model1];
                    }
                }
            }
        }
    }
    
    return rows;
}


/**  拿到某个字段的row */
- (TFCustomerRowsModel *)getRowWithName:(NSString *)name{
    
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *model1 in layout.rows) {
            
            if ([model1.name isEqualToString:name]) {
                
                return model1;
                
            }else if ([model1.type isEqualToString:@"subform"]){
                
                for (NSArray *arr in model1.subforms) {
                    for (TFCustomerRowsModel *sub in arr) {
                        
                        if ([sub.name isEqualToString:name]) {
                            return sub;
                        }
                    }
                }
            }
        }
        
    }
    
    return nil;
    
}

/** 给某个组件赋上默认值 */
- (void)handleDefaultWithModel:(TFCustomerRowsModel *)model{
    
    if (model.field.defaultValue && ![model.field.defaultValue isEqualToString:@""]) {
        model.fieldValue = model.field.defaultValue;
    }
    if ([model.type isEqualToString:@"area"]) {// 省市区默认值
        NSArray *arr = [model.field.defaultValue componentsSeparatedByString:@","];
        NSMutableArray *selects = [NSMutableArray array];
        for (NSInteger i = 0; i < arr.count; i++) {
            NSArray *se = [arr[i] componentsSeparatedByString:@":"];
            if (se.count == 2) {
                NSMutableDictionary *dd = [NSMutableDictionary dictionary];
                [dd setObject:se[0] forKey:@"id"];
                [dd setObject:se[1] forKey:@"name"];
                [selects addObject:dd];
            }
        }
        model.selects = selects;
    }
    
    if ([model.type isEqualToString:@"location"]) {// 定位默认值
        model.fieldValue = @"";// model.field.defaultValue为要不要定位，而不是显示的值
        if ([model.field.defaultValue isEqualToString:@"1"]) {
            
            if (self.type == 0) {
                TFMapController *locationVc = [[TFMapController alloc] initWithType:LocationTypeHideLocation];
                locationVc.type = LocationTypeHideLocation;
                locationVc.keyword = model.fieldValue;
                locationVc.locationAction = ^(TFLocationModel *parameter){
                    
                    if (!model.otherDict) {
                        
                        model.otherDict = [NSMutableDictionary dictionary];
                    }
                    
                    if (parameter.city) {
                        [model.otherDict setObject:parameter.city forKey:@"city"];
                    }
                    if (parameter.name) {
                        [model.otherDict setObject:parameter.name forKey:@"name"];
                    }
                    [model.otherDict setObject:@(parameter.longitude) forKey:@"longitude"];
                    [model.otherDict setObject:@(parameter.latitude) forKey:@"latitude"];
                    [model.otherDict setObject:[NSString stringWithFormat:@"%@#%@#%@",parameter.province,parameter.city,parameter.district] forKey:@"area"];
                    
                    
                    model.fieldValue = [NSString stringWithFormat:@"%@%@%@%@",parameter.province,parameter.city,parameter.district,parameter.address];
                    
                    [self.tableView reloadData];
                    
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [self.tableView beginUpdates];
//                        [self.tableView endUpdates];
//                    });
                };
                
                [self addChildViewController:locationVc];
                
            }else{
                model.fieldValue = @"";
            }
            
        }
    }
    if ([model.type isEqualToString:@"datetime"]) {// 时间
        
        if ([model.field.defaultValueId isEqualToString:@"1"]) {// 当前时间
            
            model.fieldValue = [HQHelper nsdateToTime:[HQHelper getNowTimeSp] formatStr:model.field.formatType];
        }
        
        if ([model.field.defaultValueId isEqualToString:@"2"]) {// 指定时间
            
            model.fieldValue = [HQHelper nsdateToTime:[model.field.defaultValue longLongValue] formatStr:model.field.formatType];
        }
    }
    
    // 有默认选项
    if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
        
        NSMutableArray *selects = [NSMutableArray array];
        for (TFCustomerOptionModel *op in model.field.defaultEntrys) {
            
            for (TFCustomerOptionModel *option in model.entrys) {
                
                if ([option.label isEqualToString:op.label]) {
                    option.open = @1;
                    [selects addObject:option];
                    
                    // 当该选项有控制字段（选项依赖）要替换被控制的组件选项范围
                    if (option.controlField && ![option.controlField isEqualToString:@""]) {
                        
                        TFCustomerRowsModel *rrow = [self findRowWithName:option.controlField];
                        rrow.fieldValue = nil;
//                        rrow.selects = nil;
                        rrow.controlEntrys = nil;
                        // 确定该组件的选项范围
//                        rrow.entrys = option.relyonList;
                        rrow.controlEntrys = option.relyonList;
                        // 将该选项的默认值展示出来
                        NSMutableArray *rrowArrs = [NSMutableArray array];
//                        for (TFCustomerOptionModel *rrowOp in rrow.entrys) {
                        for (TFCustomerOptionModel *rrowOp in rrow.controlEntrys) {
                            for (TFCustomerOptionModel *derrowOp in rrow.field.defaultEntrys) {
                                
                                if ([rrowOp.label isEqualToString:derrowOp.label]) {
                                    derrowOp.open = @1;
                                    [rrowArrs addObject:derrowOp];
                                }
                            }
                        }
                        rrow.selects = rrowArrs;
                    }
                    
                    break;
                }
            }
        }
        model.selects = selects;
        
        // 选项是否隐藏组件
        [self optionHiddenWithModel:model];
        
    }
    
    if ([model.type isEqualToString:@"mutlipicklist"]) {// 多级下拉默认值
        
        TFMultiOptionalDefaultModel *multiDefault = model.defaultEntrys;
        
        NSMutableArray *aaa = [NSMutableArray array];
        for (TFCustomerOptionModel *op in model.entrys) {
            
            if (![multiDefault.oneDefaultValue isEqualToString:@""] && [op.label isEqualToString:multiDefault.oneDefaultValue]) {
                [aaa addObject:op];
                op.open = @1;
                for (TFCustomerOptionModel *opq in op.subList) {
                    
                    if (![multiDefault.twoDefaultValue isEqualToString:@""] && [opq.label isEqualToString:multiDefault.twoDefaultValue]) {
                        [aaa addObject:opq];
                        opq.open = @1;
                        
                        for (TFCustomerOptionModel *opqr in opq.subList) {
                            
                            if (![multiDefault.threeDefaultValue isEqualToString:@""] && [opqr.label isEqualToString:multiDefault.threeDefaultValue]) {
                                [aaa addObject:opqr];
                                opqr.open = @1;
                                break;
                            }
                            
                        }
                        break;
                    }
                    
                }
                break;
            }
        }
        
        model.selects = aaa;
        
    }
    
    if ([model.type isEqualToString:@"reference"]) {
        
        
        if (self.relevances && self.relevances.count) {
            
            for (TFRelevanceFieldModel *field in self.relevances) {
                
                if ([field.fieldName isEqualToString:model.relevanceField.fieldName]) {
                    
                    model.relevanceField.fieldId = field.fieldId;
                    model.fieldValue = field.fieldLabel;
                    break;
                }
                
            }
            
        }
        
    }
    
    if ([model.type isEqualToString:@"personnel"]) {
        
        if (self.employ) {
            
            NSMutableArray *selects = [NSMutableArray array];
            [selects addObject:self.employ];
            model.fieldValue = self.employ.employeeName;
            
            model.selects = selects;
        }
        
        if (model.field.defaultPersonnel.count) {// 默认人员
            
            TFNormalPeopleModel *pppp = model.field.defaultPersonnel[0];
            
            NSString *currentUser = pppp.value;
            if ([currentUser isEqualToString:@"3-personnel_create_by_superior"] ||
                [currentUser isEqualToString:@"3-current_login_personnel"]) {// 默认当前用户
                NSMutableArray *arrr = [NSMutableArray array];
                HQEmployModel *ee = [[HQEmployModel alloc] init];
                TFEmployeeCModel *cee = UM.userLoginInfo.employee;
                ee.id = cee.id;
                ee.picture = cee.picture;
                ee.employeeName = cee.employee_name;
                ee.employee_name = cee.employee_name;
                
                [arrr addObject:ee];
                model.selects = arrr;
            }else{
                
                NSMutableArray *arrr = [NSMutableArray array];
                for (TFNormalPeopleModel *mo in model.field.defaultPersonnel) {
                    
                    [arrr addObject:[TFChangeHelper employeeForNormalPeople:mo]];
                    
                }
                model.selects = arrr;
                
            }
            
        }
        
        NSString *str = @"";
        for (HQEmployModel *em in model.selects) {
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",em.employeeName]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        model.fieldValue = str;
    }
    
    if ([model.type isEqualToString:@"department"]) {
        
        if (model.field.defaultDepartment.count) {// 默认人员
            
            TFNormalPeopleModel *pppp = model.field.defaultDepartment[0];
            
            NSString *currentUser = pppp.value;
            if ([currentUser isEqualToString:@"3-current_main_department"]) {// 默认当前用户
                NSMutableArray *arrr = [NSMutableArray array];
                TFDepartmentModel *ee = [[TFDepartmentModel alloc] init];
                NSArray *arr = UM.userLoginInfo.departments.allObjects;
                if (arr.count) {
                    TFDepartmentCModel *cee = arr[0];
                    ee.id = cee.id;
                    ee.name = cee.department_name;
                }
                
                [arrr addObject:ee];
                model.selects = arrr;
            }else{
                
                NSMutableArray *arrr = [NSMutableArray array];
                for (TFNormalPeopleModel *mo in model.field.defaultDepartment) {
                    
                    [arrr addObject:[TFChangeHelper departmentForNormalDepartment:mo]];
                    
                }
                model.selects = arrr;
                
            }
            
        }
        
        NSString *str = @"";
        for (TFDepartmentModel *em in model.selects) {
            
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",em.name]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        model.fieldValue = str;
    }
    
    if ([model.type isEqualToString:@"checkbox"]) {
        
        for (TFCustomerOptionModel *option in model.field.defaultEntrys) {
            for (TFFieldNameModel *hideName in option.hidenFields) {
                
                TFCustomerRowsModel *mo = [self getRowWithName:hideName.name];
                
                mo.field.isOptionHidden = @"1";
                mo.field.optionHiddenName = model.name;
            }
        }
    }
}

/** 处理默认值 */
- (void)handleDefault{
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        if (![layout.name isEqualToString:@"systemInfo"]) {
            
            for (TFCustomerRowsModel *model in layout.rows) {
                
                if ([model.type isEqualToString:@"subform"]) {
                    
                    for (NSArray *rowArr in model.subforms) {
                        for (TFCustomerRowsModel *row in rowArr) {
                            
                            [self handleDefaultWithModel:row];
                        }
                    }
                }else{
                    
                    [self handleDefaultWithModel:model];
                }
                
            }
        }
    }
    
}
/** 获取email组件 */
- (NSArray *)getEmails{
    
    NSMutableArray *emails = [NSMutableArray array];
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *model in layout.rows){
            
            if ([model.type isEqualToString:@"email"]) {
                
                [emails addObject:model];
            }
            
        }
    }
    return emails;
}

/** 处理详情 */
- (void)detailHandleWithDict:(NSDictionary *)dict{
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *model in layout.rows){
            
            [self customerRowsModel:model WithDict:dict];
            
        }
    }
    
}

/** 找到某个组件 */
- (TFCustomerRowsModel *)findRowWithName:(NSString *)name{
    
    TFCustomerRowsModel *goal = nil;
    
    for (TFCustomerLayoutModel *layout in self.customModel.layout ) {
        
        for (TFCustomerRowsModel *model in layout.rows){
            
            if ([model.name isEqualToString:name]) {
                
                goal = model;
                break;
            }
            
        }
    }
    
    return goal;
}

/** 还原选项选中状态 */
- (void)restoreOptionWithModel:(TFCustomerRowsModel *)model{
    
    for (TFCustomerOptionModel *op in model.controlEntrys) {
        op.open = @0;
    }
    
    for (TFCustomerOptionModel *op in model.entrys) {
        op.open = @0;
    }
}

/** 还原某个隐藏的组件 */
- (void)restoreHiddenWithModel:(TFCustomerRowsModel *)model{
    
    if (model.selects.count) {
        
        TFCustomerOptionModel *option = model.selects[0];
        
        if (option.hidenFields.count) {// 隐藏
            
            // 恢复该选项控制的
            for (TFCustomerLayoutModel *layout in self.layouts) {
                
                // 子表单的一组（隐藏子表单）
                if ([layout.optionHiddenName isEqualToString:model.name]) {
                    
                    layout.isOptionHidden = nil;
                    for (TFCustomerRowsModel *mo in layout.rows){
                        
                        mo.field.isOptionHidden = nil;
                        mo.field.optionHiddenName = nil;
                    }
                    
                }else{
                    
                    for (TFCustomerRowsModel *mo in layout.rows){
                        
                        if ([mo.field.optionHiddenName isEqualToString:model.name]) {// 控制相应的字段显示
                        
                            mo.field.isOptionHidden = nil;
                            mo.field.optionHiddenName = nil;
                        }
                    
                    }
                }
            }
        }
    }else{
        
        for (TFCustomerOptionModel *option in model.entrys) {
            
            for (TFFieldNameModel *field in option.hidenFields) {
                
                TFCustomerRowsModel *row = [self getRowWithName:field.name];
                
                row.field.isOptionHidden = nil;
                row.field.optionHiddenName = nil;
            }
        }
    }
}

/** 选项隐藏某个组件 */
- (void)optionHiddenWithModel:(TFCustomerRowsModel *)model{
    
    if (model.selects.count) {
        
        TFCustomerOptionModel *option = model.selects[0];
        
        if (option.hidenFields.count) {
            // 隐藏
            for (TFFieldNameModel *hideName in option.hidenFields) {
                
                for (TFCustomerLayoutModel *layout in self.layouts) {
                    
                    if ([layout.name isEqualToString:@"subform"] && [hideName.name isEqualToString:layout.fieldName]) {// 存放子表单的一组数据
                        
                        layout.isOptionHidden = @"1";
                        layout.optionHiddenName = model.name;
                        
                        for (TFCustomerRowsModel *mo in layout.rows){// 当前这一组全部隐藏
                            
                            mo.field.isOptionHidden = @"1";
                            mo.field.optionHiddenName = model.name;
                        }
                        
                    }else{// 非子表单的组
                        
                        for (TFCustomerRowsModel *mo in layout.rows){
                            
                            if ([hideName.name isEqualToString:mo.name]) {// 控制相应的字段隐藏
                                
                                mo.field.isOptionHidden = @"1";
                                mo.field.optionHiddenName = model.name;
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

/** 选项控制 */
- (void)relevanceWithOption:(TFCustomerOptionModel *)option{
    
    if (option.controlField && ![option.controlField isEqualToString:@""]) {
        
        TFCustomerRowsModel *rrow = [self findRowWithName:option.controlField];
        
        // 依赖数组
        NSMutableArray<TFCustomerOptionModel> *contrs = [NSMutableArray<TFCustomerOptionModel> array];
        // 找到所控制的选项，而不是用option.relyonList , 因为relyonList丢失了hidenFields
        for (TFCustomerOptionModel *reOp in option.relyonList) {
            for (TFCustomerOptionModel *rrowOp in rrow.entrys) {
                
                if ([rrowOp.label isEqualToString:reOp.label]) {
                    [contrs addObject:rrowOp];
                    break;
                }
            }
        }
        rrow.controlEntrys = contrs;
        
        // 将该控制的字段还原
        BOOL restore = YES;
        if (rrow.selects.count) {// 该选项在控制范围里面，无需将其还原
            for (TFCustomerOptionModel *selOp in rrow.selects) {
                for (TFCustomerOptionModel *conOp in contrs) {
                    if ([selOp.label isEqualToString:conOp.label]) {
                        restore = NO;
                        break;
                    }
                }
            }
        }
        if (restore) {
            
            [self restoreHiddenWithModel:rrow];
            // 选项还原
            [self restoreOptionWithModel:rrow];
            rrow.fieldValue = nil;
            rrow.selects = nil;
        }
        
        // 将该选项的默认值展示出来
        if (rrow.field.defaultEntrys.count && rrow.selects.count == 0) {
            
            NSMutableArray *rrowArrs = [NSMutableArray array];
            for (TFCustomerOptionModel *rrowOp in rrow.controlEntrys) {
                for (TFCustomerOptionModel *derrowOp in rrow.field.defaultEntrys) {
                    
                    if ([rrowOp.label isEqualToString:derrowOp.label]) {
                        derrowOp.open = @1;
                        rrowOp.open = @1;
                        [rrowArrs addObject:derrowOp];
                    }
                }
            }
            rrow.selects = rrowArrs;
        }
    }
    
}

/** 给某个组件赋值 */
- (void)customerRowsModel:(TFCustomerRowsModel *)model WithDict:(NSDictionary *)dict{
    
    
        if ([model.type isEqualToString:@"picklist"] || [model.type isEqualToString:@"multi"]) {
            
            
            NSMutableArray *selects = [NSMutableArray array];
            NSString *str = @"";
            if ([[dict valueForKey:model.name] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary *di in [dict valueForKey:model.name]) {
                    
                    if ([di valueForKey:@"label"] && ![[di valueForKey:@"label"] isEqualToString:@""]) {
                        
                        for (TFCustomerOptionModel *option in model.entrys) {
                            
                            if ([option.label isEqualToString:[di valueForKey:@"label"]]) {
                                
                                option.open = @1;
                                [selects addObject:option];
                                break;
                            }
                        }
                    }
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[di valueForKey:@"label"]]];
                }
                
                if (str.length) {
                    model.fieldValue = [str substringToIndex:str.length-1];
                }
                
                // 若该组件现在的选项隐藏了某组件，那么在改变选项之前，要将该选项隐藏的组件显示出来
                [self restoreHiddenWithModel:model];
                
                model.selects = selects;
                
                // 选项控制
                if (selects.count) {
                    TFCustomerOptionModel *option = selects[0];
                    [self relevanceWithOption:option];
                    
                    if (option.hidenFields.count) {
                        
                        // 消除该组件下面的所有下拉控制
                        [self cancelPicklistUnderWithModel:model];
                    }
                }
                
                // 选项是否隐藏组件
                [self optionHiddenWithModel:model];
                
                
            }else{
                model.selects = nil;
                model.fieldValue = [[dict valueForKey:model.name] description];
                for (TFCustomerOptionModel *op in model.entrys) {
                    op.open = nil;
                }
            }
            
        }
        else if ([model.type isEqualToString:@"mutlipicklist"]){// 多级下拉
            
            
            NSMutableArray *selects = [NSMutableArray array];
            NSString *str = @"";
            if ([[dict valueForKey:model.name] isKindOfClass:[NSArray class]]) {
                
                NSInteger i = 0;
                for (NSDictionary *di in [dict valueForKey:model.name]) {
                    
                    if ([di valueForKey:@"label"] && ![[di valueForKey:@"label"] isEqualToString:@""]) {
                        
                        if (i == 0) {
                            
                            for (TFCustomerOptionModel *option in model.entrys) {
                                
                                if ([option.label isEqualToString:[di valueForKey:@"label"]]) {
                                    
                                    option.open = @1;
                                    [selects addObject:option];
                                    break;
                                }
                            }
                        }else{
                            TFCustomerOptionModel *option = selects.lastObject;
                            
                            for (TFCustomerOptionModel *option1 in option.subList) {
                                
                                if ([option1.label isEqualToString:[di valueForKey:@"label"]]) {
                                    
                                    option1.open = @1;
                                    [selects addObject:option1];
                                    break;
                                }
                            }
                            
                        }
                        
                    }
                    
                    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[di valueForKey:@"label"]]];
                    
                    i ++;
                }
                
                if (str.length) {
                    model.fieldValue = [str substringToIndex:str.length-1];
                }
                
                model.selects = selects;
                
                
            }
            else{
                model.selects = nil;
                model.fieldValue = [[dict valueForKey:model.name] description];
                for (TFCustomerOptionModel *op in model.entrys) {
                    op.open = nil;
                }
            }
            
            
        }
        else if ([model.type isEqualToString:@"datetime"]) {
            // 2019.3.14 加的条件
            if ([[dict valueForKey:model.name] isKindOfClass:[NSNumber class]]) {
                model.fieldValue = [HQHelper nsdateToTime:[[dict valueForKey:model.name] longLongValue] formatStr:model.field.formatType];
            }
        }
        else if ([model.type isEqualToString:@"reference"]) {
            
            NSDictionary *relevanceDict = [dict valueForKey:model.name];
            if ([relevanceDict isKindOfClass:[NSDictionary class]]) {
                
                model.fieldValue = [[relevanceDict valueForKey:@"name"] description];
                model.relevanceField.fieldId = [[relevanceDict valueForKey:@"id"] description];
                
            }else if ([relevanceDict isKindOfClass:[NSArray class]]) {
                
                NSArray *ar = (NSArray *)relevanceDict;
                if (ar.count) {
                    NSDictionary *di = ar[0];
                    model.fieldValue = [[di valueForKey:@"name"] description];
                    model.relevanceField.fieldId = [[di valueForKey:@"id"] description];
                }
            }else{
                model.relevanceField.fieldId = nil;
                model.fieldValue = [relevanceDict description];
            }
            
        }
        else if ([model.type isEqualToString:@"identifier"] ||
                 [model.type isEqualToString:@"serialnum"] ) {// 自动编号不进行操作，都用后台返回默认值
            
            if (self.type != 3) {// 详情的时候为已有的
                model.fieldValue = [[dict valueForKey:model.name] description];
            }
            
        }
        else if ([model.type isEqualToString:@"subform"]) {// 子表单处理
            
            NSArray *arr = [dict valueForKey:model.name];
            
            if (arr.count) {
                
                for (NSInteger i = 0 ; i < model.subforms.count; i++) {
                    
                    NSArray *arrs = model.subforms[i];
                    if (i < arr.count) {
                    
                        NSDictionary *dic = arr[i];
                        for (TFCustomerRowsModel *row in arrs) {
                            
                            [self customerRowsModel:row WithDict:dic];
                        }
                    }
                }
            }
            
        }
        else if ([model.type isEqualToString:@"personnel"]) {
            
            if ([model.name containsString:@"ccTo"]) {
                
                
            }else{// 
                
                NSArray *arr = [dict valueForKey:model.name];
                
                if ([arr isKindOfClass:[NSArray class]]) {
                    
                    if (arr.count) {
                        
                        NSMutableArray *selects = [NSMutableArray array];
                        for (NSDictionary *di in arr) {
                            
                            HQEmployModel *emp = [[HQEmployModel alloc] init];
                            emp.id = [di valueForKey:@"id"];
                            emp.employeeName = [di valueForKey:@"name"]?[di valueForKey:@"name"]:[di valueForKey:@"employee_name"];
                            emp.picture = [di valueForKey:@"picture"];
                            emp.photograph = [di valueForKey:@"picture"];
                            [selects addObject:emp];
                            
                        }
                        model.selects = selects;
                        
                        NSString *str = @"";
                        for (HQEmployModel *model in selects) {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",model.employeeName]];
                        }
                        if (str.length) {
                            model.fieldValue = [str substringToIndex:str.length-1];
                        }
                    }
                    
                }
                else{
                    model.selects = nil;
                    model.fieldValue = [[dict valueForKey:model.name] description];
                }
            }
            
        }
        else if ([model.type isEqualToString:@"department"]) {
            
            NSArray *arr = [dict valueForKey:model.name];
            
            if ([arr isKindOfClass:[NSArray class]]) {
                
                if (arr.count) {
                    
                    NSMutableArray *selects = [NSMutableArray array];
                    for (NSDictionary *di in arr) {
                        
                        TFDepartmentModel *emp = [[TFDepartmentModel alloc] init];
                        emp.id = [di valueForKey:@"id"];
                        emp.name = [di valueForKey:@"name"];
                        [selects addObject:emp];
                        
                    }
                    model.selects = selects;
                    
                    NSString *str = @"";
                    for (TFDepartmentModel *model in selects) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",model.name]];
                    }
                    if (str.length) {
                        model.fieldValue = [str substringToIndex:str.length-1];
                    }
                }
                
            }else{
                model.selects = nil;
                model.fieldValue = [[dict valueForKey:model.name] description];
            }
            
        }
        else if ([model.type isEqualToString:@"attachment"] || [model.type isEqualToString:@"resumeanalysis"] || [model.type isEqualToString:@"picture"]){// 图片附件
          
            model.fieldValue = @"";
            
            id objj = [dict valueForKey:model.name];
            if ([objj isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *seles = [NSMutableArray array];
                
                for (NSDictionary *dddd in objj) {
                    
                    TFFileModel *fi = [[TFFileModel alloc] initWithDictionary:dddd error:nil];
                    if (fi) {
                        [seles addObject:fi];
                    }
                }
                
                model.selects = seles;
            }else{
                model.selects = nil;
            }
            
        }
        else if ([model.type isEqualToString:@"number"]){// 数字
            
            NSNumber *num = NUMBER([dict valueForKey:model.name]);
            
            if ([num isKindOfClass:[NSString class]]) {
                NSString *numStr = (NSString *)num;
                if ([numStr floatValue] != 0) {
                    num = @([numStr floatValue]);
                }
            }
            if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
                
//                if ([model.field.numberType isEqualToString:@"2"]) {
//                    num = @([num floatValue] * 100);
//                }
                NSInteger point = [model.field.numberLenth integerValue];
                if (point == 0) {
                    model.fieldValue = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                }else if (point == 1){
                    model.fieldValue = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                }else if (point == 2){
                    model.fieldValue = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                }else if (point == 3){
                    model.fieldValue = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                }else {
                    model.fieldValue = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                }
                if ([model.field.numberType isEqualToString:@"2"]) {
                    
                    if (model.fieldValue.length) {
                        
                        if (self.type == 1) {
                            model.fieldValue = [NSString stringWithFormat:@"%@%@",TEXT(model.fieldValue),@"%"];
                        }else{
                            model.fieldValue = [NSString stringWithFormat:@"%@",TEXT(model.fieldValue)];
                        }
                    }
                }
            }else{
                
                model.fieldValue = [NSString stringWithFormat:@"%ld",[num integerValue]];
            }
            
        }
        else if ([model.type isEqualToString:@"formula"] || [model.type isEqualToString:@"seniorformula"] || [model.type isEqualToString:@"functionformula"] || [model.type isEqualToString:@"citeformula"]){// 公式 高级公式 函数
            
            NSNumber *num = NUMBER([dict valueForKey:model.name]);
            
            if ([num isKindOfClass:[NSString class]]) {
                NSString *numStr = (NSString *)num;
                if ([numStr floatValue] != 0) {
                    num = @([numStr floatValue]);
                }
            }
            
            if ([model.field.numberType isEqualToString:@"0"] || [model.field.numberType isEqualToString:@"2"]) {// 数字和百分比
                
//                if ([model.field.numberType isEqualToString:@"2"]) {
//                    num = @([num floatValue] * 100);
//                }
                NSInteger point = [model.field.decimalLen integerValue];
                if (point == 0) {
                    model.fieldValue = [NSString stringWithFormat:@"%.0lf",[num floatValue]];
                }else if (point == 1){
                    model.fieldValue = [NSString stringWithFormat:@"%.1lf",[num floatValue]];
                }else if (point == 2){
                    model.fieldValue = [NSString stringWithFormat:@"%.2lf",[num floatValue]];
                }else if (point == 3){
                    model.fieldValue = [NSString stringWithFormat:@"%.3lf",[num floatValue]];
                }else {
                    model.fieldValue = [NSString stringWithFormat:@"%.4lf",[num floatValue]];
                }
                if ([model.field.numberType isEqualToString:@"2"]) {
                    
                    if (model.fieldValue.length) {
                        
                        if (self.type == 1) {
                            model.fieldValue = [NSString stringWithFormat:@"%@%@",TEXT(model.fieldValue),@"%"];
                        }else{
                            model.fieldValue = [NSString stringWithFormat:@"%@",TEXT(model.fieldValue)];
                        }
                    }
                }
            }else if ([model.field.numberType isEqualToString:@"4"]){// 日期
                
                model.fieldValue = [HQHelper nsdateToTime:[[dict valueForKey:model.name] longLongValue] formatStr:model.field.chooseType];
            } else{
                
                model.fieldValue = [NSString stringWithFormat:@"%@",[num description]];
            }
            
        }
        else if ([model.type isEqualToString:@"checkbox"]) {
            
            if ([[[dict valueForKey:model.name] description] isEqualToString:@"1"]) {
                
                for (TFCustomerOptionModel *option in model.field.defaultEntrys) {
                    for (TFFieldNameModel *hideName in option.hidenFields) {
                        
                        TFCustomerRowsModel *mo = [self getRowWithName:hideName.name];
                        
                        mo.field.isOptionHidden = nil;
                        mo.field.optionHiddenName = nil;
                    }
                }
            }else{
                
                for (TFCustomerOptionModel *option in model.field.defaultEntrys) {
                    for (TFFieldNameModel *hideName in option.hidenFields) {
                        
                        TFCustomerRowsModel *mo = [self getRowWithName:hideName.name];
                        
                        mo.field.isOptionHidden = @"1";
                        mo.field.optionHiddenName = model.name;
                    }
                }
            }
            
    
        }
        else if ([model.type isEqualToString:@"location"]){
            
            NSDictionary *locaDict = [dict valueForKey:model.name];
            if ([locaDict isKindOfClass:[NSDictionary class]] && locaDict) {
                
                // 此处处理保密字段
                if ([self.isSeasPool isEqualToString:@"1"] && (self.isSeasAdmin == nil ||  [self.isSeasAdmin isEqualToString:@"0"]) && !IsStrEmpty(model.highSeasPool)) {
                    NSArray *poolIds = [model.highSeasPool componentsSeparatedByString:@","];
                    BOOL have = NO;
                    for (NSString *sss in poolIds) {
                        if ([sss isEqualToString:[self.seaPoolId description]]) {
                            have = YES;
                            break;
                        }
                    }
                    if (have) {
                        NSString *ccc = [locaDict valueForKey:@"value"];
                        model.fieldValue = [HQHelper createStarWithNumber:ccc.length];
                        model.secret = @"1";
                    }else{
                        model.fieldValue = [locaDict valueForKey:@"value"];
                    }
                    
                }else{
                    model.fieldValue = [locaDict valueForKey:@"value"];
                }
                
                NSString *str = [NSString stringWithFormat:@"%@",TEXT([[locaDict valueForKey:@"lng"] description])];
                
                if (![str isEqualToString:@""]) {
                    //                if ([locaDict valueForKey:@"lng"] && ![[locaDict valueForKey:@"lng"] isEqualToString:@""]) {
                    
                    NSMutableDictionary *di = [NSMutableDictionary dictionary];
                    
                    [di setObject:[locaDict valueForKey:@"lng"] forKey:@"longitude"];
                    [di setObject:[locaDict valueForKey:@"lat"] forKey:@"latitude"];
                    
                    model.otherDict = di;
                }
                
                
            }
            else{
                model.otherDict = nil;
                model.fieldValue = @"";
            }
            
            
        }
        else if ([model.type isEqualToString:@"phone"]){
            
            NSString *phone = [[dict valueForKey:model.name] description];
            
            // 此处处理保密字段
            if ([self.isSeasPool isEqualToString:@"1"] && (self.isSeasAdmin == nil ||  [self.isSeasAdmin isEqualToString:@"0"]) && !IsStrEmpty(model.highSeasPool)) {
                
                NSArray *poolIds = [model.highSeasPool componentsSeparatedByString:@","];
                BOOL have = NO;
                for (NSString *sss in poolIds) {
                    if ([sss isEqualToString:[self.seaPoolId description]]) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    if (phone.length > 4) {
                        model.fieldValue = [NSString stringWithFormat:@"%@%@",[HQHelper createStarWithNumber:phone.length-4],[phone substringWithRange:(NSRange){phone.length-5,4}]];
                    }else{
                        model.fieldValue = [HQHelper createStarWithNumber:phone.length];
                    }
                    model.secret = @"1";
                }else{
                    model.fieldValue = phone;
                }
            
            }else{
                model.fieldValue = phone;
            }
            
        }
        else if ([model.type isEqualToString:@"email"]){
            
            NSString *phone = [[dict valueForKey:model.name] description];
            // 此处处理保密字段
            if ([self.isSeasPool isEqualToString:@"1"] && (self.isSeasAdmin == nil ||  [self.isSeasAdmin isEqualToString:@"0"]) && !IsStrEmpty(model.highSeasPool)) {
               
                NSArray *poolIds = [model.highSeasPool componentsSeparatedByString:@","];
                BOOL have = NO;
                for (NSString *sss in poolIds) {
                    if ([sss isEqualToString:[self.seaPoolId description]]) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    NSArray *emails = [phone componentsSeparatedByString:@"@"];
                    if (emails.count == 2) {
                        NSString *first = emails.firstObject;
                        model.fieldValue = [NSString stringWithFormat:@"%@%@",[HQHelper createStarWithNumber:first.length],[phone substringFromIndex:first.length]];
                    }else{
                        model.fieldValue = @"";
                    }
                    model.secret = @"1";
                }else{
                    model.fieldValue = phone;
                }
                
            }else{
                model.fieldValue = phone;
            }
        }
        else{
            
            model.fieldValue = [[dict valueForKey:model.name] description];
        }
    
}

/** 处理传递过来的关联值 */
- (void)handleDeliverReference{
    
//    if (self.lastDetailDict == nil || self.relevanceKey == nil) {
//        return;
//    }
    if (self.lastDetailDict == nil) {
        return;
    }
    NSArray *refers = [self getReferenceRows];
    
    for (TFCustomerRowsModel *model in refers) {
        
//        if ([self.relevanceKey isEqualToString:model.name]) {
        
            model.relevanceField.fieldId = [self.dataId description];
            model.fieldValue = [[self.lastDetailDict valueForKey:model.relevanceField.fieldName] description];
//        }
        
    }
    
    NSString *str = [HQHelper dictionaryToJson:self.lastDetailDict];
    [self.customBL requestReferanceReflectWithSorceBean:self.sorceBean targetBean:self.targetBean detailJson:str];
}

/** 增加检验布局 */
- (TFCustomerLayoutModel *)addCheckLayout{
    
    TFCustomerLayoutModel *model = [[TFCustomerLayoutModel alloc] init];
    model.level = [NSString stringWithFormat:@"1111"];
    model.terminalApp = @"1";
    model.isSpread = @"0";
    NSMutableArray<TFCustomerRowsModel,Optional> *mos = [NSMutableArray<TFCustomerRowsModel,Optional> array];
    
    TFCustomerRowsModel *row = [[TFCustomerRowsModel alloc] init];
    
    row.label = @"检验";
    row.name = @"checkStatus";
    row.type = @"checkbox";
    
    TFCustomerFieldModel *field = [[TFCustomerFieldModel alloc] init];
    field.detailView = @"1";
    field.terminalApp = @"1";
    
    NSMutableArray<Optional,TFCustomerOptionModel> *defaultEntrys = [NSMutableArray<Optional,TFCustomerOptionModel> array];
    TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
    
    NSMutableArray <Optional,TFFieldNameModel> *hidenFields = [NSMutableArray<Optional,TFFieldNameModel> array];
    TFFieldNameModel *fi = [[TFFieldNameModel alloc] init];
    fi.name = @"checkMember";
    fi.label = @"检验人";
    
    [hidenFields addObject:fi];
    op.hidenFields = hidenFields;
    [defaultEntrys addObject:op];
    field.defaultEntrys = defaultEntrys;
    row.field = field;
    
    [mos addObject:row];
    
    
    TFCustomerRowsModel *row1 = [[TFCustomerRowsModel alloc] init];
    row1.label = @"检验人";
    row1.name = @"checkMember";
    row1.type = @"personnel";
    
    TFCustomerFieldModel *field1 = [[TFCustomerFieldModel alloc] init];
    field1.detailView = @"1";
    field1.terminalApp = @"1";
    row1.field = field1;
    [mos addObject:row1];
    
    model.rows = mos;
    
    return model;
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
