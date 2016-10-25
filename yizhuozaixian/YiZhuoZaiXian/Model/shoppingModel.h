//
//  shoppingModel.h
//  YiZhuoZaiXian
//
//  Created by ITiOSYJM on 16/3/23.
//  Copyright © 2016年 xincedong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface shoppingModel : NSObject

@property(nonatomic,assign)BOOL gouxuanSelected;
//@property(nonatomic,strong)NSString * goodsNumber;


//@property(nonatomic,strong)NSString * goodsColor;
//@property(nonatomic,strong)NSString * goodsSize;
//@property(nonatomic,strong)NSString * goodsPrice;





@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *size;
@property (nonatomic,copy) NSString *car_id;
@property (nonatomic,copy) NSString *goods_price;
@property (nonatomic,copy) NSString *color;
@property (nonatomic,copy) NSString *goods_small_img;
@property (nonatomic,copy) NSString *goods_id;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *goods_name;


+(shoppingModel *)setModelWithDic:(NSDictionary *)dic;

//+(NSArray *)setModelWithArray:(NSArray *)array;

+(NSMutableArray *)setModelWithArray:(NSArray *)array;

/* 返回数组数据类型@[
                    @[@"店铺名",@"店铺id",@"店铺id",@[商品模型,商品模型,.......]],
                    @[@"店铺名",@"店铺id",@"店铺id",@[商品模型,商品模型,.......]],
                    @[@"店铺名",@"店铺id",@"店铺id",@[商品模型,商品模型,.......]],
                    .......
                ]
*/
@end
