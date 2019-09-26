//
//  TFNoteView.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/3/21.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFNoteView.h"
#import "TFNoteTextView.h"
#import "TFNoteModel.h"
#import "TFNoteAccessoryView.h"
#import "ZYQAssetPickerController.h"
#import "TFNoteImageView.h"
#import "TFNoteBL.h"

#define InputHeight 280

@interface TFNoteView ()<TFNoteAccessoryViewDelegate,UITextViewDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TFNoteTextViewDelegate,HQBLDelegate>

/** noteItems */
@property (nonatomic, strong) NSMutableArray *noteItems;

/** accessoryView */
@property (nonatomic, strong) TFNoteAccessoryView *accessoryView;

/** mark：编号 */
@property (nonatomic, assign) BOOL mark;
/** choice：选中 */
@property (nonatomic, assign) BOOL choice;

/** cursorModel */
@property (nonatomic, strong) TFNoteModel *cursorModel;
/** 光标位置 */
@property (nonatomic, assign) NSInteger cursorPosition;

/** 用于记录上传图片的model */
@property (nonatomic, strong) TFNoteModel *imageModel;

/** TFNoteBL */
@property (nonatomic, strong) TFNoteBL *noteBL;

/** type */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) UIView *bgView;


@end


@implementation TFNoteView

-(TFNoteBL *)noteBL{
    
    if (!_noteBL) {
        _noteBL = [TFNoteBL build];
        _noteBL.delegate = self;
    }
    return _noteBL;
}

-(NSMutableArray *)noteItems{
    if (!_noteItems) {
        _noteItems = [NSMutableArray array];
    }
    return _noteItems;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = BackGroudColor;
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = WhiteColor;
        
        bgView.layer.cornerRadius = 4.0;
        bgView.layer.masksToBounds = YES;
        self.bgView = bgView;
        [self addSubview:bgView];
        
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(@10);
            make.top.equalTo(@10);
            make.right.equalTo(@(-10));
            make.bottom.equalTo(@(-10));
        }];
        
        TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
        
        noteTextView.layer.cornerRadius = 4.0;
        noteTextView.layer.masksToBounds = YES;
        [self.bgView addSubview:noteTextView];
        noteTextView.textColor = BlackTextColor;
        noteTextView.font = FONT(17);
        noteTextView.delegate = self;
        noteTextView.noteDelegate = self;
        noteTextView.backgroundColor = ClearColor;
        noteTextView.textAlignment = NSTextAlignmentJustified;
        
        TFNoteModel *model = [[TFNoteModel alloc] init];
        model.noteTextView = noteTextView;
        
        
        [self.noteItems addObject:model];
        
        TFNoteAccessoryView *accessoryView = [[TFNoteAccessoryView alloc] initWithFrame:(CGRect){0,0,SCREEN_WIDTH,44} withImages:@[@"choice",@"mark",@"notePhoto",@"relation",@"remaind",@"noteShare",@"noteLocation",@"noteHide"]];
        self.accessoryView = accessoryView;
        accessoryView.delegate = self;
        noteTextView.inputAccessoryView = self.accessoryView;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardDidShowNotification object:nil];
        
    }
    return self;
}

- (void)keyBoardShow{
    
    for (TFNoteModel *mo in self.noteItems) {
        
        if (mo.type == 0) {
            
            if ([mo.noteTextView isFirstResponder]) {
                
                if (mo.check > 0) {
                    
                    self.accessoryView.check = YES;
                }else{
                    self.accessoryView.check = NO;
                }
                
                if (mo.num > 0) {
                    
                    self.accessoryView.num = YES;
                }else{
                    
                    self.accessoryView.num = NO;
                }
                
                break;
            }
            
        }
    }
    
}


