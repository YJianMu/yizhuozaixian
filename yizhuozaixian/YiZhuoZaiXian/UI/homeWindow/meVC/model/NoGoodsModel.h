//
//  NoGoodsModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/4/13.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoGoodsModel : NSObject
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *order_sn;
@property (nonatomic,copy) NSString *brand_id;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *total_prices;
@property (nonatomic,copy) NSString *goods_small_img;
@property (nonatomic,copy) NSString *order_status;
@property (nonatomic,copy) NSString *add_time;
@property (nonatomic,copy) NSString * brand_name;

+ (NSMutableArray *)setlist:(NSArray *)listarray;
@end
