//
//  TFProjectFileNewController.m
//  HuiJuHuaQi
//
//  Created by mac-mini on 2018/6/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFProjectFileNewController.h"
#import "HQTFInputCell.h"
#import "TFProjectTaskBL.h"
#import "TFNoteMainController.h"

@interface TFProjectFileNewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HQBLDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) TFProjectTaskBL *projectTaskBL;

@property (nonatomic, strong) UITextField *textField;

@end

@implementation TFProjectFileNewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavi];
    
    [self setupTableView];
    
    self.projectTaskBL = [TFProjectTaskBL build];
    self.projectTaskBL.delegate = self;
    
}

- (void)setNavi {

    if (self.isEdit) {
        
        self.navigationItem.title = @"编辑文件夹";
    }
    else {
        
        self.navigationItem.title = @"新增文件夹";
    }
    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) text:@"保存" textColor:LightBlackTextColor];
    
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
        
    HQTFInputCell *cell = [HQTFInputCell inputCellWithTableView:tableView];
    
    cell.requireLabel.hidden = NO;
    cell.titleLabel.text = @"文件夹名称";
    cell.textField.placeholder = @"请输入";
    cell.textField.delegate = self;
    cell.bottomLine.hidden = YES;
    cell.textField.secureTextEntry = NO;
    cell.textField.text = self.folderName;
    cell.enterBtn.hidden = YES;
    self.textField = cell.textField;
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 12;
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


-(void)textFieldDidChange:(UITextField *)textField
{
    CGFloat maxLength = 25;
    NSString *toBeString = textField.text;
    
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange)
    {
        if (toBeString.length > maxLength)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            if (rangeIndex.length == 1)
            {
                textField.text = [toBeString substringToIndex:maxLength];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, maxLength)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
    self.folderName = textField.text;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.folderName = textField.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

    self.navigationItem.rightBarButtonItem = [self itemWithTarget:self action:@selector(save) text:@"保存" textColor:GreenColor];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length > 25) {
        
        textView.text = [textView.text substringToIndex:25];
        [MBProgressHUD showError:@"最长25个字符" toView:self.view];
    }

    self.folderName = textView.text;
    
}

#pragma mark save
- (void)save {

    
    [self textFieldDidEndEditing:self.textField];
    if (self.folderName.length <= 0) {

        [MBProgressHUD showError:@"请输入文件夹名称！" toView:self.view];
        return;
    }

    if (self.isEdit) {

        [self.projectTaskBL requestProjectLibraryEditLibraryWithData:self.folderName fileId:self.folderId projectId:self.projectId];
    }
    else {

        [self.projectTaskBL requestProjectLibrarySavaLibraryWithData:self.folderName projectId:self.projectId parentId:self.parentId type:self.subType];
    }
    

}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_projectLibrarySavaLibrary) {
        
        [MBProgressHUD showError:@"添加成功" toView:self.view];
        
        if ([self.subType isEqualToNumber:@0]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshProjectFileList" object:nil];
        }
        else if ([self.subType isEqualToNumber:@1]) {
            
            if (self.refresh) {
                
                self.refresh();
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }
    
    if (resp.cmdId == HQCMD_projectLibraryEditLibrary) {
        
        [MBProgressHUD showError:@"修改成功" toView:self.view];
        
        if (self.action) {
            
            self.action(self.folderName);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshProjectFileList" object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    }

}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}

@end
