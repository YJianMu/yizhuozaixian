//
//  homeModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/16.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface homeModel : NSObject

@property (nonatomic,copy) NSString *cat_id;
@property (nonatomic,copy) NSString *shop_price;
@property (nonatomic,copy) NSString *market_price;
@property (nonatomic,copy) NSString *goods_img;
@property (nonatomic,copy) NSString *cat_name;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *goods_desc;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *keywords;
+(homeModel *)setModelWithDic:(NSDictionary *)dic;

+(NSArray *)setModelWithArray:(NSArray *)array;

+(NSMutableArray *)setModelWithDictionary:(NSArray *)array;

@end
