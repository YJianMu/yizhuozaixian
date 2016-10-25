//
//  classifitionModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/21.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface classifitionModel : NSObject

@property (nonatomic,copy) NSString *goods_brief;
@property (nonatomic,copy) NSString *cat_id;
@property (nonatomic,copy) NSString *shop_price;
@property (nonatomic,copy) NSString *goods_img;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *goods_thumb;
@property (nonatomic,copy) NSString *original_img;
@property (nonatomic,copy) NSString *goods_name;
@property (nonatomic,copy) NSString *fileName;

+(classifitionModel *)setModelWithDic:(NSDictionary *)dic;

+(NSArray *)setModelWithArray:(NSArray *)array;


@end
