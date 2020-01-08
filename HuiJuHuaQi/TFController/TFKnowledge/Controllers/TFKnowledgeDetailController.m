//
//  TFKnowledgeDetailController.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeDetailController.h"
#import "TFKnowledgeDetailHeader.h"
#import "TFCustomAttributeTextOldCell.h"
#import "TFProjectApprovalCell.h"
#import "TFProjectTaskItemCell.h"
#import "TFProjectNoteCell.h"
#import "TFNewProjectCustomCell.h"
#import "TFCustomAttachmentsOldCell.h"
#import "TFProjectRowFrameModel.h"
#import "HuiJuHuaQi-Swift.h"
#import "TFKnowledgeAnswerCell.h"
#import "TFCommentTableView.h"
#import "TFKnowledgeBL.h"
#import "IQKeyboardManager.h"
#import "LiuqsEmoticonKeyBoard.h"
#import "ZYQAssetPickerController.h"
#import "TFMutilStyleSelectPeopleController.h"
#import "TFFileMenuController.h"
#import "TFFolderListModel.h"
#import "TFCustomerCommentModel.h"
#import "TFPlayVoiceController.h"
#import "KSPhotoBrowser.h"
#import "TFKnowledgePeopleController.h"
#import "TFKnowledgeVersionController.h"
#import "TFCategoryMoveController.h"
#import "TFCreateKnowledgeController.h"
#import "PopoverView.h"
#import "TFKnowledgeBL.h"
#import "TFKnowledgeItemModel.h"
#import "TFCustomBL.h"
#import "TFKnowledgeVersionModel.h"
#import "TFApprovalListItemModel.h"
#import "TFApprovalDetailController.h"
#import "TFProjectTaskDetailController.h"
#import "TFCreateNoteController.h"
#import "TFNewCustomDetailController.h"
#import "MWPhotoBrowser.h"
#import "TFEmailsDetailController.h"
#import "TFKnowledgeVideoCell.h"
#import "TFVideoModel.h"
#import "TFNewProjectTaskItemCell.h"

@interface TFKnowledgeDetailController ()<UITableViewDelegate,UITableViewDataSource,TFKnowledgeSectionViewDelegate,TFCommentTableViewDelegate,LiuqsEmotionKeyBoardDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,KSPhotoBrowserDelegate,UIDocumentInteractionControllerDelegate,TFKnowledgeDetailHeaderDelegate,TFKnowledgeAnswerSectionViewDelegate,HQBLDelegate,TFCustomAttributeTextOldCellDelegate,MWPhotoBrowserDelegate,TFCustomAttachmentsOldCellDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFKnowledgeDetailHeader *detailHeader;
/** 任务s */
@property (nonatomic, strong) NSMutableArray *tasks;
/** 审批s */
@property (nonatomic, strong) NSMutableArray *approvals;
/** 邮件s */
@property (nonatomic, strong) NSMutableArray *emails;
/** 备忘录s */
@property (nonatomic, strong) NSMutableArray *notes;
/** 自定义s */
@property (nonatomic, strong) NSMutableArray *customs;
/** 附件s */
@property (nonatomic, strong) NSMutableArray *files;
/** 回答s */
@property (nonatomic, strong) NSMutableArray *answers;
/** 评论s */
@property (nonatomic, strong) NSMutableArray *comments;
/** 查看图片s */
@property (nonatomic, strong) NSMutableArray *images;
/** @的成员s */
@property (nonatomic, strong) NSMutableArray *peoples;
/** commentTable */
@property (nonatomic, strong) TFCommentTableView *commentTable;
/** 键盘 */
@property(nonatomic, strong) LiuqsEmoticonKeyBoard *keyboard;
/** jump */
@property (nonatomic, assign) NSInteger jump;
/** 当前评论的评论 */
@property (nonatomic, strong) TFCustomerCommentModel *commentModel;
/** 请求 */
@property (nonatomic, strong) TFKnowledgeBL *knowledgeBL;
/** sectionView */
@property (nonatomic, strong)  TFKnowledgeSectionView *sectionView;
/** 权限 0：成员， 1：创建人， 2：管理员 */
@property (nonatomic, assign) NSInteger auth;
/** 评论 */
@property (nonatomic, strong) TFCustomBL *customBL;
@property (nonatomic, copy) NSString *bean;
/** 选择的版本 */
@property (nonatomic, strong) TFKnowledgeVersionModel *selectVersion;
@property (nonatomic, assign) CGFloat multiTextHeight;

@property (nonatomic, strong) TFCustomerRowsModel *multiTextRow;
@property (nonatomic, strong) TFCustomerRowsModel *fileRow;


@property (nonatomic, strong) NSNumber *roleType;
@property (nonatomic, strong) NSMutableArray *videos;

@end

@implementation TFKnowledgeDetailController

-(NSMutableArray *)videos{
    if (!_videos) {
        _videos = [NSMutableArray array];
    }
    return _videos;
}

-(NSMutableArray *)images{
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(NSMutableArray *)tasks{
    if (!_tasks) {
        _tasks = [NSMutableArray array];
    }
    return _tasks;
}

-(NSMutableArray *)approvals{
    if (!_approvals) {
        _approvals = [NSMutableArray array];
    }
    return _approvals;
}
-(NSMutableArray *)emails{
    if (!_emails) {
        _emails = [NSMutableArray array];
    }
    return _emails;
}
-(NSMutableArray *)notes{
    if (!_notes) {
        _notes = [NSMutableArray array];
    }
    return _notes;
}
-(NSMutableArray *)customs{
    if (!_customs) {
        _customs = [NSMutableArray array];
    }
    return _customs;
}

-(NSMutableArray *)files{
    if (!_files) {
        _files = [NSMutableArray array];
    }
    return _files;
}

-(NSMutableArray *)answers{
    if (!_answers) {
        _answers = [NSMutableArray array];
    }
    return _answers;
}
-(NSMutableArray *)comments{
    if (!_comments) {
        _comments = [NSMutableArray array];
    }
    return _comments;
}
-(NSMutableArray *)peoples{
    if (!_peoples) {
        _peoples = [NSMutableArray array];
    }
    return _peoples;
}

-(TFCustomerRowsModel *)multiTextRow{
    if (!_multiTextRow) {
        _multiTextRow = [[TFCustomerRowsModel alloc] init];
    }
    return _multiTextRow;
}
-(TFCustomerRowsModel *)fileRow{
    if (!_fileRow) {
        _fileRow = [[TFCustomerRowsModel alloc] init];
    }
    return _fileRow;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = NO;
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    IQKeyboardManager *keyBoard = [IQKeyboardManager sharedManager];
    keyBoard.enable = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customBL = [TFCustomBL build];
    self.customBL.delegate = self;
    self.knowledgeBL = [TFKnowledgeBL build];
    self.knowledgeBL.delegate = self;
    self.roleType = [[NSUserDefaults standardUserDefaults] objectForKey:@"RoleType"];
    
    [self setupDetailHeader];
    [self setupTableView];
    
    if (self.answer == NO) {
        
        self.bean = @"repository_libraries";
        [self setupSectionView];
        [self setupCommentView];
        
        self.keyboard = [LiuqsEmoticonKeyBoard showKeyBoardInView:self.view type:1];
        self.keyboard.textView.placeholder = @"说点什么吧...";
        self.keyboard.delegate = self;
        [self.keyboard hideKeyBoard];
        
        [self.knowledgeBL requestGetKnowledgeDetailWithKnowledgeId:self.dataId];// 详情
        [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.dataId fromStatus:@0];// 引用
    }else{
        
        self.bean = @"repository_answer";
        [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.knowledgeDetail.id fromStatus:@1];// 引用
        
        self.knowledgeDetail.type_status = @"2";
        [self.files addObjectsFromArray:self.knowledgeDetail.repository_answer_attachment];
        self.fileRow.selects = [NSMutableArray arrayWithArray:self.knowledgeDetail.repository_answer_attachment];
        
        self.tableView.hidden = NO;
        self.detailHeader.hidden = NO;
        [self handAuth];// 处理权限
        
        [self.detailHeader refreshKnowledgeDetailHeaderWithModel:self.knowledgeDetail type:[self.knowledgeDetail.type_status integerValue] auth:self.auth];
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight+8, 0, 44, 0);
        [self.tableView setContentOffset:(CGPoint){0,-(self.detailHeader.selfHeight+8)}];
        
        [self.tableView reloadData];
        
    }
    
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menuClicked) image:@"菜单" highlightImage:@"菜单"];
    
}

