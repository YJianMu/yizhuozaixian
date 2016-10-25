//
//  paidmodel.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//  已收货

#import "paidmodel.h"


@implementation paidmodel
+ (NSMutableArray *)setlist:(NSArray *)listarray{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dic in listarray) {
        [array addObjectsFromArray:[self and:dic]];
    }
    return array;
}

+ (NSArray *)and:(NSDictionary *)dic{
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSDictionary *dictionary in dic[@"data"]) {
        paidmodel *model = [[paidmodel alloc]init];
        if ([dictionary[@"order_status"] isEqualToString:@"4"] || [dictionary[@"order_status"] isEqualToString:@"5"]) {
            model =  [self model:dictionary];
            model.brand_name = dic[@"brand_name"];
            [array addObject:model];
        }
    }
    return array;
}

+ (paidmodel *)model:(NSDictionary*)dic{
    paidmodel *model = [[paidmodel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
