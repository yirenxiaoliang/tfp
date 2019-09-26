//
//  TFTImageLabelImageCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 2018/6/7.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"

@protocol TFTImageLabelImageCellDelegate<NSObject>
@optional
/** 应用任务层级 */
-(void)imageLabelImageCellDidClickedNamePosition:(NSInteger)position;

@end

@interface TFTImageLabelImageCell : HQBaseCell

/** titleImageName */
@property (nonatomic, copy) NSString *titleImageName;
/** enterImageName */
@property (nonatomic, copy) NSString *enterImageName;
/** name */
@property (nonatomic, copy) NSString *name;
/** name */
@property (nonatomic, copy) NSString *desc;

/** trailWidth */
@property (nonatomic, assign) CGFloat trailWidth;

/** enterImageHidden */
@property (nonatomic, assign) BOOL enterImageHidden;

/** isTap */
@property (nonatomic, assign) BOOL isTap;

/** delegate */
@property (nonatomic, weak) id <TFTImageLabelImageCellDelegate>delegate;

+ (TFTImageLabelImageCell *)imageLabelImageCellWithTableView:(UITableView *)tableView;

@end