-(void)setupSectionView{
    
    TFKnowledgeSectionView *view = [[TFKnowledgeSectionView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
    view.delegate = self;
    self.sectionView = view;
}

#pragma mark - TFKnowledgeSectionViewDelegate
-(void)knowledgeSectionViewClickedWithIndex:(NSInteger)index{
    
    TFKnowledgePeopleController *people = [[TFKnowledgePeopleController alloc] init];
    people.type = index;
    people.dataId = self.dataId;
    [self.navigationController pushViewController:people animated:YES];
    
}

- (void)menuClicked{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"版本管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TFKnowledgeVersionController *version = [[TFKnowledgeVersionController alloc] init];
        version.dataId = self.dataId;
        version.model = self.selectVersion;
        version.parameter = ^(TFKnowledgeVersionModel *parameter) {
            self.knowledgeDetail.content = parameter.content;
            self.selectVersion = parameter;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:version animated:YES];
    }];
    
        
    UIAlertAction *act2 = [UIAlertAction actionWithTitle:@"移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TFCategoryMoveController *move = [[TFCategoryMoveController alloc] init];
        move.dataId = self.dataId;
        move.refresh = ^{
            [self.knowledgeBL requestGetKnowledgeDetailWithKnowledgeId:self.dataId];
        };
        [self.navigationController pushViewController:move animated:YES];
    }];
    
    
    UIAlertAction *act3 = [UIAlertAction actionWithTitle:@"编辑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (self.answer) {
            // 构造编辑数据
            TFCreateKnowledgeModel *model = [[TFCreateKnowledgeModel alloc] init];
            model.content.fieldValue = self.knowledgeDetail.content;
            model.type = 2;
            // 附件
            model.files.selects = [NSMutableArray arrayWithArray:self.knowledgeDetail.repository_answer_attachment];;
            // 引用
            [model.approvals addObjectsFromArray:self.approvals];
            [model.notes addObjectsFromArray:self.notes];
            [model.emails addObjectsFromArray:self.emails];
            [model.tasks addObjectsFromArray:self.tasks];
            [model.customs addObjectsFromArray:self.customs];
           
            TFCreateKnowledgeController *create = [[TFCreateKnowledgeController alloc] init];
            create.edit = 1;
            create.parentId = self.dataId;
            create.dataId = self.knowledgeDetail.id;
            create.type = [self.knowledgeDetail.type_status integerValue];
            create.knowledge = model;
            create.refresh = ^{
                [self.knowledgeBL requestAnwserDetailWithDataId:self.knowledgeDetail.id];
                if (self.answer == NO) {
                    [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.dataId fromStatus:@0];// 引用
                }else{
                    [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.knowledgeDetail.id fromStatus:@1];// 引用
                }
            };
            [self.navigationController pushViewController:create animated:YES];
        }else{
            // 构造编辑数据
            TFCreateKnowledgeModel *model = [[TFCreateKnowledgeModel alloc] init];
            model.type = [self.knowledgeDetail.type_status integerValue];
            if (model.type == 1) {
                model.content.field.fieldControl = @"0";
                model.content.label = @"描述";
            }
            model.title.fieldValue = self.knowledgeDetail.title;
            model.content.fieldValue = self.knowledgeDetail.content;
            // 分类
            NSMutableArray *cates = [NSMutableArray array];
            TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
            option.value = self.knowledgeDetail.classification_id;
            option.label = self.knowledgeDetail.classification_name;
            [cates addObject:option];
            model.category.selects =cates;
            // 标签
            NSMutableArray *labels = [NSMutableArray array];
            for (TFCategoryModel *mo in self.knowledgeDetail.label_ids) {
                TFCustomerOptionModel *oo = [[TFCustomerOptionModel alloc] init];
                oo.value = [mo.id description];
                oo.label = mo.name;
                [labels addObject:oo];
            }
            model.labels.selects = labels;
            // 附件
            model.files.selects = [NSMutableArray arrayWithArray:self.knowledgeDetail.repository_answer_attachment];
            // 引用
            [model.approvals addObjectsFromArray:self.approvals];
            [model.notes addObjectsFromArray:self.notes];
            [model.emails addObjectsFromArray:self.emails];
            [model.tasks addObjectsFromArray:self.tasks];
            [model.customs addObjectsFromArray:self.customs];


            
            
            TFCreateKnowledgeController *create = [[TFCreateKnowledgeController alloc] init];
            create.edit = 1;
            create.dataId = self.dataId;
            create.type = [self.knowledgeDetail.type_status integerValue];
            create.knowledge = model;
            create.refresh = ^{
                [self.knowledgeBL requestGetKnowledgeDetailWithKnowledgeId:self.dataId];
                if (self.answer == NO) {
                    [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.dataId fromStatus:@0];// 引用
                }else{
                    [self.knowledgeBL requestKnowledgeReferanceListWithKnowledgeId:self.knowledgeDetail.id fromStatus:@1];// 引用
                }
            };
            [self.navigationController pushViewController:create animated:YES];
        }
        
    }];

