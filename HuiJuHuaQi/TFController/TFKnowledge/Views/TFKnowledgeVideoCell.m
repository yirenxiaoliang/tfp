//
//  TFKnowledgeVideoCell.m
//  HuiJuHuaQi
//
//  Created by 尹明亮 on 2019/1/25.
//  Copyright © 2019年 com.huijuhuaqi.com. All rights reserved.
//

#import "TFKnowledgeVideoCell.h"

@interface TFKnowledgeVideoCell ()

@property (nonatomic, weak) UIWebView *webView;


@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation TFKnowledgeVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        [self setupChild];
    }
    return self;
}

-(void)setupChild{
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, (SCREEN_WIDTH-30)*9/16)];
    webView.allowsInlineMediaPlayback = YES;
    [self addSubview:webView];
    self.webView = webView;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRect){15,CGRectGetMaxY(webView.frame),SCREEN_WIDTH-30,40}];
    [self addSubview:titleLabel];
    self.titleLabel.font = FONT(16);
    self.titleLabel = titleLabel;
}

-(void)refreshVideoCellWithModel:(TFVideoModel *)model{
//    NSURL *url=[NSURL URLWithString:@"https://v.qq.com/iframe/player.html?vid=o0027hjfs6g&tiny=0&auto=0"];
    NSURL *url=[NSURL URLWithString:model.url];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
    [self.webView loadRequest:request];
    
    self.titleLabel.text = model.title;
}

+(instancetype)knowledgeVideoCellWithTableView:(UITableView *)tableView{
    
    static NSString *ID = @"TFKnowledgeVideoCell";
    TFKnowledgeVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
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
