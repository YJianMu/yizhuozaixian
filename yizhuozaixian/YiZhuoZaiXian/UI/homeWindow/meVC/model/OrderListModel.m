//
//  OrderListModel.m
//  YiZhuoZaiXian
//
//  Created by IT部 on 16/4/6.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "OrderListModel.h"



@implementation OrderListModel
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
       OrderListModel *model = [[OrderListModel alloc]init];
       model =  [self model:dictionary];
        model.brand_name = dic[@"brand_name"];
        [array addObject:model];
    }
    return array;
}

+ (OrderListModel *)model:(NSDictionary*)dic{
    
    OrderListModel *model = [[OrderListModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}


@end
