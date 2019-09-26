//
//  HQTFTwoLineCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/2/21.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFFileModel.h"
#import "HQEmployModel.h"
#import "TFFileCModel+CoreDataProperties.h"
#import "TFGroupEmployeeModel.h"
#import "TFProjectPeopleModel.h"
#import "TFLocationModel.h"

typedef enum {
    TwoLineCellTypeTwo,// 两行文字
    TwoLineCellTypeOne // 一行文字
}TwoLineCellType;

@class HQTFTwoLineCell;

@protocol HQTFTwoLineCellDelegate <NSObject>

@optional
- (void)twoLineCell:(HQTFTwoLineCell *)cell didEnterImage:(UIButton *)enterBtn;

- (void)twoLineCell:(HQTFTwoLineCell *)cell titleImage:(UIButton *)photoBtn;

@end

@interface HQTFTwoLineCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *titleImage;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UIButton *enterImage;
@property (weak, nonatomic) IBOutlet UIButton *titleDescImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterImgTrailW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleImageLeftW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *enterW;

+ (HQTFTwoLineCell *)twoLineCellWithTableView:(UITableView *)tableView;

+ (HQTFTwoLineCell *)twoLineCellWithTableView2:(UITableView *)tableView;
/** type */
@property (nonatomic, assign) TwoLineCellType type;

/** 设置titleImage宽度 */
@property (nonatomic, assign) CGFloat titleImageWidth;

/** isClear */
@property (nonatomic, assign) BOOL isClear;


/** delegate */
@property (nonatomic, weak) id<HQTFTwoLineCellDelegate>delegate;

/** 用于人员显示 */
-(void)refreshCellWithEmployeeModel:(HQEmployModel *)model;
/** 用于TFEmployModel人员显示 */
-(void)refreshWithTFEmployModel:(TFEmployModel *)model;

/** 用于文件显示 */
-(void)refreshCellWithFileModel:(TFFileModel *)model;
/** 用于存储文件显示 */
-(void)refreshCellWithFileCModel:(TFFileCModel *)model;

/** 用于备忘录新建附件显示 */
-(void)refreshCellWithAddNoteAttachFileModel:(TFFileModel *)model;

/** 用于人员显示 */
-(void)refreshCellWithGroupInfoModel:(TFGroupEmployeeModel *)model;
/** 用于项目人员显示 */
-(void)refreshCellWithProjectPeopleModel:(TFProjectPeopleModel *)model;

/** 地址 */
- (void)refreshCellWithLocation:(TFLocationModel *)model;
@end
