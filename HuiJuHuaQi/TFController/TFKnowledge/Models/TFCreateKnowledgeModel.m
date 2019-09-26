//
//  TFCreateKnowledgeModel.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/4.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFCreateKnowledgeModel.h"

@implementation TFCreateKnowledgeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = [[TFCustomerRowsModel alloc] init];
        self.title.field = [[TFCustomerFieldModel alloc] init];
        self.title.label = @"标题";
        self.title.type = @"text";
        self.title.field.fieldControl = @"2";
        self.title.field.pointOut = @"请输入";
        
        self.content = [[TFCustomerRowsModel alloc] init];
        self.content.field = [[TFCustomerFieldModel alloc] init];
        self.content.label = @"内容";
        self.content.type = @"multiText";
        self.content.field.fieldControl = @"2";
        self.content.field.pointOut = @"请输入";
        
        self.customs = [NSMutableArray array];
        self.tasks = [NSMutableArray array];
        self.approvals = [NSMutableArray array];
        self.notes = [NSMutableArray array];
        self.emails = [NSMutableArray array];
        
        self.files = [[TFCustomerRowsModel alloc] init];
        self.files.field = [[TFCustomerFieldModel alloc] init];
        self.files.label = @"附件";
        self.files.type = @"attachments";
        self.files.selects = [NSMutableArray array];
        self.files.field.chooseType = @"1";
        
        self.labels = [[TFCustomerRowsModel alloc] init];
        self.labels.field = [[TFCustomerFieldModel alloc] init];
        self.labels.label = @"标签";
        self.labels.type = @"picklist";
        self.labels.name  = @"label";
        self.labels.field.chooseType = @"1";
        self.labels.field.pointOut = @"请选择";
        self.labels.selects = [NSMutableArray array];
        
        self.category = [[TFCustomerRowsModel alloc] init];
        self.category.field = [[TFCustomerFieldModel alloc] init];
        self.category.label = @"分类";
        self.category.type = @"picklist";
        self.category.name = @"category";
        self.category.field.chooseType = @"0";
        self.category.field.fieldControl = @"2";
        self.category.field.pointOut = @"请选择";
        self.category.selects = [NSMutableArray array];
    }
    return self;
}

@end
