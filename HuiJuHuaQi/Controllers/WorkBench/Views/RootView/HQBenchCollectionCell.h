//
//  HQBenchCollectionCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 16/6/29.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQRootButton.h"
#import "HQRootModel.h"
#import "TFModuleModel.h"

static NSString *reusableCell = @"SubCollectionViewCell";

static NSString *editStateChanged = @"editStateChanged";



@interface HQBenchCollectionCell : UICollectionViewCell
/** rootModel */
@property (nonatomic , strong)  HQRootModel *rootModel;
/** minusButton按钮 */
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
/** 用于minusButton按钮类型， 0：添加，1：删除，2：没有（隐藏） ，3：有边框及可拖拽图标*/
@property (nonatomic , assign) NSInteger type;

/** 刷新 */
-(void)refreshCellWithModel:(TFModuleModel *)model;

@end
