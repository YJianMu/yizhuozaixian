//
//  homeAdModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "homeAdModel.h"

@implementation homeAdModel
+(homeAdModel *)setModelWithDic:(NSDictionary *)dic{
    homeAdModel *model=[[homeAdModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];
    model.img_url = [NSString stringWithFormat:@"%@/%@",websiteURLstring,model.img_url];
    
    return model;
}

+(NSArray *)setModelWithArray:(NSArray *)array{
    
    NSMutableArray * mArr=[NSMutableArray array];
    
    for (NSDictionary * dic in array) {
        
        homeAdModel * model=[homeAdModel setModelWithDic:dic];
        
        [mArr addObject:model];
    }
    return mArr;
}

@end
