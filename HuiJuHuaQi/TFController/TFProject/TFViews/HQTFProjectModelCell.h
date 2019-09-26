//
//  HQTFProjectModelCell.h
//  HuiJuHuaQi
//
//  Created by HQ-20 on 17/3/23.
//  Copyright © 2017年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQBaseCell.h"
#import "TFProjectCatagoryItemModel.h"

typedef enum { 
    ProjectModelCellTypeCooperation,
    ProjectModelCellTypeCustomer,
    ProjectModelCellTypeProduction,
    ProjectModelCellTypeDevise,
    ProjectModelCellTypeInternet
}ProjectModelCellType;

@interface HQTFProjectModelCell : HQBaseCell

@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
+ (HQTFProjectModelCell *)projectModelCellWithTableView:(UITableView *)tableView;

/** 选中 */
@property (nonatomic, assign) BOOL isSelected;


-(void)refreshProjectModelCellWithModel:(TFProjectCatagoryItemModel *)model;
@end
