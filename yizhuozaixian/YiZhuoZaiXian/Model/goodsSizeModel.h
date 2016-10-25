//
//  goodsSizeModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/25.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsSizeModel : NSObject

@property(nonatomic,strong)NSString * goods_id;
@property(nonatomic,strong)NSString * goods_name;
@property(nonatomic,strong)NSString * shop_price;
@property(nonatomic,strong)NSString * warn_number;
@property(nonatomic,strong)NSArray * goods_color;
@property(nonatomic,strong)NSArray * goods_size;
@property(nonatomic,strong)NSString * goods_thumb;
@property(nonatomic,strong)NSString * brand_id;
@property(nonatomic,strong)NSString * brand_name;
@property(nonatomic,strong)NSString * member_price;
//+(goodsSizeModel *)setModelWithDic:(NSDictionary *)dic;
//
//+(NSArray *)setModelWithArray:(NSArray *)array;

+(goodsSizeModel *)setModelWithDictionary:(NSDictionary *)yuanDic;

@end
