
//
//  HQSendFriendCell.m
//  HuiJuHuaQi
//
//  Created by HQ-14 on 16/6/2.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQSendFriendCell.h"
#import "MBProgressHUD+Add.h"
@interface HQSendFriendCell () <UITextViewDelegate, HQSelectPhotoViewDelegate>


@property (nonatomic, assign) BOOL editeOrLookAtSate;  //编辑还是查看，NO为编辑

@end

@implementation HQSendFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        

    }
    
    return self;
}


- (void)setMaxNum:(NSInteger)maxNum
{
    _maxNum = maxNum;
    
    _selectPhotoView.maxNum = maxNum;
    
}





+ (instancetype)sendFriendCellWithTableView:(UITableView *)tableView Type:(BOOL)isTaskType{
    
    
    static NSString *ID = @"GoOutOneCell";
    
    HQSendFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [self sendCell];
        [cell initViewWithGoOutOneCell:isTaskType];
        
    }
    
    return cell;
    
    
}


+ (instancetype)sendCell{
    
    return [[HQSendFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoOutOneCell"];
}





- (void)initViewWithGoOutOneCell:(BOOL)isType;
{
    
    _contentTextView = [[HQAdviceTextView alloc] init];
    _contentTextView.delegate = self;
    _contentTextView.textColor = BlackTextColor;
    _contentTextView.font   = FONT(17);
    [self.contentView addSubview:_contentTextView];
    
    if (isType) {
        
//        _fileShowView = [[[NSBundle mainBundle] loadNibNamed:@"HQFileShowView" owner:self options:nil] lastObject];
//        
//        _fileShowView.frame = CGRectMake(0, 0,0, 0);
//        _fileShowView.layer.cornerRadius = 2.0;
//        _fileShowView.layer.masksToBounds = YES;
//        _fileShowView.backgroundColor = HexColor(0xe8e8ec, 0.5);
//        
//        [self.contentView addSubview:_fileShowView];
        
        
        
    }else{
    
        
        
        _selectPhotoView = [[HQSelectPhotoView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                             maxNum:self.maxNum
                                                         lineMaxNum:4
                                                             imgArr:nil
                                                             urlArr:nil
                                                           delegate:self];
        
        
        [self.contentView addSubview:_selectPhotoView];
        
    }
    
    
  
    
    
    _contentTextView.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, (self.contentTextViewHeight ? self.contentTextViewHeight-10 : 140));
    
    
    CGFloat margin = 15;
    CGFloat imageW = (SCREEN_WIDTH - 5*margin) / 4;
    CGRect photoFrame = CGRectMake(0, _contentTextView.bottom ,SCREEN_WIDTH, imageW + 2*margin);
    
    
    _selectPhotoView.frame = photoFrame;
    
    
    
}



- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    if (_attendanceDescriptionType == HQSenderFriendCricleType_friendCricle){
        
        _contentTextView.placeholder = @"说点什么吧...";
        
    }
    
//    _fileShowView.frame = CGRectMake(17, self.height - 86, self.width-34, 66);
}



//- (void)freshType:(HQFileModel *)fileInfoModel{
//    
//    [_fileShowView freshFileModel:fileInfoModel];
//    
//}

- (void)freshPhotoWithArr:(NSArray *)imgArr
                   urlArr:(NSArray *)urlArr
{
    [_selectPhotoView refreshSelectPhotoViewWithImgArr:imgArr
                                                urlArr:urlArr];
}


- (void)freshPhotoWithArr:(NSArray *)imgArr
                   urlArr:(NSArray *)urlArr
        editeOrLookAtSate:(BOOL)editeOrLookAtSate
{
    
    _editeOrLookAtSate = editeOrLookAtSate;
    
    [_selectPhotoView refreshSelectPhotoViewWithImgArr:imgArr
                                                urlArr:urlArr
                                     editeOrLookAtSate:editeOrLookAtSate];
}


#pragma mark - HQSelectPhotoViewDelegate

- (void)addPhotoAction
{
    if ([self.delegate respondsToSelector:@selector(didAddPhotoAction)]) {
        
        [self.delegate didAddPhotoAction];
    }
}


- (void)deletePhotoActionWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didDeletePhotoActionWithIndex:)]) {
        
        [self.delegate didDeletePhotoActionWithIndex:index];
    }
}


- (void)lookAtPhotoActionWithIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(didLookAtPhotoActionWithIndex:)]) {
        
        [self.delegate didLookAtPhotoActionWithIndex:index];
    }
}

-(void)lookAtPhotoActionWithIndex:(NSInteger)index imageViews:(NSArray *)imageViews{
    
    if ([self.delegate respondsToSelector:@selector(didLookAtPhotoActionWithIndex:imageViews:)]) {
        
        [self.delegate didLookAtPhotoActionWithIndex:index imageViews:imageViews];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (_editeOrLookAtSate == YES) {
        return NO;
    }else {
        return YES;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //    if (_attendanceDescriptionType == HQAttendanceDescriptionType_goOut
    //        ||  _attendanceDescriptionType == HQAttendanceDescriptionType_goOutEdite) {
    
    //    }
    //    else {
    //
    //        if (textView.text.length >= 300) {
    //            return NO;
    //        }
    //    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView.text.length > 2000) {
        //        HQLog(@"字太多了");
        [MBProgressHUD showError:@"文字长度大于2000字" toView:KeyWindow];
        textView.text = [textView.text substringToIndex:2000];
        
    }
    if ([self.delegate respondsToSelector:@selector(textChangeWithStr:)]) {
        
        [self.delegate textChangeWithStr:textView.text];
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
