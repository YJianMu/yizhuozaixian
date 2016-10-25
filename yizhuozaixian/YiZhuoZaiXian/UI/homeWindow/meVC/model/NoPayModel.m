//
//  NoPayModel.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/9.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "NoPayModel.h"



@implementation NoPayModel
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
        NoPayModel *model = [[NoPayModel alloc]init];
        if ([dictionary[@"order_status"] isEqualToString:@"0"]) {
            model =  [self model:dictionary];
            model.brand_name = dic[@"brand_name"];
            [array addObject:model];

        }
    }
    return array;
}

+ (NoPayModel *)model:(NSDictionary*)dic{
    
    NoPayModel *model = [[NoPayModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

@end