-(void)refreshNoteViewWithNotes:(NSArray *)notes withType:(NSInteger)type{
    
    self.type = type;
    
    for (TFNoteModel *mo in self.noteItems) {
        
        if (mo.type == 0) {
            [mo.noteTextView removeFromSuperview];
        }else{
            
            [mo.noteImageView removeFromSuperview];
        }
    }
    
    [self.noteItems removeAllObjects];
    
    BOOL edit = type == 1 ? NO : YES;
    
    for (NSInteger i = 0; i < notes.count; i ++) {
        TFNoteModel *noteModel = notes[i];
        
        if (noteModel.type == 0) {
            
            TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteTextView];
            noteTextView.textColor = BlackTextColor;
            noteTextView.font = FONT(17);
            noteTextView.delegate = self;
            noteTextView.noteDelegate = self;
            noteTextView.backgroundColor = ClearColor;
            noteTextView.textAlignment = NSTextAlignmentJustified;
            noteTextView.editable = edit;
            noteTextView.text = noteModel.content;
            
            noteModel.noteTextView = noteTextView;
            if (edit) {
                noteTextView.inputAccessoryView = self.accessoryView;
            }
            
            
            [self.noteItems addObject:noteModel];
            
        }else{
            
            
            TFNoteImageView *noteImageView = [[TFNoteImageView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteImageView];
            noteImageView.textView.textColor = BlackTextColor;
            noteImageView.textView.font = FONT(17);
            noteImageView.textView.delegate = self;
            noteImageView.textView.backgroundColor = ClearColor;
            noteImageView.textView.textAlignment = NSTextAlignmentJustified;
            noteImageView.textView.text = @"";
            if (edit) {
                noteImageView.textView.inputAccessoryView = self.accessoryView;
            }
            noteImageView.textView.editable = edit;
            
            noteModel.noteImageView = noteImageView;
            
            [self.noteItems addObject:noteModel];
            
            
        }
        
        
    }
    
    [self setNeedsLayout];
    
}





#pragma mark - noteDelegateDelegate
-(void)noteTextView:(TFNoteTextView *)noteTextView didCheckBtnWithCheck:(NSInteger)check{
    
    
    TFNoteModel *model = self.noteItems[noteTextView.tag];
    model.check = check;
    
    if ([self.delegate respondsToSelector:@selector(noteView:check:model:)]) {
        [self.delegate noteView:self check:check model:model];
    }
    [self setNeedsLayout];
}


#pragma mark - textView代理
/** 获取光标位置 */
- (void)textViewDidChangeSelection:(UITextView *)textView{
    // 文字改变后的光标
    self.cursorPosition = textView.selectedRange.location;
}

/** 文字改变 */
-(void)textViewDidChange:(UITextView *)textView{
    
    HQLog(@"%f===%f",textView.height,textView.contentSize.height);
    
    TFNoteModel *model = self.noteItems[textView.tag];
    self.cursorModel = model;
    
    if (model.check > 0) {
        
        self.accessoryView.check = YES;
    }else{
        self.accessoryView.check = NO;
    }
    
    if (model.num > 0) {
        
        self.accessoryView.num = YES;
    }else{
        
        self.accessoryView.num = NO;
    }
    
    textView.scrollEnabled = YES;
    if (textView.height < textView.contentSize.height) {
        
        [self setNeedsLayout];
    }
    
}

/** 是否让其成为第一响应者 */
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    
    // 成为响应者时的光标
    self.cursorPosition = textView.selectedRange.location;
    
    TFNoteModel *model = self.noteItems[textView.tag];
    self.cursorModel = model;
    
    if (model.check > 0) {
        
        self.accessoryView.check = YES;
    }else{
        self.accessoryView.check = NO;
    }
    
    if (model.num > 0) {
        
        self.accessoryView.num = YES;
    }else{
        
        self.accessoryView.num = NO;
    }
    textView.scrollEnabled = YES;
    
    [self setNeedsLayout];
    return YES;
}