// 设置action字体颜色
//    [act3 setValue:BlackTextColor forKey:@"titleTextColor"];

    UIAlertAction *act4 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIAlertController *alert22 = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后不可恢复，你确定要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *act22 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert22 addAction:act22];
        
        UIAlertAction *cancel22 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            // 此处删除
            if (self.answer) {
                
                [self.knowledgeBL requestAnwserDeleteWithDataId:self.knowledgeDetail.id];
            }else{
                
                [self.knowledgeBL requesDeleteKnowledgeWithKnowledgeId:[self.dataId description]];
            }
            
        }];
        [alert22 addAction:cancel22];
        [self presentViewController:alert22 animated:YES completion:nil];
    }];
    
    UIAlertAction *act5 = [UIAlertAction actionWithTitle:[self.knowledgeDetail.top isEqualToNumber:@1]?@"取消置顶":@"置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        if ([self.knowledgeDetail.type_status integerValue] == 0 || [self.knowledgeDetail.type_status integerValue] == 1) {// 知识和提问
            [self.knowledgeBL requestKnowledgeTopWithDataId:self.knowledgeDetail.id top:[self.knowledgeDetail.top isEqualToNumber:@1]?@0:@1];
            self.knowledgeDetail.top = [self.knowledgeDetail.top isEqualToNumber:@1]?@0:@1;
            
        }else{// 回答
            // 置顶操作
            [self.knowledgeBL requestAnwserTopWithDataId:self.knowledgeDetail.id status:[self.knowledgeDetail.top isEqualToNumber:@1]?@0:@1];
            self.knowledgeDetail.top = [self.knowledgeDetail.top isEqualToNumber:@1]?@0:@1;
        }
    }];
    
    // action 1:版本管理， 2:移动， 3:编辑， 4:删除 5：置顶
    /** 0:知识 1:提问 2:回答 */
    if ([self.knowledgeDetail.type_status integerValue] == 0) {
        
        [alert addAction:act1];
        if (self.auth > 0 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {// 分类创建者、管理员 || 系统管理员3 || 企业所有者2
            [alert addAction:act2];
            [alert addAction:act3];
        }
        if (self.auth > 1 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {
            [alert addAction:act4];
        }
        if (self.auth == 2 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {// 分类管理员 || 系统管理员3 || 企业所有者2
            
            [alert addAction:act5];
        }
        
    }else if ([self.knowledgeDetail.type_status integerValue] == 1){
    
        if (self.auth > 0 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {
            [alert addAction:act2];
            [alert addAction:act3];
        }
        if (self.auth > 1 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {
            [alert addAction:act4];
        }
        if (self.auth == 2 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {// 分类管理员 || 系统管理员3 || 企业所有者2
            
            [alert addAction:act5];
        }
        
    }else{
        
        if (self.auth > 0 || [self.roleType integerValue] == 3 || [self.roleType integerValue] == 2) {
            [alert addAction:act5];
            [alert addAction:act3];
            [alert addAction:act4];
        }
    }
    
//    [alert addAction:act1];
//    [alert addAction:act2];
//    [alert addAction:act3];
//    [alert addAction:act4];
    
    if (alert.actions.count == 0) {
        [MBProgressHUD showError:@"无可操作项" toView:self.view];
        return;
    }

    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

/** 添加评论View */
- (void)setupCommentView{
    
    TFCommentTableView *commentTable = [[TFCommentTableView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,0}];
    self.commentTable = commentTable;
    commentTable.delegate = self;
    [commentTable refreshCommentTableViewWithDatas:self.comments];
    [self.customBL requestCustomModuleCommentListWithBean:self.bean dataId:self.dataId];// 评论数据
}
#pragma mark - TFCommentTableViewDelegate
-(void)commentTableView:(TFCommentTableView *)commentTableView didChangeHeight:(CGFloat)height{
    self.commentTable.height = height;
    self.tableView.tableFooterView = self.commentTable;
}

-(void)commentTableViewDidClickVioce:(TFFileModel *)model{
    
    TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
    play.file = model;
    [self.navigationController pushViewController:play animated:YES];
    
}

-(void)commentTableViewDidClickImage:(UIImageView *)imageView{
    
    NSMutableArray *items = @[].mutableCopy;
    KSPhotoItem *item = [KSPhotoItem itemWithSourceView:imageView image:imageView.image];
    [items addObject:item];
    
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:items selectedIndex:0];
    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = NO;
    [browser showFromViewController:self];
    
}

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index {
    HQLog(@"selected index: %lu", (unsigned long)index);
}

- (void)commentTableViewDidClickFile:(TFFileModel *)model{
    
    if ([[model.file_type lowercaseString] isEqualToString:@"jpg"] || [[model.file_type lowercaseString] isEqualToString:@"png"] || [[model.file_type lowercaseString] isEqualToString:@"gif"] || [[model.file_type lowercaseString] isEqualToString:@"jpeg"]) {// 查看图片
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = self.view.center;
        
        
        [self commentTableViewDidClickImage:view];
        
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
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
    }
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


/** 头部 */
-(void)setupDetailHeader{
    
    TFKnowledgeDetailHeader *header = [TFKnowledgeDetailHeader knowledgeDatailHeader];
    self.detailHeader = header;
    header.delegate = self;
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    header.hidden = YES;
    [self.view addSubview:self.detailHeader];
}
#pragma mark - TFKnowledgeDetailHeaderDelegate
-(void)knowledgeDetailHeaderDidGood:(UIButton *)button{
    
    [self.knowledgeBL requestGoodWithKnowledgeId:self.dataId goodStatus:button.selected?@0:@1];
    self.knowledgeDetail.alreadyprasing = button.selected?@1:@0;
    if (button.selected) {
        self.knowledgeDetail.praisecount = @([self.knowledgeDetail.praisecount integerValue] + 1);
    }else{
        self.knowledgeDetail.praisecount = @([self.knowledgeDetail.praisecount integerValue] - 1);
    }
    [self.sectionView refreshNumWithSee:[self.knowledgeDetail.readcount integerValue] star:[self.knowledgeDetail.collectioncount integerValue] good:[self.knowledgeDetail.praisecount integerValue] learn:[self.knowledgeDetail.studycount integerValue]];
}
-(void)knowledgeDetailHeaderDidStar:(UIButton *)button{
    
    [self.knowledgeBL requestCollectionWithKnowledgeId:self.dataId collectStatus:button.selected?@0:@1];
    self.knowledgeDetail.alreadycollecting = button.selected?@1:@0;
    if (button.selected) {
        self.knowledgeDetail.collectioncount = @([self.knowledgeDetail.collectioncount integerValue] + 1);
    }else{
        self.knowledgeDetail.collectioncount = @([self.knowledgeDetail.collectioncount integerValue] - 1);
    }
    [self.sectionView refreshNumWithSee:[self.knowledgeDetail.readcount integerValue] star:[self.knowledgeDetail.collectioncount integerValue] good:[self.knowledgeDetail.praisecount integerValue] learn:[self.knowledgeDetail.studycount integerValue]];
}
-(void)knowledgeDetailHeaderDidLearn:(UIButton *)button{
    
    NSString *str = @"如果你已经学习完该知识，请点击“确定”按钮，系统会将你的学习状态标记下来，以便管理员查询员工学习记录。";
    if ([[self.knowledgeDetail.alreadystudying description] isEqualToString:@"1"]) {
        str = @"确定要取消学习记录吗？";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        button.selected = !button.selected;
        [self.knowledgeBL requestSureLearnWithKnowledgeId:self.dataId learnStatus:button.selected?@0:@1];
        self.knowledgeDetail.alreadystudying = button.selected?@1:@0;
        if (button.selected) {
            self.knowledgeDetail.studycount = @([self.knowledgeDetail.studycount integerValue] + 1);
        }else{
            self.knowledgeDetail.studycount = @([self.knowledgeDetail.studycount integerValue] - 1);
        }
        [self.sectionView refreshNumWithSee:[self.knowledgeDetail.readcount integerValue] star:[self.knowledgeDetail.collectioncount integerValue] good:[self.knowledgeDetail.praisecount integerValue] learn:[self.knowledgeDetail.studycount integerValue]];
        
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)knowledgeDetailHeaderDidAnswer{
    TFCreateKnowledgeController *create = [[TFCreateKnowledgeController alloc] init];
    create.type = 2;
    create.edit = 0;
    create.parentId = self.dataId;
    create.refresh = ^{
        [self.knowledgeBL requestAnwserListWithDataId:self.dataId orderBy:@"create_time"];
    };
    [self.navigationController pushViewController:create animated:YES];
}
-(void)knowledgeDetailHeaderDidInvite{
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = NO;
//    scheduleVC.defaultPoeples = model.selects;
    //            scheduleVC.noSelectPoeples = model.selects;
    scheduleVC.actionParameter = ^(NSArray *parameter) {
        
        NSString *str = @"";
        for (HQEmployModel *em in parameter) {
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@、",em.employee_name?:em.employeeName]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length - 1];
        }
        // 邀请回答
        [self.knowledgeBL requestInvitePeopleToAnswerWithDataId:self.dataId employeeIds:str ];
        
    };
    [self.navigationController pushViewController:scheduleVC animated:YES];
    
}

#pragma mark - 初始化tableView
- (void)setupTableView
{
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NaviHeight) style:UITableViewStyleGrouped];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight + 8, 0, 44, 0);
    tableView.backgroundColor = BackGroudColor;
    tableView.tag = 0x3344;
    [self.view insertSubview:tableView atIndex:0];
    self.tableView = tableView;
    tableView.hidden = YES;
}
#pragma mark - tableView 数据源及代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1 + self.videos.count;
    }else if (section == 1){
        return self.approvals.count;
    }else if (section == 2){
        return self.tasks.count;
    }else if (section == 3){
        return self.emails.count;
    }else if (section == 4){
        return self.notes.count;
    }else if (section == 5){
        return self.customs.count;
    }else if (section == 6){
        return self.files.count > 0 ? 1 : 0;
    }else if (section == 7){
        return self.answers.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {// 富文本
        if (indexPath.row == 0) {
            TFCustomAttributeTextOldCell *cell = [TFCustomAttributeTextOldCell customAttributeTextCellWithTableView:tableView type:1 index:indexPath.section * 0x11 + indexPath.row];
            cell.tag = 0x777 *indexPath.section + indexPath.row;
            cell.title = @"";
            cell.fieldControl = @"0";
            [cell reloadDetailContentWithContent:self.knowledgeDetail.content];
            cell.showEdit = NO;
            cell.delegate = self;
            cell.model = self.multiTextRow;
            return cell;
        }else{
            TFKnowledgeVideoCell *cell = [TFKnowledgeVideoCell knowledgeVideoCellWithTableView:tableView];
            [cell refreshVideoCellWithModel:self.videos[indexPath.row-1]];
            return cell;
        }
    }else if (indexPath.section == 1){// 审批
        
        TFProjectApprovalCell *cell = [TFProjectApprovalCell projectApprovalCellWithTableView:tableView];
        cell.frameModel = self.approvals[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.tag = indexPath.row;
        cell.edit = NO;
//        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 2){// 任务
        
//        TFProjectTaskItemCell *cell = [TFProjectTaskItemCell projectTaskItemCellWithTableView:tableView];
//        cell.frameModel = self.tasks[indexPath.row];
//        cell.hidden = NO;
//        cell.knowledge = YES;
//        cell.edit = NO;
//        cell.tag = indexPath.row;
////        cell.delegate = self;
//        return cell;
        TFNewProjectTaskItemCell *cell = [TFNewProjectTaskItemCell newProjectTaskItemCellWithTableView:tableView];
        [cell refreshNewProjectTaskItemCellWithModel:self.tasks[indexPath.row] haveClear:NO];
        cell.backgroundColor = WhiteColor;
        cell.contentView.backgroundColor = WhiteColor;
        return cell;
        
        
    }else if (indexPath.section == 3){// 邮件
        
        static NSString *ID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.masksToBounds = YES;
        }
        cell.textLabel.text = @"我是邮件卡片";
        return cell;
        
    }else if (indexPath.section == 4){// 备忘录
        
        TFProjectNoteCell *cell = [TFProjectNoteCell projectNoteCellWithTableView:tableView];
        cell.frameModel = self.notes[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.tag = indexPath.row;
        cell.edit = NO;
//        cell.delegate = self;
        return cell;
    }else if (indexPath.section == 5){// 自定义
        
        TFNewProjectCustomCell *cell = [TFNewProjectCustomCell newProjectCustomCellWithTableView:tableView];
        cell.frameModel = self.customs[indexPath.row];
        cell.hidden = NO;
        cell.knowledge = YES;
        cell.edit = NO;
//        cell.delegate = self;
        cell.tag = indexPath.row;
        return cell;
    }else if (indexPath.section == 6){// 附件
        
        TFCustomAttachmentsOldCell *cell = [TFCustomAttachmentsOldCell CustomAttachmentsCellWithTableView:tableView];
        cell.tag = 0x777 *indexPath.section + indexPath.row;
        cell.delegate = self;
        cell.title = @"附件：";
        cell.fieldControl = @"0";
        cell.type = AttachmentsCellDetail;
        cell.showEdit = YES;
        cell.model = self.fileRow;
        return cell;
        
    }else if (indexPath.section == 7){// 回答
        
        TFKnowledgeAnswerCell *cell = [TFKnowledgeAnswerCell knowledgeAnswerCellWithTableView:tableView];
        [cell refreshKnowledgeAnswerCellWithModel:self.answers[indexPath.row]];
        return cell;
    }
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.layer.masksToBounds = YES;
    }
    cell.textLabel.text = @"eeeeeeeeeeeeeeeeeeeee";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1){// 审批
        
        TFProjectRowFrameModel *frame = self.approvals[indexPath.row];
        TFProjectRowModel *model = frame.projectRow;
        
        TFApprovalListItemModel *approval = [[TFApprovalListItemModel alloc] init];
        approval.id = model.id;
        approval.task_id = [model.task_id description];
        approval.task_key = model.task_key;
        approval.task_name = model.task_name;
//        approval.approval_data_id = model.approval_data_id;
        approval.approval_data_id = [model.bean_id description];
        approval.module_bean = model.module_bean;
        approval.begin_user_name = model.begin_user_name;
        approval.begin_user_id = model.begin_user_id;
        approval.process_definition_id = model.process_definition_id;
        approval.process_key = model.process_key;
        approval.process_name = model.process_name;
        approval.process_status = model.process_status;
        approval.status = model.status;
        approval.process_field_v = model.process_field_v;
        
        TFApprovalDetailController *detail = [[TFApprovalDetailController alloc] init];
        detail.approvalItem = approval;
        detail.listType = 1;
        [self.navigationController pushViewController:detail animated:YES];
    }else if (indexPath.section == 2){// 任务
//        TFProjectRowFrameModel *frame = self.tasks[indexPath.row];
        TFProjectRowModel *model = self.tasks[indexPath.row];

        TFProjectTaskDetailController *detail = [[TFProjectTaskDetailController alloc] init];
        detail.projectId = model.projectId;
        if ([model.from isEqualToNumber:@1]) {// 个人任务
            if (model.task_id) {// 子任务
                detail.taskType = 3;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 2;
            }
        }else{// 项目任务
            if (model.task_id) {// 子任务
                detail.taskType = 1;
                detail.parentTaskId = model.task_id;
            }else{// 主任务
                detail.taskType = 0;
            }
        }
//        detail.dataId = model.taskInfoId;
        detail.dataId = model.bean_id;
        detail.action = ^(id parameter) {
            
            model.complete_status = parameter;
            model.finishType = parameter;
//            [self.moveView refreshData];
        };
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if (indexPath.section == 3){// 邮件
        TFProjectRowFrameModel *frame = self.emails[indexPath.row];
        TFProjectRowModel *model = frame.projectRow;
        
        TFEmailReceiveListModel *email = [[TFEmailReceiveListModel alloc] init];
        email.mail_box_id = model.mail_box_id;
        email.id = model.id;
        
        TFEmailsDetailController *emailsDetaiVC = [[TFEmailsDetailController alloc] init];
        emailsDetaiVC.model = email;
        emailsDetaiVC.emailId = model.id;
        emailsDetaiVC.boxId = model.mail_box_id;
        emailsDetaiVC.refresh = ^{
            
        };
        [self.navigationController pushViewController:emailsDetaiVC animated:YES];
        
    }else if (indexPath.section == 4){// 备忘录
        TFProjectRowFrameModel *frame = self.notes[indexPath.row];
        TFProjectRowModel *model = frame.projectRow;

        TFCreateNoteController *note = [[TFCreateNoteController alloc] init];
        note.type = 1;
//        note.noteId = model.id;
        note.noteId = model.bean_id;
        [self.navigationController pushViewController:note animated:YES];
        
    }else if (indexPath.section == 5){// 自定义
        
        TFProjectRowFrameModel *frame = self.customs[indexPath.row];
        TFProjectRowModel *model = frame.projectRow;
        
        TFNewCustomDetailController *detail = [[TFNewCustomDetailController alloc] init];
        detail.bean = model.bean_name;
        detail.dataId = model.bean_id;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }
//    else if (indexPath.section == 6){// 附件
//
//        [self seeFileWithFileModel:self.files[indexPath.row] withRows:self.fileRow withIndex:indexPath.row];
//    }
    
    if (indexPath.section == 7) {
        
        TFKnowledgeItemModel *model = self.answers[indexPath.row];
        model.title = self.knowledgeDetail.title;
        
        TFKnowledgeDetailController *detail = [[TFKnowledgeDetailController alloc] init];
        detail.answer = YES;
        detail.dataId = self.dataId;
        detail.knowledgeDetail = model;
        detail.refreshAction = ^(TFKnowledgeItemModel *parameter) {
            
            [self.answers replaceObjectAtIndex:indexPath.row withObject:parameter];
            [tableView reloadData];
        };
        detail.deleteAction = ^{
            [self.answers removeObjectAtIndex:indexPath.row];
            [tableView reloadData];
        };
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {// 富文本
        if (indexPath.row == 0) {
            return self.multiTextHeight;
        }else{
            return (SCREEN_WIDTH - 30)*9/16 + 40;
        }
    }else if (indexPath.section == 1){// 审批s
        TFProjectRowFrameModel *frame = self.approvals[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 2){// 任务s
        TFProjectRowModel *frame = self.tasks[indexPath.row];
        return [frame.cellHeight floatValue];
    }else if (indexPath.section == 3){// 邮件s
        TFProjectRowFrameModel *frame = self.emails[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 4){// 备忘录s
        TFProjectRowFrameModel *frame = self.notes[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 5){// 自定义s
        TFProjectRowFrameModel *frame = self.customs[indexPath.row];
        return frame.cellHeight;
    }else if (indexPath.section == 6){// 附件s
        if (self.files.count) {
            return [TFCustomAttachmentsOldCell refreshCustomAttachmentsCellHeightWithFiles:self.files];
        }else{
            return 0;
        }
    }else if (indexPath.section == 7){
        return [TFKnowledgeAnswerCell refreshAnswerHeightWithModel:self.answers[indexPath.row]];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 7) {
        
        if ([self.knowledgeDetail.type_status isEqualToString:@"1"]) {
            TFKnowledgeAnswerSectionView *view = [[TFKnowledgeAnswerSectionView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
            [view refreshAnswerNumWithNum:self.answers.count];
            view.delegete = self;
            return view;
        }
    }
    return [UIView new];
}

/** TFKnowledgeAnswerSectionViewDelegate */
-(void)knowledgeAnswerSectionViewDidSortWithType:(NSInteger)type arrow:(UIImageView *)arrow view:(TFKnowledgeAnswerSectionView *)view{
    
    CGPoint point = [view convertPoint:arrow.center toView:self.view];
    [self methodWithPoint:CGPointMake(point.x+20, point.y+20)];
}
-(void)methodWithPoint:(CGPoint)point{
    
    PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:@[@"按回答时间排序",@"按更新时间排序"] images:nil];
    pop.selectRowAtIndex = ^(NSInteger index) {
        
        if (index == 0) {
            
            [self.knowledgeBL requestAnwserListWithDataId:self.dataId orderBy:@"create_time"];
        }
        else {
            
            [self.knowledgeBL requestAnwserListWithDataId:self.dataId orderBy:@"modify_time"];
        }
    };
    
    [pop show];
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 6) {
        if (![self.knowledgeDetail.type_status isEqualToString:@"2"]) {
            return self.sectionView;
        }
    }
    if (section == 7) {
        if (![self.knowledgeDetail.type_status isEqualToString:@"2"]) {
            
            UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,40}];
            view.backgroundColor = WhiteColor;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:IMG(@"评论CDS") forState:UIControlStateNormal];
            [button setImage:IMG(@"评论CDS") forState:UIControlStateHighlighted];
            [button setTitle:@"  评论" forState:UIControlStateNormal];
            [button setTitle:@"  评论" forState:UIControlStateHighlighted];
            [view addSubview:button];
            button.frame = CGRectMake(15, 0, 70, 40);
            [button setTitleColor:BlackTextColor forState:UIControlStateNormal];
            [button setTitleColor:BlackTextColor forState:UIControlStateHighlighted];
            button.titleLabel.font = FONT(14);
            return view;
        }
    }
    return [UIView new];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 7) {
        
        if ([self.knowledgeDetail.type_status isEqualToString:@"1"]) {
            return 40;// 有多少个回答栏
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 6 || section == 7) {
        
        if (![self.knowledgeDetail.type_status isEqualToString:@"2"]) {
            return 40;
        }
    }
    return 0;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 0x3344) {
        
        [self.keyboard hideKeyBoard];
    }
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
//    if (targetContentOffset->y < -(self.detailHeader.selfHeight/2)) {
//        targetContentOffset ->y = -(self.detailHeader.selfHeight + 10);
//    }else if (targetContentOffset->y < 0){
//
//        targetContentOffset ->y = -(self.detailHeader.selfHeight + 10 - 100);
//    }
    
    if (scrollView.tag == 0x3344) {
        
        if ([self.knowledgeDetail.type_status integerValue] == 2) {
            return;
        }
        
        HQLog(@"%f=======",scrollView.contentOffset.y);
        
        if (velocity.y > 0) {// 向上滑动
            
            [self.detailHeader foldDetailHeader];
            self.tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight-100+8, 0, 44, 0);
            
        }else{// 向下滑动
            
            if ([self.knowledgeDetail.type_status integerValue] == 0) {
                
                self.tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight+8, 0, 44, 0);
                [self.detailHeader unfoldDetailHeader];
            }else{
                
//                if (targetContentOffset->y < -(self.detailHeader.selfHeight/2)) {
                
                    self.tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight+8, 0, 44, 0);
                    [self.detailHeader unfoldDetailHeader];
//                }
            }
            
        }
    }
    
    
}
#pragma mark - 文件查看
-(void)customAttachmentsCell:(TFCustomAttachmentsOldCell *)cell didClickedFile:(TFFileModel *)file index:(NSInteger)index{
    
    [self seeFileWithFileModel:file withRows:self.fileRow withIndex:index];
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
              [[model.file_type lowercaseString] isEqualToString:@"zip"] ||
              [[model.file_type lowercaseString] isEqualToString:@"rar"] ||
              [[model.file_type lowercaseString] isEqualToString:@"pdf"]){
        
        
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
        
        
        TFPlayVoiceController *play = [[TFPlayVoiceController alloc] init];
        play.file = model;
        [self.navigationController pushViewController:play animated:YES];
        
    }else{
        
        [MBProgressHUD showError:@"未知文件无法预览" toView:self.view];
    }
}


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
#pragma mark - 图片浏览器

