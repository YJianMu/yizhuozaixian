//
//  homeAdModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/22.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeAdModel : NSObject
@property(nonatomic,strong)NSString * cat_id;
@property(nonatomic,strong)NSString * img_url;
@property(nonatomic,strong)NSString * ad_name;
@property(nonatomic,strong)NSString * cat_name;
@property(nonatomic,strong)NSString * keywords;

+(homeAdModel *)setModelWithDic:(NSDictionary *)dic;

+(NSArray *)setModelWithArray:(NSArray *)array;

@end
