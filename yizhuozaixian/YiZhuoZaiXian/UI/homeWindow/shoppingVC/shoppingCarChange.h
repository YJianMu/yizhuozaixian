//
//  shoppingCarChange.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/31.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shoppingCarChange : NSObject


//修改购物车中商品数量
-(void)changeShoppingCarNumRequestWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr;


//删除购物车中某条商品数据
-(void)deleteShoppingCarGoodsWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr;


//添加商品到购物车
-(void)addGoodsShoppingCarGoodsWithDic:(NSDictionary *)dic andURLstr:(NSString *)URLstr;
@end