/**
 * 标题
 */
- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index{
    return [NSString stringWithFormat:@"%ld/%ld",index+1,self.images.count] ;
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


#pragma mark - TFCustomAttributeTextOldCellDelegate
-(void)customAttributeTextCell:(TFCustomAttributeTextOldCell *)cell getWebViewHeight:(CGFloat)height{
    self.multiTextHeight = height < 150?150:height;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

#pragma mark ==== LiuqsEmotionKeyBoardDelegate ====
-(void)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) {
        
        //        [self didHeartBtn:nil];
        
    }
}

-(void)recordStarting{
    
    self.enablePanGesture = NO;
}

-(void)cancelStarting{
    
    self.enablePanGesture = YES;
}

#pragma mark - @功能选人
-(void)didHeartBtn:(UIButton *)button{
    
    
    TFMutilStyleSelectPeopleController *scheduleVC = [[TFMutilStyleSelectPeopleController alloc] init];
    scheduleVC.selectType = 1;
    scheduleVC.isSingleSelect = YES;
    scheduleVC.actionParameter = ^(NSArray *peoples) {
        
        NSString *str = @"";
        [self.peoples addObjectsFromArray:peoples];
        for (HQEmployModel *model in self.peoples) {
            str = [NSString stringWithFormat:@"%@,",model.employeeName?:model.employee_name];
        }
        str = [str substringToIndex:str.length-1];
        self.keyboard.textView.text = [NSString stringWithFormat:@"@%@%@ ",self.keyboard.textView.text,str];
        
        for (HQEmployModel *model in self.peoples) {
            
            NSString *str1 = [NSString stringWithFormat:@"%@",model.employeeName?:model.employee_name];
            
            NSRange range = [self.keyboard.textView.text rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
            
        }
        self.jump = 0;
        [self.keyboard.textView becomeFirstResponder];
        
    };
    self.jump = 1;
    [self.navigationController pushViewController:scheduleVC animated:YES];
}

#pragma mark - 文字改变
- (void)textViewDidChange:(UITextView *)textView{
    
    
    NSString *str = textView.text;
    
    if (str.length == 0) {
        self.keyboard.textView.placeholder = @"说点什么吧...";
    }else{
        self.keyboard.textView.placeholder = @"";
    }
    
    for (HQEmployModel *model in self.peoples) {
        
        NSString *str1 = [NSString stringWithFormat:@"@%@",model.employeeName?:model.employee_name];
        
        if (![str containsString:str1]) {
            
            // 剩余名字位置
            NSRange range = NSMakeRange([model.location integerValue], [model.length integerValue]-1);
            
            if (range.location + range.length > textView.text.length) {// 考虑删除多个字
                
                [self.peoples removeObject:model];
                continue;
            }
            
            str = [str stringByReplacingCharactersInRange:range withString:@""];
            textView.text = str;
            
            [self.peoples removeObject:model];
            break;
        }else{
            
            NSRange range = [str rangeOfString:str1];
            model.location = @(range.location);
            model.length = @(range.length);
        }
    }
    
}


//发送按钮的事件
- (void)sendButtonEventsWithPlainString:(NSString *)PlainStr {
    
    if (!PlainStr.length) {
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
        return;
    }
    //点击发送，发出一条消息
    [self prepareTextMessage:PlainStr];
    
    self.keyboard.textView.text = @"";
    [self.keyboard.topBar resetSubsives];
    
}

/** 发送语音 */
-(void)sendVoiceWithVoice:(NSString *)voicePath voiceDuration:(NSString *)voiceDuration{
    
    
    NSURL *mp3Url = [HQHelper recordCafToMp3WithCafUrl:voicePath toMp3Url:[self getMp3Path]];
    
    [self SendMessageWithVoice:[mp3Url absoluteString]
                 voiceDuration:voiceDuration];
    
    //    [self SendMessageWithVoice:voicePath
    //                 voiceDuration:voiceDuration];
}


/** 发送其他 */
-(void)sendAddItemContentWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            [self openCamera];
        }
            break;
        case 1:
        {
            [self openAlbum];
        }
            break;
        case 2:
        {
            [self pushFileLibray];
        }
            break;
        case 3:
        {
            [self didHeartBtn:nil];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark ---文件库选
- (void)pushFileLibray {
    
    TFFileMenuController *fileVC = [[TFFileMenuController alloc] init];
    
    fileVC.isFileLibraySelect = YES;
    
    fileVC.refreshAction = ^(id parameter) {
        
        TFFolderListModel *model = parameter;
        
        TFCustomerCommentModel *commentModel = [[TFCustomerCommentModel alloc] init];
        commentModel.fileUrl = model.fileUrl;
        commentModel.fileName = model.name;
        commentModel.fileType = model.siffix;
        commentModel.fileSize = @([model.size integerValue]);
        
        commentModel.employee_name = UM.userLoginInfo.employee.employee_name;
        commentModel.employee_id = UM.userLoginInfo.employee.id;
        commentModel.picture = UM.userLoginInfo.employee.picture;
        commentModel.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = commentModel;
        
        model.siffix = [model.siffix stringByReplacingOccurrencesOfString:@"." withString:@""];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setObject:model.fileUrl forKey:@"file_url"];
        [dic setObject:@([model.size integerValue]) forKey:@"file_size"];
        [dic setObject:model.siffix forKey:@"file_type"];
        [dic setObject:model.name forKey:@"file_name"];
        
        [dic setObject:@([HQHelper getNowTimeSp]) forKey:@"datetime_time"];
        
        NSMutableArray *files = [NSMutableArray array];
        
        
        [files addObject:dic];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];

        [self.customBL requestCustomModuleCommentWithDict:dict];
        
    };
    
    [self.navigationController pushViewController:fileVC animated:YES];
}


