//
//  classifitionModel.m
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/21.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import "classifitionModel.h"

@implementation classifitionModel

+(classifitionModel *)setModelWithDic:(NSDictionary *)dic{
    classifitionModel *model=[[classifitionModel alloc] init];
    
    [model setValuesForKeysWithDictionary:dic];
    
    return model;
}

+(NSArray *)setModelWithArray:(NSArray *)array{
    
    NSMutableArray * mArr=[NSMutableArray array];
    
    for (NSDictionary * dic in array) {
        
        classifitionModel * model=[classifitionModel setModelWithDic:dic];
        
        [mArr addObject:model];
    }
    return mArr;
}


@end
