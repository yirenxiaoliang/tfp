//
//  TFKnowledgeDetailHeader.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeDetailHeader.h"
#import "TFTagListView.h"
#import "TFCustomerOptionModel.h"

@interface TFKnowledgeDetailHeader ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet TFTagListView *tagListView;
@property (weak, nonatomic) IBOutlet UIView *peopleView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *learnBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;
@property (weak, nonatomic) IBOutlet UIButton *starBtn;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *writeRightW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteLeftW;
@property (weak, nonatomic) IBOutlet UILabel *line;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *learnTopM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *learnTrailM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleBottomM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagListViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagListViewBottomM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *peopleViewBottomM;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;



@property (nonatomic, assign) BOOL animationFinished;
@property (nonatomic, assign) BOOL fold;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) TFKnowledgeItemModel *model;

@end


@implementation TFKnowledgeDetailHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.categoryView.backgroundColor = ClearColor;
    self.tagListView.backgroundColor = ClearColor;
    self.tagListView.layer.masksToBounds = YES;
    self.peopleView.backgroundColor = ClearColor;
    self.bottomView.backgroundColor = ClearColor;
    self.goodBtn.backgroundColor = ClearColor;
    self.starBtn.backgroundColor = ClearColor;
    self.headBtn.backgroundColor = ClearColor;
    self.learnBtn.backgroundColor = ClearColor;
    self.bottomView.layer.borderColor = CellSeparatorColor.CGColor;
    self.bottomView.layer.borderWidth = 0.5;
    self.line.backgroundColor = CellSeparatorColor;
    
    self.categoryLabel.textColor = GreenColor;
    self.categoryLabel.font = FONT(12);
    self.categoryLabel.backgroundColor = BackGroudColor;
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryLabel.layer.cornerRadius = 4;
    self.categoryLabel.layer.masksToBounds = YES;
    
    self.titleLabel.textColor = BlackTextColor;
    self.titleLabel.font = FONT(16);
    
    self.headBtn.layer.cornerRadius = 15;
    self.headBtn.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(12);
    
    self.timeLabel.textColor = GrayTextColor;
    self.timeLabel.font = FONT(12);
    
    self.writeRightW.constant = SCREEN_WIDTH/2;
    self.inviteLeftW.constant = SCREEN_WIDTH/2;
    
    self.learnBtn.layer.cornerRadius = 14;
    self.learnBtn.layer.masksToBounds = YES;
    self.learnBtn.layer.borderWidth = 0.5;
    self.learnBtn.layer.borderColor = CellSeparatorColor.CGColor;
    [self.learnBtn setTitle:@" 确认学习" forState:UIControlStateNormal];
    [self.learnBtn setTitle:@"  已学习   " forState:UIControlStateSelected];
    [self.learnBtn setImage:IMG(@"确认学习") forState:UIControlStateNormal];
    [self.learnBtn setImage:IMG(@"已学习") forState:UIControlStateSelected];
    self.learnBtn.highlighted = NO;
    self.learnBtn.titleLabel.font = FONT(12);
    [self.learnBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.learnBtn setTitleColor:GreenColor forState:UIControlStateSelected];
    
    
    [self.starBtn setTitle:@"  收藏" forState:UIControlStateNormal];
    [self.starBtn setTitle:@"  收藏" forState:UIControlStateSelected];
    [self.starBtn setImage:IMG(@"收藏knowledge") forState:UIControlStateNormal];
    [self.starBtn setImage:IMG(@"收藏-0") forState:UIControlStateSelected];
    self.starBtn.titleLabel.font = FONT(12);
    [self.starBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.starBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateSelected];
    
    
    [self.goodBtn setTitle:@"  点赞" forState:UIControlStateNormal];
    [self.goodBtn setTitle:@"  点赞" forState:UIControlStateSelected];
    [self.goodBtn setImage:IMG(@"点赞knowledge") forState:UIControlStateNormal];
    [self.goodBtn setImage:IMG(@"点赞-0") forState:UIControlStateSelected];
    self.goodBtn.titleLabel.font = FONT(12);
    [self.goodBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.goodBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateSelected];
    
    [self.writeBtn setTitle:@"  写回答" forState:UIControlStateNormal];
    [self.writeBtn setTitle:@"  写回答" forState:UIControlStateHighlighted];
    [self.writeBtn setImage:IMG(@"写回答") forState:UIControlStateNormal];
    [self.writeBtn setImage:IMG(@"写回答") forState:UIControlStateHighlighted];
    self.writeBtn.titleLabel.font = FONT(12);
    [self.writeBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.writeBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    
    
    [self.inviteBtn setTitle:@"  邀请回答" forState:UIControlStateNormal];
    [self.inviteBtn setTitle:@"  邀请回答" forState:UIControlStateHighlighted];
    [self.inviteBtn setImage:IMG(@"邀请回答") forState:UIControlStateNormal];
    [self.inviteBtn setImage:IMG(@"邀请回答") forState:UIControlStateHighlighted];
    self.inviteBtn.titleLabel.font = FONT(12);
    [self.inviteBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateNormal];
    [self.inviteBtn setTitleColor:ExtraLightBlackTextColor forState:UIControlStateHighlighted];
    self.bottomView.backgroundColor = WhiteColor;
    
    self.fold = NO;
    self.animationFinished = YES;
    
    
//    self.categoryLabel.text = @" 我是一个很长的分类 ";
//    self.titleLabel.text = @"我是一个很长的标题哦哦哦";
//    [self.headBtn setImage:PlaceholderHeadImage forState:UIControlStateNormal];
//    self.nameLabel.text = @"尹明亮";
//    self.timeLabel.text = [HQHelper nsdateToTimeNowYear:[HQHelper getNowTimeSp]];
//
//    NSMutableArray *arr = @[].mutableCopy;
//    for (NSInteger i = 0; i < 9; i++) {
//        TFCustomerOptionModel *option = [[TFCustomerOptionModel alloc] init];
//        option.label = [NSString stringWithFormat:@"我是标签%ld",i];
//        option.color = @"#f2f2f2";
//        [arr addObject:option];
//    }
//    [self.tagListView refreshKnowledgeWithOptions:arr];
//    self.selfHeight = 200;
}

