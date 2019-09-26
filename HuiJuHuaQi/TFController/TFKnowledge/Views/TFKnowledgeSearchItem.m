//
//  TFKnowledgeSearchItem.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2018/12/5.
//  Copyright © 2018年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeSearchItem.h"

@interface TFKnowledgeSearchItem ()
@end

@implementation TFKnowledgeSearchItem


-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.topLine.backgroundColor = CellSeparatorColor;
    self.rightLine.backgroundColor = CellSeparatorColor;
    self.leftLine.backgroundColor = CellSeparatorColor;
    self.bottomLine.backgroundColor = CellSeparatorColor;
    
    self.nameLabel.textColor = LightBlackTextColor;
    self.nameLabel.font = FONT(16);
    
}

+(instancetype)knowledgeSearchItem{
    return [[[NSBundle mainBundle] loadNibNamed:@"TFKnowledgeSearchItem" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
