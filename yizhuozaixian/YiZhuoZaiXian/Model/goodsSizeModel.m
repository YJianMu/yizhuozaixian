//
//  goodsSizeModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "goodsSizeModel.h"

@implementation goodsSizeModel


+(goodsSizeModel * )setModelWithDic:(NSDictionary *)dic{
    goodsSizeModel *model=[[goodsSizeModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];

    
    return model;
}

/*
+(NSArray *)setModelWithArray:(NSArray *)array{
    
    NSMutableArray * mArr=[NSMutableArray array];
    
    for (NSDictionary * dic in array) {
        
        goodsSizeModel * model=[goodsSizeModel setModelWithDic:dic];
        
        [mArr addObject:model];
    }
    return mArr;
}
*/
+(goodsSizeModel *)setModelWithDictionary:(NSDictionary *)yuanDic{
  
    
    NSMutableDictionary * mdic = [NSMutableDictionary dictionaryWithDictionary:yuanDic];
    [mdic removeObjectForKey:@"attrInfo"];
    goodsSizeModel * model=[goodsSizeModel setModelWithDic:mdic];
    model.goods_color = yuanDic[@"attrInfo"][@"color"];
    model.goods_size = yuanDic[@"attrInfo"][@"size"];
    
    return model;
}






@end
