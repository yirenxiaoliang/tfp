//
//  TFModelsCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/5/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFModelsCell.h"
#import "TFModelView.h"

#define Margin 15
#define ModelHeight 100

@interface TFModelsCell ()<TFModelViewDelegate>

/** modelViews */
@property (nonatomic, strong) NSMutableArray *modelViews;

@property (nonatomic, assign) NSInteger type;

/** index 0:常用 1：系统 2：应用 */
@property (nonatomic, assign) NSInteger sectionIndex;

/** application */
@property (nonatomic, strong) TFApplicationModel *application;

/** applications */
@property (nonatomic, strong) NSArray *applications;

@end

@implementation TFModelsCell

-(NSMutableArray *)modelViews{
    
    if (!_modelViews) {
        _modelViews = [NSMutableArray array];
    }
    return _modelViews;
}

+(instancetype)modelsCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"TFModelsCell";
    TFModelsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TFModelsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.layer.masksToBounds = YES;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        nameLabel.textColor = BlackTextColor;
        nameLabel.font = FONT(16);
        self.nameLabel = nameLabel;
        
    }
    return self;
}
/** 常用模块 */
-(void)refreshModelsCellWithOftenApplication:(TFApplicationModel *)application{
    
    self.application = application;
    self.type = 0;
    self.sectionIndex = 0;
    
    for (TFModelView *view in self.modelViews) {
        [view removeFromSuperview];
    }
    [self.modelViews removeAllObjects];
    self.nameLabel.hidden = YES;
    self.nameLabel.text = application.name;
    
    for (NSInteger i = 0; i < application.modules.count; i ++) {
        
        TFModuleModel *model = application.modules[i];
        TFModelView *view = [TFModelView modelView];
        [self addSubview:view];
        [self.modelViews addObject:view];
        view.delegate = self;
        view.tag = i;
        [view refreshViewWithModule:model type:0];
    }
    
    [self setNeedsLayout];
}
/** 系统模块 */
-(void)refreshModelsCellWithApplication:(TFApplicationModel *)application type:(NSInteger)type oftenApplication:(TFApplicationModel *)oftenApplication{
    
    self.application = application;
    self.type = type;
    self.sectionIndex = 1;
    
    for (TFModelView *view in self.modelViews) {
        [view removeFromSuperview];
    }
    [self.modelViews removeAllObjects];
    
    self.nameLabel.text = application.name;
    self.nameLabel.hidden = NO;
    
    for (NSInteger i = 0; i < application.modules.count; i ++) {
        
        TFModuleModel *model = application.modules[i];
        TFModelView *view = [TFModelView modelView];
        [self addSubview:view];
        [self.modelViews addObject:view];
        view.delegate = self;
        view.tag = i;
        
        if (oftenApplication) {
            
            if (type == 0) {
                [view refreshViewWithModule:model type:0];
            }else{
                
                BOOL have = NO;
                for (TFModuleModel *often in oftenApplication.modules) {
                    
                    if ([often.english_name isEqualToString:model.english_name]) {
                        have = YES;
                        break;
                    }
                }
                if (have) {
                    
                    [view refreshViewWithModule:model type:2];
                }else{
                    
                    [view refreshViewWithModule:model type:1];
                }
            }
        }else{
            [view refreshViewWithModule:model type:type];
        }
    }
    
    [self setNeedsLayout];
}

/** 应用 */
-(void)refreshModelsCellWithApplications:(NSArray *)applications type:(NSInteger)type{
    self.applications = applications;
    self.type = type;
    self.sectionIndex = 2;
    
    for (TFModelView *view in self.modelViews) {
        [view removeFromSuperview];
    }
    [self.modelViews removeAllObjects];
    self.nameLabel.hidden = NO;
    
    for (NSInteger i = 0; i < applications.count; i ++) {
        TFApplicationModel *model = applications[i];
        
        TFModelView *view = [TFModelView modelView];
        [self addSubview:view];
        [self.modelViews addObject:view];
        [view refreshViewWithApplication:model type:type];
        view.delegate = self;
        view.tag = i;
    }
    
    [self setNeedsLayout];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameLabel.frame = CGRectMake(15, 0, self.width-30, 44);
    
    CGFloat X = 0;
    CGFloat Y = 44;
    CGFloat start = self.sectionIndex == 0 ? 15 : 44;
    CGFloat W = (self.width - 2 * Margin)/4;
    
    for (NSInteger i = 0; i < self.modelViews.count; i ++) {
        
        TFModelView *view = self.modelViews[i];
        
        X = (i % 4) * W + Margin;
        Y = start + (i / 4) * ModelHeight;
        
        view.frame = CGRectMake(X, Y, W, ModelHeight);
    }
    
}

+ (CGFloat)modelsCellWithApplications:(NSArray *)applications{
    
    if (applications.count == 0) {
        return 0;
    }
    CGFloat height = 44;
    
    NSInteger i = applications.count + 3;
    
    height += ((i / 4) * ModelHeight);
    
    return height;
}


+ (CGFloat)modelsCellWithApplication:(TFApplicationModel *)application showTitle:(BOOL)showTitle{
    
    if (application.modules.count == 0) {
        return 0;
    }
    
    CGFloat height = showTitle ? 44 : 15;
    
    NSInteger i = application.modules.count + 3;
    
    height += ((i / 4) * ModelHeight);
    
    return height;
}

#pragma mark - TFModelViewDelegate
-(void)didClickedHandleBtnWithModelView:(TFModelView *)modelView module:(TFModuleModel *)module{
    
    if (self.type == 1) {// +
        
        if ([self.delegate respondsToSelector:@selector(modelsCell:didClickedAddModule:)]) {
            [self.delegate modelsCell:self didClickedAddModule:module];
        }
    }
    if (self.type == 2) {// -
        
        if ([self.delegate respondsToSelector:@selector(modelsCell:didClickedMinusModule:)]) {
            [self.delegate modelsCell:self didClickedMinusModule:module];
        }
        
    }
    
}

-(void)didClickedmodelView:(TFModelView *)modelView application:(TFApplicationModel *)application module:(TFModuleModel *)module{
    
    if ([self.delegate respondsToSelector:@selector(modelsCell:didClickedModelView:application:module:)]) {
        [self.delegate modelsCell:self didClickedModelView:modelView application:application module:module];
    }
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
