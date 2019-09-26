//
//  HQIndustryManager.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/4/28.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQIndustryManager.h"

@interface HQIndustryManager () <NSXMLParserDelegate>

@end

@implementation HQIndustryManager

+ (instancetype)defaultIndustryManager
{
    static HQIndustryManager *instance = nil;
    static dispatch_once_t oncetoKen;
    dispatch_once(&oncetoKen, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

-(NSString *)industryWithIndustryId:(NSString *)industryId{
    
    HQIndustryManager *manager = [HQIndustryManager defaultIndustryManager];
    
    for (NSInteger i = 0; i < manager.industryArr.count; i ++) {
        
        NSDictionary *dict = manager.industryArr[i];
        
        if ([[dict valueForKey:@"id"] isEqualToString:industryId]) {
            
            
            return [dict valueForKey:@"value"];
        }
    }
    
    return @"";
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _industryArr = [NSMutableArray array];
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"industry" ofType:@"xml"];
        NSString *_xmlContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSXMLParser *parse=[[NSXMLParser alloc] initWithData:[_xmlContent dataUsingEncoding:NSUTF8StringEncoding]];
        [parse setDelegate:self];
        [parse parse];
        
        
        
//        NSString *xml=[[NSBundle mainBundle] pathForResource:@"industry" ofType:@"xml"];
//        NSXMLParser *parser=[[NSXMLParser alloc] initWithData:[xml dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        //    NSXMLParser *parser=[[NSXMLParser alloc] initWithContentsOfURL:[HQHelper URLWithString:@"http://earthquake.usgs.gov/earthquakes/catalogs/7day-M2.5.xml"]];
//        
//        [parser setDelegate:self];//设置NSXMLParser对象的解析方法代理
//        [parser setShouldProcessNamespaces:NO];
//        [parser parse];//开始解析
        
    }
    return self;
}


#pragma mark - NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"industry"]) {
        
        [_industryArr addObject:attributeDict];
    }
    
//    //判断是否是meeting
//    if ([elementName isEqualToString:@"id"]) {
//        //判断属性节点
//        if ([attributeDict objectForKey:@"value"]) {
//            //获取属性节点中的值
//            NSString *addr=[attributeDict objectForKey:@"addr"];
//        }
//    }
//    //判断member
//    if ([elementName isEqualToString:@"member"]) {
//        HQLog(@"member");
//    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
//    HQLog(@"xml_parser value:%@",string);
//    [itemValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
//    HQLog(@"xml_parser end %@ ",elementName);
//    if ( [elementName isEqualToString:@"firstName"] ) {
//        [personNameArrary addObject:itemValue];
//    }
//    
//    if ( [elementName isEqualToString:@"person"] ) {
//        HQLog(@"xml_parser person end");
//    }
    
}

@end
