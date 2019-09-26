//
//  HQTFModelCell.m
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/15.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQTFModelCell.h"
#import "HQTFModelView.h"
#import "HQBenchMainfaceModel.h"

@interface HQTFModelCell ()<HQTFModelViewDelegate>

/** HQTFModelView *modelView */
@property (nonatomic, weak) HQTFModelView *modelView ;
@property (nonatomic, weak) UILabel *titleLabel;
@end

@implementation HQTFModelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChild];
        
    }
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupChild];
}

+ (HQTFModelCell *)modelCellWithTableView:(UITableView *)tableView
{
    static NSString *indentifier = @"HQTFModelCell";
    HQTFModelCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[HQTFModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.topLine.hidden = YES;
    cell.bottomLine.hidden = YES;
    cell.layer.masksToBounds = YES;
    return cell;
}

- (void)setupChild{
    
    UILabel *titleLabel = [HQHelper labelWithFrame:(CGRect){0,-0.5,SCREEN_WIDTH,50} text:@"我的应用" textColor:BlackTextColor textAlignment:NSTextAlignmentLeft font:FONT(16)];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    self.titleLabel.backgroundColor = BackGroudColor;
    
    HQTFModelView *modelView = [[HQTFModelView alloc] initWithFrame:(CGRect){0,50,SCREEN_WIDTH,SCREEN_WIDTH/4 * 3}];
    [self.contentView addSubview:modelView];
    modelView.delegate = self;
    self.modelView = modelView;
}

-(void)modelView:(HQTFModelView *)modelView didSelectItem:(HQRootModel *)model{
    

    
    if (modelView.modelType == 3) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel nowApprovalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:model];
        
        for (HQRootModel *mod in benchNew.nowItems) {
            
            if (model.functionModelType == mod.functionModelType) {
                continue;
            }else{
                [arr addObject:mod];
            }
        }
        
        NSInteger indedx = arr.count<=4 ? arr.count : 4;
        NSMutableArray *models = [NSMutableArray array];
        for (NSInteger i = 0; i < indedx; i ++) {
            
            [models addObject:arr[i]];
        }
        HQBenchMainfaceModel *ben = [[HQBenchMainfaceModel alloc] init];
        ben.nowItems = models;
        ben.allItems = models;
        ben.employID = [HQHelper getCurrentLoginEmployee].id;
        [HQBenchMainfaceModel nowApprovalTypeArchiveWithModel:ben];
        
    }
    
    if ([self.delegate respondsToSelector:@selector(modelCell:didSelectItem:)]) {
        [self.delegate modelCell:self didSelectItem:model];
    }
    
}


- (void)setCellType:(NSInteger)cellType{
    _cellType = cellType;
    
    self.modelView.cellType = cellType;
    
    if (cellType == 0) {
        self.modelView.pan = NO;
    }else if (cellType == 1) {
        self.modelView.pan = NO;
    }else if (cellType == 2) {
        self.modelView.pan = NO;
    }else if (cellType == 3){
        self.modelView.pan = YES;
    }else if (cellType == 4){
        self.modelView.pan = YES;
    }else if (cellType == 5){
        self.modelView.pan = YES;
    }
}

-(void)setModelType:(NSInteger)modelType{
    _modelType = modelType;
    self.modelView.modelType = modelType;
    
    if(modelType == 0){
        self.titleLabel.text = @"    我的应用";
        self.titleLabel.top = 10;
        self.titleLabel.backgroundColor = WhiteColor;
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel modelManageUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
    
    if(modelType == 1){
        self.titleLabel.text = @"    第三方应用";
        self.titleLabel.top = 10;
        self.titleLabel.backgroundColor = WhiteColor;
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel thirdAppUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
    
    if(modelType == 2){
        self.titleLabel.text = @"    最近使用";
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel nowApprovalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
    
    if(modelType == 3){
        self.titleLabel.text = @"    所有审批";
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel approvalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
    
    
    if(modelType == 4){
        self.titleLabel.text = @"    销售应用";
        self.titleLabel.top = 10;
        self.titleLabel.backgroundColor = WhiteColor;
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel sellUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
    
    
    if(modelType == 5){
        self.titleLabel.text = @"    商品应用";
        self.titleLabel.backgroundColor = WhiteColor;
        self.titleLabel.top = 10;
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel goodsUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            self.modelView.height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
        }
    }
}

+(CGFloat)refreshModelCellHeightWithModelType:(NSInteger)modelType{
    
    CGFloat height = 0;
    
    if (modelType == 0) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel modelManageUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
            
        }
    }else if (modelType == 1) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel thirdAppUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
        }
    }else if (modelType == 2) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel nowApprovalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
        }
    }else if (modelType == 3) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel approvalTypeUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
        }
    }else if (modelType == 4) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel sellUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
        }
    }else if (modelType == 5) {
        
        HQBenchMainfaceModel *benchNew = [HQBenchMainfaceModel goodsUnarchiveWithEmployID:[HQHelper getCurrentLoginEmployee].id];
        if (benchNew) {
            
            if (benchNew.nowItems.count) {
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4) + 70;
            }else{
                height = SCREEN_WIDTH/4 * ((benchNew.nowItems.count + 3)/4);
            }
        }
    }

    return height;
}

/** ************************自定义********************** */

/** 刷新自定义模块 */
-(void)refreshModelCellWithModel:(TFApplicationModel *)model{
    
    self.titleLabel.text = [NSString stringWithFormat:@"    %@",model.name];
    self.titleLabel.backgroundColor = WhiteColor;
    self.titleLabel.top = 10;
    if (model.modules.count) {
        self.modelView.height = SCREEN_WIDTH/4 * ((model.modules.count + 3)/4);
    }else{
        self.modelView.height = 0;
    }

    [self.modelView refreshModelViewWithModules:model.modules];
}

+(CGFloat)refreshModelCellHeightWithModel:(TFApplicationModel *)model{

    return SCREEN_WIDTH/4 * ((model.modules.count + 3)/4) + 70;
}

-(void)modelView:(HQTFModelView *)modelView didSelectModule:(TFModuleModel *)model{
    
    if ([self.delegate respondsToSelector:@selector(modelCell:didSelectModule:)]) {
        [self.delegate modelCell:self didSelectModule:model];
    }
}

-(void)modelView:(HQTFModelView *)modelView didSelectModule:(TFModuleModel *)model contentView:(id)view{
    
    if ([self.delegate respondsToSelector:@selector(modelCell:didSelectModule:contentView:)]) {
        [self.delegate modelCell:self didSelectModule:model contentView:view];
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
