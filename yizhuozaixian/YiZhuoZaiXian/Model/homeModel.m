//
//  homeModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "homeModel.h"

@implementation homeModel

+(homeModel *)setModelWithDic:(NSDictionary *)dic{
    homeModel *model=[[homeModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

+(NSArray *)setModelWithArray:(NSArray *)array{
    
    NSMutableArray * mArr=[NSMutableArray array];
    
    for (NSDictionary * dic in array) {
        
        homeModel * model=[homeModel setModelWithDic:dic];
        
        [mArr addObject:model];
    }
    return mArr;
}

+(NSMutableArray *)setModelWithDictionary:(NSArray *)array{
    NSMutableArray * returnArr = [NSMutableArray array];
    for (NSDictionary * dic in array) {
        NSMutableDictionary * mdic = [[NSMutableDictionary alloc]init];
        [mdic setObject:dic[@"cat_name"] forKey:@"className"];
        [mdic setObject:[homeModel setModelWithArray:dic[@"goodList"]] forKey:@"secondClassifiction"];
        [mdic setObject:dic[@"cat_icon"] forKey:@"classIcon"];
        [returnArr addObject:mdic];
    }
    return returnArr;
}


@end