+(instancetype)knowledgeDatailHeader{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeDetailHeader" owner:self options:nil] lastObject];
}

-(CGFloat)knowledgeDetailHeaderWithModel:(TFKnowledgeItemModel *)model type:(NSInteger)type{
    CGFloat height = 200;
    if (type == 0) {
        height -= 49.5;// 底部按钮（回答和邀请）
        if (model.label_ids.count == 0) {
            height -= 30;// 标签栏
        }
    }else if (type == 1){
        if (model.label_ids.count == 0) {
            height -= 30;// 标签栏
        }
    }else{
        height -= 49.5;// 底部按钮（回答和邀请）
        height -= 40;// 分类栏
        height -= 30;// 标签栏
//        height -= 30;// 标题
    }
    
    return height;
}

/** 刷新 */
-(void)refreshKnowledgeDetailHeaderWithModel:(TFKnowledgeItemModel *)model type:(NSInteger)type auth:(NSInteger)auth{
    self.type = self.type;
    self.model = model;
    self.selfHeight = [self knowledgeDetailHeaderWithModel:model type:type];
    self.height = self.selfHeight;
    
    if (type == 0) {// 知识
        self.bottomView.hidden = YES;
        self.peopleViewBottomM.constant = 0;
        self.bottomH.constant = 0;
        self.learnBtn.hidden = NO;
        self.tagListView.hidden = NO;
        self.tagListViewH.constant = 20;
        self.tagListViewBottomM.constant = 10;
        self.categoryView.hidden = NO;
        self.categoryH.constant = 30;
        self.categoryBottom.constant = 10;
        
    }else if (type == 1){// 提问
        self.bottomView.hidden = NO;
        self.peopleViewBottomM.constant = 10;
        self.bottomH.constant = 49.5;
        self.learnBtn.hidden = NO;
        self.tagListView.hidden = NO;
        self.tagListViewH.constant = 20;
        self.tagListViewBottomM.constant = 10;
        self.categoryView.hidden = NO;
        self.categoryH.constant = 30;
        self.categoryBottom.constant = 10;
        
        if (auth > 0) {
            self.writeRightW.constant = SCREEN_WIDTH/2;
            self.inviteBtn.hidden = NO;
            self.line.hidden = NO;
        }else{
            self.writeRightW.constant = 0;
            self.inviteBtn.hidden = YES;
            self.line.hidden = YES;
        }
        
    }else{// 回答
        self.bottomView.hidden = YES;
        self.peopleViewBottomM.constant = 0;
        self.bottomH.constant = 0;
        self.learnBtn.hidden = YES;
        self.tagListView.hidden = YES;
        self.tagListViewH.constant = 0;
        self.tagListViewBottomM.constant = 0;
        self.categoryView.hidden = YES;
        self.categoryH.constant = 0;
        self.categoryBottom.constant = 0;
//        self.titleLabel.hidden = NO;
//        self.titleH.constant = 0;
//        self.titleBottomM.constant = 0;
    }
    
    self.star = [model.alreadycollecting integerValue];
    self.good = [model.alreadyprasing integerValue];
    self.learn = [model.alreadystudying integerValue];
    self.categoryLabel.text = [NSString stringWithFormat:@"%@  ",model.classification_name];
    self.titleLabel.text = model.title;
    
    NSMutableArray *labels = [NSMutableArray array];
    for (TFCategoryModel *cate in model.label_ids) {
        TFCustomerOptionModel *op = [[TFCustomerOptionModel alloc] init];
        op.value = [cate.id description];
        op.label = cate.name;
        op.color = @"#cccccc";
        [labels addObject:op];
    }
    [self.tagListView refreshKnowledgeWithOptions:labels];
    
    if (model.label_ids.count == 0) {
        self.tagListView.hidden = YES;
        self.tagListViewH.constant = 0;
        self.tagListViewBottomM.constant = 0;
        self.learnTopM.constant = 111-30;
    }else{
        self.learnTopM.constant = 111;
    }
    
    [self.headBtn sd_setBackgroundImageWithURL:[HQHelper URLWithString:model.create_by.picture] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [self.headBtn setTitle:@"" forState:UIControlStateNormal];
        }else{
            self.headBtn.backgroundColor = GreenColor;
            [self.headBtn setTitle:[HQHelper nameWithTotalName:model.create_by.employee_name] forState:UIControlStateNormal];
            self.headBtn.titleLabel.font = FONT(10);
        }
    }];
    
    self.nameLabel.text = model.create_by.employee_name;
    self.timeLabel.text = [HQHelper nsdateToTime:[model.create_time longLongValue] formatStr:@"yyyy-MM-dd HH:mm"];
    
}

