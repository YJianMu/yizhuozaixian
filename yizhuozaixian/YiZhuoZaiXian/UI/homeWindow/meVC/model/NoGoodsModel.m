//
//  NoGoodsModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/13.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "NoGoodsModel.h"


@implementation NoGoodsModel
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
        NoGoodsModel *model = [[NoGoodsModel alloc]init];
        if ([dictionary[@"order_status"] isEqualToString:@"1"]) {
            model =  [self model:dictionary];
            model.brand_name = dic[@"brand_name"];
            [array addObject:model];
            
        }
    }
    return array;
}

+ (NoGoodsModel *)model:(NSDictionary*)dic{
    
    NoGoodsModel *model = [[NoGoodsModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
