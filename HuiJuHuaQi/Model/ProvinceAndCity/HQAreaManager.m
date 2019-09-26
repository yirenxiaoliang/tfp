//
//  HQAreaManager.m
//  HuiJuHuaQi
//
//  Created by XieLB on 16/5/30.
//  Copyright © 2016年 com.huijuhuaqi.com. All rights reserved.
//

#import "HQAreaManager.h"


@interface HQAreaManager () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *cityForProviceArr;   //一个省的所有市

@property (nonatomic, strong) NSMutableArray *areaForProviceArr;   //一个省的所有地区

@property (nonatomic, strong) NSMutableArray *areaForCityArr;      //一个市的所有地区


@end


@implementation HQAreaManager


+ (instancetype)defaultAreaManager
{
    static HQAreaManager *instance = nil;
    static dispatch_once_t oncetoKen;
    dispatch_once(&oncetoKen, ^{
        if(instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

/** 获取地址 */
-(NSString *)regionWithRegionData:(NSString *)regionData{
    
    NSString *region = @"";
    
    NSArray *arr = [regionData componentsSeparatedByString:@","];
    
    NSMutableArray *speces = [NSMutableArray array];
    for (NSString *str in arr) {
        
        NSArray *ss = [str componentsSeparatedByString:@":"];
        
        if (ss.count == 2) {
            [speces addObject:ss[1]];
        }
    }
    
    for (NSString *rec in speces) {
        
        region = [region stringByAppendingString:[NSString stringWithFormat:@"%@ ",rec]];
    }
    
    return region;
}

-(NSString *)regionWithRegionId:(NSString *)regionId{
    
    NSArray *arr = [regionId componentsSeparatedByString:@","];
    regionId = [arr lastObject];
    
    HQAreaManager *manager =[HQAreaManager defaultAreaManager];
    
    if (arr.count == 3) {
        
        NSInteger i , j , k ;
        for (i = 0; i < manager.areaArr.count; i ++) {
            NSArray *privince = manager.areaArr[i];
            for (j = 0; j < privince.count; j ++) {
                NSArray *city = privince[j];
                for (k = 0; k < city.count; k ++) {
                    NSDictionary *dict = city[k];
                    if ([[dict valueForKey:@"id"] isEqualToString:regionId]) {
                        NSDictionary *priDict = manager.provinceArr[i];
                        NSString *priStr = [priDict valueForKey:@"name"];
                        NSDictionary *cityDict = manager.cityArr[i][j];
                        NSString *cityStr = [cityDict valueForKey:@"name"];
                        NSDictionary *areaDict = manager.areaArr[i][j][k];
                        NSString *areaStr = [areaDict valueForKey:@"name"];
                        return [NSString stringWithFormat:@"%@ %@ %@",priStr,cityStr,areaStr];
                    }
                }
            }
        }
    }else if (arr.count == 2) {
        
        NSInteger i , j ;
        for (i = 0; i < manager.cityArr.count; i ++) {
            NSArray *privince = manager.cityArr[i];
            for (j = 0; j < privince.count; j ++) {
                NSDictionary *dict = privince[j];
                if ([[dict valueForKey:@"id"] isEqualToString:regionId]) {
                    NSDictionary *priDict = manager.provinceArr[i];
                    NSString *priStr = [priDict valueForKey:@"name"];
                    NSDictionary *cityDict = manager.cityArr[i][j];
                    NSString *cityStr = [cityDict valueForKey:@"name"];
                    return [NSString stringWithFormat:@"%@ %@",priStr,cityStr];
                }
                
            }
        }
        
    }else{
        
        
        NSInteger i ;
        for (i = 0; i < manager.provinceArr.count; i ++) {
            NSDictionary *dict = manager.provinceArr[i];
            if ([[dict valueForKey:@"id"] isEqualToString:regionId]) {
                NSDictionary *priDict = manager.provinceArr[i];
                NSString *priStr = [priDict valueForKey:@"name"];
                return [NSString stringWithFormat:@"%@",priStr];
            }
            
        }
        
    }
    
    return @"";
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        _provinceArr = [NSMutableArray array];
        _cityArr = [NSMutableArray array];
        _areaArr = [NSMutableArray array];
        
        
        _cityForProviceArr = [NSMutableArray array];
        _areaForProviceArr = [NSMutableArray array];
        _areaForCityArr    = [NSMutableArray array];
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ProvinceAndCity" ofType:@"xml"];
        NSString *_xmlContent=[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSXMLParser *parse=[[NSXMLParser alloc] initWithData:[_xmlContent dataUsingEncoding:NSUTF8StringEncoding]];
        [parse setDelegate:self];
        [parse parse];
        
    }
    return self;
}



#pragma mark - NSXMLParserDelegate
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    
    
    if ([elementName isEqualToString:@"Province"]) {
        
        [_provinceArr  addObject:attributeDict];
//         NSLog(@"%@", attributeDict);
    }
    
    
    if ([elementName isEqualToString:@"City"]) {
        
        [_cityForProviceArr addObject:attributeDict];
//        NSLog(@"%@", attributeDict);
    }
    
    
    if ([elementName isEqualToString:@"Area"]) {
        
        [_areaForCityArr addObject:attributeDict];
//        NSLog(@"%@", attributeDict);
    }
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    
    if ([elementName isEqualToString:@"Province"]) {
        
        [_cityArr addObject:_cityForProviceArr];
        [_areaArr addObject:_areaForProviceArr];
        _cityForProviceArr = [NSMutableArray array];
        _areaForProviceArr = [NSMutableArray array];
    }
    
    
    if ([elementName isEqualToString:@"City"]) {
        
        [_areaForProviceArr addObject:_areaForCityArr];
        _areaForCityArr = [NSMutableArray array];
    }
}



- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    //    HQLog(@"xml_parser value:%@",string);
    //    [itemValue appendString:string];
}





@end