#pragma mark - 发送文本
/** 发送文本消息 */
- (void)prepareTextMessage:(NSString *)text {
    
    
    if (text.length) {
        
        NSMutableArray *arr = [NSMutableArray array];
        NSString *str = @"";
        for (HQEmployModel *mode in self.peoples) {
            [arr addObject:mode.sign_id];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",[mode.sign_id description]]];
        }
        if (str.length) {
            str = [str substringToIndex:str.length-1];
        }
        [self.peoples removeAllObjects];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:text forKey:@"content"];
        [dict setObject:str forKey:@"at_employee"];
        [dict setObject:@[] forKey:@"information"];
        [dict setObject:@0 forKey:@"type"];
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        model.content = text;
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        
        self.commentModel = model;
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.customBL requestCustomModuleCommentWithDict:dict];
        
    }else{
        
        [MBProgressHUD showError:@"请输入内容" toView:self.view];
    }
}


#pragma mark - RecorderPath Helper Method
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


#pragma mark - Message Send helper Method
#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    HQLog(@"Action - SendMessageWithVoice");
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.fileUrl = voicePath;
    model.fileType = @"mp3";
    model.voiceTime = @([voiceDuration doubleValue]);
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //    审批  approval    邮件 email    文件  file_library   备忘录  note
    if ([self.bean isEqualToString:@"file_library"] || [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"] || [self.bean isEqualToString:@"repository_libraries"])  {

        [self.customBL chatFileWithImages:@[] withVioces:@[voicePath] bean:self.bean];
    }else{
        [self.customBL uploadFileWithImages:@[] withAudios:@[voicePath] bean:self.bean];
    }
    
}