-(void)setStar:(BOOL)star{
    _star = star;
    self.starBtn.selected = star;
}
-(void)setGood:(BOOL)good{
    _good = good;
    self.goodBtn.selected = good;
}
-(void)setLearn:(BOOL)learn{
    _learn = learn;
    self.learnBtn.selected = learn;
    if (learn) {
        self.learnBtn.layer.borderColor = GreenColor.CGColor;
    }else{
        self.learnBtn.layer.borderColor = CellSeparatorColor.CGColor;
    }
}
- (IBAction)learnClicked:(UIButton *)sender {
//    self.learn = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(knowledgeDetailHeaderDidLearn:)]) {
        [self.delegate knowledgeDetailHeaderDidLearn:sender];
    }
}
- (IBAction)starClicked:(UIButton *)sender {
    self.star = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(knowledgeDetailHeaderDidStar:)]) {
        [self.delegate knowledgeDetailHeaderDidStar:sender];
    }
}
- (IBAction)goodClicked:(UIButton *)sender {
    self.good = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(knowledgeDetailHeaderDidGood:)]) {
        [self.delegate knowledgeDetailHeaderDidGood:sender];
    }
}
- (IBAction)answerClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(knowledgeDetailHeaderDidAnswer)]) {
        [self.delegate knowledgeDetailHeaderDidAnswer];
    }
}
- (IBAction)inviteClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(knowledgeDetailHeaderDidInvite)]) {
        [self.delegate knowledgeDetailHeaderDidInvite];
    }
}

/** 折叠 */
-(void)foldDetailHeader{
    
    if (self.type == 2) {
        return;
    }
    
    if (!self.fold && self.animationFinished) {
        self.animationFinished = NO;
        self.fold = YES;
//        [UIView animateWithDuration:.25 animations:^{
        
            self.learnTrailM.constant = SCREEN_WIDTH-15-84;
            self.learnTopM.constant = 11;
            self.titleH.constant = 0;
            self.titleBottomM.constant = 0;
            self.tagListViewH.constant = 0;
            self.tagListViewBottomM.constant = 0;
            self.peopleViewH.constant = 0;
            self.peopleViewBottomM.constant = 0;
            if (self.type == 0) {
                self.height = 50;
            }else{
                self.height = self.selfHeight - 100;
            }
            self.categoryLabel.hidden = YES;
            self.titleLabel.hidden = YES;
            self.tagListView.hidden = YES;
            self.peopleView.hidden = YES;
            
//        } completion:^(BOOL finished) {
        
            self.animationFinished = YES;
//        }];
    }
}
/** 展开 */
-(void)unfoldDetailHeader{
    
    if (self.type == 2) {
        return;
    }
    
    if (self.fold && self.animationFinished) {
        self.animationFinished = NO;
        self.fold = NO;
//        [UIView animateWithDuration:0.25 animations:^{
        
            self.learnTrailM.constant = 15;
            self.titleH.constant = 20;
            self.titleBottomM.constant = 10;
            
            if (self.model.label_ids.count == 0) {
                self.tagListViewH.constant = 0;
                self.tagListViewBottomM.constant = 0;
                self.learnTopM.constant = 111-30;
            }else{
                self.tagListViewH.constant = 20;
                self.tagListViewBottomM.constant = 10;
                self.learnTopM.constant = 111;
            }
            self.peopleViewH.constant = 30;
            self.peopleViewBottomM.constant = 10;
            self.height = self.selfHeight;
            self.categoryLabel.hidden = NO;
            self.titleLabel.hidden = NO;
            self.tagListView.hidden = NO;
            self.peopleView.hidden = NO;
            
//        } completion:^(BOOL finished) {
        
            self.animationFinished = YES;
//        }];
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