/** 是否让其文字改变 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    TFNoteModel *mo = self.noteItems[textView.tag];
    self.cursorModel = mo;
    
    if (mo.type == 0) {
        
        if ([text isEqualToString:@"\n"]) {// 分裂为两个
            
            
            TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteTextView];
            noteTextView.textColor = BlackTextColor;
            noteTextView.font = FONT(17);
            noteTextView.delegate = self;
            noteTextView.noteDelegate = self;
            noteTextView.backgroundColor = ClearColor;
            noteTextView.textAlignment = NSTextAlignmentJustified;
            noteTextView.text = [textView.text substringFromIndex:range.location];
            noteTextView.inputAccessoryView = self.accessoryView;
            noteTextView.tag = mo.noteTextView.tag + 1;
            
            TFNoteModel *model = [[TFNoteModel alloc] init];
            model.noteTextView = noteTextView;
            model.type = 0;
            model.check = mo.check;
            model.num = mo.num == 0 ? 0 : mo.num + 1;
            
            [self.noteItems insertObject:model atIndex:textView.tag + 1];
            
            [noteTextView becomeFirstResponder];// 会调用textViewShouldBeginEditing:
            self.cursorPosition = 0;
            textView.text = [textView.text substringToIndex:range.location];
            
            self.cursorModel = model;
            
            if (self.cursorModel.check > 0) {
                
                self.accessoryView.check = YES;
            }else{
                self.accessoryView.check = NO;
            }
            
            if (self.cursorModel.num > 0) {
                
                self.accessoryView.num = YES;
            }else{
                
                self.accessoryView.num = NO;
            }
            [self setNeedsLayout];
            
            
            return NO;
        }

    }else{// 图片
        
        
        TFNoteModel *last = nil;
        if (textView.tag+1 < self.noteItems.count) {
            last = self.noteItems[textView.tag + 1];
        }
        // 图片下面为空文
        BOOL textNil = [text isEqualToString:@""];
        // 满足这个条件就是图片下方为空的文本
        BOOL sepecial = (last && last.type == 0 && mo != self.noteItems.lastObject && last.check == 0 && last.num == 0 && last.noteTextView.text.length == 0);
        // 可以分裂为两个
        BOOL gene = !sepecial && !textNil;
        
        if ([text isEqualToString:@"\n"] || gene) {// 分裂为两个
            
            TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteTextView];
            noteTextView.textColor = BlackTextColor;
            noteTextView.font = FONT(17);
            noteTextView.delegate = self;
            noteTextView.noteDelegate = self;
            noteTextView.backgroundColor = ClearColor;
            noteTextView.textAlignment = NSTextAlignmentJustified;
            noteTextView.text = [textView.text substringFromIndex:range.location];
            noteTextView.inputAccessoryView = self.accessoryView;
            noteTextView.tag = mo.noteTextView.tag + 1;
            
            TFNoteModel *model = [[TFNoteModel alloc] init];
            model.noteTextView = noteTextView;
            model.type = 0;
            
            // 此时check和num取决于当前item之上最近的一个文本item的值
            TFNoteModel *require = nil;
            for (NSInteger i = textView.tag; i >= 0 ; i--) {
                TFNoteModel *note = self.noteItems[i];
                if (note.type == 0) {
                    require = note;
                    break;
                }
            }
            if (require == nil) {
                model.check = 0;
                model.num = 0;
            }else{
                model.check = require.check;
                model.num = require.num == 0 ? 0 : require.num + 1;
            }
            
            [self.noteItems insertObject:model atIndex:textView.tag + 1];
            
            [noteTextView becomeFirstResponder];// 会调用textViewShouldBeginEditing:
            self.cursorPosition = 0;
            textView.text = [textView.text substringToIndex:range.location];
            
            self.cursorModel = model;
            
            [self setNeedsLayout];
            
            return NO;
        }
        
        // 跳入空白区
        if (sepecial && !textNil) {
            
            // 文字是输入到响应者上面的，虽然textView变了，也没有关系。
            [last.noteTextView becomeFirstResponder];
            self.cursorPosition = 0;
            self.cursorModel = last;
            [self setNeedsLayout];
            return YES;
        }
        
    }
    
    
    // 删除文字、图片走一样的逻辑
    if (range.location == 0 && range.length == 0 && [text isEqualToString:@""]) {// 此处为首字符删除
        
        if (mo.num > 0) {// 有编号
            mo.num = 0;
            
            if (mo.num > 0) {
                
                self.accessoryView.num = YES;
            }else{
                
                self.accessoryView.num = NO;
            }
        }else{// 无编号
            
            if (mo.check > 0) {// 有待办
                
                mo.check = 0;
                
                if (mo.check > 0) {
                    
                    self.accessoryView.check = YES;
                }else{
                    self.accessoryView.check = NO;
                }
                
            }else{// 无待办
                
                if (textView.text.length == 0) {// 没有文字
                    
                    // 删除该编辑框
                    if (textView.tag == 0) {// 第一个编辑框
                        
                        // 没有删除对象
                    }else{
                        // 跳入上一个
                        TFNoteModel *mmmm = self.noteItems[textView.tag - 1];
                        
                        if (mmmm.type == 0) {// 文字
                            
                            [mmmm.noteTextView becomeFirstResponder];
                            // 干掉自己
                            [self.noteItems removeObjectAtIndex:textView.tag];
                        }else{// 图片
                            
                            
                            [mmmm.noteImageView.textView becomeFirstResponder];
                            // 干掉自己
                            [self.noteItems removeObjectAtIndex:textView.tag];
                            
                        }
                        self.cursorModel = mmmm;
                        
                        // 从父控件中移除
                        if (mo.type == 0) {
                            
                            [mo.noteTextView removeFromSuperview];
                        }else{
                            
                            [mo.noteImageView removeFromSuperview];
                        }
                        
                        // 不让删掉上个编辑框的内容
                        [self setNeedsLayout];
                        return NO;
                        
                    }
                    
                }else{// 有文字
                    
                    // 跳入上一个编辑框
                    if (textView.tag == 0) {// 第一个编辑框
                        // 没有跳入对象
                    }else{
                        // 跳入上一个
                        TFNoteModel *mmmm = self.noteItems[textView.tag - 1];
                        if (mmmm.type == 0) {// 文字
                            
                            [mmmm.noteTextView becomeFirstResponder];
                        }else{// 图片
                            
                            [mmmm.noteImageView.textView becomeFirstResponder];
                        }
                        
                        self.cursorModel = mmmm;
                    }
                    
                }
            }
        }
        
        [self setNeedsLayout];
    }
    
    return  YES;
}

#pragma mark - TFNoteAccessoryViewDelegate
-(void)noteAccessoryDidSelectedItem:(UIButton *)button AtIndex:(NSUInteger)index{
    
    //  找到响应的那个model
    for (TFNoteModel *mok in self.noteItems) {
        
        if (mok.type == 0) {
            
            if (mok.noteTextView.isFirstResponder) {
                
                self.cursorModel = mok;
                break;
            }
            
        }else{
            if (mok.noteImageView.textView.isFirstResponder) {
                self.cursorModel = mok;
                break;
            }
        }
        
    }
    
    
    
    if (index == 0) {
        
        
        if (self.cursorModel.type == 1) {// 图片
            
            return;
        }else{
            
            self.choice = button.selected;
            self.cursorModel.check = self.choice ? 1 : 0;
        }
        
        [self setNeedsLayout];
        
    }
    if (index == 1) {
        
        
        if (self.cursorModel.type == 1) {// 图片
            
            return;
        }else{
            
            self.mark = button.selected;
            
            if (self.mark) {
                
                // 此时check和num取决于当前item之上最近的一个文本item的值
                TFNoteModel *require = nil;
                for (NSInteger i = self.cursorModel.noteTextView.tag-1; i >= 0 ; i--) {
                    TFNoteModel *note = self.noteItems[i];
                    if (note.type == 0) {
                        require = note;
                        break;
                    }
                }
                if (require == nil) {
                    self.cursorModel.check = self.cursorModel.check;
                    self.cursorModel.num = 1;
                }else{
                    self.cursorModel.check = self.cursorModel.check > 0 ? self.cursorModel.check : require.check;
                    self.cursorModel.num = require.num + 1;
                }
            }else{
                
                self.cursorModel.num = self.mark ? 1 : 0;
            }
            
            
            if (self.cursorModel.check > 0) {
                
                self.accessoryView.check = YES;
            }else{
                self.accessoryView.check = NO;
            }
            
            if (self.cursorModel.num > 0) {
                
                self.accessoryView.num = YES;
            }else{
                
                self.accessoryView.num = NO;
            }
            
        }
        
        [self setNeedsLayout];
        

        
    }
    
    if (2 == index) {
        
        [self endEditing:YES];
        [self setNeedsLayout];
        
        [self didClickedPhoto];
        
    }
    
    if (index > 2 && index < 7) {
        
        [self endEditing:YES];
        [self setNeedsLayout];
        
        if ([self.delegate respondsToSelector:@selector(noteView:accessoryIndex:)]) {
            [self.delegate noteView:self accessoryIndex:index];
        }
    }
    
    if (index == 7) {
        [self endEditing:YES];
        [self setNeedsLayout];
    }
    
}

-(void)didClickedPhoto{
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选择", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self];
}


#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [self openCamera];
    }
    if (buttonIndex == 1) {
        [self openAlbum];
    }
    
}


#pragma mark - 打开相机
- (void)openAlbum{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 1 ; // 选择图片最大数量
    picker.assetsFilter = [ALAssetsFilter allPhotos]; // 可选择所有相册图片
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 8;
        } else {
            return YES;
        }
    }];
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [delegate.window.rootViewController presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - 打开相机
- (void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        AppDelegate *delegate = [AppDelegate shareAppDelegate];
        [delegate.window.rootViewController presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - ZYQAssetPickerControllerDelegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i=0; i<assets.count; i++) {
        ALAsset *asset=assets[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        // 添加图片
        [arr addObject:tempImg];
    }
    
    if (arr.count) {
        
        if (self.cursorModel == nil) {
            self.cursorModel = self.noteItems.lastObject;
        }
        
        if (self.cursorModel.check > 0 || self.cursorModel.num > 0 || self.cursorModel.type == 1) {
            
            UIImage *image = arr[0];
            TFNoteImageView *noteImageView = [[TFNoteImageView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteImageView];
            noteImageView.textView.textColor = BlackTextColor;
            noteImageView.textView.font = FONT(17);
            noteImageView.textView.delegate = self;
            noteImageView.textView.backgroundColor = ClearColor;
            noteImageView.textView.textAlignment = NSTextAlignmentJustified;
            noteImageView.textView.text = @"";
            noteImageView.textView.inputAccessoryView = self.accessoryView;
            noteImageView.tag = self.cursorModel.noteTextView.tag + 1;
            
            TFNoteModel *model = [[TFNoteModel alloc] init];
            model.noteImageView = noteImageView;
            model.type = 1;
            model.check = 0;
            model.num = 0;
            model.image = image;
            self.imageModel = model;
            
            [self.noteItems insertObject:model atIndex:self.cursorModel.noteTextView.tag + 1];
            
            
            // 加入item为最后一个，需在下方加入输入框
            if (model == self.noteItems.lastObject) {
                
                
                TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
                [self.bgView addSubview:noteTextView];
                noteTextView.textColor = BlackTextColor;
                noteTextView.font = FONT(17);
                noteTextView.delegate = self;
                noteTextView.noteDelegate = self;
                noteTextView.backgroundColor = ClearColor;
                noteTextView.textAlignment = NSTextAlignmentJustified;
                noteTextView.inputAccessoryView = self.accessoryView;
                noteTextView.tag = noteImageView.textView.tag + 1;
                
                TFNoteModel *model1 = [[TFNoteModel alloc] init];
                model1.noteTextView = noteTextView;
                model1.type = 0;
                model1.check = self.cursorModel.check;
                model1.num = self.cursorModel.num == 0 ? 0 : self.cursorModel.num + 1;
                
                [self.noteItems addObject:model1];
                
            }
            
            
        }else{// 纯文本，分裂成为三个
            
            // 加入图片
            UIImage *image = arr[0];
            TFNoteImageView *noteImageView = [[TFNoteImageView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteImageView];
            noteImageView.textView.textColor = BlackTextColor;
            noteImageView.textView.font = FONT(17);
            noteImageView.textView.delegate = self;
            noteImageView.textView.backgroundColor = ClearColor;
            noteImageView.textView.textAlignment = NSTextAlignmentJustified;
            noteImageView.textView.text = @"";
            noteImageView.textView.inputAccessoryView = self.accessoryView;
            noteImageView.tag = self.cursorModel.noteTextView.tag + 1;
            
            TFNoteModel *model = [[TFNoteModel alloc] init];
            model.noteImageView = noteImageView;
            model.type = 1;
            model.check = 0;
            model.num = 0;
            model.image = image;
            self.imageModel = model;
            
            [self.noteItems insertObject:model atIndex:self.cursorModel.noteTextView.tag + 1];
            
            
            TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteTextView];
            noteTextView.textColor = BlackTextColor;
            noteTextView.font = FONT(17);
            noteTextView.delegate = self;
            noteTextView.noteDelegate = self;
            noteTextView.backgroundColor = ClearColor;
            noteTextView.textAlignment = NSTextAlignmentJustified;
            noteTextView.text = [self.cursorModel.noteTextView.text substringFromIndex:self.cursorPosition];
            noteTextView.inputAccessoryView = self.accessoryView;
            noteTextView.tag = self.cursorModel.noteTextView.tag + 2;
            
            TFNoteModel *model1 = [[TFNoteModel alloc] init];
            model1.noteTextView = noteTextView;
            model1.type = 0;
            model1.check = 0;
            model1.num = 0;
            
            [self.noteItems insertObject:model1 atIndex:self.cursorModel.noteTextView.tag + 2];
            
//            [noteTextView becomeFirstResponder];// 会调用textViewShouldBeginEditing:
            self.cursorModel.noteTextView.text = [self.cursorModel.noteTextView.text substringToIndex:self.cursorPosition];
            
        }
        
//        [self setNeedsLayout];
        [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        [self.noteBL chatFileWithImages:arr withVioces:@[] bean:@"memo"];
        
    }
    
}

#pragma mark - imagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (self.cursorModel == nil) {
        self.cursorModel = self.noteItems.lastObject;
    }
    
    if (self.cursorModel.check > 0 || self.cursorModel.num > 0 || self.cursorModel.type == 1) {// 在待办，编号，图片框时直接在该框下插入图片
        
        TFNoteImageView *noteImageView = [[TFNoteImageView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:noteImageView];
        noteImageView.textView.textColor = BlackTextColor;
        noteImageView.textView.font = FONT(17);
        noteImageView.textView.delegate = self;
        noteImageView.textView.backgroundColor = ClearColor;
        noteImageView.textView.textAlignment = NSTextAlignmentJustified;
        noteImageView.textView.text = @"";
        noteImageView.textView.inputAccessoryView = self.accessoryView;
        noteImageView.textView.tag = self.cursorModel.noteTextView.tag + 1;
        
        TFNoteModel *model = [[TFNoteModel alloc] init];
        model.noteImageView = noteImageView;
        model.type = 1;
        model.check = 0;
        model.num = 0;
        model.image = image;
        self.imageModel = model;
        
        [self.noteItems insertObject:model atIndex:self.cursorModel.noteTextView.tag + 1];
        
        
        // 加入item为最后一个，需在下方加入输入框
        if (model == self.noteItems.lastObject) {
            
            
            TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
            [self.bgView addSubview:noteTextView];
            noteTextView.textColor = BlackTextColor;
            noteTextView.font = FONT(17);
            noteTextView.delegate = self;
            noteTextView.noteDelegate = self;
            noteTextView.backgroundColor = ClearColor;
            noteTextView.textAlignment = NSTextAlignmentJustified;
            noteTextView.inputAccessoryView = self.accessoryView;
            noteTextView.tag = noteImageView.textView.tag + 1;
            
            TFNoteModel *model1 = [[TFNoteModel alloc] init];
            model1.noteTextView = noteTextView;
            model1.type = 0;
            model1.check = self.cursorModel.check;
            model1.num = self.cursorModel.num == 0 ? 0 : self.cursorModel.num + 1;
            
            [self.noteItems addObject:model1];
            
        }
        
        
    }else{// 纯文本，分裂成为三个
        
        // 加入图片
        TFNoteImageView *noteImageView = [[TFNoteImageView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:noteImageView];
        noteImageView.textView.textColor = BlackTextColor;
        noteImageView.textView.font = FONT(17);
        noteImageView.textView.delegate = self;
        noteImageView.textView.backgroundColor = ClearColor;
        noteImageView.textView.textAlignment = NSTextAlignmentJustified;
        noteImageView.textView.text = @"";
        noteImageView.textView.inputAccessoryView = self.accessoryView;
        noteImageView.tag = self.cursorModel.noteTextView.tag + 1;
        
        TFNoteModel *model = [[TFNoteModel alloc] init];
        model.noteImageView = noteImageView;
        model.type = 1;
        model.check = 0;
        model.num = 0;
        model.image = image;
        self.imageModel = model;
        
        [self.noteItems insertObject:model atIndex:self.cursorModel.noteTextView.tag + 1];
        
        
        TFNoteTextView *noteTextView = [[TFNoteTextView alloc] initWithFrame:CGRectZero];
        [self.bgView addSubview:noteTextView];
        noteTextView.textColor = BlackTextColor;
        noteTextView.font = FONT(17);
        noteTextView.delegate = self;
        noteTextView.noteDelegate = self;
        noteTextView.backgroundColor = ClearColor;
        noteTextView.textAlignment = NSTextAlignmentJustified;
        noteTextView.text = [self.cursorModel.noteTextView.text substringFromIndex:self.cursorPosition];
        noteTextView.inputAccessoryView = self.accessoryView;
        noteTextView.tag = self.cursorModel.noteTextView.tag + 2;
        
        TFNoteModel *model1 = [[TFNoteModel alloc] init];
        model1.noteTextView = noteTextView;
        model1.type = 0;
        model1.check = 0;
        model1.num = 0;
        
        [self.noteItems insertObject:model1 atIndex:self.cursorModel.noteTextView.tag + 2];
        
        //            [noteTextView becomeFirstResponder];// 会调用textViewShouldBeginEditing:
        self.cursorModel.noteTextView.text = [self.cursorModel.noteTextView.text substringToIndex:self.cursorPosition];
        
    }
    
    
//    [self setNeedsLayout];
    [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    [self.noteBL chatFileWithImages:@[image] withVioces:@[] bean:@"memo"];
    
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [delegate.tabCtrl dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [KeyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 网络请求代理
-(void)finishedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    if (resp.cmdId == HQCMD_ChatFile) {
        
        [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
        NSArray *arr = resp.body;
        
        if (arr.count) {
            TFFileModel *model = arr[0];
            self.imageModel.fileUrl = model.file_url;
            [self setNeedsLayout];
        }
        
    }
    
}

-(void)failedHandle:(HQBaseBL *)blEntity response:(HQResponseEntity *)resp{
    
    [MBProgressHUD hideHUDForView:KeyWindow animated:YES];
    [MBProgressHUD showError:resp.errorDescription toView:KeyWindow];
}



-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGRect lastRect = CGRectMake(0, 10, 0, 0);// 上一个item的frame
    
    for (NSInteger i = 0; i < self.noteItems.count; i++) {
        
        TFNoteModel *model = self.noteItems[i];
        TFNoteTextView *noteTextView = model.noteTextView;
        TFNoteImageView *noteImageView = model.noteImageView;
        noteImageView.textView.textAlignment = NSTextAlignmentJustified;
        noteTextView.tag = i;
        noteTextView.type = model.type;
        noteTextView.num = model.num;
        noteTextView.check = model.check;
        noteTextView.textAlignment = NSTextAlignmentJustified;
        noteImageView.textView.tag = i;
        
        
        if (model.type == 0) {// 文字
            
//            CGSize size = noteTextView.contentSize;
            CGFloat margin = 20;
            
            if (model.check == 0 && model.num == 0) {
                margin += 20;
            }else{
                
                if (model.check > 0) {
                    margin += 20;
                }
                if (model.num > 0) {
                    margin += 20;
                }
            }
            
            
            if (noteTextView.isFirstResponder) {// 是响应者
                
                if (noteTextView.text.length) {// 有文字
                    
                    CGSize wordSize = [HQHelper sizeWithFont:noteTextView.font maxSize:(CGSize){self.width-margin,MAXFLOAT} titleStr:noteTextView.text];
                    
                    if (i == self.noteItems.count-1) {// 最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, wordSize.height + InputHeight);
                        
                    }else{// 不是最后一个
                        if (self.type == 1) {
                            noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, wordSize.height + 10);
                        }else{
                            noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, wordSize.height + 30);
                        }
                    }
                    
                }else{// 没文字
                    
                    if (i == self.noteItems.count-1) {// 最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width,InputHeight);
                        
                    }else{// 不是最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width,30);
                    }
                }
                
            }else{// 非响应者
                
                if (noteTextView.text.length) {// 有文字
                    
                    CGSize wordSize = [HQHelper sizeWithFont:noteTextView.font maxSize:(CGSize){self.width-margin,MAXFLOAT} titleStr:noteTextView.text];
                    
                    if (i == self.noteItems.count-1) {// 最后一个
                        
                        if (self.type == 1) {
                            noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width,  wordSize.height + 30);
                            
                        }else{
                            noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, wordSize.height + InputHeight);
                        }
                        
                        
                    }else{// 不是最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, wordSize.height + 10);
                        
                    }
                    
                }else{// 没文字
                    
                    if (i == self.noteItems.count-1) {// 最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width,InputHeight);
                        
                    }else{// 不是最后一个
                        
                        noteTextView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width,30);
                    }
                }
                
            }
            
            lastRect = noteTextView.frame;
        }
        else{// 图片
            
            if (model.image == nil && model.fileUrl) {
                
                [noteImageView.imageView sd_setImageWithURL:[HQHelper URLWithString:[model.fileUrl  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]  placeholderImage:[HQHelper createImageWithColor:BackGroudColor] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image != nil) {
                        
                        model.image = image;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [self setNeedsLayout];
                        });
                    }
                }];
                
                noteImageView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), 0, 0);
                
            }else if (model.image){
                
                CGSize size = model.image.size;
                CGFloat width = size.width;
                CGFloat height = size.height;
                if (width > self.width-40) {
                    
                    width = self.width-40;
                    height = (self.width-40)/size.width*size.height;
                }
                
                noteImageView.frame = CGRectMake(-10, CGRectGetMaxY(lastRect), self.width, height/width*self.width);
                noteImageView.imageView.image = model.image;
            }
            
            lastRect = noteImageView.frame;
        }
        
        if (self.type == 1) {
            
            noteTextView.scrollEnabled = NO;
        }else{
            if (noteTextView.isFirstResponder) {
                noteTextView.scrollEnabled = YES;
            }else{
                noteTextView.scrollEnabled = NO;
            }
        }
        
    }
    
    if ([self.delegate respondsToSelector:@selector(noteView:changedHeight:)]) {
        [self.delegate noteView:self changedHeight:CGRectGetMaxY(lastRect)+20];
    }
    
    if ([self.delegate respondsToSelector:@selector(noteView:noteItems:)]) {
        [self.delegate noteView:self noteItems:self.noteItems];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