#pragma mark -调用相册
- (void)photoClick {
    
    [self openAlbum];
}

#pragma mark --调用相机
- (void)cameraClick {
    
    [self openCamera];
}
/** 选择照片处理 */
-(void)handleImages:(NSArray *)arr{
    
    if (arr.count == 0) {
        return;
    }
    // 选择照片上传
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.fileType = @"jpg";
    model.image = arr.firstObject;
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.bean isEqualToString:@"file_library"]|| [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"] || [self.bean isEqualToString:@"repository_libraries"]) {

        [self.customBL chatFileWithImages:arr withVioces:@[] bean:self.bean];
    }else{
        [self.customBL uploadFileWithImages:arr withAudios:@[] bean:self.bean];
    }
}


#pragma mark - 打开相册
- (void)openAlbum{
    
    kWEAKSELF
    ZLPhotoActionSheet *sheet =[HQHelper takeHPhotoWithBlock:^(NSArray<UIImage *> *images) {
        [weakSelf handleImages:images];
    }];
    //图片数量
    sheet.configuration.maxSelectCount = 1;
    //如果调用的方法没有传sender，则该属性必须提前赋值
    sheet.sender = self;
    [sheet showPhotoLibrary];
    return;
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
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
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *image=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        NSString *fileName = [representation filename];
        HQLog(@"fileName : %@",fileName);
        
        
        TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
        
        model.fileType = @"jpg";
        model.image = image;
        
        model.employee_name = UM.userLoginInfo.employee.employee_name;
        model.employee_id = UM.userLoginInfo.employee.id;
        model.picture = UM.userLoginInfo.employee.picture;
        model.datetime_time = @([HQHelper getNowTimeSp]);
        model.content = @"";
        
        self.commentModel = model;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([self.bean isEqualToString:@"file_library"]|| [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"] || [self.bean isEqualToString:@"repository_libraries"]) {

            [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
        }else{
            [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];
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
        picker.modalPresentationStyle = UIModalPresentationFullScreen;

        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    TFCustomerCommentModel *model = [[TFCustomerCommentModel alloc] init];
    
    model.image = image;
    model.fileType = @"jpg";
    
    model.employee_name = UM.userLoginInfo.employee.employee_name;
    model.employee_id = UM.userLoginInfo.employee.id;
    model.picture = UM.userLoginInfo.employee.picture;
    model.datetime_time = @([HQHelper getNowTimeSp]);
    model.content = @"";
    
    self.commentModel = model;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([self.bean isEqualToString:@"file_library"]|| [self.bean isEqualToString:@"approval"] || [self.bean isEqualToString:@"email"] || [self.bean isEqualToString:@"memo"] || [self.bean isEqualToString:@"repository_libraries"]) {

        [self.customBL chatFileWithImages:@[image] withVioces:@[] bean:self.bean];
    }else{
        [self.customBL uploadFileWithImages:@[image] withAudios:@[] bean:self.bean];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_customCommentList) {
        
        [self.comments removeAllObjects];
        [self.comments addObjectsFromArray:resp.body];
        
        [self.commentTable refreshCommentTableViewWithDatas:self.comments];
        
    }
    
    if (resp.cmdId == HQCMD_customCommentSave) {// 保存
        
        if (self.commentModel) {
            [self.comments addObject:self.commentModel];
        }
        
        [self.commentTable refreshCommentTableViewWithDatas:self.comments];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.keyboard hideKeyBoard];
        });
    }
    
    if (resp.cmdId == HQCMD_uploadFile || resp.cmdId == HQCMD_ChatFile) {
        
        NSArray *arr = resp.body;
        NSMutableArray *files = [NSMutableArray array];
        for (TFFileModel *ff in arr) {
            
            NSMutableDictionary *dd = [NSMutableDictionary dictionaryWithDictionary:[ff toDictionary]];
            
            if (dd) {
                
//                if ([[ff.file_type lowercaseString] isEqualToString:@"mp3"] || [[ff.file_type lowercaseString] isEqualToString:@"amr"]) {
//                    
//                    CGFloat timeSp = [self.commentModel.voiceTime floatValue]*1000;
//                    
//                    NSString *str = [NSString stringWithFormat:@"%.0f",timeSp];
//                    
//                    [dd setObject:@([str integerValue]) forKey:@"voiceTime"];
//                }
                
                [files addObject:dd];
            }
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:self.bean forKey:@"bean"];
        [dict setObject:self.dataId forKey:@"relation_id"];
        [dict setObject:files forKey:@"information"];
        [dict setObject:@"" forKey:@"content"];
        
        
        if (arr.count) {
            
            TFFileModel *file = arr[0];
            self.commentModel.fileUrl = file.file_url;
        }
        
        [self.customBL requestCustomModuleCommentWithDict:dict];
    }
    
    
    if (resp.cmdId == HQCMD_getKnowledgeDetail ) {
        
        self.knowledgeDetail = resp.body;
        NSArray *arr = [HQHelper dictionaryWithJsonString:self.knowledgeDetail.video];
        [self.videos removeAllObjects];
        for (NSDictionary *dict in arr) {// 视频s
            TFVideoModel *video = [[TFVideoModel alloc] initWithDictionary:dict error:nil];
            if (video) {
                [self.videos addObject:video];
            }
        }
        
        if ([self.knowledgeDetail.type_status integerValue] == 1) {// 提问有回答
            [self.knowledgeBL requestAnwserListWithDataId:self.dataId orderBy:@"create_time"];
        }
        
        [self.files removeAllObjects];
        [self.files addObjectsFromArray:self.knowledgeDetail.repository_lib_attachment];
        self.fileRow.selects = [NSMutableArray arrayWithArray:self.knowledgeDetail.repository_lib_attachment];
        
        self.tableView.hidden = NO;
        self.detailHeader.hidden = NO;
        [self handAuth];// 处理权限
        
        [self.detailHeader refreshKnowledgeDetailHeaderWithModel:self.knowledgeDetail type:[self.knowledgeDetail.type_status integerValue] auth:self.auth];
        
        self.tableView.contentInset = UIEdgeInsetsMake(self.detailHeader.selfHeight+8, 0, 44, 0);
        [self.tableView setContentOffset:(CGPoint){0,-(self.detailHeader.selfHeight+8)}];
    
        [self.sectionView refreshNumWithSee:[self.knowledgeDetail.readcount integerValue] star:[self.knowledgeDetail.collectioncount integerValue] good:[self.knowledgeDetail.praisecount integerValue] learn:[self.knowledgeDetail.studycount integerValue]];
        
        [self.tableView reloadData];
        
        if (self.refreshAction) {
            self.refreshAction(self.knowledgeDetail);
        }
        // action 1:版本管理， 2:移动， 3:编辑， 4:删除
        /** 0:知识 1:提问 2:回答 */
        NSMutableArray *alert = [NSMutableArray array];
        if ([self.knowledgeDetail.type_status integerValue] == 0) {
            
            [alert addObject:@""];
            if (self.auth > 0) {
                [alert addObject:@""];
                [alert addObject:@""];
            }
            if (self.auth > 1) {
                [alert addObject:@""];
            }
            
        }else if ([self.knowledgeDetail.type_status integerValue] == 1){
            
            if (self.auth > 0) {
                [alert addObject:@""];
                [alert addObject:@""];
            }
            if (self.auth > 1) {
                [alert addObject:@""];
            }
            
        }else{
            
            if (self.auth > 0) {
                [alert addObject:@""];
                [alert addObject:@""];
                [alert addObject:@""];
            }
        }
        if (alert.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(menuClicked) image:@"菜单" highlightImage:@"菜单"];
        }
        
    }
    if (resp.cmdId == HQCMD_deleteKnowledge) {
        
        [MBProgressHUD showImageSuccess:@"删除成功" toView:self.view];
        if (self.deleteAction) {
            self.deleteAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_anwserList) {
        
        self.answers = resp.body;
        [self.tableView reloadData];
        
    }
    
    if (resp.cmdId == HQCMD_anwserTop ) {
        
        [MBProgressHUD showImageSuccess:@"操作成功" toView:self.view];
    }
    if (resp.cmdId == HQCMD_knowledgeTop) {
        if (self.reloadAction) {
            self.reloadAction(nil);
        }
        [MBProgressHUD showImageSuccess:@"操作成功" toView:self.view];
    }
    
    if (resp.cmdId == HQCMD_anwserDelete) {
        
        [MBProgressHUD showImageSuccess:@"删除成功" toView:self.view];
        if (self.deleteAction) {
            self.deleteAction();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (resp.cmdId == HQCMD_anwserDetail) {
        
        TFKnowledgeItemModel *model = resp.body;
        model.type_status = @"2";
        model.title = self.knowledgeDetail.title;
        model.create_by = self.knowledgeDetail.create_by;
        model.files = self.knowledgeDetail.files;
        
        self.knowledgeDetail = model;
        
        [self.detailHeader refreshKnowledgeDetailHeaderWithModel:self.knowledgeDetail type:[self.knowledgeDetail.type_status integerValue] auth:self.auth];
        
        
        [self.tableView reloadData];
        
        if (self.refreshAction) {
            self.refreshAction(self.knowledgeDetail);
        }
    }
    
    if (resp.cmdId == HQCMD_knowledgeReferances) {
        NSArray *arr = resp.body;
        NSMutableArray *items = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            NSArray *datas = [dict valueForKey:@"moduleDataList"];
            [items addObjectsFromArray:datas];
        }
        
        [self.emails removeAllObjects];
        [self.tasks removeAllObjects];
        [self.approvals  removeAllObjects];
        [self.notes removeAllObjects];
        [self.customs removeAllObjects];
        
        for (NSDictionary *dd in items) {
            TFProjectRowModel *row = [HQHelper projectRowWithTaskDict:dd];
            /** (数据类型 1备忘录 2任务 3自定义模块数据 4审批数据 5邮件) */
            if ([row.dataType isEqualToNumber:@1]) {
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                model.projectRow = row;
                [self.notes addObject:model];
            }else if ([row.dataType isEqualToNumber:@2]){
                row.cellHeight = @([TFNewProjectTaskItemCell refreshNewProjectTaskItemCellHeightWithModel:row haveClear:NO]);
                [self.tasks addObject:row];
            }else if ([row.dataType isEqualToNumber:@3]){
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                model.projectRow = row;
                [self.customs addObject:model];
            }else if ([row.dataType isEqualToNumber:@4]){
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                model.projectRow = row;
                [self.approvals addObject:model];
            }else{
                TFProjectRowFrameModel *model = [[TFProjectRowFrameModel alloc] initBorder];
                model.projectRow = row;
                [self.emails addObject:model];
            }
        }
        
        [self.tableView reloadData];
      
    }
    
    if (resp.cmdId == HQCMD_inviteToAnswer) {
        [MBProgressHUD showImageSuccess:@"邀请成功" toView:self.view];
    }
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:self.view];
}

#pragma mark - 判断权限
-(void)handAuth{
    
    // 此处为创建人
    if ([[UM.userLoginInfo.employee.id description] isEqualToString:[self.knowledgeDetail.create_by.id description]]) {
        self.auth = 1;
    }
    // 此处为管理员
    for (TFEmployModel *model in self.knowledgeDetail.allot_manager) {
        if ([[UM.userLoginInfo.employee.id description] isEqualToNumber:[model.id description]]) {
            self.auth = 2;
            break;
        }
    }
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
